import 'dart:convert';
import 'package:chargiz/models/station_data_model.dart';
import 'package:chargiz/Page/Location/nearby_stations.dart';
import 'package:chargiz/services/common_services.dart';
import 'package:chargiz/widgets/loader.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as d;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

const String googleApiKey = "AIzaSyCyzxOeCiFf7YszDASz1k0Mi6NnbsiO-5I";

class LocationEVStation extends StatefulWidget {
  const LocationEVStation({super.key});

  @override
  State<LocationEVStation> createState() => _LocationEVStationState();
}

class _LocationEVStationState extends State<LocationEVStation> {
  GoogleMapController? mapController;
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  bool isLoading = false;

  List<StationDataModel> stationData = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Fetch user's current location
  Future<void> _getCurrentLocation() async {
    var status = await Permission.location.request();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showStatus(
            "GPS servic permission is disabled. Please enable it.", context);
        return;
      }
    }

    if (!status.isGranted) {
      return;
    }
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    d.log(serviceEnabled.toString());
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: LocationAccuracy.best));

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
    d.log("current location fetched");
  }

  // Fetch 20 nearest EV charging stations
  Future<void> _fetchEVStations() async {
    if (_currentPosition == null) return;
    isLoading = true;
    setState(() {});
    //  showStatus("Locating free Charging Station..", context);
    final url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${_currentPosition!.latitude},${_currentPosition!.longitude}"
        "&radius=5000" // 5 km range
        "&type=charging_station"
        "&key=$googleApiKey";

    try {
      final response = await http.get(Uri.parse(url));
      d.log(response.statusCode.toString());
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List results = data['results'];
        stationData.clear();
        d.log(results.length.toString());
        for (var place in results) {
          final lat = place['geometry']['location']['lat'];
          final lng = place['geometry']['location']['lng'];
          final name = place['name'];
          final address = place['vicinity'];

          LatLng placeLocation = LatLng(lat, lng);
          double distance =
              await _calculateDistance(_currentPosition!, placeLocation);
          stationData.add(StationDataModel(
            name: name,
            address: address,
            distance: distance,
            position: placeLocation,
          ));
        }
        ////////////////////////////////////////////////////
        stationData.sort((a, b) => a.distance.compareTo(b.distance));
        addMarker(stationData[0]);
      }
    } catch (e) {
      //
    }
    isLoading = false;
    setState(() {});
  }

  void addMarker(StationDataModel stationData) {
    Set<Marker> newMarkers = {};
    newMarkers.add(
      Marker(
        markerId: MarkerId(stationData.name),
        position: stationData.position,
        infoWindow: InfoWindow(
          title: stationData.name,
          snippet:
              "${stationData.distance.toStringAsFixed(2)} km", //\n⏳ ETA: $travelTime",
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    setState(() {
      _markers = newMarkers;
    });
  }

  // Calculate Distance between two points
  Future<double> _calculateDistance(LatLng start, LatLng end) async {
    double distance = Geolocator.distanceBetween(
          start.latitude,
          start.longitude,
          end.latitude,
          end.longitude,
        ) /
        1000; // Convert to KM
    d.log(distance.toString());
    return distance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
                mapController!.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: _currentPosition!, zoom: 14),
                ));
                d.log("map created");
              },
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 14,
              ),
              markers: _markers,
              myLocationEnabled: true,
            ),
      bottomNavigationBar: Container(
        height: (stationData.isNotEmpty) ? 150 : 80,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 0.5, color: Colors.grey)),
          color: Colors.white,
        ),
        child: isLoading
            ? const Loader()
            : (stationData.isNotEmpty)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Chargiz Point',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                            GestureDetector(
                                onTap: () {
                                  stationData.clear();
                                  _markers.clear();
                                  setState(() {});
                                },
                                child: Icon(Icons.close)),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(calculateTravelTime(stationData[0].distance),
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                color: Colors.red.shade700),
                            const SizedBox(width: 6),
                            Text(stationData[0].name,
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Text(stationData[0].address,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ),
                      ],
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade200),
                        onPressed: _fetchEVStations,
                        child: Text(
                          'Locate',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 40),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade200),
                        onPressed: () async {
                          if (stationData.isEmpty) {
                            await _fetchEVStations();
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NearbyStations(
                                      stationData: stationData)));
                        },
                        child: Text(
                          'Show nearby',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
