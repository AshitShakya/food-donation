import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'donation_success_page.dart';

class DonationPage extends StatefulWidget {
  @override
  _DonationPageState createState() => _DonationPageState();
}

class _DonationPageState extends State<DonationPage> {
  final _typeOfFoodController = TextEditingController();
  final _quantityController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _messageController = TextEditingController();
  final _pickupLocationController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Help us in our mission to provide food to those in need. Your contribution makes a difference!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _typeOfFoodController,
                  decoration: InputDecoration(labelText: 'Type of Food'),
                  style: TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the type of food';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity of Food (in kg)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the quantity';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _expirationDateController,
                  decoration: InputDecoration(labelText: 'Expiration Date'),
                  style: TextStyle(fontSize: 16),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null && pickedDate != DateTime.now()) {
                      _expirationDateController.text = pickedDate.toLocal().toString().split(' ')[0];
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select the expiration date';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _pickupLocationController,
                  decoration: InputDecoration(labelText: 'Pickup Location'),
                  style: TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the pickup location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description of Food'),
                  style: TextStyle(fontSize: 16),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration(labelText: 'Additional Message (optional)'),
                  style: TextStyle(fontSize: 16),
                  maxLines: 4,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      // All fields are valid, process the donation
                      _processDonation();
                    }
                  },
                  child: Text('Donate Now', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _processDonation() async {
    // Store donation data in Firestore
    await _storeDonationData();

    // Show success page
    _showSuccessPage();
  }

  Future<void> _storeDonationData() async {
    try {
      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Retrieve user information
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        // Store donation data along with user information
        await _firestore.collection('available_donations').add({
          'user_full_name': userDoc['fullName'],
          'user_email': user.email,
          'user_contact_number': userDoc['contactNumber'],
          'type_of_food': _typeOfFoodController.text,
          'quantity': _quantityController.text,
          'expiration_date': _expirationDateController.text,
          'pickup_location': _pickupLocationController.text,
          'description': _descriptionController.text,
          'message': _messageController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error storing donation data: $e");
    }
  }

  void _showSuccessPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DonationSuccessPage(
          donationQuantity: _quantityController.text,
          typeOfFood: _typeOfFoodController.text,
          expirationDate: _expirationDateController.text,
          donationMessage: _messageController.text,
          pickupLocation: _pickupLocationController.text,
          descriptionOfFood: _descriptionController.text,
        ),
      ),
    );

    if (result == 'success') {
      // Clear data on success
      _typeOfFoodController.clear();
      _quantityController.clear();
      _expirationDateController.clear();
      _pickupLocationController.clear();
      _descriptionController.clear();
      _messageController.clear();
    }
  }
}
