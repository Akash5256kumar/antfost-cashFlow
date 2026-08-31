import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../core/widgets/primary_button.dart';

enum _DocCategory { corporate, quality }

enum _DocStatus { verified, expiringSoon, pendingReview }

class _DocItem {
  final String id;
  final String title;
  final String docNumber;
  final String fileFormat;
  final String fileSize;
  final String issueDate;
  final String expiryDate;
  final _DocCategory category;
  final _DocStatus status;

  const _DocItem({
    required this.id,
    required this.title,
    required this.docNumber,
    required this.fileFormat,
    required this.fileSize,
    required this.issueDate,
    required this.expiryDate,
    required this.category,
    required this.status,
  });
}

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_DocItem> _documents = [
    const _DocItem(
      id: 'doc_1',
      title: 'Commercial Trade License',
      docNumber: 'DED-CN-849201',
      fileFormat: 'PDF',
      fileSize: '3.2 MB',
      issueDate: '12 Jan 2025',
      expiryDate: '11 Jan 2027',
      category: _DocCategory.corporate,
      status: _DocStatus.verified,
    ),
    const _DocItem(
      id: 'doc_2',
      title: 'Federal Tax Authority (TRN / VAT)',
      docNumber: 'TRN-100293847500003',
      fileFormat: 'PDF',
      fileSize: '1.8 MB',
      issueDate: '01 Feb 2024',
      expiryDate: 'Permanent',
      category: _DocCategory.corporate,
      status: _DocStatus.verified,
    ),
    const _DocItem(
      id: 'doc_3',
      title: 'Authorized Signatory Emirates ID',
      docNumber: '784-1988-2940182-1',
      fileFormat: 'PDF',
      fileSize: '2.1 MB',
      issueDate: '15 Mar 2023',
      expiryDate: '14 Mar 2026',
      category: _DocCategory.corporate,
      status: _DocStatus.expiringSoon,
    ),
    const _DocItem(
      id: 'doc_4',
      title: 'Chamber of Commerce Certificate',
      docNumber: 'ADCCI-99482',
      fileFormat: 'PDF',
      fileSize: '1.4 MB',
      issueDate: '10 Jan 2025',
      expiryDate: '09 Jan 2026',
      category: _DocCategory.corporate,
      status: _DocStatus.verified,
    ),
    const _DocItem(
      id: 'doc_5',
      title: 'Municipality Night Pouring Permit (NOC)',
      docNumber: 'ADM-NOC-2026-0419',
      fileFormat: 'PDF',
      fileSize: '4.5 MB',
      issueDate: '01 Feb 2026',
      expiryDate: '28 Feb 2026',
      category: _DocCategory.quality,
      status: _DocStatus.verified,
    ),
    const _DocItem(
      id: 'doc_6',
      title: 'Concrete Mix QA / Slump Test Report',
      docNumber: 'QA-C35/45-9821',
      fileFormat: 'PDF',
      fileSize: '2.9 MB',
      issueDate: '05 Feb 2026',
      expiryDate: 'Valid for Al Reef Site',
      category: _DocCategory.quality,
      status: _DocStatus.verified,
    ),
    const _DocItem(
      id: 'doc_7',
      title: 'Cube 28-Day Strength Approval',
      docNumber: 'LAB-COMPR-2026',
      fileFormat: 'PDF',
      fileSize: '1.9 MB',
      issueDate: '08 Feb 2026',
      expiryDate: 'Under Review',
      category: _DocCategory.quality,
      status: _DocStatus.pendingReview,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showPreviewModal(_DocItem doc) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.scaled(18)),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                doc.title,
                style: TextStyle(
                  fontSize: context.scaled(16),
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dialogDetailRow('Document ID', doc.docNumber),
            _dialogDetailRow(
              'Format & Size',
              '${doc.fileFormat} • ${doc.fileSize}',
            ),
            _dialogDetailRow('Issued Date', doc.issueDate),
            _dialogDetailRow('Expiry / Validity', doc.expiryDate),
            const SizedBox(height: 12),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E5E8)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.verified_user_rounded,
                    color: Color(0xFF10B981),
                    size: 36,
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Digitally Certified Document',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Downloading ${doc.title}...'),
                  backgroundColor: AppColors.primary,
                ),
              );
            },
            icon: const Icon(
              Icons.download_rounded,
              size: 16,
              color: Colors.white,
            ),
            label: const Text(
              'Download PDF',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _dialogDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF888888), fontSize: 13),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A1A),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUploadSheet() {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.scaled(24)),
        ),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(context.scaled(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Upload Document',
              style: TextStyle(
                fontSize: context.scaled(18),
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Upload company license, VAT cert or municipality pouring permit (PDF/JPG)',
              style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8FA),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD4D4D4),
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 44,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Tap to browse files',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'PDF, JPG, PNG up to 15MB',
                    style: TextStyle(color: Color(0xFFAAAAAA), fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              label: 'Choose from Device',
              onPressed: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Document uploaded for verification!'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final corpDocs = _documents
        .where((d) => d.category == _DocCategory.corporate)
        .toList();
    final qualityDocs = _documents
        .where((d) => d.category == _DocCategory.quality)
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.upload_file_rounded,
              color: AppColors.primary,
              size: context.scaled(24),
            ),
            onPressed: _showUploadSheet,
          ),
        ],
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: AppColors.primary,
              unselectedLabelColor: const Color(0xFF777777),
              labelStyle: TextStyle(
                fontSize: context.scaled(13),
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(
                fontSize: context.scaled(13),
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Corporate & KYC'),
                  ),
                ),
                Tab(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('QC & Pouring Permits'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [_buildDocList(corpDocs), _buildDocList(qualityDocs)],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.fromLTRB(
            context.scaled(16),
            context.scaledV(12),
            context.scaled(16),
            context.scaledV(16),
          ),
          child: PrimaryButton(
            label: 'Upload New Document',
            onPressed: _showUploadSheet,
          ),
        ),
      ),
    );
  }

  Widget _buildDocList(List<_DocItem> docs) {
    return ListView.builder(
      padding: EdgeInsets.all(context.scaled(16)),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        return _buildDocCard(doc);
      },
    );
  }

  Widget _buildDocCard(_DocItem doc) {
    return Container(
      margin: EdgeInsets.only(bottom: context.scaledV(14)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.scaled(18)),
        border: Border.all(color: const Color(0xFFEAEAEA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.all(context.scaled(16)),
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
                    doc.fileFormat,
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
                      doc.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: context.scaled(15),
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: context.scaledV(4)),
                    Text(
                      '${doc.docNumber} • ${doc.fileSize}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: context.scaled(12),
                        color: const Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: context.scaled(8)),

              _buildStatusBadge(doc.status),
            ],
          ),
          SizedBox(height: context.scaledV(12)),

          const Divider(height: 1, color: Color(0xFFEFEFEF)),
          SizedBox(height: context.scaledV(10)),

          Row(
            children: [
              Expanded(
                child: Text(
                  'Expiry: ${doc.expiryDate}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: context.scaled(12),
                    color: const Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: context.scaled(8)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.all(context.scaled(6)),
                    icon: const Icon(
                      Icons.remove_red_eye_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: () => _showPreviewModal(doc),
                    tooltip: 'Preview',
                  ),
                  IconButton(
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.all(context.scaled(6)),
                    icon: const Icon(
                      Icons.download_rounded,
                      size: 20,
                      color: Color(0xFF555555),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading ${doc.title}...')),
                      );
                    },
                    tooltip: 'Download',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(_DocStatus status) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status) {
      case _DocStatus.verified:
        bg = const Color(0xFFE8F8F0);
        fg = const Color(0xFF10B981);
        label = 'Verified';
        icon = Icons.check_circle_rounded;
        break;
      case _DocStatus.expiringSoon:
        bg = const Color(0xFFFFF4E5);
        fg = const Color(0xFFD97706);
        label = 'Expires Soon';
        icon = Icons.access_time_rounded;
        break;
      case _DocStatus.pendingReview:
        bg = const Color(0xFFEEF2FF);
        fg = AppColors.primary;
        label = 'Under Review';
        icon = Icons.hourglass_empty_rounded;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scaled(8),
        vertical: context.scaledV(4),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.scaled(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: context.scaled(12), color: fg),
          SizedBox(width: context.scaled(4)),
          Text(
            label,
            style: TextStyle(
              fontSize: context.scaled(11),
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
