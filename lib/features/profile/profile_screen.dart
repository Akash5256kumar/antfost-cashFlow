import 'package:flutter/material.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';

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
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accountItems = [
      _MenuItem(icon: Icons.person_outline_rounded, label: 'Personal Details'),
      _MenuItem(icon: Icons.location_on_outlined, label: 'Saved Sites'),
      _MenuItem(icon: Icons.description_outlined, label: 'Documents'),
      _MenuItem(icon: Icons.business_outlined, label: 'Company Info'),
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

    return Scaffold(
      backgroundColor: _bodyBg,
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
                    // Purple hero
                    _ProfileHero(),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Account section
                          _SectionLabel(label: 'Account'),
                          const SizedBox(height: 10),
                          _MenuGroup(items: accountItems),
                          const SizedBox(height: 20),

                          // Preferences section
                          _SectionLabel(label: 'Preferences'),
                          const SizedBox(height: 10),
                          _MenuGroup(items: preferenceItems),
                          const SizedBox(height: 20),

                          // Support section
                          _SectionLabel(label: 'Support'),
                          const SizedBox(height: 10),
                          _MenuGroup(items: supportItems),
                          const SizedBox(height: 24),

                          // Sign Out button
                          _SignOutButton(
                            onPressed: () =>
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pushNamedAndRemoveUntil(
                                  AppRoutes.signIn,
                                  (_) => false,
                                ),
                          ),
                          const SizedBox(height: 16),

                          // Version
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

// ── Profile hero ──────────────────────────────────────────────────────────────
class _ProfileHero extends StatelessWidget {
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
              child: Container(
                color: const Color(0xFFE0E0E0),
                child: const Icon(
                  Icons.person_rounded,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Name + company
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Omar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Icon(Icons.business_rounded, size: 14, color: Colors.white70),
                  SizedBox(width: 5),
                  Text(
                    'Omar Construction',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
