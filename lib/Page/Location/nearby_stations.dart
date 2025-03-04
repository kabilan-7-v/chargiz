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
              Align(
                alignment: Alignment(-0.8, 0),
                child: SizedBox(
                  width: 160,
                  child: MaterialButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7)),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, left: 20, bottom: 20),
                                  child: Text("Are you sure want to continue ?",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: MaterialButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("No",
                                            style: TextStyle(fontSize: 18)),
                                      ),
                                    ),
                                    Expanded(
                                      child: MaterialButton(
                                        onPressed: () async {
                                          //code here
                                          Navigator.pop(context);
                                        },
                                        child: Text("Yes",
                                            style: TextStyle(fontSize: 18)),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                              ],
                            );
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.payment,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Book now",
                          style: TextStyle(color: Colors.white),
                        ),
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
