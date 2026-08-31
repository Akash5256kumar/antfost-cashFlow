import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import 'signatures_screen.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark = AppColors.textPrimary;
const Color _textGrey = AppColors.textSecondary;
const Color _fieldBorder = AppColors.cardBorder;
const Color _bodyBg = AppColors.background;
final Color _greenBorder = AppColors.success.withValues(alpha: 0.35);
const Color _greenBg = AppColors.successContainer;
const Color _greenText = AppColors.success;

// ── Checkpoint data model ─────────────────────────────────────────────────────
class _CheckpointItem {
  final String title;
  final String dateTime;
  final String verifiedBy;
  final String note;

  const _CheckpointItem({
    required this.title,
    required this.dateTime,
    required this.verifiedBy,
    required this.note,
  });
}

const _checkpoints = [
  _CheckpointItem(
    title: 'Batching Check',
    dateTime: '9 Feb, 01:45 PM',
    verifiedBy: 'QC Officer Ahmed',
    note: 'Mix proportions verified',
  ),
  _CheckpointItem(
    title: 'Loading Verification',
    dateTime: '9 Feb, 02:00 PM',
    verifiedBy: 'QC Officer Ahmed',
    note: 'Quantity confirmed: 45m³',
  ),
  _CheckpointItem(
    title: 'Delivery Verification',
    dateTime: '9 Feb, 08:00 PM',
    verifiedBy: 'Site Engineer',
    note: 'Delivered in full',
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────
class QcCheckpointScreen extends StatelessWidget {
  const QcCheckpointScreen({super.key, required this.invoiceId});
  final String invoiceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bodyBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // App bar
            _QcAppBar(invoiceId: invoiceId),

            // Body
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  context.scaled(16),
                  context.scaled(16),
                  context.scaled(16),
                  context.scaled(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header card
                    _WhiteCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Invoice: $invoiceId',
                            style: TextStyle(
                              fontSize: context.scaled(13),
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: context.scaledV(4)),
                          Text(
                            'Quality Check',
                            style: TextStyle(
                              fontSize: context.scaled(18),
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: context.scaledV(12)),
                          _QcVerifiedBadge(),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(16)),

                    // Checkpoint cards
                    ..._checkpoints.map(
                      (cp) => Padding(
                        padding: EdgeInsets.only(bottom: context.scaled(12)),
                        child: _CheckpointCard(item: cp),
                      ),
                    ),

                    // View Signature row
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const SignaturesScreen(),
                        ),
                      ),
                      child: _WhiteCard(
                        child: Row(
                          children: [
                            Text(
                              'View Signature',
                              style: TextStyle(
                                fontSize: context.scaled(15),
                                fontWeight: FontWeight.w500,
                                color: _textDark,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.chevron_right_rounded,
                              size: context.scaled(22),
                              color: _textGrey,
                            ),
                          ],
                        ),
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
class _QcAppBar extends StatelessWidget {
  const _QcAppBar({required this.invoiceId});
  final String invoiceId;

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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'QC Checkpoint Details',
                style: TextStyle(
                  fontSize: context.scaled(20),
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              SizedBox(height: context.scaledV(2)),
              Text(
                invoiceId,
                style: TextStyle(
                  fontSize: context.scaled(13),
                  fontWeight: FontWeight.w400,
                  color: _textGrey,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Checkpoint card ───────────────────────────────────────────────────────────
class _CheckpointCard extends StatelessWidget {
  const _CheckpointCard({required this.item});
  final _CheckpointItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.scaled(16)),
      decoration: BoxDecoration(
        color: _greenBg,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(color: _greenBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Passed badge
          Row(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                size: context.scaled(20),
                color: _greenText,
              ),
              SizedBox(width: context.scaled(8)),
              Expanded(
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: context.scaled(15),
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.scaled(12),
                  vertical: context.scaled(4),
                ),
                decoration: BoxDecoration(
                  color: _greenText,
                  borderRadius: BorderRadius.circular(context.scaled(20)),
                ),
                child: Text(
                  'Passed',
                  style: TextStyle(
                    fontSize: context.scaled(12),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.scaledV(6)),

          // Date
          Text(
            item.dateTime,
            style: TextStyle(
              fontSize: context.scaled(13),
              color: _textGrey,
              height: 1.3,
            ),
          ),
          SizedBox(height: context.scaledV(4)),

          // Verified by
          RichText(
            text: TextSpan(
              text: 'Verified by: ',
              style: TextStyle(
                fontSize: context.scaled(14),
                color: _textDark,
                height: 1.4,
              ),
              children: [
                TextSpan(
                  text: item.verifiedBy,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(height: context.scaledV(10)),

          // Note box
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: context.scaled(16),
              vertical: context.scaled(12),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(context.scaled(10)),
            ),
            child: Text(
              item.note,
              style: TextStyle(
                fontSize: context.scaled(14),
                fontWeight: FontWeight.w500,
                color: _textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ── QC Verified badge ─────────────────────────────────────────────────────────
class _QcVerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(12),
        vertical: context.scaled(6),
      ),
      decoration: BoxDecoration(
        color: _greenBg,
        borderRadius: BorderRadius.circular(context.scaled(20)),
        border: Border.all(color: _greenBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline_rounded,
            size: context.scaled(16),
            color: _greenText,
          ),
          SizedBox(width: context.scaled(6)),
          Text(
            'QC Verified',
            style: TextStyle(
              fontSize: context.scaled(13),
              fontWeight: FontWeight.w600,
              color: _greenText,
            ),
          ),
        ],
      ),
    );
  }
}

// ── White card ────────────────────────────────────────────────────────────────
class _WhiteCard extends StatelessWidget {
  const _WhiteCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.scaled(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        border: Border.all(color: _fieldBorder),
      ),
      child: child,
    );
  }
}
