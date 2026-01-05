import 'package:flutter/material.dart';

class MainSettings extends StatelessWidget {
  const MainSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ListTile(leading: Icon(Icons.contacts), title: Text('Contact')),
            ListTile(leading: Icon(Icons.design_services), title: Text('Terms of Service')),
            ListTile(leading: Icon(Icons.privacy_tip), title: Text('Privacy Policy')),
            ListTile(leading: Icon(Icons.info), title: Text('Company Info')),
          ],
        ),
      ),
    );
  }
}
