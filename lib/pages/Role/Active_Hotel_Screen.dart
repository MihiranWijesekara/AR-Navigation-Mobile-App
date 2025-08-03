import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActiveHotelScreen extends StatefulWidget {
  const ActiveHotelScreen({Key? key}) : super(key: key);

  @override
  State<ActiveHotelScreen> createState() => _ActiveHotelScreenState();
}

class _ActiveHotelScreenState extends State<ActiveHotelScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _userId;

  // Controllers for form fields
  final _hotelNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _fullDayFeeController = TextEditingController();
  final _nightFeeController = TextEditingController();
  final _numberOfRoomsController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _hotelNameController.dispose();
    _addressController.dispose();
    _fullDayFeeController.dispose();
    _nightFeeController.dispose();
    _numberOfRoomsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Add this method to load user data
  void _loadUserData() async {
    final userData = await UserService.getUserData();
    if (userData != null) {
      setState(() {
        _userId = userData['id']?.toString(); // Update the state with user ID
      });
      print('User role: ${userData['userRoles']}');
      print('User ID: ${userData['id']}');
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User ID not available. Please try again.'),
          ),
        );
        return;
      }

      try {
        // Prepare the data to send
        final Map<String, dynamic> hotelData = {
          'fullDayFee': _fullDayFeeController.text,
          'nightFee': _nightFeeController.text,
          'numberOfRooms': _numberOfRoomsController.text,
          'address': _addressController.text,
          'hotelName': _hotelNameController.text,
        };

        // Make the POST request
        final response = await http.post(
          Uri.parse(
            'https://d136e3df961c.ngrok-free.app/api/register/hotel?userId=$_userId',
          ),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(hotelData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hotel information saved successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Wait for the snackbar to show, then navigate to login page
          await Future.delayed(const Duration(seconds: 1));

          if (mounted) {
            // Navigate to login page and clear all previous routes
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', // Replace with your login route name
              (Route<dynamic> route) => false,
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to save hotel information. Status: ${response.statusCode}',
              ),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _hotelNameController.clear();
    _addressController.clear();
    _fullDayFeeController.clear();
    _nightFeeController.clear();
    _numberOfRoomsController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Hotel Management'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hotel Information',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Hotel Name Field
              TextFormField(
                controller: _hotelNameController,
                decoration: InputDecoration(
                  labelText: 'Hotel Name',
                  hintText: 'Enter hotel name',
                  prefixIcon: const Icon(Icons.hotel),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hotel name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Address Field
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter hotel address',
                  prefixIcon: const Icon(Icons.location_on),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hotel address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Full Day Fee Field
              TextFormField(
                controller: _fullDayFeeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Full Day Fee',
                  hintText: 'Enter full day fee',
                  prefixIcon: const Icon(Icons.attach_money),
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full day fee';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Night Fee Field
              TextFormField(
                controller: _nightFeeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Night Fee',
                  hintText: 'Enter night fee',
                  prefixIcon: const Icon(Icons.nightlight_round),
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter night fee';
                  }
                  if (double.tryParse(value) == null ||
                      double.parse(value) <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Number of Rooms Field
              TextFormField(
                controller: _numberOfRoomsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of Rooms',
                  hintText: 'Enter number of rooms',
                  prefixIcon: const Icon(Icons.meeting_room),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of rooms';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of rooms';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[350],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Hotel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
