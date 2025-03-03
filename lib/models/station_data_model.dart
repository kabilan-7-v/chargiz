import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationDataModel {
  final String name;
  final String address;
  final double distance;
  final LatLng position;

  StationDataModel({
    required this.name,
    required this.address,
    required this.distance,
    required this.position,
  });
}
