import 'package:flutter/material.dart';

import '../../app/di/injection.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/errors/exceptions.dart';
import '../../core/services/document_api_service.dart';

enum _DocCategory { corporate, quality }

enum _DocStatus { uploaded, underReview, verified, rejected }

class _DocItem {
  const _DocItem({
    required this.id,
    required this.type,
    required this.fileName,
    required this.mimeType,
    required this.status,
    required this.uploadedAt,
    required this.fileUrl,
  });

  factory _DocItem.fromApi(Map<String, dynamic> json) => _DocItem(
    id: json['id']?.toString() ?? '',
    type: json['type']?.toString() ?? 'Document',
    fileName: json['fileName']?.toString() ?? 'Uploaded document',
    mimeType: json['mimeType']?.toString() ?? 'application/pdf',
    status: _statusFrom(json['status']?.toString()),
    uploadedAt: DateTime.tryParse(json['uploadedAt']?.toString() ?? ''),
    fileUrl: json['fileUrl']?.toString() ?? '',
  );

  final String id;
  final String type;
  final String fileName;
  final String mimeType;
  final _DocStatus status;
  final DateTime? uploadedAt;
  final String fileUrl;

  _DocCategory get category {
    final value = type.toLowerCase();
    return value.contains('quality') ||
            value.contains('pour') ||
            value.contains('permit') ||
            value.contains('cube') ||
            value.contains('slump') ||
            value.contains('test')
        ? _DocCategory.quality
        : _DocCategory.corporate;
  }

  String get title => _displayType(type);
  String get fileFormat => mimeType == 'application/pdf'
      ? 'PDF'
      : mimeType == 'image/png'
      ? 'PNG'
      : 'JPG';

  static _DocStatus _statusFrom(String? value) => switch (value
      ?.toLowerCase()) {
    'verified' || 'approved' => _DocStatus.verified,
    'rejected' => _DocStatus.rejected,
    'under_review' || 'pending_review' || 'pending' => _DocStatus.underReview,
    _ => _DocStatus.uploaded,
  };
}

