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
