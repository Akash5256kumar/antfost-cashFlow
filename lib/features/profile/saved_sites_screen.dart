import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

import '../../app/navigation/app_routes.dart';
import '../../app/navigation/app_route_args.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/primary_button.dart';
import '../orders/order_project_summary.dart';
import '../orders/new_cash_order_draft.dart';
import '../orders/new_cash_order_mix_code_screen.dart';
import '../../app/config/app_assets.dart';
import '../../app/di/injection.dart';
import '../../core/services/project_location_api_service.dart';
import '../../core/errors/exceptions.dart';

class _SiteItem {
  final String id;
  final String projectId;
  final String name;
  final String subtitle;
  final String location;
  final String imagePath;
  final String? imageUrl;
  final String contactPerson;
  final String contactPhone;
  final int activeOrdersCount;
  final bool isDefault;
  final double latitude;
  final double longitude;

  const _SiteItem({
    required this.id,
    this.projectId = '',
    required this.name,
    required this.subtitle,
    required this.location,
    required this.imagePath,
    this.imageUrl,
    required this.contactPerson,
    required this.contactPhone,
    required this.activeOrdersCount,
    this.isDefault = false,
    this.latitude = 0,
    this.longitude = 0,
  });

  _SiteItem copyWith({
    String? id,
    String? projectId,
    String? name,
    String? subtitle,
    String? location,
    String? imagePath,
    String? contactPerson,
    String? contactPhone,
    int? activeOrdersCount,
    bool? isDefault,
  }) {
    return _SiteItem(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      location: location ?? this.location,
      imagePath: imagePath ?? this.imagePath,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
      activeOrdersCount: activeOrdersCount ?? this.activeOrdersCount,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

class SavedSitesScreen extends StatefulWidget {
  const SavedSitesScreen({
    super.key,
    this.pickForOrder = false,
    this.pickForProject = false,
  });

  /// When true, renders the new Figma design's `screens/SavedLocations.tsx`
  /// picker flow (single-select + "Create New Order") instead of the
  /// management view.
  final bool pickForOrder;

  /// When true, renders the picker flow but with no default selection,
  /// and clicking the button returns a [ProjectLocationDraft].
  final bool pickForProject;

  @override
  State<SavedSitesScreen> createState() => _SavedSitesScreenState();
}

class _SavedSitesScreenState extends State<SavedSitesScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _selectedIndex;
  late Future<List<_SiteItem>> _sitesFuture;
  String? _loadMessage;

  @override
  void initState() {
    super.initState();
    // Start with nothing selected if picking for a project, otherwise select the first one.
    _selectedIndex = widget.pickForProject ? null : 0;
    _sitesFuture = _loadSites();
  }

  List<_SiteItem> _sites = [
    const _SiteItem(
      id: 'site_1',
      name: 'Main Villa Entrance',
      subtitle: 'Palm Jumeirah Villa',
      location: 'Palm Jumeirah, Dubai',
      imagePath: AppAssets.orderThumbPalm,
      contactPerson: 'Eng. Tarek Mahmoud',
      contactPhone: '+971 52 849 2011',
      activeOrdersCount: 2,
      isDefault: true,
    ),
    const _SiteItem(
      id: 'site_2',
      name: 'Service Gate',
      subtitle: 'Palm Jumeirah Villa',
      location: 'Palm Jumeirah, Dubai',
      imagePath: AppAssets.orderThumbPalm,
      contactPerson: 'Eng. Khalid Al Mazrouei',
      contactPhone: '+971 50 392 4810',
      activeOrdersCount: 1,
    ),
    const _SiteItem(
      id: 'site_3',
      name: 'Tower Loading Bay',
      subtitle: 'Marina Tower',
      location: 'Dubai Marina, Dubai',
      imagePath: AppAssets.orderThumbMarina,
      contactPerson: 'Eng. Rashid Siddiqui',
      contactPhone: '+971 55 104 9283',
      activeOrdersCount: 0,
    ),
    const _SiteItem(
      id: 'site_4',
      name: 'Main Site Entrance',
      subtitle: 'Creek Residence',
      location: 'Dubai Creek Harbour, Dubai',
      imagePath: AppAssets.orderThumbCreek,
      contactPerson: 'Eng. Omar Farooq',
      contactPhone: '+971 56 718 2930',
      activeOrdersCount: 0,
    ),
  ];

  Future<List<_SiteItem>> _loadSites() async {
    _loadMessage = null;
    try {
      final locations = await sl<ProjectLocationApiService>().getLocations();
      return locations
          .map(
            (location) => _SiteItem(
              id: location.id,
              projectId: location.projectId,
              name: location.name,
              subtitle: location.projectName,
              location: location.address,
              imagePath: AppAssets.orderThumbPalm,
              imageUrl: location.imageUrl,
              contactPerson: location.contactName,
              contactPhone: location.contactPhone,
              activeOrdersCount: location.activeOrdersCount,
              isDefault: location.isDefault,
              latitude: location.latitude,
              longitude: location.longitude,
            ),
          )
          .toList();
    } on ServerException catch (error) {
      _loadMessage = error.message;
      return const [];
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_SiteItem> get _filteredSites {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _sites;
    return _sites.where((s) {
      return s.name.toLowerCase().contains(query) ||
          s.location.toLowerCase().contains(query) ||
          s.contactPerson.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _handleAddNewProject() async {
    final result = await Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed<OrderProjectSummary?>(AppRoutes.addNewProject, arguments: true);

    if (result != null && mounted) {
      setState(() {
        _sites.insert(
          0,
          _SiteItem(
            id: 'site_${DateTime.now().millisecondsSinceEpoch}',
            name: result.projectName,
            subtitle: result.projectSite,
            location: '${result.projectSite}, ${result.locationLabel}',
            imagePath: AppAssets.figmaVilla,
            contactPerson: 'Site In-Charge',
            contactPhone: '+971 50 000 0000',
            activeOrdersCount: 0,
          ),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Site "${result.projectName}" added successfully!'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void _setDefaultSite(String id) {
    setState(() {
      _sites = _sites.map((s) => s.copyWith(isDefault: s.id == id)).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Default delivery site updated'),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Future<void> _deleteSite(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Location'),
        content: const Text(
          'Are you sure you want to delete this location? '
          'Active orders will keep showing where they were delivered.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await sl<ProjectLocationApiService>().deleteLocation(id);
      if (mounted) {
        setState(() => _sitesFuture = _loadSites());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Site removed from saved sites')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e')),
        );
      }
    }
  }

  Future<void> _editSite(String id) async {
    final site = _sites.firstWhere((s) => s.id == id);
    
    // We need to reconstruct a SavedLocation object from _SiteItem
    final savedLocation = SavedLocation(
      id: site.id,
      projectId: site.projectId,
      name: site.name,
      address: site.location,
      latitude: site.latitude,
      longitude: site.longitude,
      contactName: site.contactPerson,
      contactPhone: site.contactPhone,
      isDefault: site.isDefault,
      activeOrdersCount: site.activeOrdersCount,
      projectName: site.subtitle,
      imageUrl: site.imageUrl,
    );

    final result = await Navigator.of(context).pushNamed(
      AppRoutes.addLocation,
      arguments: AddLocationRouteArgs(
        projectId: site.projectId,
        initialLocation: savedLocation,
      ),
    );

    if (result == true && mounted) {
      setState(() => _sitesFuture = _loadSites());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<_SiteItem>>(
      future: _sitesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          final message = _loadMessage ?? 'Could not load saved locations.';
          return Scaffold(
            appBar: const AppBrandHeader(showBack: true),
            body: Center(
              child: TextButton(
                onPressed: () => setState(() => _sitesFuture = _loadSites()),
                child: Text('$message Retry'),
              ),
            ),
          );
        }
        if (_loadMessage != null) {
          return Scaffold(
            appBar: const AppBrandHeader(showBack: true),
            body: Center(
              child: TextButton(
                onPressed: () => setState(() => _sitesFuture = _loadSites()),
                child: Text('$_loadMessage Retry'),
              ),
            ),
          );
        }
        _sites
          ..clear()
          ..addAll(snapshot.data ?? const []);
        final filtered = _filteredSites;

        if (!widget.pickForOrder && !widget.pickForProject) {
          return _ManagementView(
            sites: filtered,
            searchController: _searchController,
            onSearchChanged: (_) => setState(() {}),
            onAddNewProject: _handleAddNewProject,
            onSetDefault: _setDefaultSite,
            onDelete: _deleteSite,
            onEdit: _editSite,
          );
        }

        return _PickerView(
          sites: filtered,
          selectedIndex: _selectedIndex,
          pickForProject: widget.pickForProject,
          onSelect: (i) => setState(() => _selectedIndex = i),
          onCreateOrder: () {
            if (_selectedIndex == null || _selectedIndex! >= filtered.length)
              return;
            final selected = filtered[_selectedIndex!];
            if (widget.pickForProject) {
              Navigator.of(context).pop(
                ProjectLocationDraft(
                  name: selected.name,
                  address: selected.location,
                  latitude: selected.latitude,
                  longitude: selected.longitude,
                  contactName: selected.contactPerson,
                  contactPhone: selected.contactPhone,
                ),
              );
            } else {
              final project = OrderProjectSummary(
                projectId: selected.projectId,
                locationId: selected.id,
                projectName: selected.subtitle,
                projectSite: selected.subtitle,
                locationLabel: selected.location,
                coordinates: LatLng(selected.latitude, selected.longitude),
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => NewCashOrderMixCodeScreen(
                    draft: NewCashOrderDraft(project: project),
                  ),
                ),
              );
            }
          },
          searchController: _searchController,
          onSearchChanged: (_) => setState(() => _selectedIndex = null),
        );
      },
    );
  }
}

/// Management view — Profile's entry point. Lists every saved site with a
/// "..." menu for Set Default / Delete, plus an "Add New Project" CTA.
class _ManagementView extends StatelessWidget {
  const _ManagementView({
    required this.sites,
    required this.searchController,
    required this.onSearchChanged,
    required this.onAddNewProject,
    required this.onSetDefault,
    required this.onDelete,
    required this.onEdit,
  });

  final List<_SiteItem> sites;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onAddNewProject;
  final ValueChanged<String> onSetDefault;
  final ValueChanged<String> onDelete;
  final ValueChanged<String> onEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBrandHeader(showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.scaledV(4)),
            Text(
              'Saved Sites',
              style: TextStyle(
                fontSize: context.scaled(24),
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: context.scaledV(6)),
            Text(
              'Manage the project sites you deliver to most often.',
              style: AppTextStyles.cardSubtitle(context),
            ),
            SizedBox(height: context.scaledV(16)),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFEBEBEB)),
              ),
              child: TextField(
                controller: searchController,
                onChanged: onSearchChanged,
                style: TextStyle(
                  fontSize: context.scaled(14),
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search saved sites',
                  hintStyle: TextStyle(
                    fontSize: context.scaled(13),
                    color: AppColors.textHint,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.iconMuted,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: context.scaledV(14),
                  ),
                ),
              ),
            ),
            SizedBox(height: context.scaledV(16)),
            if (sites.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.scaledV(32)),
                child: Center(
                  child: Text(
                    'No saved sites found',
                    style: AppTextStyles.cardSubtitle(context),
                  ),
                ),
              )
            else
              ...sites.map(
                (site) => Padding(
                  padding: EdgeInsets.only(bottom: context.scaledV(14)),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child:
                              site.imageUrl != null && site.imageUrl!.isNotEmpty
                              ? Image.network(
                                  site.imageUrl!,
                                  width: 68,
                                  height: 68,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.asset(
                                    site.imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  site.imagePath,
                                  width: 68,
                                  height: 68,
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.high,
                                  isAntiAlias: true,
                                ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      site.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: context.scaled(14),
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                site.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.cardSubtitle(context),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert_rounded,
                            color: AppColors.iconMuted,
                          ),
                          onSelected: (v) {
                            if (v == 'edit') onEdit(site.id);
                            if (v == 'delete') onDelete(site.id);
                          },
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: context.scaledV(8)),
            PrimaryButton(label: 'Add New Project', onPressed: onAddNewProject),
            SizedBox(height: context.scaledV(24)),
          ],
        ),
      ),
    );
  }
}

