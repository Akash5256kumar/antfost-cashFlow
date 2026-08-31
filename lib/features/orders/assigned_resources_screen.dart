import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class AssignedResourcesScreen extends StatefulWidget {
  const AssignedResourcesScreen({
    super.key,
    this.orderId = 'AF-2048',
    this.projectName = 'Palm Jumeirah Villa',
  });

  final String orderId;
  final String projectName;

  @override
  State<AssignedResourcesScreen> createState() =>
      _AssignedResourcesScreenState();
}

class _AssignedResourcesScreenState extends State<AssignedResourcesScreen> {
  int _tab = 0; // 0 = Active, 1 = History

  static const _trucks = [
    ('Truck 01 of 4', 'Pouring', Color(0xFF4F46E5), '18:24'),
    ('Truck 02 of 4', 'Site Checkpoint', Color(0xFF4F46E5), '02:10'),
    ('Truck 03 of 4', 'Approaching', Color(0xFF4F46E5), '08 min'),
    ('Truck 04 of 4', 'Completed', Color(0xFF94A3B8), '10:12'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
        ),
        title: SvgPicture.asset(AppAssets.antfostLogo, height: 26),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.notifications),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
            ),
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
                  Text(
                    'Assigned Resources',
                    style: AppTextStyles.authScreenTitle(
                      context,
                    ).copyWith(fontSize: 24, color: const Color(0xFF1E1B4B)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.orderId} · ${widget.projectName}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Stats Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.local_shipping_outlined,
                        color: Color(0xFF4F46E5),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: '3',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E1B4B),
                            ),
                          ),
                          const TextSpan(
                            text: ' Active  ·  ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const TextSpan(
                            text: '1',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E1B4B),
                            ),
                          ),
                          const TextSpan(
                            text: ' Completed',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Map Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  AppAssets.artTrackingMap,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _TabButton(
                      label: 'Active',
                      active: _tab == 0,
                      onTap: () => setState(() => _tab = 0),
                    ),
                  ),
                  Expanded(
                    child: _TabButton(
                      label: 'History',
                      active: _tab == 1,
                      onTap: () => setState(() => _tab = 1),
                    ),
                  ),
                ],
              ),
            ),

            // List Area
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        'Each truck progresses independently.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ..._trucks.map((t) {
                      final isHistory =
                          t.$4 == '10:12'; // Simple check for the completed one
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: isHistory
                              ? () => Navigator.of(
                                  context,
                                ).pushNamed(AppRoutes.orderComplete)
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFF1F5F9),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x05000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  AppAssets.artHeroTruck,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        t.$1,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1E1B4B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Row(
                                        children: [
                                          Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              color: t.$3,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            t.$2,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: t.$3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (!isHistory)
                                      const Icon(
                                        Icons.access_time_rounded,
                                        size: 14,
                                        color: Color(0xFF4F46E5),
                                      ),
                                    if (!isHistory) const SizedBox(width: 4),
                                    Text(
                                      t.$4,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: t.$3,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      size: 18,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.liveTracking),
                        icon: const Icon(Icons.map_outlined, size: 20),
                        label: const Text('Open Live Map'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(height: MediaQuery.paddingOf(context).bottom + 20),
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

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
              width: 2,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
            color: active ? const Color(0xFF4F46E5) : const Color(0xFF94A3B8),
          ),
        ),
      ),
    );
  }
}
