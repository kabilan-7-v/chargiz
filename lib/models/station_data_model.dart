import 'package:google_maps_flutter/google_maps_flutter.dart';

class StationDataModel {
  final String name;
  final String address;
  final double distance;
  final LatLng position;
  final String portName;
  final int estimatedTime;
  final String stationId;
  final String portId;

  StationDataModel({
    required this.name,
    required this.address,
    required this.distance,
    required this.position,
    required this.portName,
    required this.estimatedTime,
    required this.stationId,
    required this.portId,
  });
}
