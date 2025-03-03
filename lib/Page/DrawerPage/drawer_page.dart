import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            children: [
              SizedBox(
                width: 8,
              ),
              CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage("assets/images/bike.jpg")),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Kabilan V"),
                  Text("chargiz@gmail.com"),
                ],
              )
            ],
          ),
          Center(
            child: ListTile(
              leading: Icon(Icons.person_outline),
              title: Text("Account"),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit_document),
            title: Text("Document"),
          ),
          ListTile(
            leading: Icon(Icons.charging_station_outlined),
            title: Text("Charging"),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
          ),
          ListTile(
            leading: Icon(Icons.help_center_outlined),
            title: Text("Help & FAQ"),
          ),
        ],
      ),
    );
  }
}