String _displayType(String type) {
  const labels = {
    'tradeLicense': 'Commercial Trade License',
    'vatCertificate': 'VAT Certificate',
    'authorizedPersonId': 'Authorized Person ID',
  };
  if (labels.containsKey(type)) return labels[type]!;
  return type
      .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
      .replaceAll('_', ' ')
      .split(' ')
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});
  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final DocumentApiService _documentsApi = sl<DocumentApiService>();
  List<_DocItem> _documents = const [];
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadDocuments();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDocuments() async {
    if (mounted)
      setState(() {
        _isLoading = true;
        _loadError = null;
      });
    try {
      final documents = await _documentsApi.list();
      if (!mounted) return;
      setState(() => _documents = documents.map(_DocItem.fromApi).toList());
    } on ServerException catch (error) {
      if (mounted) setState(() => _loadError = error.message);
    } catch (_) {
      if (mounted)
        setState(
          () => _loadError = 'Unable to load documents. Please try again.',
        );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: isError ? AppColors.error : AppColors.primary,
        content: Text(message),
      ),
    );
  }

  Future<void> _confirmDelete(_DocItem document) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete document?'),
        content: Text('${document.title} will be removed from your documents.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete != true) return;
    try {
      await _documentsApi.delete(document.id);
      if (!mounted) return;
      _showMessage('Document deleted.');
      await _loadDocuments();
    } on ServerException catch (error) {
      if (mounted) _showMessage(error.message, isError: true);
    } catch (_) {
      if (mounted)
        _showMessage(
          'Unable to delete document. Please try again.',
          isError: true,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final corporate = _documents
        .where((document) => document.category == _DocCategory.corporate)
        .toList();
    final quality = _documents
        .where((document) => document.category == _DocCategory.quality)
        .toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textDark,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Documents',
          style: TextStyle(
            fontSize: context.scaled(18),
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: context.scaled(16)),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F5),
              borderRadius: BorderRadius.circular(context.scaled(12)),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(context.scaled(10)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.primary,
              unselectedLabelColor: const Color(0xFF777777),
              tabs: const [
                Tab(text: 'Corporate & KYC'),
                Tab(text: 'QC & Permits'),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _loadError != null
            ? _buildError()
            : TabBarView(
                controller: _tabController,
                children: [_buildDocList(corporate), _buildDocList(quality)],
              ),
      ),
    );
  }

  Widget _buildError() => Center(
    child: Padding(
      padding: EdgeInsets.all(context.scaled(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.folder_off_outlined,
            size: 44,
            color: Color(0xFF777777),
          ),
          const SizedBox(height: 12),
          Text(
            _loadError!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF555555)),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: _loadDocuments,
            child: const Text('Try Again'),
          ),
        ],
      ),
    ),
  );

  Widget _buildDocList(List<_DocItem> documents) {
    if (documents.isEmpty)
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.scaled(28)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.folder_open_outlined,
                size: 52,
                color: Color(0xFF9A9A9A),
              ),
              const SizedBox(height: 12),
              Text(
                'No documents uploaded yet',
                style: TextStyle(
                  fontSize: context.scaled(16),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Upload your verification documents from the KYC flow.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF777777)),
              ),
            ],
          ),
        ),
      );
    return RefreshIndicator(
      onRefresh: _loadDocuments,
      child: ListView.builder(
        padding: EdgeInsets.all(context.scaled(16)),
        itemCount: documents.length,
        itemBuilder: (context, index) => _buildDocCard(documents[index]),
      ),
    );
  }

  Widget _buildDocCard(_DocItem document) => Container(
    margin: EdgeInsets.only(bottom: context.scaledV(14)),
    padding: EdgeInsets.all(context.scaled(16)),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(context.scaled(18)),
      border: Border.all(color: const Color(0xFFEAEAEA)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.scaled(44),
              height: context.scaled(44),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEEEE),
                borderRadius: BorderRadius.circular(context.scaled(12)),
              ),
              child: Center(
                child: Text(
                  document.fileFormat,
                  style: TextStyle(
                    fontSize: context.scaled(12),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE53935),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.scaled(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: context.scaled(15),
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: context.scaledV(4)),
                  Text(
                    document.fileName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: context.scaled(12),
                      color: const Color(0xFF777777),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: context.scaled(8)),
            _buildStatusBadge(document.status),
          ],
        ),
        SizedBox(height: context.scaledV(12)),
        const Divider(height: 1, color: Color(0xFFEFEFEF)),
        SizedBox(height: context.scaledV(8)),
        Row(
          children: [
            Expanded(
              child: Text(
                'Uploaded: ${_formatDate(document.uploadedAt)}',
                style: TextStyle(
                  fontSize: context.scaled(12),
                  color: const Color(0xFF666666),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              constraints: const BoxConstraints(),
              padding: EdgeInsets.all(context.scaled(6)),
              icon: const Icon(
                Icons.remove_red_eye_outlined,
                size: 20,
                color: AppColors.primary,
              ),
              tooltip: 'Details',
              onPressed: () => _showDetails(document),
            ),
            IconButton(
              constraints: const BoxConstraints(),
              padding: EdgeInsets.all(context.scaled(6)),
              icon: const Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: Color(0xFFB42318),
              ),
              tooltip: 'Delete',
              onPressed: () => _confirmDelete(document),
            ),
          ],
        ),
      ],
    ),
  );

  void _showDetails(_DocItem document) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(document.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow('File', document.fileName),
          _detailRow('Format', document.fileFormat),
          _detailRow('Status', _statusLabel(document.status)),
          _detailRow('Uploaded', _formatDate(document.uploadedAt)),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    ),
  );
  Widget _detailRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        Text('$label: ', style: const TextStyle(color: Color(0xFF777777))),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );

  Widget _buildStatusBadge(_DocStatus status) {
    final (background, foreground, icon) = switch (status) {
      _DocStatus.verified => (
        const Color(0xFFE8F8F0),
        const Color(0xFF10B981),
        Icons.check_circle_rounded,
      ),
      _DocStatus.rejected => (
        const Color(0xFFFFEDEC),
        const Color(0xFFB42318),
        Icons.cancel_rounded,
      ),
      _DocStatus.underReview => (
        const Color(0xFFEEF2FF),
        AppColors.primary,
        Icons.hourglass_empty_rounded,
      ),
      _DocStatus.uploaded => (
        const Color(0xFFFFF4E5),
        const Color(0xFFD97706),
        Icons.cloud_upload_outlined,
      ),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(8),
        vertical: context.scaledV(4),
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(context.scaled(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.scaled(12), color: foreground),
          SizedBox(width: context.scaled(4)),
          Text(
            _statusLabel(status),
            style: TextStyle(
              fontSize: context.scaled(11),
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }

  String _statusLabel(_DocStatus status) => switch (status) {
    _DocStatus.verified => 'Verified',
    _DocStatus.rejected => 'Rejected',
    _DocStatus.underReview => 'Under Review',
    _DocStatus.uploaded => 'Uploaded',
  };
  String _formatDate(DateTime? value) {
    if (value == null) return '—';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${value.day} ${months[value.month - 1]} ${value.year}';
  }
}
