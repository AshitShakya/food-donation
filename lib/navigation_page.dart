// navigation_page.dart
import 'package:flutter/material.dart';
import 'donation_page.dart';
import 'receiver_page.dart';
import 'my_profile_page.dart';

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Donation'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.yellow[100], // Set the pale yellow background color
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                context,
                'DONATE',
                Colors.blue,
                'Donate Food, Save Lives',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DonationPage()),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildButton(
                context,
                'RECEIVE',
                Colors.green,
                'Receive Food, Share Smiles',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReceiverPage()),
                  );
                },
              ),
              SizedBox(height: 20),
              _buildButton(
                context,
                'MY PROFILE',
                Colors.orange,
                null, // No slogan for My Profile button
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyProfilePage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context,
    String text,
    Color color,
    String? slogan,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        primary: color,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Make the buttons round
        ),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(fontSize: 18),
          ),
          if (slogan != null)
            SizedBox(height: 8),
          if (slogan != null)
            Text(
              slogan,
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
        ],
      ),
    );
  }
}
