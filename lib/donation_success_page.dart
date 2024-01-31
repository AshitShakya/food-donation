import 'package:flutter/material.dart';

class DonationSuccessPage extends StatelessWidget {
  final String donationQuantity;
  final String typeOfFood;
  final String expirationDate;
  final String donationMessage;
  final String pickupLocation;
  final String descriptionOfFood;

  DonationSuccessPage({
    required this.donationQuantity,
    required this.typeOfFood,
    required this.expirationDate,
    required this.donationMessage,
    required this.pickupLocation,
    required this.descriptionOfFood,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation Successful'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Thank you for your donation!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text('Donation Details:', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Type of Food: $typeOfFood', style: TextStyle(fontSize: 16)),
              Text('Quantity: $donationQuantity pounds', style: TextStyle(fontSize: 16)),
              Text('Expiration Date: $expirationDate', style: TextStyle(fontSize: 16)),
              Text('Pickup Location: $pickupLocation', style: TextStyle(fontSize: 16)),
              Text('Description of Food: $descriptionOfFood', style: TextStyle(fontSize: 16)),
              Text('Additional Message: $donationMessage', style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, 'success');
                },
                child: Text('Back to Home', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
