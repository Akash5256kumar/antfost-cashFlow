import 'package:flutter/material.dart';
import '../../app/di/injection.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/order_api_service.dart';

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
  Map<String, dynamic>? data;
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
      data = await sl<OrderApiService>().operations(widget.orderId);
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
      title: const Text('Assigned Resources'),
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
        : _body(),
  );
  Widget _body() {
    final resources =
        (data?['resources'] as List? ?? [])
            .whereType<Map>()
            .map(Map<String, dynamic>.from)
            .toList()
          ..sort(
            (a, b) => ((a['sequence'] as num?)?.toInt() ?? 0).compareTo(
              (b['sequence'] as num?)?.toInt() ?? 0,
            ),
          );
    final progress = data?['siteProgress'] as Map?;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          widget.projectName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'Order ${widget.orderId}',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        _card('Delivery status', data?['deliveryStatus']?.toString() ?? '—'),
        _card('Site checkpoint', progress?['checkpoint']?.toString() ?? '—'),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Assigned resources',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        if (resources.isEmpty)
          const Text('No resources have been assigned yet.'),
        ...resources.map(
          (r) => _card(
            r['label']?.toString() ?? r['type']?.toString() ?? 'Resource',
            '${r['type'] ?? 'resource'} • ${r['status'] ?? '—'}${r['eta'] == null ? '' : '\nETA: ${r['eta']}'}',
          ),
        ),
      ],
    );
  }

  Widget _card(String title, String value) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 5),
        Text(value, style: const TextStyle(color: AppColors.textSecondary)),
      ],
    ),
  );
}
