import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../app/config/app_assets.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_scale.dart';
import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_headers.dart';
import '../../core/widgets/app_illustration_image.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/utils/input_validators.dart';
import '../../app/navigation/app_tab_navigation.dart';
import '../../app/di/injection.dart';
import '../../core/services/project_location_api_service.dart';
import 'order_project_summary.dart';

/// Ported from the new Figma design's `screens/AddLocation.tsx` — a map
/// band (placeholder; see `AppIllustrationPlaceholder` doc comment) plus a
/// short location/contact form. Pops with a [ProjectLocationDraft] so the
/// calling screen (`AddNewProjectScreen`) can append it to the project's
/// location list, mirroring Figma's `nav.navigate("createProject", {saved:
/// true})` round trip without a second navigation.
class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({
    super.key,
    this.projectName,
    this.projectId,
    this.initialLocation,
  });

  final String? projectName;
  final String? projectId;
  final SavedLocation? initialLocation;

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isResolvingPin = false;
  double? _currentLatitude;
  double? _currentLongitude;
  GoogleMapController? _mapController;
  late LatLng _initialPosition;
  bool _ignoreNextCameraIdle = true; 

  bool get _isEditMode => widget.initialLocation != null;
  bool get _hasActiveOrders => (widget.initialLocation?.activeOrdersCount ?? 0) > 0;

  bool get _isFormReady {
    return _nameController.text.trim().isNotEmpty &&
        _addressController.text.trim().isNotEmpty;
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFieldChanged);
    _addressController.addListener(_onFieldChanged);
    _contactController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);

    if (widget.initialLocation != null) {
      final loc = widget.initialLocation!;
      _nameController.text = loc.name;
      _addressController.text = loc.address;
      _contactController.text = loc.contactName;
      _phoneController.text = loc.contactPhone;
      if (loc.latitude != 0 && loc.longitude != 0) {
        _currentLatitude = loc.latitude;
        _currentLongitude = loc.longitude;
        _initialPosition = LatLng(loc.latitude, loc.longitude);
      } else {
        _initialPosition = const LatLng(25.2048, 55.2708);
      }
    } else {
      _initialPosition = const LatLng(25.2048, 55.2708);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _phoneController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _onCameraIdle() async {
    if (_ignoreNextCameraIdle) {
      _ignoreNextCameraIdle = false;
      return;
    }
    if (_hasActiveOrders) return;
    
    if (_currentLatitude == null || _currentLongitude == null) return;
    try {
      final places = await placemarkFromCoordinates(
        _currentLatitude!,
        _currentLongitude!,
      );
      final place = places.isEmpty ? null : places.first;
      final address = [
        place?.name,
        place?.street,
        place?.locality,
        place?.administrativeArea,
        place?.country,
      ].whereType<String>().where((part) => part.trim().isNotEmpty).join(', ');
      
      if (mounted) {
        _addressController.text = address.isEmpty
            ? '${_currentLatitude!.toStringAsFixed(6)}, ${_currentLongitude!.toStringAsFixed(6)}'
            : address;
        FocusManager.instance.primaryFocus?.unfocus();
      }
    } catch (_) {}
  }

  void _onPlaceSelected(double lat, double lng) {
    if (_hasActiveOrders) return;
    setState(() {
      _currentLatitude = lat;
      _currentLongitude = lng;
      _ignoreNextCameraIdle = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15),
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<Location> _locationFromAddress() async {
    final address = _addressController.text.trim();
    final locations = await locationFromAddress(address);
    if (locations.isEmpty) throw Exception('Location not found');
    return locations.first;
  }

  Future<void> _addLocation() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isResolvingPin = true);
    Location? pin;
    try {
      pin = _currentLatitude != null && _currentLongitude != null
          ? Location(
              latitude: _currentLatitude!,
              longitude: _currentLongitude!,
              timestamp: DateTime.now(),
            )
          : await _locationFromAddress();
    } catch (_) {
      setState(() => _isResolvingPin = false);
      _showMessage('Unable to read your current location. Please enter the address.');
      return;
    }

    if (!mounted) return;

    final projectId = widget.projectId;
    if (projectId != null && projectId.isNotEmpty) {
      try {
        final apiService = sl<ProjectLocationApiService>();
        final payload = ProjectLocationPayload(
          name: _nameController.text.trim(),
          address: _addressController.text.trim(),
          latitude: pin.latitude,
          longitude: pin.longitude,
          contactName: _contactController.text.trim(),
          contactPhone: _phoneController.text.trim(),
        );

        if (_isEditMode) {
          await apiService.updateLocation(
            locationId: widget.initialLocation!.id,
            location: payload,
          );
        } else {
          await apiService.addLocation(
            projectId: projectId,
            location: payload,
          );
        }
        Navigator.of(context).pop(true);
      } catch (e) {
        if (!mounted) return;
        setState(() => _isResolvingPin = false);
        _showMessage(e.toString());
      }
      return;
    }

    Navigator.of(context).pop(
      ProjectLocationDraft(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        latitude: pin.latitude,
        longitude: pin.longitude,
        contactName: _contactController.text.trim(),
        contactPhone: _phoneController.text.trim(),
      ),
    );
  }

  Future<void> _useCurrentLocation() async {
    if (_isResolvingPin) return;
    if (!await Geolocator.isLocationServiceEnabled()) {
      _showMessage('Turn on location services to use your current location.');
      return;
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showMessage(
        'Location permission is needed to use your current location.',
      );
      return;
    }
    setState(() => _isResolvingPin = true);
    try {
      final position = await Geolocator.getCurrentPosition();
      final places = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      final place = places.isEmpty ? null : places.first;
      final address = [
        place?.name,
        place?.street,
        place?.locality,
        place?.administrativeArea,
        place?.country,
      ].whereType<String>().where((part) => part.trim().isNotEmpty).join(', ');
      if (mounted) {
        setState(() {
          _currentLatitude = position.latitude;
          _currentLongitude = position.longitude;
          _addressController.text = address.isEmpty
              ? '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}'
              : address;
          _ignoreNextCameraIdle = true;
        });
        FocusManager.instance.primaryFocus?.unfocus();
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            15,
          ),
        );
      }
    } catch (_) {
      _showMessage(
        'Unable to read your current location. Please enter the address.',
      );
    } finally {
      if (mounted) setState(() => _isResolvingPin = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppBrandHeader(showBack: true),
      bottomNavigationBar: const AppTabBottomNavBar(
        currentTab: AppTab.projects,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg(context),
                  context.scaledV(8),
                  AppSpacing.lg(context),
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Location',
                      style: AppTextStyles.authScreenTitle(context),
                    ),
                    if (widget.projectName != null) ...[
                      SizedBox(height: context.scaledV(4)),
                      Text.rich(
                        TextSpan(
                          text: 'For ',
                          style: AppTextStyles.cardSubtitle(context),
                          children: [
                            TextSpan(
                              text: widget.projectName,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                                fontSize: context.scaled(13.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: context.scaledV(14)),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg(context),
                ),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 230,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: _initialPosition,
                                zoom: 12,
                              ),
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              gestureRecognizers: {
                                Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                              },
                              onMapCreated: (controller) => _mapController = controller,
                              onCameraMove: _hasActiveOrders ? null : (position) {
                                _currentLatitude = position.target.latitude;
                                _currentLongitude = position.target.longitude;
                              },
                              onCameraIdle: _onCameraIdle,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(bottom: 35),
                              child: Icon(
                                Icons.location_on,
                                size: 40,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!_hasActiveOrders)
                      Positioned(
                        right: 12,
                        bottom: 12,
                        child: InkWell(
                          onTap: _useCurrentLocation,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(999),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.gps_fixed_rounded,
                                  size: 14,
                                  color: AppColors.primary,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Use current location',
                                  style: TextStyle(
                                    fontSize: context.scaled(12),
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.lg(context),
                  context.scaledV(18),
                  AppSpacing.lg(context),
                  AppSpacing.xxl(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AddressAutocompleteField(
                      controller: _addressController,
                      onPlaceSelected: _onPlaceSelected,
                      enabled: !_hasActiveOrders,
                    ),
                    SizedBox(height: context.scaledV(12)),
                    _FieldRow(
                      label: 'Location Name',
                      hint: 'e.g. Main Gate, North Entrance',
                      controller: _nameController,
                      validator: (value) =>
                          InputValidators.required(value, 'Location name'),
                    ),
                    SizedBox(height: context.scaledV(12)),
                    Row(
                      children: [
                        Expanded(
                          child: _FieldRow(
                            label: 'Site Contact',
                            hint: 'e.g. Ahmed Khalid',
                            controller: _contactController,
                            validator: (value) => InputValidators.fullName(
                              value,
                              fieldName: 'Site contact',
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.md(context)),
                        Expanded(
                          child: _FieldRow(
                            label: 'Mobile Number',
                            hint: '+971 50 123 4567',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            validator: InputValidators.mobile,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.scaledV(16)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: AppSpacing.sm(context)),
                        Expanded(
                          child: Text(
                            'This pin helps ANTFAST deliver to the correct entrance.',
                            style: AppTextStyles.cardSubtitle(context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.scaledV(18)),
                    PrimaryButton(
                      onPressed: (_isResolvingPin || !_isFormReady) ? null : _addLocation,
                      label: _isResolvingPin
                          ? 'Saving…'
                          : _isEditMode
                              ? 'Save Changes'
                              : 'Add Location',
                    ),
                    SizedBox(height: context.scaledV(10)),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: context.scaled(14),
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.label,
    required this.hint,
    required this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x051E1946),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (prefixIcon != null) ...[
            prefixIcon!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: context.scaled(11),
                    color: AppColors.textSecondary,
                  ),
                ),
                TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  keyboardType: keyboardType,
                  validator: validator,
                  enabled: enabled,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: TextStyle(
                    fontSize: context.scaled(13),
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: context.scaled(13),
                      color: AppColors.textHint,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (suffixIcon != null) ...[
            const SizedBox(width: 12),
            suffixIcon!,
          ],
        ],
      ),
    );
  }
}

class _AddressAutocompleteField extends StatefulWidget {
  const _AddressAutocompleteField({
    required this.controller,
    required this.onPlaceSelected,
    this.enabled = true,
  });

  final TextEditingController controller;
  final void Function(double lat, double lng) onPlaceSelected;
  final bool enabled;

  @override
  State<_AddressAutocompleteField> createState() => _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<_AddressAutocompleteField> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<Iterable<Map<String, dynamic>>> _getSuggestions(String query) async {
    if (query.isEmpty || !_focusNode.hasFocus) return const Iterable.empty();
    try {
      final response = await Dio().get(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json',
        queryParameters: {
          'input': query,
          'key': 'AIzaSyAOTvknCyOHg2kSXSIt2V26bAH7lYzcGpI',
        },
      );
      if (response.data['status'] == 'OK') {
        return (response.data['predictions'] as List).cast<Map<String, dynamic>>();
      }
    } catch (_) {}
    return const Iterable.empty();
  }

  Future<void> _fetchPlaceDetails(String placeId) async {
    try {
      final response = await Dio().get(
        'https://maps.googleapis.com/maps/api/place/details/json',
        queryParameters: {
          'place_id': placeId,
          'key': 'AIzaSyAOTvknCyOHg2kSXSIt2V26bAH7lYzcGpI',
        },
      );
      if (response.data['status'] == 'OK') {
        final loc = response.data['result']['geometry']['location'];
        widget.onPlaceSelected(loc['lat'], loc['lng']);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return RawAutocomplete<Map<String, dynamic>>(
      textEditingController: widget.controller,
      focusNode: _focusNode,
      optionsBuilder: (textEditingValue) => _getSuggestions(textEditingValue.text),
      displayStringForOption: (option) => option['description'] as String,
      onSelected: (option) {
        _fetchPlaceDetails(option['place_id'] as String);
      },
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return _FieldRow(
          label: 'Address',
          hint: 'Search for building, street, or area',
          controller: controller,
          focusNode: focusNode,
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
          validator: (value) => InputValidators.required(value, 'Address'),
          enabled: widget.enabled,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 2 * AppSpacing.lg(context),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final option = options.elementAt(index);
                  return ListTile(
                    leading: const Icon(Icons.location_on, color: AppColors.textHint),
                    title: Text(
                      option['description'] as String,
                      style: TextStyle(
                        fontSize: context.scaled(13),
                        color: AppColors.textPrimary,
                      ),
                    ),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
