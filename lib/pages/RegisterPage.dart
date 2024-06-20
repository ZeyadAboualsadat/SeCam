// Page 2: Registration Page
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.yellow[800],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[400],

      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8, // Adjust width as needed
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40), // Add space on left and right
          decoration: BoxDecoration(
            color: Colors.yellow[800], // Set box color to white
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Enter Email Address'),
              ),
              SizedBox(height: 20),
              TextField(
                obscureText: true,
                decoration: InputDecoration(labelText: 'Enter Password'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to Home Page
                  Navigator.pushNamed(context, '/home');
                },
                child: Text('Sign In'),
              ),
            ],
          ),
        ),
      ),

    );
  }
}