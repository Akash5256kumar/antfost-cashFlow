import 'package:flutter/material.dart';
import '../../app/di/injection.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/order_api_service.dart';

class SiteCheckpointScreen extends StatefulWidget {
  const SiteCheckpointScreen({
    super.key,
    this.orderId = 'AF-2057',
    this.projectName = 'Palm Jumeirah Villa',
  });
  final String orderId;
  final String projectName;
  @override
  State<SiteCheckpointScreen> createState() => _SiteCheckpointScreenState();
}

class _SiteCheckpointScreenState extends State<SiteCheckpointScreen> {
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
      title: const Text('Site Checkpoint'),
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
    final progress = data?['siteProgress'] as Map?;
    final resources = (data?['resources'] as List? ?? [])
        .whereType<Map>()
        .map(Map<String, dynamic>.from)
        .toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          widget.projectName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        Text(
          'Order ${widget.orderId}',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        _card('Checkpoint', progress?['checkpoint']?.toString() ?? '—'),
        if (progress?['startedAt'] != null)
          _card('Started', progress!['startedAt'].toString()),
        if (progress?['completedAt'] != null)
          _card('Completed', progress!['completedAt'].toString()),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Pump + Trucks',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        if (resources.isEmpty) const Text('No live resources available yet.'),
        ...resources.map(
          (r) => _card(
            r['label']?.toString() ?? 'Resource',
            '${r['status'] ?? '—'}${r['eta'] == null ? '' : '\nETA: ${r['eta']}'}',
          ),
        ),
      ],
    );
  }

  Widget _card(String a, String b) => Container(
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
        Text(a, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 5),
        Text(b, style: const TextStyle(color: AppColors.textSecondary)),
      ],
    ),
  );
}
