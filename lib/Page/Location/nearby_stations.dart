import 'dart:async';

import 'package:chargiz/models/station_data_model.dart';
import 'package:chargiz/services/common_services.dart';
import 'package:chargiz/services/payment_services.dart';
import 'package:chargiz/services/station_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as d;

import 'package:url_launcher/url_launcher.dart';

class NearbyStations extends StatefulWidget {
  final List<StationDataModel> stationData;
  const NearbyStations({super.key, required this.stationData});

  @override
  State<NearbyStations> createState() => _NearbyStationsState();
}

class _NearbyStationsState extends State<NearbyStations> {
  String stationId = "";
  String portId = "";
  bool isLoading = false;
  bool showValidation = false;
  bool isSuccess = false;
  bool isVerifying = false;
  String? qrID;
  String? qrUrl;
  bool showQR = false;
  Timer? verifyTimer;
  final String paymentServer = "https://flython-payment.onrender.com";

  @override
  void initState() {
    verifyTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => manualPaymentValidation(),
    );
    super.initState();
  }

  void requestPaymentSession() async {
    isLoading = true;
    setState(() {});
    ///////////////////////////////////

    //////////////////////////////////////////////////////////////////////////////
    final payLink = await PaymentServices.generateQR(
        context: context,
        totalSum: 1,
        serverUri: paymentServer // serverData!['uri'],
        );
    showValidation = true;
    isLoading = false;
    setState(() {});
    if (payLink == null) {
      return;
    }
    await Future.delayed(const Duration(milliseconds: 2000));
    if (payLink['url'] == "") {
      qrID = null;
      return;
    }
    qrID = payLink['id'];
    qrUrl = payLink['url'];
    launchUrl(Uri.parse(payLink['url'] as String));
  }

  Future<void> manualPaymentValidation() async {
    if (!showValidation || isSuccess || qrID == null || isVerifying) {
      return;
    }
    isVerifying = true;
    final status = await PaymentServices.verifyPayment(
      id: qrID!,
      serverUri: paymentServer, //serverData!['uri'],
      context: context,
    );
    finishValidation(status);
    isVerifying = false;
  }

  void finishValidation(bool status) async {
    if (status) {
      isSuccess = true;
      setState(() {});
      StationServices.makePortBusy(
        stationId,
        portId,
        Timestamp.fromDate(DateTime.now().add(const Duration(minutes: 10))),
      );
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pop(context);
      return;
    }
  }

  @override
  void dispose() {
    super.dispose();
    verifyTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    d.log(widget.stationData.length.toString());

    return showValidation
        ? paymentValidationPage()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              title: Text("Nearby Charging Stations"),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
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
                                      color: widget.stationData[index]
                                                  .estimatedTime <=
                                              0
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 30,
                                                  left: 20,
                                                  bottom: 20),
                                              child: Text(
                                                  "Are you sure want to continue ?",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
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
                                                        style: TextStyle(
                                                            fontSize: 18)),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: MaterialButton(
                                                    onPressed: () {
                                                      stationId = widget
                                                          .stationData[index]
                                                          .stationId;
                                                      portId = widget
                                                          .stationData[index]
                                                          .portId;
                                                      requestPaymentSession();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Yes",
                                                        style: TextStyle(
                                                            fontSize: 18)),
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
                ),
                if (isLoading) const LinearProgressIndicator(),
              ],
            ),
          );
  }

  Widget paymentValidationPage() {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                  height: height * ((showQR && qrUrl != null) ? 0.1 : 0.35)),
              isSuccess
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          color: Colors.green,
                          size: 48,
                        ),
                        Text(
                          'Payment Success',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )
                  : const Text(
                      'Payment is in progress',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
              const Text(
                'This page will be redirected automatically',
                style: TextStyle(color: Colors.black),
              ),
              const SizedBox(
                height: 40,
              ),
              const SizedBox(height: 30),
              SizedBox(
                  height: height * ((showQR && qrUrl != null) ? 0.1 : 0.25)),
              if (!isSuccess)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Failed Payment?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 5),
                    MaterialButton(
                      onPressed: () {
                        showValidation = false;
                        showQR = false;
                        setState(() {});
                      },
                      color: Colors.cyan.shade900,
                      height: 45,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      minWidth: 120,
                      child: const Text(
                        "Retry",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
