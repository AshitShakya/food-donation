import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReceiverPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Donations'),
      ),
      body: DonationList(),
    );
  }
}

class DonationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('available_donations').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator while waiting for data
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<QueryDocumentSnapshot> donations = snapshot.data!.docs.cast<QueryDocumentSnapshot>();

        return ListView.builder(
          itemCount: donations.length,
          itemBuilder: (context, index) {
            Map<String, dynamic>? donationData = donations[index].data() as Map<String, dynamic>?;

            if (donationData == null) {
              return Container(); // or show an error message
            }

            String donationId = donations[index].id;

            return DonationListItem(donationData, donationId);
          },
        );
      },
    );
  }
}

class DonationListItem extends StatelessWidget {
  final Map<String, dynamic> donationData;
  final String donationId;

  DonationListItem(this.donationData, this.donationId);

  @override
  Widget build(BuildContext context) {
    String typeOfFood = donationData['type_of_food'].toString();
    String userEmail = donationData['user_email'].toString(); // Added this line
    String quantity = donationData['quantity'].toString();
    String expirationDate = donationData['expiration_date'].toString();
    String pickupLocation = donationData['pickup_location'].toString();
    String descriptionOfFood = donationData['description'].toString();
    String message = donationData['message'].toString();
    String donatedBy = donationData['user_full_name'].toString();
    String contact = donationData['user_contact_number'].toString();
    String email = donationData['user_email'].toString();

    // Check if the currently authenticated user's email matches the donation's user_email
    bool canReceive = FirebaseAuth.instance.currentUser?.email != userEmail;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type of Food: $typeOfFood',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Quantity (in kg): $quantity'),
            Text('Expiration Date: $expirationDate'),
            Text('Pickup Location: $pickupLocation'),
            Text('Description of Food: $descriptionOfFood'),
            Text('Message: $message'),
            Text('Donated By: $donatedBy'),
            Text('Contact: $contact'),
            Text('Email: $email'),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: canReceive
              ? () {
                  _showConfirmationDialog(context, typeOfFood, donationId);
                }
              : null, // Disable button if the user is the donor
          child: Text('Receive'),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String typeOfFood, String donationId) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Receive Donation'),
          content: Text('Do you want to receive the donation of $typeOfFood?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _receiveDonation(context, typeOfFood, donationId);
                Navigator.of(context).pop();
              },
              child: Text('Receive'),
            ),
          ],
        );
      },
    );
  }

  void _receiveDonation(BuildContext context, String typeOfFood, String donationId) async {
    try {
      // Get the current user
      User? receiverUser = FirebaseAuth.instance.currentUser;

      if (receiverUser != null) {
        // Retrieve receiver user information
        DocumentSnapshot receiverUserDoc = await FirebaseFirestore.instance.collection('users').doc(receiverUser.uid).get();

        // Add receiver information to donation data
        donationData['receiver_full_name'] = receiverUserDoc['fullName'];
        donationData['receiver_email'] = receiverUser.email;
        donationData['receiver_contact_number'] = receiverUserDoc['contactNumber'];

        // Perform actions needed when donation is received
        // For example, move data to 'successful_donations' collection
        // and delete from 'available_donations' collection
        await FirebaseFirestore.instance.collection('successful_donations').doc(donationId).set(donationData);
        await FirebaseFirestore.instance.collection('available_donations').doc(donationId).delete();

        // Show success popup
        _showReceivedPopup(context, typeOfFood);
      }
    } catch (e) {
      print("Error receiving donation: $e");
    }
  }

  void _showReceivedPopup(BuildContext context, String typeOfFood) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You received the donation of $typeOfFood!. Please get in touch with the donor'),
      ),
    );
  }
}
