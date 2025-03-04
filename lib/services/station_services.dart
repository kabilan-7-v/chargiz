import 'package:chargiz/models/station_port_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StationServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> stationStream() {
    return _firestore.collection('stations').snapshots();
  }

  static Future<void> makePortBusy(
      String stationId, String portId, Timestamp estimatedTime) async {
    _firestore
        .collection('stations')
        .doc(stationId)
        .collection("ports")
        .doc(portId)
        .set(
      {"estimated_time": estimatedTime},
      SetOptions(merge: true),
    );
    _firestore.collection('stations').doc(stationId).set(
      {"last_updated": Timestamp.now()},
      SetOptions(merge: true),
    );
  }

  static Future<List<StationPortDataModel>> fetchAllPortsStatus() async {
    List<StationPortDataModel> allPorts = [];

    for (int i = 0; i < 20; i++) {
      final stationData =
          await _firestore.collection("stations").doc(i.toString()).get();
      final String stationName = stationData.data()!['name'];
      final portSnap = await _firestore
          .collection("stations")
          .doc(i.toString())
          .collection('ports')
          .get();
      Map<String, Timestamp?> ports = {};
      Map<String, String> portIds = {};
      for (var doc in portSnap.docs) {
        final name = doc.data()["name"];
        final estimatedTime = doc.data()["estimated_time"];
        portIds[name] = doc.id;
        if (estimatedTime == null) {
          ports[name] = null;
        } else if (estimatedTime.toDate().isBefore(DateTime.now())) {
          ports[name] = null;
          await resetPortStatus(i.toString(), doc.id);
        } else {
          ports[name] = estimatedTime;
        }
      }
      allPorts.add(StationPortDataModel(
          stationName: stationName,
          ports: ports,
          stationId: stationData.id,
          portId: portIds));
    }
    return allPorts;
  }

  static Future<void> resetPortStatus(String stationId, String portId) async {
    await _firestore
        .collection("stations")
        .doc(stationId)
        .collection('ports')
        .doc(portId)
        .set({"estimated_time": null}, SetOptions(merge: true));
  }
}
