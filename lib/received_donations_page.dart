import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceivedDonationsPage extends StatelessWidget {
  final String userEmail;

  ReceivedDonationsPage({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donations Received'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('successful_donations')
            .where('receiver_email', isEqualTo: userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<QueryDocumentSnapshot> receivedDonations = snapshot.data!.docs.cast<QueryDocumentSnapshot>();

          return ListView.builder(
            itemCount: receivedDonations.length,
            itemBuilder: (context, index) {
              Map<String, dynamic>? donationData = receivedDonations[index].data() as Map<String, dynamic>?;

              if (donationData == null) {
                return Container(); // or show an error message
              }

              return DonationCard(donationData: donationData);
            },
          );
        },
      ),
    );
  }
}

class DonationCard extends StatelessWidget {
  final Map<String, dynamic> donationData;

  DonationCard({required this.donationData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Item: ${donationData['type_of_food']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Quantity(in kg): ${donationData['quantity']}'),
            SizedBox(height: 8),
            Text('Description: ${donationData['description']}'),
            SizedBox(height: 8),
            Text('Expiration Date: ${donationData['expiration_date']}'),
            SizedBox(height: 8),
            Text('Pickup Location: ${donationData['pickup_location']}'),
            SizedBox(height: 8),
            Text('Message: ${donationData['message']}'),
            SizedBox(height: 8),
            Text('Donated by: ${donationData['user_full_name']}'),
            SizedBox(height: 8),
            Text('Donor Contact: ${donationData['user_contact_number']}'),
            SizedBox(height: 8),
            Text('Donor Email: ${donationData['user_email']}'),
            SizedBox(height: 8),
            ],
        ),
      ),
    );
  }
}
