import 'package:flutter/material.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _smsAlerts = true;
  bool _emailInvoices = true;
  bool _whatsappUpdates = false;
  bool _biometricsEnabled = true;

  void _showLegalDialog(String title, String content) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.scaled(18)),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: context.scaled(18),
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: TextStyle(
              fontSize: context.scaled(13),
              color: const Color(0xFF555555),
              height: 1.5,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.scaled(18)),
        ),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Deactivate Account?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to deactivate your AntFast corporate account? Active concrete deliveries and pending wallet balances will require administrative settlement.',
          style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Account deactivation request submitted to support'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Request Deactivation', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            fontSize: context.scaled(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(context.scaled(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Settings
              _buildSectionTitle('Notifications & Alerts'),
              SizedBox(height: context.scaledV(8)),
              _buildCard([
                _buildSwitchTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Live transit and batching plant status',
                  value: _pushNotifications,
                  onChanged: (val) => setState(() => _pushNotifications = val),
                ),
                _divider(),
                _buildSwitchTile(
                  icon: Icons.sms_outlined,
                  title: 'SMS Delivery Alerts',
                  subtitle: 'Truck arrival SMS to site engineer',
                  value: _smsAlerts,
                  onChanged: (val) => setState(() => _smsAlerts = val),
                ),
                _divider(),
                _buildSwitchTile(
                  icon: Icons.mail_outline_rounded,
                  title: 'Invoices by Email',
                  subtitle: 'Instant VAT receipts and PDF invoices',
                  value: _emailInvoices,
                  onChanged: (val) => setState(() => _emailInvoices = val),
                ),
                _divider(),
                _buildSwitchTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'WhatsApp Updates',
                  subtitle: 'Driver contact and slump test reports',
                  value: _whatsappUpdates,
                  onChanged: (val) => setState(() => _whatsappUpdates = val),
                ),
              ]),
              SizedBox(height: context.scaledV(20)),

              // Security
              _buildSectionTitle('Security & Access'),
              SizedBox(height: context.scaledV(8)),
              _buildCard([
                _buildSwitchTile(
                  icon: Icons.fingerprint_rounded,
                  title: 'Biometric Login',
                  subtitle: 'Face ID / Fingerprint quick authentication',
                  value: _biometricsEnabled,
                  onChanged: (val) => setState(() => _biometricsEnabled = val),
                ),
                _divider(),
                _buildNavTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Passcode',
                  subtitle: 'Update your 4-digit mobile passcode',
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.forgotPasscode),
                ),
              ]),
              SizedBox(height: context.scaledV(20)),

              // Preferences & Regional
              _buildSectionTitle('Preferences'),
              SizedBox(height: context.scaledV(8)),
              _buildCard([
                _buildInfoTile(
                  icon: Icons.monetization_on_outlined,
                  title: 'Default Currency',
                  value: 'AED (UAE Dirham)',
                ),
                _divider(),
                _buildInfoTile(
                  icon: Icons.view_in_ar_rounded,
                  title: 'Volume Unit',
                  value: 'm³ (Cubic Metres)',
                ),
                _divider(),
                _buildInfoTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  value: 'English (UAE)',
                ),
              ]),
              SizedBox(height: context.scaledV(20)),

              // Legal & About
              _buildSectionTitle('Legal & Support'),
              SizedBox(height: context.scaledV(8)),
              _buildCard([
                _buildNavTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () => _showLegalDialog(
                    'Terms of Service',
                    'AntFast ReadyMix Ordering Terms:\n\n1. Concrete mix orders are dispatched from accredited UAE batching plants.\n2. Slump tolerances adhere to BS EN 206 standards.\n3. Cancellations must be made at least 2 hours prior to scheduled batching.\n4. Payments are processed securely via registered UAE payment gateways.',
                  ),
                ),
                _divider(),
                _buildNavTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => _showLegalDialog(
                    'Privacy Policy',
                    'AntFast Privacy Commitment:\n\nWe store your corporate KYC, delivery project locations, and transaction history in encrypted databases compliant with UAE data protection regulations.',
                  ),
                ),
              ]),
              SizedBox(height: context.scaledV(20)),

              // Danger Zone
              _buildSectionTitle('Account'),
              SizedBox(height: context.scaledV(8)),
              _buildCard([
                _buildNavTile(
                  icon: Icons.delete_outline_rounded,
                  title: 'Deactivate Account',
                  subtitle: 'Permanently close your corporate buyer account',
                  titleColor: Colors.redAccent,
                  iconColor: Colors.redAccent,
                  onTap: _showDeleteAccountDialog,
                ),
              ]),
              SizedBox(height: context.scaledV(24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: context.scaled(15),
        fontWeight: FontWeight.w700,
        color: const Color(0xFF1A1A1A),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(18)),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      color: Color(0xFFEFEFEF),
      indent: 16,
      endIndent: 16,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(16),
        vertical: context.scaledV(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: context.scaled(14),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: context.scaled(12),
                    color: const Color(0xFF888888),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.scaled(16),
            vertical: context.scaledV(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: context.scaled(14),
                        fontWeight: FontWeight.w600,
                        color: titleColor ?? const Color(0xFF1A1A1A),
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: context.scaled(12),
                          color: const Color(0xFF888888),
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF9E9E9E), size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(16),
        vertical: context.scaledV(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: context.scaled(14),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: context.scaled(13),
                fontWeight: FontWeight.w500,
                color: const Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
