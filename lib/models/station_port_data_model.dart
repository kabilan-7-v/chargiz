import 'package:cloud_firestore/cloud_firestore.dart';

class StationPortDataModel {
  final String stationName;
  final Map<String, Timestamp?> ports;

  StationPortDataModel({
    required this.stationName,
    required this.ports,
  });
}
