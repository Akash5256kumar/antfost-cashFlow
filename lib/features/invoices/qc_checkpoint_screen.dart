import 'package:flutter/material.dart';

import '../../app/di/injection.dart';
import '../../app/theme/app_colors.dart';
import '../../core/services/order_api_service.dart';
import 'signatures_screen.dart';

class QcCheckpointScreen extends StatefulWidget {
  const QcCheckpointScreen({super.key, required this.orderId});
  final String orderId;
  @override
  State<QcCheckpointScreen> createState() => _QcCheckpointScreenState();
}

class _QcCheckpointScreenState extends State<QcCheckpointScreen> {
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
      await Future.delayed(const Duration(milliseconds: 500));
      data = {
        'status': 'verified',
        'checkedBy': 'John Doe (Inspector)',
        'checkpoints': [
          {
            'name': 'Slump Test',
            'status': 'verified',
            'checkedAt': '10:15 AM',
            'note': 'Slump is within 150mm limit',
          },
          {
            'name': 'Temperature Check',
            'status': 'verified',
            'checkedAt': '10:18 AM',
            'note': '31°C (Optimal)',
          },
          {
            'name': 'Visual Inspection',
            'status': 'pending',
          }
        ]
      };
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
      title: const Text('Quality Check'),
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
    final items = (data?['checkpoints'] as List? ?? [])
        .whereType<Map>()
        .map(Map<String, dynamic>.from)
        .toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _card(
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order ${widget.orderId}',
                      style: const TextStyle(color: AppColors.primary),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Quality Check',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              _badge(data?['status']?.toString() ?? 'pending'),
            ],
          ),
        ),
        if (items.isEmpty)
          _card(const Text('No quality checkpoints are available yet.')),
        ...items.map(
          (item) => _card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['name']?.toString() ?? 'Checkpoint',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    _badge(item['status']?.toString() ?? 'pending'),
                  ],
                ),
                if (item['checkedAt'] != null)
                  Text(
                    item['checkedAt'].toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                if (item['note'] != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(item['note'].toString()),
                  ),
              ],
            ),
          ),
        ),
        if ((data?['checkedBy']?.toString().isNotEmpty ?? false))
          _card(Text('Checked by: ${data!['checkedBy']}')),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SignaturesScreen(orderId: widget.orderId),
            ),
          ),
          icon: const Icon(Icons.draw_outlined),
          label: const Text('View Delivery Signatures'),
        ),
      ],
    );
  }

  Widget _card(Widget child) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: child,
  );
  Widget _badge(String value) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: value == 'verified'
          ? AppColors.successContainer
          : AppColors.primaryContainer,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      value.replaceAll('_', ' '),
      style: TextStyle(
        fontSize: 12,
        color: value == 'verified' ? AppColors.success : AppColors.primary,
      ),
    ),
  );
}
