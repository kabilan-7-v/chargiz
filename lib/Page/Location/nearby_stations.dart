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
      backgroundColor: Colors.white,
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                isThreeLine: true,

                tileColor: Colors.white,
                //dense: true,
                title: Text(widget.stationData[index].name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${widget.stationData[index].portName}: ${((calculateTimeInSeconds(widget.stationData[index].distance).ceil() + widget.stationData[index].estimatedTime) / 60).ceil()} mins (${widget.stationData[index].estimatedTime <= 0 ? "Available" : "Busy"})',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.stationData[index].estimatedTime <= 0
                              ? Colors.green
                              : Colors.red),
                    ),
                    if (widget.stationData[index].estimatedTime > 0)
                      Text(
                          "Available in ${(widget.stationData[index].estimatedTime / 60).ceil()} mins"),
                    Text(widget.stationData[index].address),
                  ],
                ),

                trailing: Text(
                    "${widget.stationData[index].distance.toStringAsFixed(2)} km"),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SizedBox(
                  width: 150,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(),
                        borderRadius: BorderRadius.circular(7)),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.payment),
                        SizedBox(width: 10),
                        Text("Book now"),
                      ],
                    ),
                  ),
                ),
              ),
              Divider()
            ],
          );
        },
      ),
    );
  }
}
