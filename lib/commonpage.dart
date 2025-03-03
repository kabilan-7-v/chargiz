import 'package:chargiz/Page/HomePage/home_page.dart';
import 'package:chargiz/Page/Location/location_ev_station.dart';
import 'package:chargiz/Page/ProfilePage/profile_page.dart';
import 'package:flutter/material.dart';

class Commonpage extends StatefulWidget {
  const Commonpage({super.key});

  @override
  State<Commonpage> createState() => _CommonpageState();
}

class _CommonpageState extends State<Commonpage> {
  int index = 0;
  final List<Widget> pages = [HomePage(), LocationEVStation(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: pages,
      ),
      bottomNavigationBar: Container(
          color: Colors.white,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                  onTap: () {
                    setState(() {
                      index = 0;
                    });
                  },
                  child: index == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  'assets/icon/homefill.png',
                                )),
                            Text(
                              'Home',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Image.asset(
                                    'assets/icon/home.png',
                                  )),
                              Text(
                                'Home',
                              )
                            ])),
              InkWell(
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                },
                child: index == 1
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset(
                                'assets/icon/locationfill.png',
                              )),
                          Text(
                            'Map',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  'assets/icon/location.png',
                                )),
                            Text(
                              'Map',
                            )
                          ]),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
                child: index == 2
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 30,
                              width: 30,
                              child: Image.asset(
                                'assets/icon/personfill.png',
                              )),
                          Text(
                            'Profile',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  'assets/icon/person.png',
                                )),
                            Text(
                              'Profile',
                            )
                          ]),
              ),
            ],
          )),
    );
  }
}
