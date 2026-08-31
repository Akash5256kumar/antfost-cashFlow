import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';

class RateDeliveryScreen extends StatefulWidget {
  const RateDeliveryScreen({super.key, this.orderId = 'AF-2057'});

  final String orderId;

  @override
  State<RateDeliveryScreen> createState() => _RateDeliveryScreenState();
}

class _RateDeliveryScreenState extends State<RateDeliveryScreen> {
  int _overall = 5;
  
  // Storing individual ratings
  final Map<String, int> _ratings = {
    'On-time Delivery': 5,
    'Concrete Quality': 5,
    'Driver Service': 5,
    'Pump Service': 5,
    'ANTFAST Support': 5,
  };

  final _commentController = TextEditingController();

  static const _categories = [
    (Icons.access_time_rounded, 'On-time Delivery'),
    (Icons.shield_outlined, 'Concrete Quality'),
    (Icons.person_outline, 'Driver Service'),
    (Icons.precision_manufacturing_outlined, 'Pump Service'),
    (Icons.support_agent_rounded, 'ANTFAST Support'),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
        ),
        title: SvgPicture.asset(AppAssets.antfostLogo, height: 26),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Rate Your Delivery', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(999)),
                    child: Text('${widget.orderId} · Palm Jumeirah Villa', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF4F46E5))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Hero Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  AppAssets.artPumpPourHero,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Overall Experience Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    const Text('Overall Experience', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (i) {
                        final n = i + 1;
                        return GestureDetector(
                          onTap: () => setState(() => _overall = n),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Icon(
                              Icons.star_rounded,
                              size: 44,
                              color: n <= _overall ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 8),
                    const Text('Excellent', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Rating Categories List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: _categories.asMap().entries.map((entry) {
                    final i = entry.key;
                    final icon = entry.value.$1;
                    final title = entry.value.$2;
                    final rating = _ratings[title]!;
                    
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(color: Color(0xFFEEF2FF), shape: BoxShape.circle),
                                child: Icon(icon, size: 18, color: const Color(0xFF4F46E5)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF1E1B4B)))),
                              Row(
                                children: List.generate(5, (starIndex) {
                                  final n = starIndex + 1;
                                  return GestureDetector(
                                    onTap: () => setState(() => _ratings[title] = n),
                                    child: Icon(
                                      Icons.star_rounded,
                                      size: 20,
                                      color: n <= rating ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
                            ],
                          ),
                        ),
                        if (i < _categories.length - 1)
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Text Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(text: 'Tell us more ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B))),
                          const TextSpan(text: '(optional)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _commentController,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Share any details or suggestions...',
                        hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                        isDense: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Upload Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.file_upload_outlined, size: 18, color: Color(0xFF4F46E5)),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('Add photos or documents', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF4F46E5)))),
                    const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Disclaimer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline_rounded, size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 8),
                  const Expanded(child: Text('Your feedback is linked to this delivery for service improvement.', style: TextStyle(fontSize: 12, color: Color(0xFF64748B)))),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (r) => false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Submit Rating'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      child: const Text('Not now'),
                    ),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: MediaQuery.paddingOf(context).bottom + 32),
          ],
        ),
      ),
    );
  }
}
