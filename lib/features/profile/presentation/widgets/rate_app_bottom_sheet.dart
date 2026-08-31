import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_scale.dart';
import '../../../../core/widgets/primary_button.dart';

/// Interactive modal bottom sheet allowing users to rate the application
/// with stars, positive/feedback tags, and free-form feedback.
class RateAppBottomSheet extends StatefulWidget {
  const RateAppBottomSheet({super.key});

  /// Static helper to display the sheet.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const RateAppBottomSheet(),
    );
  }

  @override
  State<RateAppBottomSheet> createState() => _RateAppBottomSheetState();
}

class _RateAppBottomSheetState extends State<RateAppBottomSheet> {
  int _selectedRating = 5;
  final Set<String> _selectedTags = {'Fast Delivery', 'Easy Mix Selection'};
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitted = false;

  static const List<String> _tags = [
    'Fast Delivery',
    'Easy Mix Selection',
    'Accurate GPS Tracking',
    'Great Concrete Quality',
    'Helpful Support',
    'Transparent Pricing',
    'Clean Invoicing',
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    setState(() => _isSubmitted = true);
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              content: Text('Thank you for your rating!'),
              backgroundColor: AppColors.primary,
            ),
          );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.scaled(28)),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        context.scaled(20),
        context.scaled(12),
        context.scaled(20),
        context.scaled(24) + bottomInset,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isSubmitted ? _buildSuccessView() : _buildFormView(),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Column(
      key: const ValueKey('success'),
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: context.scaledV(24)),
        Container(
          width: context.scaled(72),
          height: context.scaled(72),
          decoration: const BoxDecoration(
            color: AppColors.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_rounded,
            color: AppColors.primary,
            size: context.scaled(48),
          ),
        ),
        SizedBox(height: context.scaledV(16)),
        Text(
          'Thank You!',
          style: TextStyle(
            fontSize: context.scaled(22),
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        SizedBox(height: context.scaledV(8)),
        Text(
          'Your feedback helps us make concrete deliveries faster, smoother, and more reliable.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: context.scaled(14),
            color: const Color(0xFF888888),
            height: 1.4,
          ),
        ),
        SizedBox(height: context.scaledV(24)),
      ],
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      key: const ValueKey('form'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle
          Container(
            width: context.scaled(40),
            height: context.scaled(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: context.scaledV(16)),

          // Header
          Text(
            'Enjoying AntFast?',
            style: TextStyle(
              fontSize: context.scaled(20),
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: context.scaledV(6)),
          Text(
            'Tap a star to rate your overall experience',
            style: TextStyle(
              fontSize: context.scaled(14),
              color: const Color(0xFF888888),
            ),
          ),
          SizedBox(height: context.scaledV(16)),

          // Interactive Stars
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                final starIndex = index + 1;
                final isFilled = starIndex <= _selectedRating;

                return IconButton(
                  onPressed: () => setState(() => _selectedRating = starIndex),
                  iconSize: context.scaled(36),
                  splashRadius: context.scaled(24),
                  icon: Icon(
                    isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFilled ? const Color(0xFFFFB800) : const Color(0xFFD4D4D4),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: context.scaledV(16)),

          // Tag chips
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'What did you like most?',
              style: TextStyle(
                fontSize: context.scaled(14),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          SizedBox(height: context.scaledV(10)),

          Wrap(
            spacing: context.scaled(8),
            runSpacing: context.scaledV(8),
            children: _tags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedTags.add(tag);
                    } else {
                      _selectedTags.remove(tag);
                    }
                  });
                },
                selectedColor: AppColors.primaryContainer,
                backgroundColor: const Color(0xFFF7F7F9),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  fontSize: context.scaled(13),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primary : const Color(0xFF555555),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.scaled(10)),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : const Color(0xFFE8E8E8),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: context.scaledV(16)),

          // Optional comment
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8FA),
              borderRadius: BorderRadius.circular(context.scaled(14)),
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            padding: EdgeInsets.symmetric(horizontal: context.scaled(14)),
            child: TextField(
              controller: _feedbackController,
              maxLines: 3,
              style: TextStyle(
                fontSize: context.scaled(14),
                color: const Color(0xFF1A1A1A),
              ),
              decoration: InputDecoration(
                hintText: 'Add an optional note or suggestion...',
                hintStyle: TextStyle(
                  fontSize: context.scaled(13),
                  color: const Color(0xFFAAAAAA),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: context.scaledV(20)),

          // Submit button
          PrimaryButton(
            label: 'Submit Rating',
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
}