/// Ported from the new Figma design's `screens/SavedLocations.tsx` — a
/// single-select location list used when starting an order from the
/// project flow, as opposed to the management view above (Profile entry
/// point).
class _PickerView extends StatelessWidget {
  const _PickerView({
    required this.sites,
    required this.selectedIndex,
    required this.pickForProject,
    required this.onSelect,
    required this.onCreateOrder,
    required this.searchController,
    required this.onSearchChanged,
  });

  final List<_SiteItem> sites;
  final int? selectedIndex;
  final bool pickForProject;
  final ValueChanged<int> onSelect;
  final VoidCallback onCreateOrder;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBrandHeader(showBack: true),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            context.scaled(20),
            context.scaledV(4),
            context.scaled(20),
            context.scaledV(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Saved Locations',
                style: TextStyle(
                  fontSize: context.scaled(22),
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: context.scaledV(4)),
              Text(
                'Choose a location to create an order for.',
                style: TextStyle(
                  fontSize: context.scaled(13),
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: context.scaledV(20)),
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(context.scaled(16)),
                  border: Border.all(
                    color: const Color(0xFFF1F5F9),
                  ), // faint border
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x051E1946),
                      offset: Offset(0, 2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  style: TextStyle(
                    fontSize: context.scaled(14),
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search saved locations',
                    hintStyle: TextStyle(
                      fontSize: context.scaled(13),
                      color: AppColors.textHint,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.iconMuted,
                      size: context.scaled(20),
                    ),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              size: context.scaled(18),
                            ),
                            onPressed: () {
                              searchController.clear();
                              onSearchChanged('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: context.scaled(16),
                      vertical: context.scaledV(14),
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.scaledV(24)),
              if (sites.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.scaledV(32)),
                  child: Center(
                    child: Text(
                      'No saved locations found',
                      style: AppTextStyles.cardSubtitle(context),
                    ),
                  ),
                )
              else
                ...List.generate(sites.length, (i) {
                  final site = sites[i];
                  final on = i == selectedIndex;
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.scaledV(12)),
                    child: GestureDetector(
                      onTap: () => onSelect(i),
                      child: Container(
                        padding: EdgeInsets.all(context.scaled(12)),
                        decoration: BoxDecoration(
                          color: on
                              ? const Color(
                                  0x0A2B44FF,
                                ) // super soft primary background
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(
                            context.scaled(16),
                          ),
                          border: Border.all(
                            color: on
                                ? AppColors.primary
                                : const Color(0xFFF1F5F9),
                            width: on ? 1.5 : 1,
                          ),
                          boxShadow: [
                            if (!on)
                              const BoxShadow(
                                color: Color(0x051E1946),
                                offset: Offset(0, 2),
                                blurRadius: 8,
                              ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(
                                context.scaled(12),
                              ),
                              child:
                                  site.imageUrl != null &&
                                      site.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      site.imageUrl!,
                                      width: context.scaled(72),
                                      height: context.scaled(72),
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Image.asset(
                                        site.imagePath,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      site.imagePath,
                                      width: context.scaled(72),
                                      height: context.scaled(72),
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            SizedBox(width: context.scaled(14)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    site.name,
                                    style: TextStyle(
                                      fontSize: context.scaled(14.5),
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1F2533),
                                    ),
                                  ),
                                  SizedBox(height: context.scaledV(2)),
                                  Text(
                                    site.subtitle,
                                    style: TextStyle(
                                      fontSize: context.scaled(13),
                                      fontWeight: FontWeight.w600,
                                      color: AppColors
                                          .primary, // ALWAYS primary in screenshot
                                    ),
                                  ),
                                  SizedBox(height: context.scaledV(6)),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        size: context.scaled(13),
                                        color: AppColors.textSecondary,
                                      ),
                                      SizedBox(width: context.scaled(4)),
                                      Expanded(
                                        child: Text(
                                          site.location,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: context.scaled(12),
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: context.scaled(10)),
                            Container(
                              width: context.scaled(22),
                              height: context.scaled(22),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: on ? AppColors.primary : null,
                                border: Border.all(
                                  color: on
                                      ? AppColors.primary
                                      : const Color(0xFFD3D1E4),
                                  width: 2,
                                ),
                              ),
                              child: on
                                  ? Center(
                                      child: Container(
                                        width: context.scaled(9),
                                        height: context.scaled(9),
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              SizedBox(height: context.scaledV(32)),
              PrimaryButton(
                arrow: true,
                label: pickForProject ? 'Select Location' : 'Create New Order',
                onPressed: (sites.isEmpty || selectedIndex == null)
                    ? null
                    : onCreateOrder,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
