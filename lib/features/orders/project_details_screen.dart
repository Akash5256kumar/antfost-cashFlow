import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/navigation/app_routes.dart';
import '../../app/navigation/app_route_args.dart';
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
import '../../app/di/injection.dart';
import '../../core/services/project_location_api_service.dart';
import 'new_cash_order_draft.dart';
import 'new_cash_order_mix_code_screen.dart';
import 'order_project_summary.dart';

/// Ported from the new Figma design's `screens/ProjectDetails.tsx`.
///
/// TODO(redesign-follow-up): this reads from static placeholder content —
/// wire it to the real project id once `ProjectsScreen`'s tap navigation
/// threads a `Project` (and its orders/locations) through instead of a
/// bare route push.
class ProjectDetailsScreen extends StatefulWidget {
  const ProjectDetailsScreen({super.key, this.projectId});
  final String? projectId;

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  Map<String, dynamic>? _details;
  bool _loading = true;
  String? _error;
  GoogleMapController? _mapController;
  Map<String, dynamic>? _selectedLocation;

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (final latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  void _fitMapToLocations(List<Map<String, dynamic>> locations) {
    final controller = _mapController;
    if (controller == null) return;
    final latLngs = locations.map((loc) {
      final lat = (loc['latitude'] as num?)?.toDouble();
      final lng = (loc['longitude'] as num?)?.toDouble();
      if (lat == null || lng == null) return null;
      return LatLng(lat, lng);
    }).whereType<LatLng>().toList();
    if (latLngs.isEmpty) return;
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (latLngs.length == 1) {
        controller.animateCamera(CameraUpdate.newLatLngZoom(latLngs.first, 13));
      } else {
        final bounds = _boundsFromLatLngList(latLngs);
        controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 40));
      }
    });
  }

  void _createOrder() {
    final details = _details;
    final location = _selectedLocation;
    if (details == null || location == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Project details are still loading. Please try again.'),
        ),
      );
      return;
    }
    final lat = (location['latitude'] as num?)?.toDouble() ?? 0;
    final lng = (location['longitude'] as num?)?.toDouble() ?? 0;
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (_) => NewCashOrderMixCodeScreen(
          draft: NewCashOrderDraft(
            project: OrderProjectSummary(
              projectId: details['id'].toString(),
              locationId: location['id'].toString(),
              projectName: details['name'] as String? ?? '',
              projectSite: location['name'] as String? ?? '',
              locationLabel: location['address'] as String? ?? '',
              coordinates: LatLng(lat, lng),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final id = widget.projectId;
    if (id != null && id.isNotEmpty) {
      sl<ProjectLocationApiService>()
          .getProjectDetails(id)
          .then((value) {
            if (mounted) setState(() => _details = value);
          })
          .catchError((_) {});
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final details = _details;
    if (details == null) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBrandHeader(showBack: true),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    final name = details['name'] as String? ?? '';
    final id = details['id']?.toString() ?? widget.projectId ?? '';
    final locations = details?['locations'];
    final locationCount = locations is List ? locations.length : 0;
    final orders = (details?['activeOrdersCount'] as num?)?.toInt() ?? 0;
    final delivered =
        (details?['deliveredVolumeM3'] as num?)?.toString() ?? '0';
    final projectType = details?['projectType'] as String?;
    final projectLocations = locations is List
        ? locations.whereType<Map>().map(Map<String, dynamic>.from).toList()
        : const <Map<String, dynamic>>[];
    final recentOrders = (details?['recentOrders'] as List? ?? const [])
        .whereType<Map>()
        .map(Map<String, dynamic>.from)
        .toList();
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
              child: (details?['imageUrl'] as String?)?.isNotEmpty == true
                  ? Image.network(
                      details!['imageUrl'] as String,
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => SvgEmbeddedRasterImage(
                        assetPath: AppAssets.artVillaHero,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : SvgEmbeddedRasterImage(
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
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.authScreenTitle(context).copyWith(
                          fontSize: context.scaled(20),
                          letterSpacing: -0.02,
                        ),
                      ),
                      Text(
                        id,
                        style: AppTextStyles.cardSubtitle(
                          context,
                        ).copyWith(fontSize: context.scaled(12)),
                      ),
                      if (projectType != null)
                        Text(
                          projectType,
                          style: AppTextStyles.cardSubtitle(context),
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
              child: Row(
                children: [
                  Expanded(
                    child: _StatCell(
                      icon: Icons.article_outlined,
                      value: '$orders',
                      label: 'Orders',
                    ),
                  ),
                  _VerticalDivider(),
                  Expanded(
                    child: _StatCell(
                      icon: Icons.location_on_outlined,
                      value: '$locationCount',
                      label: 'Locations',
                    ),
                  ),
                  _VerticalDivider(),
                  Expanded(
                    child: _StatCell(
                      icon: Icons.view_in_ar_outlined,
                      value: '$delivered m³',
                      label: 'Delivered',
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.scaledV(14)),
            SizedBox(
              height: 154,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: projectLocations.isNotEmpty 
                        ? LatLng(
                            (projectLocations.first['latitude'] as num?)?.toDouble() ?? 25.2048, 
                            (projectLocations.first['longitude'] as num?)?.toDouble() ?? 55.2708
                          )
                        : const LatLng(25.2048, 55.2708),
                    zoom: projectLocations.isNotEmpty ? 13 : 10,
                  ),
                  markers: projectLocations.map((loc) {
                    final lat = (loc['latitude'] as num?)?.toDouble();
                    final lng = (loc['longitude'] as num?)?.toDouble();
                    if (lat == null || lng == null) return null;
                    return Marker(
                      markerId: MarkerId(loc['id']?.toString() ?? loc.hashCode.toString()),
                      position: LatLng(lat, lng),
                      infoWindow: InfoWindow(
                        title: loc['name']?.toString() ?? 'Location',
                        snippet: loc['address']?.toString(),
                      ),
                    );
                  }).whereType<Marker>().toSet(),
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                    Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer(),
                    ),
                  },
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                    _fitMapToLocations(projectLocations);
                  },
                ),
              ),
            ),
            SizedBox(height: context.scaledV(16)),
            Text('Project Locations', style: AppTextStyles.cardTitle(context)),
            SizedBox(height: context.scaledV(8)),
            Material(
              color: AppColors.white,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: AppColors.cardBorder),
              ),
              child: projectLocations.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(18),
                      child: Text('No locations added yet.'),
                    )
                  : Column(
                      children: projectLocations.asMap().entries.map((entry) {
                        final location = entry.value;
                        return Column(
                          children: [
                              _LocationRow(
                                name: location['name'] as String? ?? 'Location',
                                area: location['address'] as String? ?? '',
                                isSelected: _selectedLocation?['id'] == location['id'],
                                onTap: () {
                                  setState(() {
                                    _selectedLocation = Map<String, dynamic>.from(location as Map);
                                  });
                                },
                              ),
                            if (entry.key < projectLocations.length - 1)
                              const Divider(
                                height: 1,
                                color: AppColors.cardBorder,
                              ),
                          ],
                        );
                      }).toList(),
                    ),
            ),
            SizedBox(height: context.scaledV(16)),
            Text('Recent Orders', style: AppTextStyles.cardTitle(context)),
            SizedBox(height: context.scaledV(8)),
            if (recentOrders.isNotEmpty)
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: Column(
                  children: recentOrders.asMap().entries.map((entry) {
                    final order = entry.value;
                    return Column(
                      children: [
                        _OrderRow(
                          id:
                              order['orderReference']?.toString() ??
                              order['orderId']?.toString() ??
                              '',
                          loc: order['location']?.toString() ?? '',
                          spec:
                              '${order['volumeLabel'] ?? order['volume'] ?? ''} · ${order['grade'] ?? ''}',
                          label: order['status']?.toString() ?? 'Draft',
                          tone: _toneForOrderStatus(
                            order['status']?.toString(),
                          ),
                          imageUrl: order['imageUrl'] as String?,
                        ),
                        if (entry.key < recentOrders.length - 1)
                          const Divider(height: 1, color: AppColors.cardBorder),
                      ],
                    );
                  }).toList(),
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
              label: 'Create Order for Selected Location',
              onPressed: _selectedLocation == null ? null : _createOrder,
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
              onPressed: () async {
                final result = await Navigator.of(context).pushNamed(
                  AppRoutes.addLocation,
                  arguments: AddLocationRouteArgs(projectId: id),
                );
                if (result == true) {
                  // Refresh the details and re-fit the map camera
                  sl<ProjectLocationApiService>()
                      .getProjectDetails(id)
                      .then((value) {
                    if (mounted) {
                      setState(() => _details = value);
                      final locs = value['locations'];
                      if (locs is List) {
                        _fitMapToLocations(
                          locs.whereType<Map>().map(Map<String, dynamic>.from).toList(),
                        );
                      }
                    }
                  }).catchError((_) {});
                }
              },
            ),
            SizedBox(height: context.scaledV(20)),
          ],
        ),
      ),
    );
  }
}

