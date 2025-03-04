import 'package:cloud_firestore/cloud_firestore.dart';

class StationPortDataModel {
  final String stationName;
  final String stationId;
  final Map<String, Timestamp?> ports;
  final Map<String, String> portId;

  StationPortDataModel({
    required this.stationName,
    required this.ports,
    required this.stationId,
    required this.portId,
  });
}
