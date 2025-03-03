import 'package:chargiz/Page/HomePage/home_page.dart';
import 'package:chargiz/Page/Location/location_page.dart';
import 'package:chargiz/Page/ProfilePage/profile_page.dart';
import 'package:flutter/material.dart';

class Commonpage extends StatefulWidget {
  const Commonpage({super.key});

  @override
  State<Commonpage> createState() => _CommonpageState();
}

class _CommonpageState extends State<Commonpage> {
  int index = 0;
  final List<Widget> pages = [HomePage(), LocationPage(), ProfilePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
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
                child: Column(
                  children: [Icon(Icons.home), Text('Home')],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    index = 1;
                  });
                },
                child: Column(
                  children: [Icon(Icons.location_on), Text('Home')],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
                child: Column(
                  children: [Icon(Icons.person), Text('Home')],
                ),
              )
            ],
          )),
    );
  }
}