AppStatusTone _toneForOrderStatus(String? status) {
  switch (status?.toLowerCase()) {
    case 'completed':
      return AppStatusTone.completed;
    case 'in progress':
    case 'scheduled':
    case 'confirmed':
    case 'pending':
      return AppStatusTone.onWay;
    default:
      return AppStatusTone.review;
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
  const _LocationRow({
    required this.name,
    required this.area,
    this.isSelected = false,
    this.onTap,
  });
  final String name;
  final String area;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
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
                    ).copyWith(
                      fontSize: context.scaled(13.5),
                      color: isSelected ? AppColors.primary : AppColors.textPrimary,
                    ),
                  ),
                  Text(area, style: AppTextStyles.cardSubtitle(context)),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.radio_button_checked_rounded,
                size: 24,
                color: AppColors.primary,
              )
            else
              const Icon(
                Icons.radio_button_unchecked_rounded,
                size: 24,
                color: AppColors.iconMuted,
              ),
          ],
        ),
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
    this.imageUrl,
  });
  final String id;
  final String loc;
  final String spec;
  final String label;
  final AppStatusTone tone;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl?.isNotEmpty == true
                ? Image.network(
                    imageUrl!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => SvgEmbeddedRasterImage(
                      assetPath: AppAssets.figmaTruck,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
                  )
                : SvgEmbeddedRasterImage(
                    assetPath: AppAssets.figmaTruck,
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
