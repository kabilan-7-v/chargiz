import 'package:chargiz/Page/DrawerPage/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  O3DController controller = O3DController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chargiz'),
        ),
        drawer: DrawerPage(),
        body: Column(
          children: [
            SizedBox(
                height: 400,
                width: double.infinity,
                child: O3D.asset(src: "assets/bike.glb")),
            SizedBox(
                height: 250,
                child: SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
                    GaugeRange(startValue: 0, endValue: 25, color: Colors.red),
                    GaugeRange(
                        startValue: 25, endValue: 80, color: Colors.orange),
                    GaugeRange(
                        startValue: 80, endValue: 150, color: Colors.green)
                  ], pointers: <GaugePointer>[
                    NeedlePointer(value: 90)
                  ], annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: SizedBox(
                            child: Text('90.0 %',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                        angle: 90,
                        positionFactor: 0.5)
                  ])
                ])),
            Text("Battery Level")
          ],
        ));
  }
}
