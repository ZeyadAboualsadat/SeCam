// Page 1: Welcome Page

import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to SecCam'),
        backgroundColor: Colors.yellow[800],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[400],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/seccam_logo.png')),

            Text(
              'Welcome to SecCam',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),

            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Sign In Page
                Navigator.pushNamed(context, '/signin');
              },
              child: Text('Sign In'),
            ),
            SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                // Navigate to Register Page
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Register'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
