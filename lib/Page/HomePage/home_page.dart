import 'package:chargiz/Page/DrawerPage/drawer_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Chargiz'),
        ),
        drawer: DrawerPage(),
        body: Column());
  }
}
