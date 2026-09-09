import 'package:flutter/material.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../app/config/app_assets.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/app_status_badge.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/svg_embedded_raster_image.dart';

/// Ported from the new Figma design's `screens/ProjectDetails.tsx`.
///
/// TODO(redesign-follow-up): this reads from static placeholder content —
/// wire it to the real project id once `ProjectsScreen`'s tap navigation
/// threads a `Project` (and its orders/locations) through instead of a
/// bare route push.
class ProjectDetailsScreen extends StatelessWidget {
  const ProjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBrandHeader(showBack: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg(context),
          0,
          AppSpacing.lg(context),
          context.scaledV(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.scaledV(4)),
            Text(
              'Project Details',
              style: AppTextStyles.authScreenTitle(
                context,
              ).copyWith(fontSize: context.scaled(22), letterSpacing: -0.02),
            ),
            SizedBox(height: context.scaledV(12)),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SvgEmbeddedRasterImage(
                assetPath: AppAssets.artVillaHero,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: context.scaledV(12)),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Palm Jumeirah Villa',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.authScreenTitle(context).copyWith(
                          fontSize: context.scaled(20),
                          letterSpacing: -0.02,
                        ),
                      ),
                      Text(
                        'PRJ-0318',
                        style: AppTextStyles.cardSubtitle(
                          context,
                        ).copyWith(fontSize: context.scaled(12)),
                      ),
                    ],
                  ),
                ),
                const AppStatusBadge(
                  label: 'Active',
                  tone: AppStatusTone.active,
                  showIcon: false,
                ),
              ],
            ),
            SizedBox(height: context.scaledV(14)),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: const Row(
                children: [
                  Expanded(
                    child: _StatCell(
                      icon: Icons.article_outlined,
                      value: '3',
                      label: 'Orders',
                    ),
                  ),
                  _VerticalDivider(),
                  Expanded(
                    child: _StatCell(
                      icon: Icons.location_on_outlined,
                      value: '2',
                      label: 'Locations',
                    ),
                  ),
                  _VerticalDivider(),
                  Expanded(
                    child: _StatCell(
                      icon: Icons.view_in_ar_outlined,
                      value: '46 m³',
                      label: 'Delivered',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.scaledV(14)),
            const AppIllustrationImage(
              asset: AppAssets.mapTwoPins,
              height: 154,
              borderRadius: 18,
            ),
            SizedBox(height: context.scaledV(16)),
            Text('Project Locations', style: AppTextStyles.cardTitle(context)),
            SizedBox(height: context.scaledV(8)),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: const [
                  _LocationRow(
                    name: 'Main Villa Entrance',
                    area: 'Palm Jumeirah, Frond F',
                  ),
                  Divider(height: 1, color: AppColors.cardBorder),
                  _LocationRow(
                    name: 'Service Gate',
                    area: 'Palm Jumeirah, Frond F',
                  ),
                ],
              ),
            ),
            SizedBox(height: context.scaledV(16)),
            Text('Recent Orders', style: AppTextStyles.cardTitle(context)),
            SizedBox(height: context.scaledV(8)),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: const [
                  _OrderRow(
                    id: 'AF-2048',
                    loc: 'Main Villa Entrance',
                    spec: '28 m³ · PUMP · 30 MPa',
                    label: 'On the way',
                    tone: AppStatusTone.onWay,
                    assetPath: AppAssets.figmaTruck,
                  ),
                  Divider(height: 1, color: AppColors.cardBorder),
                  _OrderRow(
                    id: 'AF-1987',
                    loc: 'Service Gate',
                    spec: '18 m³ · PUMP · 30 MPa',
                    label: 'Completed',
                    tone: AppStatusTone.completed,
                    assetPath: AppAssets.figmaTruck,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.scaledV(32)),
            PrimaryButton(
              arrow: true,
              icon: const Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: AppColors.white,
              ),
              label: 'Create Order for This Project',
              onPressed: () => Navigator.of(
                context,
                rootNavigator: true,
              ).pushNamed(AppRoutes.newCashOrderMixCode),
            ),
            SizedBox(height: context.scaledV(12)),
            PrimaryButton(
              variant: PrimaryButtonVariant.outline,
              icon: const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: AppColors.primary,
              ),
              label: 'Add Project Location',
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.addLocation),
            ),
            SizedBox(height: context.scaledV(20)),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: context.scaledV(16),
        horizontal: context.scaled(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.muted,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: context.scaled(18),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.0,
                  ),
                ),
                SizedBox(height: context.scaledV(4)),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: context.scaled(11),
                    color: AppColors.textSecondary,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();
  @override
  Widget build(BuildContext context) => const SizedBox(
    height: 52,
    child: VerticalDivider(width: 1, color: AppColors.cardBorder),
  );
}

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.name, required this.area});
  final String name;
  final String area;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.muted,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.location_on_outlined,
              size: 17,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.cardTitle(
                    context,
                  ).copyWith(fontSize: context.scaled(13.5)),
                ),
                Text(area, style: AppTextStyles.cardSubtitle(context)),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: AppColors.iconMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({
    required this.id,
    required this.loc,
    required this.spec,
    required this.label,
    required this.tone,
    required this.assetPath,
  });
  final String id;
  final String loc;
  final String spec;
  final String label;
  final AppStatusTone tone;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SvgEmbeddedRasterImage(
              assetPath: assetPath,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order $id',
                  style: AppTextStyles.cardTitle(
                    context,
                  ).copyWith(fontSize: context.scaled(13)),
                ),
                Text(loc, style: AppTextStyles.cardSubtitle(context)),
                Text(
                  spec,
                  style: AppTextStyles.cardSubtitle(
                    context,
                  ).copyWith(fontSize: context.scaled(10.5)),
                ),
              ],
            ),
          ),
          AppStatusBadge(label: label, tone: tone),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            size: 17,
            color: AppColors.iconMuted,
          ),
        ],
      ),
    );
  }
}
