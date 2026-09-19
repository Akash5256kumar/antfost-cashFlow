import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/navigation/app_route_args.dart';
import '../../app/navigation/app_routes.dart';
import '../../core/widgets/primary_button.dart';
import 'domain/entities/kyc_status.dart';
import 'presentation/bloc/kyc_bloc.dart';
import 'presentation/bloc/kyc_event.dart';
import 'presentation/bloc/kyc_state.dart';

/// Uses GET /kyc/status so this page never presents a hard-coded KYC state.
class VerificationStatusScreen extends StatefulWidget {
  const VerificationStatusScreen({super.key});

  @override
  State<VerificationStatusScreen> createState() =>
      _VerificationStatusScreenState();
}

class _VerificationStatusScreenState extends State<VerificationStatusScreen> {
  @override
  void initState() {
    super.initState();
    context.read<KycBloc>().add(const FetchKycStatusEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Verification Status',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: context.scaled(18),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<KycBloc, KycState>(
          builder: (context, state) {
            if (state is KycInitial || state is KycLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is KycError) {
              return _StatusError(
                message: state.message,
                onRetry: () =>
                    context.read<KycBloc>().add(const RetryKycEvent()),
              );
            }
            if (state is KycStatusLoaded) {
              return _VerificationStatusBody(status: state.status);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _VerificationStatusBody extends StatelessWidget {
  const _VerificationStatusBody({required this.status});
  final KycStatus status;

  @override
  Widget build(BuildContext context) {
    final view = _VerificationView.fromStatus(status);
    final companyStatus = status.companyDetailsComplete == false
        ? _missingFieldsLabel(status.companyMissingFields)
        : view.companyStatus;
    final requiredDocuments = status.documents.where((doc) => doc.required);
    final documentStatus = requiredDocuments.isEmpty
        ? view.documentStatus
        : requiredDocuments.every(
            (doc) => doc.status.toLowerCase() == 'under_review',
          )
        ? 'Under review'
        : requiredDocuments.any((doc) => doc.status.toLowerCase() == 'missing')
        ? 'Upload required'
        : 'Submitted';
    final documentDetail = status.documents.isEmpty
        ? null
        : status.documents
              .map((doc) => '${doc.label}${doc.required ? '' : ' (optional)'}')
              .join(' • ');
    final returnsHome =
        status.status == KycVerificationStatus.pending ||
        status.status == KycVerificationStatus.approved ||
        status.status == KycVerificationStatus.notRequired;
    final canPop = Navigator.of(context).canPop();

    void handlePrimaryAction() {
      if (returnsHome) {
        if (canPop) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRoutes.home,
            (route) => false,
            arguments: HomeRouteArgs(
              verificationUnderReview:
                  status.status == KycVerificationStatus.pending,
            ),
          );
        }
        return;
      }
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.kycVerification,
        (route) => false,
        arguments: true,
      );
    }

    return Padding(
      padding: EdgeInsets.all(context.scaled(20)),
      child: Column(
        children: [
          _StatusHero(
            imageUrl: status.imageUrl,
            icon: view.icon,
            color: view.color,
            background: view.background,
          ),
          SizedBox(height: context.scaledV(20)),
          Text(
            view.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.scaled(22),
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: context.scaledV(8)),
          Text(
            view.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.scaled(13),
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          SizedBox(height: context.scaledV(28)),
          _StatusRow(
            icon: Icons.business_rounded,
            title: 'Company details',
            status: companyStatus,
            color: view.color,
          ),
          _StatusRow(
            icon: Icons.description_outlined,
            title: 'Business documents',
            status: documentStatus,
            color: view.color,
            detail: documentDetail,
          ),
          if (status.estimatedReviewTime?.trim().isNotEmpty ?? false)
            Padding(
              padding: EdgeInsets.only(top: context.scaledV(4)),
              child: Text(
                'Estimated review time: ${status.estimatedReviewTime}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: context.scaled(12),
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          if (status.rejectionReason?.trim().isNotEmpty ?? false) ...[
            SizedBox(height: context.scaledV(4)),
            _ReasonCard(reason: status.rejectionReason!),
          ],
          const Spacer(),
          PrimaryButton(
            label: returnsHome
                ? 'Proceed'
                : status.status == KycVerificationStatus.rejected
                ? 'Update verification'
                : 'Continue verification',
            onPressed: handlePrimaryAction,
          ),
        ],
      ),
    );
  }

  String _missingFieldsLabel(List<String> fields) {
    if (fields.isEmpty) return 'Details required';
    return '${fields.length} detail${fields.length == 1 ? '' : 's'} required';
  }
}

class _StatusHero extends StatelessWidget {
  const _StatusHero({
    required this.imageUrl,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String? imageUrl;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl?.trim().isNotEmpty ?? false;
    if (hasImage) {
      // KYC artwork is intentionally wide. Keep its original aspect ratio
      // rather than cropping it into the old circular status icon.
      return Image.network(
        imageUrl!,
        width: context.scaled(260),
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => _fallback(context),
      );
    }
    return _fallback(context);
  }

  Widget _fallback(BuildContext context) => Container(
    width: context.scaled(88),
    height: context.scaled(88),
    decoration: BoxDecoration(color: background, shape: BoxShape.circle),
    child: Icon(icon, color: color, size: context.scaled(38)),
  );
}

class _VerificationView {
  const _VerificationView({
    required this.icon,
    required this.color,
    required this.background,
    required this.title,
    required this.description,
    required this.companyStatus,
    required this.documentStatus,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String title;
  final String description;
  final String companyStatus;
  final String documentStatus;

  factory _VerificationView.fromStatus(
    KycStatus status,
  ) => switch (status.status) {
    KycVerificationStatus.notRequired => const _VerificationView(
      icon: Icons.verified_rounded,
      color: AppColors.success,
      background: AppColors.successContainer,
      title: 'Verification not required',
      description:
          'Your account is ready. You can plan orders and make payments.',
      companyStatus: 'Not required',
      documentStatus: 'Not required',
    ),
    KycVerificationStatus.approved => const _VerificationView(
      icon: Icons.verified_rounded,
      color: AppColors.success,
      background: AppColors.successContainer,
      title: 'Verification approved',
      description:
          'Your business is verified. You can plan orders and make payments.',
      companyStatus: 'Verified',
      documentStatus: 'Verified',
    ),
    KycVerificationStatus.pending => const _VerificationView(
      icon: Icons.hourglass_top_rounded,
      color: AppColors.warning,
      background: AppColors.warningContainer,
      title: 'Verification under review',
      description:
          'Your company documents have been submitted and are being reviewed.',
      companyStatus: 'Submitted',
      documentStatus: 'Under review',
    ),
    KycVerificationStatus.partiallySubmitted => const _VerificationView(
      icon: Icons.assignment_late_outlined,
      color: AppColors.infoText,
      background: AppColors.infoContainer,
      title: 'More details required',
      description:
          'Your uploaded documents are saved. Complete the remaining business details to submit verification for review.',
      companyStatus: 'Details required',
      documentStatus: 'Submitted',
    ),
    KycVerificationStatus.rejected => const _VerificationView(
      icon: Icons.error_outline_rounded,
      color: AppColors.error,
      background: Color(0xFFFEECEC),
      title: 'Verification needs attention',
      description:
          'Please update the requested business information or documents.',
      companyStatus: 'Action required',
      documentStatus: 'Action required',
    ),
    KycVerificationStatus.notSubmitted => const _VerificationView(
      icon: Icons.assignment_late_outlined,
      color: AppColors.infoText,
      background: AppColors.infoContainer,
      title: 'Complete verification',
      description:
          'Submit your business details and documents to activate payments.',
      companyStatus: 'Not submitted',
      documentStatus: 'Not submitted',
    ),
  };
}

class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.icon,
    required this.title,
    required this.status,
    required this.color,
    this.detail,
  });
  final IconData icon;
  final String title;
  final String status;
  final Color color;
  final String? detail;

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(bottom: context.scaledV(12)),
    padding: EdgeInsets.all(context.scaled(14)),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(context.scaled(14)),
      border: Border.all(color: AppColors.cardBorder),
    ),
    child: Row(
      children: [
        Icon(icon, color: AppColors.primary),
        SizedBox(width: context.scaled(12)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: context.scaled(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              if (detail?.isNotEmpty ?? false)
                Padding(
                  padding: EdgeInsets.only(top: context.scaledV(3)),
                  child: Text(
                    detail!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: context.scaled(11),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Text(
          status,
          style: TextStyle(
            fontSize: context.scaled(12),
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    ),
  );
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({required this.reason});
  final String reason;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(context.scaled(14)),
    decoration: BoxDecoration(
      color: const Color(0xFFFEECEC),
      borderRadius: BorderRadius.circular(context.scaled(14)),
    ),
    child: Text(
      reason,
      style: TextStyle(fontSize: context.scaled(13), color: AppColors.error),
    ),
  );
}

class _StatusError extends StatelessWidget {
  const _StatusError({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(context.scaled(24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline_rounded, size: 46),
          SizedBox(height: context.scaledV(12)),
          Text(message, textAlign: TextAlign.center),
          SizedBox(height: context.scaledV(12)),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    ),
  );
}
