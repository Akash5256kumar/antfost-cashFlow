import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/di/injection.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/order_api_service.dart';

class SignaturesScreen extends StatefulWidget {
  const SignaturesScreen({super.key, required this.orderId});
  final String orderId;
  @override
  State<SignaturesScreen> createState() => _SignaturesScreenState();
}

class _SignaturesScreenState extends State<SignaturesScreen> {
  List<Map<String, dynamic>> items = const [];
  String? error;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      items = await sl<OrderApiService>().deliverySignatures(widget.orderId);
    } catch (e) {
      error = e.toString();
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.background,
    appBar: AppBar(
      backgroundColor: Colors.white,
      title: const Text('Delivery Signatures'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : error != null
        ? Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error!),
                TextButton(onPressed: load, child: const Text('Try Again')),
              ],
            ),
          )
        : ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (items.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(28),
                    child: Text('No delivery signatures are available yet.'),
                  ),
                ),
              ...items.map(_card),
            ],
          ),
  );
  Widget _card(Map<String, dynamic> item) => Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item['signerName']?.toString() ?? 'Signer',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 4),
        Text(
          item['signerRole']?.toString() ?? '—',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 8),
        Text(
          'Signed: ${item['signedAt'] ?? '—'}',
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        if (item['imageUrl'] is String &&
            (item['imageUrl'] as String).isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => launchUrl(
                Uri.parse(item['imageUrl'] as String),
                mode: LaunchMode.externalApplication,
              ),
              child: const Text('View signature'),
            ),
          ),
      ],
    ),
  );
}
