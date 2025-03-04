import 'package:chargiz/models/station_data_model.dart';
import 'package:chargiz/services/common_services.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as d;

class NearbyStations extends StatefulWidget {
  final List<StationDataModel> stationData;
  const NearbyStations({super.key, required this.stationData});

  @override
  State<NearbyStations> createState() => _NearbyStationsState();
}

class _NearbyStationsState extends State<NearbyStations> {
  @override
  Widget build(BuildContext context) {
    d.log(widget.stationData.length.toString());

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text("Nearby Charging Stations"),
      ),
      body: ListView.builder(
        // shrinkWrap: true,

        scrollDirection: Axis.vertical,
        itemCount: widget.stationData.length,
        itemBuilder: (context, index) {
          return ListTile(
            isThreeLine: true,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey, width: 0.5)),
            tileColor: Colors.white,
            //dense: true,
            title: Text(widget.stationData[index].name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    '${widget.stationData[index].portName}: ${((calculateTimeInSeconds(widget.stationData[index].distance).ceil() + widget.stationData[index].estimatedTime) / 60).ceil()} mins',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                Text(widget.stationData[index].address),
              ],
            ),

            trailing: Text(
                "${widget.stationData[index].distance.toStringAsFixed(2)} km"),
          );
        },
      ),
    );
  }
}
