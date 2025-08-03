import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActiveGuideScreen extends StatefulWidget {
  const ActiveGuideScreen({Key? key}) : super(key: key);

  @override
  State<ActiveGuideScreen> createState() => _ActiveGuideScreenState();
}

class _ActiveGuideScreenState extends State<ActiveGuideScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _userId;

  // Controllers for form fields
  final _ageController = TextEditingController();
  final _guideRegNumberController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _numberOfExperienceYearsController = TextEditingController();
  final _shortDescriptionController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _ageController.dispose();
    _guideRegNumberController.dispose();
    _hourlyRateController.dispose();
    _numberOfExperienceYearsController.dispose();
    _shortDescriptionController.dispose();
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
        final Map<String, dynamic> guideData = {
          'age': _ageController.text,
          'guideRegNumber': _guideRegNumberController.text,
          'hourlyRate': _hourlyRateController.text,
          'numberOfExperienceYears': _numberOfExperienceYearsController.text,
          'shortDescription': _shortDescriptionController.text,
        };

        // Make the POST request
        final response = await http.post(
          Uri.parse(
            'https://d136e3df961c.ngrok-free.app/api/register/guide?userId=$_userId',
          ),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(guideData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Guide information saved successfully!'),
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
                'Failed to save guide information. Status: ${response.statusCode}',
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
    _ageController.clear();
    _guideRegNumberController.clear();
    _hourlyRateController.clear();
    _numberOfExperienceYearsController.clear();
    _shortDescriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Guide Management'),
        backgroundColor: Colors.green[600],
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
              const Text(
                'Guide Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Age Field
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                  hintText: 'Enter your age',
                  prefixIcon: const Icon(Icons.cake),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  int? age = int.tryParse(value);
                  if (age == null || age < 18 || age > 80) {
                    return 'Please enter a valid age (18-80)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Guide Registration Number Field
              TextFormField(
                controller: _guideRegNumberController,
                decoration: InputDecoration(
                  labelText: 'Guide Registration Number',
                  hintText: 'Enter your guide registration number',
                  prefixIcon: const Icon(Icons.badge),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter guide registration number';
                  }
                  if (value.length < 5) {
                    return 'Registration number must be at least 5 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Hourly Rate Field
              TextFormField(
                controller: _hourlyRateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Hourly Rate',
                  hintText: 'Enter your hourly rate',
                  prefixIcon: const Icon(Icons.attach_money),
                  prefixText: '\$ ',
                  suffixText: '/hour',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hourly rate';
                  }
                  double? rate = double.tryParse(value);
                  if (rate == null || rate <= 0) {
                    return 'Please enter a valid hourly rate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Number of Experience Years Field
              TextFormField(
                controller: _numberOfExperienceYearsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Years of Experience',
                  hintText: 'Enter your years of experience',
                  prefixIcon: const Icon(Icons.work),
                  suffixText: 'years',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter years of experience';
                  }
                  int? experience = int.tryParse(value);
                  if (experience == null || experience < 0 || experience > 50) {
                    return 'Please enter valid years of experience (0-50)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Short Description Field
              TextFormField(
                controller: _shortDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Short Description',
                  hintText: 'Enter a brief description about yourself',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a short description';
                  }
                  if (value.length < 10) {
                    return 'Description must be at least 10 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        foregroundColor: Colors.white,
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
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Guide',
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
