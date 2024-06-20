import 'package:flutter/material.dart';
import 'package:secam_app/pages/CameraViewPage.dart';
import 'package:secam_app/pages/HomePage.dart';
import 'package:secam_app/pages/NotificationPage.dart';
import 'package:secam_app/pages/RegisterPage.dart';
import 'package:secam_app/pages/WelcomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecCam App',
      theme: ThemeData(
        primaryColor: Colors.yellow,
        secondaryHeaderColor: Colors.grey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/signin': (context) => RegisterPage(),
        '/register': (context) => RegisterPage(),
        '/camera_view': (context) => CameraViewPage(),
        '/notifications': (context) => NotificationPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SecCam App'),
        backgroundColor: Colors.grey[800],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.yellow[800],
      body: Column(
        children: [
          Center(child: Image(image: AssetImage('assets/seccam_logo.png'))),

          Center(
            child: Text('Welcome to SecCam App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
            ),
          ),
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