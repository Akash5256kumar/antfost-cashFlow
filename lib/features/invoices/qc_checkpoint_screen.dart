import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

// ── Local palette ─────────────────────────────────────────────────────────────
const Color _textDark    = Color(0xFF1A1A1A);
const Color _textGrey    = Color(0xFF9E9E9E);
const Color _fieldBorder = Color(0xFFE8E8E8);
const Color _bodyBg      = Color(0xFFF2F2F7);
const Color _greenBorder = Color(0xFF86EFAC);
const Color _greenBg     = Color(0xFFF0FDF4);
const Color _greenText   = Color(0xFF16A34A);

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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
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
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Quality Check',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: _textDark,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _QcVerifiedBadge(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Checkpoint cards
                    ..._checkpoints.map(
                      (cp) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CheckpointCard(item: cp),
                      ),
                    ),

                    // View Signature row
                    _WhiteCard(
                      child: Row(
                        children: const [
                          Text(
                            'View Signature',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: _textDark,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.chevron_right_rounded,
                              size: 22, color: _textGrey),
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
class _QcAppBar extends StatelessWidget {
  const _QcAppBar({required this.invoiceId});
  final String invoiceId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'QC Checkpoint Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                invoiceId,
                style: const TextStyle(
                  fontSize: 13,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _greenBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _greenBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Passed badge
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                size: 20,
                color: _greenText,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _greenText,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Passed',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Date
          Text(
            item.dateTime,
            style: const TextStyle(
              fontSize: 13,
              color: _textGrey,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),

          // Verified by
          RichText(
            text: TextSpan(
              text: 'Verified by: ',
              style: const TextStyle(
                fontSize: 14,
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
          const SizedBox(height: 10),

          // Note box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              item.note,
              style: const TextStyle(
                fontSize: 14,
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _greenBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _greenBorder),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline_rounded,
              size: 16, color: _greenText),
          SizedBox(width: 6),
          Text(
            'QC Verified',
            style: TextStyle(
              fontSize: 13,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _fieldBorder),
      ),
      child: child,
    );
  }
}
