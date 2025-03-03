import 'package:chargiz/Page/HomePage/home_page.dart';
import 'package:flutter/material.dart';

class Commonpage extends StatefulWidget {
  const Commonpage({super.key});

  @override
  State<Commonpage> createState() => _CommonpageState();
}

class _CommonpageState extends State<Commonpage> {
  int index = 0;
  final List<Widget> pages = [HomePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: Container(
          color: Colors.white,
          height: 60,
          child: const Row(
            children: [],
          )),
    );
  }
}
