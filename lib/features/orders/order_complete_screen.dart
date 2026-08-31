import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/config/app_assets.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'rate_delivery_screen.dart';

class OrderCompleteScreen extends StatelessWidget {
  const OrderCompleteScreen({
    super.key,
    this.orderId = 'AF-2057',
    this.projectName = 'Palm Jumeirah Villa',
    this.totalPoured = '50.00 m³',
    this.startTime = '06:15 AM',
    this.completedTime = '07:45 AM',
    this.driverName = 'Abdul Rahman',
    this.truckId = 'TR-4022',
    this.totalAmountPaid = 'AED 17,400.00',
  });

  final String orderId;
  final String projectName;
  final String totalPoured;
  final String startTime;
  final String completedTime;
  final String driverName;
  final String truckId;
  final String totalAmountPaid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        automaticallyImplyLeading: false, // No back arrow in design
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
            Text('Delivery Completed', textAlign: TextAlign.center, style: AppTextStyles.authScreenTitle(context).copyWith(fontSize: 24, color: const Color(0xFF1E1B4B))),
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(999)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Color(0xFF16A34A), shape: BoxShape.circle),
                      child: const Icon(Icons.check, size: 10, color: Colors.white),
                    ),
                    const SizedBox(width: 6),
                    const Text('Completed', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF16A34A))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Hero Image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  AppAssets.artDeliveredVilla, // matches confetti + villa + truck + receipt
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Details Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.home_outlined, size: 18, color: Color(0xFF4F46E5)),
                        ),
                        const SizedBox(width: 12),
                        Text('$orderId · $projectName', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoColumn(Icons.inventory_2_outlined, '120 m³', 'Delivered'),
                        _buildInfoColumn(Icons.verified_user_outlined, 'C30/37', 'Concrete Grade'),
                        _buildInfoColumn(Icons.person_outline, 'Pump +', 'Technician'),
                        _buildInfoColumn(Icons.calendar_today_outlined, 'Tuesday', '12 August'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Status Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildStatusItem(Icons.local_shipping_outlined, '8 of 8 trucks completed', 'All scheduled trucks have been delivered.'),
                    const SizedBox(height: 16),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 16),
                    _buildStatusItem(Icons.precision_manufacturing_outlined, 'Pump service completed', 'Concrete pumping and site service completed.'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Documents Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Documents', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        _buildDocItem('Download Invoice'),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        _buildDocItem('Download Receipt'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RateDeliveryScreen(orderId: 'AF-2057')),
                      ),
                      icon: const Icon(Icons.star_border_rounded, size: 20),
                      label: const Text('Rate Delivery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4F46E5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('View Order Summary'),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
                    icon: const Icon(Icons.home_outlined, size: 20, color: Color(0xFF4F46E5)),
                    label: const Text('Back to Home', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5))),
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

  Widget _buildInfoColumn(IconData icon, String val1, String val2) {
    return Column(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF8B5CF6)), // Purplish icon color
        const SizedBox(height: 8),
        Text(val1, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
        const SizedBox(height: 2),
        Text(val2, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildStatusItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 20, color: const Color(0xFF4F46E5)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1E1B4B))),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF64748B))),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
          child: const Icon(Icons.check, size: 12, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildDocItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, size: 18, color: Color(0xFF8B5CF6)),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E1B4B)))),
          const Icon(Icons.file_download_outlined, size: 18, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}
