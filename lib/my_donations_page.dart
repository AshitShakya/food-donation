import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDonationsPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Donations'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            User? user = snapshot.data;

            if (user != null) {
              return DonationList(userEmail: user.email!);
            } else {
              return Center(
                child: Text('User not found'),
              );
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class DonationList extends StatelessWidget {
  final String userEmail;

  DonationList({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('available_donations')
          .where('user_email', isEqualTo: userEmail)
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

        List<QueryDocumentSnapshot> pendingDonations = snapshot.data!.docs.cast<QueryDocumentSnapshot>();

        return SingleChildScrollView(
          child: Column(
            children: [
              DonationSection(title: 'Pending Donations', donations: pendingDonations),
              SizedBox(height: 16),
              SuccessfulDonationsSection(userEmail: userEmail),
            ],
          ),
        );
      },
    );
  }
}

class DonationSection extends StatelessWidget {
  final String title;
  final List<QueryDocumentSnapshot> donations;

  DonationSection({required this.title, required this.donations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: donations.length,
          itemBuilder: (context, index) {
            Map<String, dynamic>? donationData = donations[index].data() as Map<String, dynamic>?;

            if (donationData == null) {
              return Container(); // or show an error message
            }

            return DonationCard(donationData: donationData);
          },
        ),
      ],
    );
  }
}

class SuccessfulDonationsSection extends StatelessWidget {
  final String userEmail;

  SuccessfulDonationsSection({required this.userEmail});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('successful_donations')
          .where('user_email', isEqualTo: userEmail)
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

        List<QueryDocumentSnapshot> successfulDonations = snapshot.data!.docs.cast<QueryDocumentSnapshot>();

        return DonationSection(title: 'Completed Donations', donations: successfulDonations);
      },
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
            if (donationData.containsKey('receiver_full_name')) ...[
              SizedBox(height: 8),
              Text('Received by: ${donationData['receiver_full_name']}'),
              SizedBox(height: 8),
              Text('Receiver Contact: ${donationData['receiver_contact_number']}'),
              SizedBox(height: 8),
              Text('Receiver Email: ${donationData['receiver_email']}'),
              SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
