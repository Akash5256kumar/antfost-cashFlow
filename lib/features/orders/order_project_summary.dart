import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderProjectSummary {
  const OrderProjectSummary({
    required this.projectName,
    required this.projectSite,
    required this.locationLabel,
    required this.coordinates,
  });

  final String projectName;
  final String projectSite;
  final String locationLabel;
  final LatLng coordinates;
}

/// A single delivery location added to a project via `AddLocationScreen`,
/// ported from the new Figma design's `screens/AddLocation.tsx` form.
class ProjectLocationDraft {
  const ProjectLocationDraft({
    required this.name,
    required this.address,
    this.contactName,
    this.contactPhone,
  });

  final String name;
  final String address;
  final String? contactName;
  final String? contactPhone;
}
