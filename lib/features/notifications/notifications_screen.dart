import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/svg_embedded_raster_image.dart';
import 'domain/entities/notification.dart';
import 'presentation/bloc/notifications_bloc.dart';
import 'presentation/bloc/notifications_event.dart';
import 'presentation/bloc/notifications_state.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark = AppColors.textPrimary;
const Color _textGrey = AppColors.textSecondary;
const Color _fieldBorder = AppColors.cardBorder;
const Color _bodyBg = AppColors.background;
const Color _iconBoxBlue = AppColors.primaryContainer;
const Color _iconBoxPink = Color(0xFFFDE8E8);
const Color _iconGlyph = Color(0xFFFF7A3D);
const Color _riskAccent = Color(0xFFF43F5E);
const Color _tagBg = Color(0xFFEDEDED);

const _filters = ['All', 'Operational', 'Financial', 'Risk'];

// ── Screen ────────────────────────────────────────────────────────────────────
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _filterIndex = 0;

  @override
  void initState() {
    super.initState();
    // Trigger initial fetch when the screen is first created.
    context.read<NotificationsBloc>().add(const FetchNotificationsEvent());
  }

  /// Maps the selected filter chip to a category, or `null` for "All".
  NotificationCategory? get _selectedCategory => switch (_filterIndex) {
    1 => NotificationCategory.operational,
    2 => NotificationCategory.financial,
    3 => NotificationCategory.risk,
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsBloc, NotificationsState>(
      // Show a snackbar whenever an error occurs.
      listener: (context, state) {
        if (state is NotificationsError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
        }
      },
      builder: (context, state) {
        // Derive unread count for the app bar subtitle — always reflects the
        // full list, independent of the active filter chip.
        final int unreadCount = state is NotificationsSuccess
            ? state.unreadCount
            : 0;

        return Scaffold(
          backgroundColor: _bodyBg,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // App bar
                _NotifAppBar(unreadCount: unreadCount),

                // Filter chips
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.scaled(16),
                    context.scaled(12),
                    0,
                    0,
                  ),
                  child: SizedBox(
                    height: context.scaled(34),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(right: context.scaled(16)),
                      itemCount: _filters.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: context.scaled(8)),
                      itemBuilder: (_, i) => _FilterChip(
                        label: _filters[i],
                        isSelected: _filterIndex == i,
                        onTap: () => setState(() => _filterIndex = i),
                      ),
                    ),
                  ),
                ),

                // Clear All
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.scaled(16),
                    context.scaled(6),
                    context.scaled(16),
                    0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => context.read<NotificationsBloc>().add(
                          const MarkAllReadEvent(),
                        ),
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            fontSize: context.scaled(12),
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: context.scaledV(8)),

                // Body content
                Expanded(child: _buildBody(context, state)),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds the scrollable body based on the current [state].
  Widget _buildBody(BuildContext context, NotificationsState state) {
    if (state is NotificationsLoading || state is NotificationsInitial) {
      return _NotificationsShimmer();
    }

    if (state is NotificationsError) {
      return _NotificationsErrorBody(
        message: state.message,
        onRetry: () => context.read<NotificationsBloc>().add(
          const RetryNotificationsEvent(),
        ),
      );
    }

    if (state is NotificationsSuccess) {
      final category = _selectedCategory;
      final notifications = category == null
          ? state.notifications
          : state.notifications.where((n) => n.category == category).toList();

      if (notifications.isEmpty) {
        return const _EmptyNotifications();
      }

      return ListView.separated(
        padding: EdgeInsets.fromLTRB(
          context.scaled(16),
          0,
          context.scaled(16),
          context.scaled(32),
        ),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => SizedBox(height: context.scaledV(9)),
        itemBuilder: (_, i) => _NotificationCard(
          notification: notifications[i],
          onTap: () => context.read<NotificationsBloc>().add(
            MarkNotificationReadEvent(notifications[i].id),
          ),
        ),
      );
    }

    // Fallback – should not be reached.
    return const SizedBox.shrink();
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _NotifAppBar extends StatelessWidget {
  const _NotifAppBar({required this.unreadCount});

  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(
        context.scaled(4),
        context.scaled(8),
        context.scaled(16),
        context.scaled(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button
          SizedBox(
            width: context.scaled(44),
            height: context.scaled(44),
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: Icon(Icons.arrow_back_rounded, size: context.scaled(24)),
              color: AppColors.textPrimary,
              padding: EdgeInsets.zero,
              splashRadius: 22,
            ),
          ),
          SizedBox(width: context.scaled(4)),

          // Title + unread subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: context.scaled(20),
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              if (unreadCount > 0) ...[
                // Hairline gap under the title — treated like a divider
                // stroke, left unscaled.
                const SizedBox(height: 1),
                Text(
                  '$unreadCount unread',
                  style: TextStyle(
                    fontSize: context.scaled(12),
                    fontWeight: FontWeight.w400,
                    color: _textGrey,
                    height: 1.2,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(
          horizontal: context.scaled(14),
          vertical: context.scaled(6),
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(context.scaled(17)),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFEFEFEF),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: context.scaled(13),
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : _textDark,
          ),
        ),
      ),
    );
  }
}

