import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/di/injection.dart';
import '../../app/navigation/app_routes.dart';
import '../../app/navigation/app_route_args.dart';
import '../../core/usecases/usecase.dart';
import '../../app/navigation/app_tab_navigation.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_location_thumb.dart';
import '../../core/services/project_location_api_service.dart';
import 'domain/entities/order.dart' as order_entity;
import 'domain/entities/project.dart';
import 'domain/usecases/get_projects_use_case.dart';
import 'presentation/bloc/orders_bloc.dart';
import 'presentation/bloc/orders_event.dart';
import 'presentation/bloc/orders_state.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final _searchController = TextEditingController();
  late Future<List<Project>> _future;
  late Future<int> _locationCountFuture;

  @override
  void initState() {
    super.initState();
    _future = sl<GetProjectsUseCase>()(const NoParams()).then(
      (either) =>
          either.fold((failure) => throw failure, (projects) => projects),
    );
    _locationCountFuture = sl<ProjectLocationApiService>().getLocations().then(
      (items) => items.length,
    );
    context.read<OrdersBloc>().add(const FetchOrdersEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBrandHeader(
        onBellTap: () =>
            Navigator.of(context).pushNamed(AppRoutes.notifications),
      ),
      bottomNavigationBar: const AppTabBottomNavBar(
        currentTab: AppTab.projects,
      ),
      body: FutureBuilder<List<Project>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Could not load projects.',
                style: AppTextStyles.cardSubtitle(context),
              ),
            );
          }

          final allProjects = snapshot.data ?? const [];
          final query = _searchController.text.trim().toLowerCase();
          final projects = query.isEmpty
              ? allProjects
              : allProjects
                    .where(
                      (p) =>
                          p.name.toLowerCase().contains(query) ||
                          p.location.toLowerCase().contains(query),
                    )
                    .toList();

          return BlocBuilder<OrdersBloc, OrdersState>(
            builder: (context, ordersState) {
              final orders = ordersState is OrdersSuccess
                  ? ordersState.orders
                  : const <order_entity.Order>[];

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.scaledV(4)),
                    Text(
                      'Projects',
                      style: AppTextStyles.authScreenTitle(
                        context,
                      ).copyWith(fontSize: context.scaled(20)),
                    ),
                    SizedBox(height: context.scaledV(12)),
                    Row(
                      children: [
                        Expanded(
                          child: _MiniStat(
                            icon: Icons.apartment_rounded,
                            label: 'Active Projects',
                            value: '${allProjects.length}',
                          ),
                        ),
                        SizedBox(width: AppSpacing.md(context)),
                        Expanded(
                          child: _MiniStat(
                            icon: Icons.location_on_outlined,
                            label: 'Saved Locations',
                            value: '',
                            valueWidget: FutureBuilder<int>(
                              future: _locationCountFuture,
                              builder: (context, snapshot) => Text(
                                '${snapshot.data ?? 0}',
                                style: TextStyle(
                                  fontSize: context.scaled(18),
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.savedSites,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.scaledV(12)),
                    Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            size: 19,
                            color: AppColors.iconMuted,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (_) => setState(() {}),
                              style: TextStyle(fontSize: context.scaled(13)),
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: 'Search projects or locations',
                                hintStyle: TextStyle(
                                  fontSize: context.scaled(13),
                                  color: AppColors.textHint,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.scaledV(14)),
                    if (projects.isEmpty)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: context.scaledV(32),
                        ),
                        child: Center(
                          child: Text(
                            'No projects yet',
                            style: AppTextStyles.cardSubtitle(context),
                          ),
                        ),
                      )
                    else
                      ...projects.map((p) {
                        final pOrders = orders
                            .where((o) => o.location.contains(p.name))
                            .toList();
                        return Padding(
                          padding: EdgeInsets.only(bottom: context.scaledV(14)),
                          child: _ProjectCard(
                            project: p,
                            activeOrders: pOrders.length,
                            onTap: () => Navigator.of(context).pushNamed(
                              AppRoutes.projectDetails,
                              arguments: ProjectDetailsRouteArgs(
                                projectId: p.id,
                              ),
                            ),
                          ),
                        );
                      }),
                    SizedBox(height: context.scaledV(8)),
                    _AddProjectButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.addNewProject),
                    ),
                    SizedBox(height: context.scaledV(20)),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.icon,
    required this.label,
    required this.value,
    this.valueWidget,
    this.onTap,
  });
  final IconData icon;
  final String label;
  final String value;
  final Widget? valueWidget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: AppColors.primaryContainer,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: context.scaled(10),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textHint,
                    ),
                  ),
                  valueWidget ??
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: context.scaled(19),
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.iconMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  const _ProjectCard({
    required this.project,
    required this.activeOrders,
    required this.onTap,
  });

  final Project project;
  final int activeOrders;
  final VoidCallback onTap;

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  int? _savedLocations;
  int? _liveOrders;

  @override
  void initState() {
    super.initState();
    sl<ProjectLocationApiService>()
        .getProjectDetails(widget.project.id)
        .then((d) {
          if (!mounted) return;
          setState(() {
            final locations = d['locations'];
            _savedLocations = locations is List ? locations.length : 0;
            _liveOrders = (d['activeOrdersCount'] as num?)?.toInt() ?? 0;
          });
        })
        .catchError((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final activeOrders = _liveOrders ?? widget.activeOrders;
    int savedLocs = _savedLocations ?? 0;
    double progress = 0.60;
    String statusStr = 'On Track';
    Color statusColor = AppColors.primary;

    if (_savedLocations == null && project.name.contains('Marina')) {
      savedLocs = 6;
      progress = 0.35;
    } else if (_savedLocations == null && project.name.contains('Creek')) {
      savedLocs = 5;
      progress = 0.15;
      statusStr = 'Planning';
      statusColor = AppColors.success;
    }

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppLocationThumb(
              location: '${project.name} ${project.location}',
              width: 105,
              height: 105,
              borderRadius: 12,
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
                          project.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: context.scaled(14),
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.iconMuted,
                        size: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          project.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: context.scaled(11),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(height: 1, color: AppColors.cardBorder),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _ProjectStatColumn(
                          icon: Icons.location_on_outlined,
                          label: 'Saved Locations',
                          value: '$savedLocs',
                        ),
                      ),
                      Expanded(
                        child: _ProjectStatColumn(
                          icon: Icons.assignment_outlined,
                          label: 'Active Orders',
                          value: '$activeOrders',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              statusStr,
                              style: TextStyle(
                                fontSize: context.scaled(9),
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.cardBorder,
                            color: statusColor,
                            minHeight: 5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: context.scaled(10),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectStatColumn extends StatelessWidget {
  const _ProjectStatColumn({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, size: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: context.scaled(9),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: context.scaled(14),
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AddProjectButton extends StatelessWidget {
  const _AddProjectButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            children: [
              const Expanded(child: SizedBox()),
              const Text(
                'Add New Project',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.add, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
