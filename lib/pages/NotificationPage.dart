// Page 5: Notification Page
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.yellow[800],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[400],
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.warning, color: Colors.red),
            title: Text('Hazard Detected'),
            subtitle: Text('💀'),
          ),

          Divider(color: Colors.black,),

          ListTile(
            leading: Icon(Icons.warning, color: Colors.red),
            title: Text('No Helmet Detected'),
            subtitle: Text('⛑️'),
          ),

          Divider(color: Colors.black,),

          ListTile(
            leading: Icon(Icons.check_circle, color: Colors.green),
            title: Text('Everything Looks Cool'),
            subtitle: Text('✅'),
          ),

          Divider(color: Colors.black,),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Cameras',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.popUntil(context, ModalRoute.withName('/'));
              break;
            case 1:
              Navigator.pushNamed(context, '/camera_view');
              break;
            case 2:
              Navigator.pushNamed(context, '/notifications');
              break;
          }
        },
      ),
    );
  }
}