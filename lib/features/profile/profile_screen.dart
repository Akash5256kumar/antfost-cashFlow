import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/navigation/app_tab_navigation.dart';
import '../../app/theme/app_colors.dart';
import '../auth/presentation/bloc/auth_bloc.dart';
import '../auth/presentation/bloc/auth_event.dart';
import '../auth/presentation/bloc/auth_state.dart';
import 'domain/entities/user_profile.dart';
import 'presentation/bloc/profile_bloc.dart';
import 'presentation/bloc/profile_event.dart';
import 'presentation/bloc/profile_state.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark = Color(0xFF1A1A1A);
const Color _textGrey = Color(0xFF9E9E9E);
const Color _fieldBorder = Color(0xFFE8E8E8);
const Color _bodyBg = Color(0xFFF2F2F7);
const Color _iconBoxBg = Color(0xFFEDE9FB);

// ── Menu item model ───────────────────────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MenuItem({required this.icon, required this.label, this.onTap});
}

// ── Screen ────────────────────────────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger profile fetch when the screen is first created.
    context.read<ProfileBloc>().add(const FetchProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    final accountItems = [
      _MenuItem(icon: Icons.person_outline_rounded, label: 'Personal Details'),
      _MenuItem(icon: Icons.location_on_outlined, label: 'Saved Sites'),
      _MenuItem(icon: Icons.description_outlined, label: 'Documents'),
      _MenuItem(icon: Icons.business_outlined, label: 'Company Info'),
      _MenuItem(
        icon: Icons.receipt_long_outlined,
        label: 'Invoices',
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.invoices),
      ),
      _MenuItem(
        icon: Icons.account_balance_wallet_outlined,
        label: 'Transaction History',
        onTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.transactionHistory),
      ),
    ];

    final preferenceItems = [
      _MenuItem(
        icon: Icons.notifications_outlined,
        label: 'Notifications',
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
      ),
      _MenuItem(icon: Icons.settings_outlined, label: 'Settings'),
    ];

    final supportItems = [
      _MenuItem(icon: Icons.help_outline_rounded, label: 'Help & FAQ'),
      _MenuItem(icon: Icons.chat_bubble_outline_rounded, label: 'Contact Us'),
      _MenuItem(icon: Icons.star_outline_rounded, label: 'Rate the App'),
    ];

    return MultiBlocListener(
      listeners: [
        // Listen to ProfileBloc for error snackbars.
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.redAccent,
                ));
            }
          },
        ),
        // Listen to AuthBloc for sign-out navigation.
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSignedOut) {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamedAndRemoveUntil(AppRoutes.signIn, (_) => false);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: _bodyBg,
        bottomNavigationBar:
            const AppTabBottomNavBar(currentTab: AppTab.profile),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // App bar
              _ProfileAppBar(),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Purple hero (data-driven via BLoC)
                      BlocBuilder<ProfileBloc, ProfileState>(
                        builder: (context, state) {
                          if (state is ProfileLoading ||
                              state is ProfileInitial) {
                            return _ProfileHeroShimmer();
                          }
                          if (state is ProfileSuccess) {
                            return _ProfileHero(profile: state.profile);
                          }
                          // Error fallback – show a minimal placeholder hero.
                          return _ProfileHeroShimmer();
                        },
                      ),

                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(16, 20, 16, 0),
                        child: BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            if (state is ProfileLoading ||
                                state is ProfileInitial) {
                              return _MenuGroupsShimmer();
                            }

                            if (state is ProfileError) {
                              return _ProfileErrorBody(
                                message: state.message,
                                onRetry: () => context
                                    .read<ProfileBloc>()
                                    .add(const FetchProfileEvent()),
                              );
                            }

                            // Both ProfileSuccess and ProfileUpdateSuccess show menus.
                            return _ProfileMenuContent(
                              accountItems: accountItems,
                              preferenceItems: preferenceItems,
                              supportItems: supportItems,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _ProfileAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: const Center(
        child: Text(
          'My Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _textDark,
            height: 1.2,
          ),
        ),
      ),
    );
  }
}

// ── Profile hero (with real data) ─────────────────────────────────────────────
class _ProfileHero extends StatelessWidget {
  const _ProfileHero({required this.profile});

