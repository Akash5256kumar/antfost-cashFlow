import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/primary_button.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _orderRefController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  String _selectedCategory = 'Order Delivery & Dispatch';
  bool _isSending = false;

  final List<String> _categories = [
    'Order Delivery & Dispatch',
    'Concrete Mix & Quality (QA/QC)',
    'Invoices & VAT Certificates',
    'Wallet Top-Up & Refunds',
    'Site Access & Pump Booking',
    'Other Technical Inquiry',
  ];

  @override
  void dispose() {
    _subjectController.dispose();
    _orderRefController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => _isSending = false);
        _subjectController.clear();
        _orderRefController.clear();
        _messageController.clear();

        showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.scaled(18)),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Color(0xFF10B981), size: 28),
                SizedBox(width: 10),
                Text('Message Sent'),
              ],
            ),
            content: const Text(
              'Your support ticket has been logged. Our technical dispatch team will respond within 30 minutes.',
              style: TextStyle(fontSize: 13, color: Color(0xFF555555)),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      }
    });
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
          'Contact Us',
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
              // Contact Channels Grid
              Row(
                children: [
                  Expanded(
                    child: _buildContactChannel(
                      icon: Icons.phone_in_talk_rounded,
                      title: '24/7 Hotline',
                      subtitle: '+971 800 ANTFAS',
                      color: const Color(0xFF10B981),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Calling Dispatch Hotline: 800-ANTFAS')),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: context.scaled(12)),
                  Expanded(
                    child: _buildContactChannel(
                      icon: Icons.chat_rounded,
                      title: 'WhatsApp Chat',
                      subtitle: '+971 50 849 2011',
                      color: const Color(0xFF25D366),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening WhatsApp Support Chat...')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.scaledV(12)),

              Row(
                children: [
                  Expanded(
                    child: _buildContactChannel(
                      icon: Icons.mail_outline_rounded,
                      title: 'Email Support',
                      subtitle: 'support@antfast.ae',
                      color: AppColors.primary,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening Email client for support@antfast.ae')),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: context.scaled(12)),
                  Expanded(
                    child: _buildContactChannel(
                      icon: Icons.location_city_rounded,
                      title: 'Headquarters',
                      subtitle: 'Abu Dhabi, UAE',
                      color: const Color(0xFFFF9800),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('AntFast ReadyMix HQ, Al Maryah Island')),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.scaledV(24)),

              // Inquiry Form Card
              Text(
                'Send Us a Message',
                style: TextStyle(
                  fontSize: context.scaled(16),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: context.scaledV(10)),

              Container(
                padding: EdgeInsets.all(context.scaled(16)),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(context.scaled(18)),
                  border: Border.all(color: const Color(0xFFEAEAEA)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Dropdown
                      Text(
                        'Inquiry Category',
                        style: TextStyle(
                          fontSize: context.scaled(13),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF777777),
                        ),
                      ),
                      SizedBox(height: context.scaledV(6)),
                      DropdownButtonFormField<String>(
                        value: _selectedCategory,
                        isExpanded: true,
                        items: _categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(
                              cat,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: context.scaled(13)),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedCategory = val);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF9F9FB),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                          ),
                        ),
                      ),
                      SizedBox(height: context.scaledV(14)),

                      // Order Ref (Optional)
                      Text(
                        'Order Reference ID (Optional)',
                        style: TextStyle(
                          fontSize: context.scaled(13),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF777777),
                        ),
                      ),
                      SizedBox(height: context.scaledV(6)),
                      TextFormField(
                        controller: _orderRefController,
                        decoration: InputDecoration(
                          hintText: 'e.g. ORD-2026-0842',
                          hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                          filled: true,
                          fillColor: const Color(0xFFF9F9FB),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                          ),
                        ),
                      ),
                      SizedBox(height: context.scaledV(14)),

                      // Subject
                      Text(
                        'Subject',
                        style: TextStyle(
                          fontSize: context.scaled(13),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF777777),
                        ),
                      ),
                      SizedBox(height: context.scaledV(6)),
                      TextFormField(
                        controller: _subjectController,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a subject' : null,
                        decoration: InputDecoration(
                          hintText: 'Brief summary of your inquiry',
                          hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                          filled: true,
                          fillColor: const Color(0xFFF9F9FB),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                          ),
                        ),
                      ),
                      SizedBox(height: context.scaledV(14)),

                      // Message
                      Text(
                        'Message Details',
                        style: TextStyle(
                          fontSize: context.scaled(13),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF777777),
                        ),
                      ),
                      SizedBox(height: context.scaledV(6)),
                      TextFormField(
                        controller: _messageController,
                        maxLines: 4,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Please describe your request' : null,
                        decoration: InputDecoration(
                          hintText: 'Provide complete details regarding your concrete order, site location, or issue...',
                          hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 13),
                          filled: true,
                          fillColor: const Color(0xFFF9F9FB),
                          contentPadding: const EdgeInsets.all(14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFE8E8E8)),
                          ),
                        ),
                      ),
                      SizedBox(height: context.scaledV(20)),

                      // Submit Button
                      PrimaryButton(
                        label: 'Submit Support Ticket',
                        isLoading: _isSending,
                        onPressed: _handleSubmit,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: context.scaledV(24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactChannel({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(context.scaled(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.scaled(16)),
        child: Container(
          padding: EdgeInsets.all(context.scaled(14)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(context.scaled(16)),
            border: Border.all(color: const Color(0xFFEAEAEA)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(height: context.scaledV(10)),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: context.scaled(14),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              SizedBox(height: context.scaledV(2)),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: context.scaled(12),
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF666666),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
