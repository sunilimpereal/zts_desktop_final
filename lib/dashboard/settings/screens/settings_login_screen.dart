import 'package:flutter/material.dart';
import 'package:zts_counter_desktop/dashboard/settings/screens/settings_screen.dart';

import '../../../main.dart';

class SettingsLoginScrteen extends StatefulWidget {
  const SettingsLoginScrteen({Key? key}) : super(key: key);

  @override
  _SettingsLoginScrteenState createState() => _SettingsLoginScrteenState();
}

class _SettingsLoginScrteenState extends State<SettingsLoginScrteen> {
  @override
  Widget build(BuildContext context) {
    return WinScaffold(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
        child: Column(
          children: [
            Row(
              children: [IconButton(onPressed: () {
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back))],
            ),
            SettingsScreen(),
          ],
        ),
      ),
    ));
  }
}
