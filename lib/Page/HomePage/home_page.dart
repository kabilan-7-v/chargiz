import 'package:chargiz/Page/DrawerPage/drawer_page.dart';
import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  O3DController controller = O3DController();
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _slideAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(_controller);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
            .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Chargiz'),
          actions: [
            FadeTransition(
              opacity: _animation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Colors.red,
                      size: 12,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    const Text(
                      "disconnected",
                      style: TextStyle(fontSize: 14, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 30,
            )
          ],
        ),
        drawer: DrawerPage(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Your",
                  style: TextStyle(
                      fontSize: 24,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: FadeTransition(
                opacity: _animation,
                child: const Text(
                  "Chargiz",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(child: O3D.asset(src: "assets/bike.glb")),
            SizedBox(
                height: 150,
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
                        widget: Column(
                          children: [
                            SizedBox(
                                child: Text('90.0 %',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold))),
                          ],
                        ),
                        angle: 90,
                        positionFactor: 1.8)
                  ])
                ])),
            SizedBox(
              height: 16,
            ),
            Center(child: Text("Battery Level")),
            const SizedBox(height: 20),
          ],
        ));
  }
}