// ── Notification card ─────────────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  Color get _accent => notification.category == NotificationCategory.risk
      ? _riskAccent
      : AppColors.primary;

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !notification.isRead;
    // Unread borders read as a softer tint of the accent, not a fully
    // saturated line.
    final Color borderColor = isUnread
        ? _accent.withValues(alpha: 0.8)
        : _fieldBorder;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(context.scaled(11)),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(context.scaled(10)),
              border: Border.all(color: borderColor, width: isUnread ? 1.2 : 1),
              boxShadow: isUnread
                  ? [
                      BoxShadow(
                        color: _accent.withValues(alpha: 0.35),
                        offset: const Offset(-5, 0),
                        blurRadius: 10,
                        spreadRadius: -2,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type icon
                _NotificationIcon(category: notification.category),
                SizedBox(width: context.scaled(10)),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: context.scaled(15),
                          fontWeight: FontWeight.w600,
                          color: _textDark,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: context.scaledV(3)),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: context.scaled(12),
                          color: _textGrey,
                          height: 1.3,
                        ),
                      ),
                      SizedBox(height: context.scaledV(7)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (notification.orderId != null) ...[
                            _TagPill(label: notification.orderId!),
                            const Spacer(),
                          ] else
                            const Spacer(),
                          Text(
                            notification.date,
                            style: TextStyle(
                              fontSize: context.scaled(10),
                              color: _textGrey,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Unread dot — top-right corner of the card.
          if (isUnread)
            Positioned(
              top: 7,
              right: 7,
              child: Container(
                width: context.scaled(6),
                height: context.scaled(6),
                decoration: BoxDecoration(
                  color: _accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Order-id tag pill ─────────────────────────────────────────────────────────
class _TagPill extends StatelessWidget {
  const _TagPill({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(7),
        vertical: context.scaled(3),
      ),
      decoration: BoxDecoration(
        color: _tagBg,
        borderRadius: BorderRadius.circular(context.scaled(8)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: context.scaled(10),
          fontWeight: FontWeight.w600,
          color: _textDark,
        ),
      ),
    );
  }
}

// ── Notification icon ─────────────────────────────────────────────────────────
class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.category});

  final NotificationCategory category;

  @override
  Widget build(BuildContext context) {
    final Color bg = category == NotificationCategory.risk
        ? _iconBoxPink
        : _iconBoxBlue;

    final Widget glyph = switch (category) {
      NotificationCategory.operational => SvgEmbeddedRasterImage(
        assetPath: AppAssets.truck,
        width: context.scaled(20),
        height: context.scaled(20),
      ),
      NotificationCategory.financial => Icon(
        Icons.account_balance_wallet_outlined,
        size: context.scaled(20),
        color: _iconGlyph,
      ),
      NotificationCategory.risk => Icon(
        Icons.warning_amber_rounded,
        size: context.scaled(20),
        color: _iconGlyph,
      ),
    };

    return Container(
      width: context.scaled(36),
      height: context.scaled(36),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(child: glyph),
    );
  }
}

// ── Shimmer list (loading state) ──────────────────────────────────────────────
class _NotificationsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        context.scaled(16),
        0,
        context.scaled(16),
        context.scaled(32),
      ),
      itemCount: 5,
      separatorBuilder: (_, __) => SizedBox(height: context.scaledV(10)),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Container(
          height: context.scaled(80),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(context.scaled(12)),
          ),
        ),
      ),
    );
  }
}

// ── Error body ────────────────────────────────────────────────────────────────
class _NotificationsErrorBody extends StatelessWidget {
  const _NotificationsErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.scaled(24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: context.scaled(48),
              color: _textGrey,
            ),
            SizedBox(height: context.scaledV(12)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: context.scaled(14), color: _textGrey),
            ),
            SizedBox(height: context.scaledV(20)),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.scaled(12)),
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

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: context.scaled(72),
            height: context.scaled(72),
            decoration: const BoxDecoration(
              color: _iconBoxBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: context.scaled(36),
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: context.scaledV(16)),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: context.scaled(16),
              fontWeight: FontWeight.w600,
              color: _textDark,
              height: 1.3,
            ),
          ),
          SizedBox(height: context.scaledV(8)),
          Text(
            'You are all caught up!',
            style: TextStyle(
              fontSize: context.scaled(14),
              color: _textGrey,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