  /// The authenticated user's profile data.
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              color: Colors.white,
            ),
            child: ClipOval(
              child: profile.avatarUrl != null
                  ? Image.network(
                      profile.avatarUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _defaultAvatarIcon(),
                    )
                  : _defaultAvatarIcon(),
            ),
          ),
          const SizedBox(width: 16),

          // Name + company
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.business_rounded,
                      size: 14,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        profile.company,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Fallback avatar icon shown when no [avatarUrl] is available.
  Widget _defaultAvatarIcon() => Container(
        color: const Color(0xFFE0E0E0),
        child: const Icon(
          Icons.person_rounded,
          size: 40,
          color: Colors.grey,
        ),
      );
}

// ── Profile hero shimmer (loading placeholder) ────────────────────────────────
class _ProfileHeroShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF8878FF),
      highlightColor: const Color(0xFFB0A6FF),
      child: Container(
        width: double.infinity,
        height: 110,
        color: const Color(0xFF8878FF),
      ),
    );
  }
}

// ── Menu groups shimmer (loading placeholder) ─────────────────────────────────
class _MenuGroupsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _shimmerBlock(height: 20, width: 100),
        const SizedBox(height: 10),
        _shimmerGroup(itemCount: 6),
        const SizedBox(height: 20),
        _shimmerBlock(height: 20, width: 120),
        const SizedBox(height: 10),
        _shimmerGroup(itemCount: 2),
        const SizedBox(height: 20),
        _shimmerBlock(height: 20, width: 80),
        const SizedBox(height: 10),
        _shimmerGroup(itemCount: 3),
        const SizedBox(height: 24),
        _shimmerBlock(height: 58, width: double.infinity),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _shimmerBlock({required double height, required double width}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _shimmerGroup({required int itemCount}) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: List.generate(itemCount, (i) {
            final isLast = i == itemCount - 1;
            return Column(
              children: [
                Container(
                  height: 68,
                  color: Colors.white,
                ),
                if (!isLast)
                  const Divider(color: _fieldBorder, height: 1),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ── Profile error body ────────────────────────────────────────────────────────
class _ProfileErrorBody extends StatelessWidget {
  const _ProfileErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: _textGrey),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: _textGrey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Profile menu content (menus + sign-out + version) ────────────────────────
class _ProfileMenuContent extends StatelessWidget {
  const _ProfileMenuContent({
    required this.accountItems,
    required this.preferenceItems,
    required this.supportItems,
  });

  final List<_MenuItem> accountItems;
  final List<_MenuItem> preferenceItems;
  final List<_MenuItem> supportItems;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Account section
        const _SectionLabel(label: 'Account'),
        const SizedBox(height: 10),
        _MenuGroup(items: accountItems),
        const SizedBox(height: 20),

        // Preferences section
        const _SectionLabel(label: 'Preferences'),
        const SizedBox(height: 10),
        _MenuGroup(items: preferenceItems),
        const SizedBox(height: 20),

        // Support section
        const _SectionLabel(label: 'Support'),
        const SizedBox(height: 10),
        _MenuGroup(items: supportItems),
        const SizedBox(height: 24),

        // Sign Out button – dispatches SignOutEvent to AuthBloc.
        _SignOutButton(
          onPressed: () =>
              context.read<AuthBloc>().add(const SignOutEvent()),
        ),
        const SizedBox(height: 16),

        // App version label
        const Center(
          child: Text(
            'Cash Order v1.0.0',
            style: TextStyle(
              fontSize: 13,
              color: _textGrey,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: _textDark,
        height: 1.3,
      ),
    );
  }
}

// ── Menu group ────────────────────────────────────────────────────────────────
class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.items});
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fieldBorder),
      ),
      child: Column(
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isLast = i == items.length - 1;
          return Column(
            children: [
              _MenuTile(item: item),
              if (!isLast)
                const Divider(
                  color: _fieldBorder,
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ── Menu tile ─────────────────────────────────────────────────────────────────
class _MenuTile extends StatelessWidget {
  const _MenuTile({required this.item});
  final _MenuItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onTap ?? () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: _iconBoxBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, size: 20, color: AppColors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: _textDark,
                    height: 1.3,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 22,
                color: _textGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sign Out button ───────────────────────────────────────────────────────────
class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.primaryGradientStart,
              AppColors.primaryGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: EdgeInsets.zero,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, size: 20, color: Colors.white),
              SizedBox(width: 8),
              Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
