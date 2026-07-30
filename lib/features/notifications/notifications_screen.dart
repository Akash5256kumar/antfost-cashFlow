import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../app/theme/app_colors.dart';
import 'domain/entities/notification.dart';
import 'presentation/bloc/notifications_bloc.dart';
import 'presentation/bloc/notifications_event.dart';
import 'presentation/bloc/notifications_state.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark = Color(0xFF1A1A1A);
const Color _textGrey = Color(0xFF9E9E9E);
const Color _fieldBorder = Color(0xFFE8E8E8);
const Color _bodyBg = Color(0xFFF2F2F7);
const Color _iconBoxBg = Color(0xFFEDE9FB);
const Color _unreadDot = Color(0xFF7A6BFF);
const Color _unreadCardBg = Color(0xFFFAF9FF);

// ── Screen ────────────────────────────────────────────────────────────────────
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger initial fetch when the screen is first created.
    context.read<NotificationsBloc>().add(const FetchNotificationsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsBloc, NotificationsState>(
      // Show a snackbar whenever an error occurs.
      listener: (context, state) {
        if (state is NotificationsError) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ));
        }
      },
      builder: (context, state) {
        // Derive unread count for the app bar badge.
        final int unreadCount =
            state is NotificationsSuccess ? state.unreadCount : 0;

        return Scaffold(
          backgroundColor: _bodyBg,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // App bar
                _NotifAppBar(
                  unreadCount: unreadCount,
                  onMarkAllRead: () => context
                      .read<NotificationsBloc>()
                      .add(const MarkAllReadEvent()),
                ),

                const SizedBox(height: 14),

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
        onRetry: () => context
            .read<NotificationsBloc>()
            .add(const RetryNotificationsEvent()),
      );
    }

    if (state is NotificationsSuccess) {
      final notifications = state.notifications;

      if (notifications.isEmpty) {
        return const _EmptyNotifications();
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _NotificationCard(
          notification: notifications[i],
          onTap: () => context
              .read<NotificationsBloc>()
              .add(MarkNotificationReadEvent(notifications[i].id)),
        ),
      );
    }

    // Fallback – should not be reached.
    return const SizedBox.shrink();
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _NotifAppBar extends StatelessWidget {
  const _NotifAppBar({
    required this.unreadCount,
    required this.onMarkAllRead,
  });

  final int unreadCount;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Back button
          SizedBox(
            width: 44,
            height: 44,
            child: IconButton(
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 24),
              color: AppColors.textPrimary,
              padding: EdgeInsets.zero,
              splashRadius: 22,
            ),
          ),
          const SizedBox(width: 4),

          // Title + unread badge
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                    height: 1.2,
                  ),
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _unreadDot,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Mark all read text button
          TextButton(
            onPressed: onMarkAllRead,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: const Text(
              'Mark all read',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Notification card ─────────────────────────────────────────────────────────
class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          // Unread cards have a subtle purple tint; read cards are white.
          color: isUnread ? _unreadCardBg : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _fieldBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Type icon
            _NotificationIcon(type: notification.type),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _textDark,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Date + unread dot
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            notification.date,
                            style: const TextStyle(
                              fontSize: 11,
                              color: _textGrey,
                              height: 1.3,
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(height: 4),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: _unreadDot,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Message
                  Text(
                    notification.message,
                    style: const TextStyle(
                      fontSize: 12,
                      color: _textGrey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Notification icon ─────────────────────────────────────────────────────────
class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.type});

  final NotificationType type;

  @override
  Widget build(BuildContext context) {
    final IconData icon = switch (type) {
      NotificationType.order => Icons.local_shipping_outlined,
      NotificationType.payment => Icons.payment_outlined,
      NotificationType.kyc => Icons.verified_user_outlined,
      NotificationType.system => Icons.notifications_outlined,
    };

    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: _iconBoxBg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 22, color: AppColors.primary),
    );
  }
}

// ── Shimmer list (loading state) ──────────────────────────────────────────────
class _NotificationsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

// ── Error body ────────────────────────────────────────────────────────────────
class _NotificationsErrorBody extends StatelessWidget {
  const _NotificationsErrorBody({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: _iconBoxBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textDark,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You are all caught up!',
            style: TextStyle(
              fontSize: 14,
              color: _textGrey,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
