import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/user_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ActiveSafariScreen extends StatefulWidget {
  const ActiveSafariScreen({Key? key}) : super(key: key);

  @override
  State<ActiveSafariScreen> createState() => _ActiveSafariScreenState();
}

class _ActiveSafariScreenState extends State<ActiveSafariScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _userId;

  // Controllers for form fields
  final _vehicleRegNumberController = TextEditingController();
  final _numberOfTouristsController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _fullDayServiceRateController = TextEditingController();

  // Vehicle type dropdown
  String? _selectedVehicleType;
  final List<String> _vehicleTypes = [
    'Safari Jeep',
    'Open Jeep',
    '4WD Vehicle',
    'Safari Van',
    'Land Cruiser',
    'Mini Bus',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Load user data method
  void _loadUserData() async {
    final userData = await UserService.getUserData();
    if (userData != null) {
      setState(() {
        _userId = userData['id']?.toString();
      });
      print('User role: ${userData['userRoles']}');
      print('User ID: ${userData['id']}');
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _vehicleRegNumberController.dispose();
    _numberOfTouristsController.dispose();
    _hourlyRateController.dispose();
    _fullDayServiceRateController.dispose();
    super.dispose();
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
        // Prepare the data to send to backend
        final Map<String, dynamic> vehicleData = {
          'vehicleRegNumber': _vehicleRegNumberController.text,
          'hourlyRate': _hourlyRateController.text,
          'fullDayServiceRate': _fullDayServiceRateController.text,
          'vehicleType': _selectedVehicleType,
          'numberOfTourists': _numberOfTouristsController.text,
        };

        // Make the POST request
        final response = await http.post(
          Uri.parse(
            'http://localhost:8082/api/register/vehicle?userId=$_userId',
          ),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(vehicleData),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Safari information saved successfully!'),
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
                'Failed to save safari information. Status: ${response.statusCode}',
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
    _vehicleRegNumberController.clear();
    _numberOfTouristsController.clear();
    _hourlyRateController.clear();
    _fullDayServiceRateController.clear();
    setState(() {
      _selectedVehicleType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Safari Management'),
        backgroundColor: Colors.orange[600],
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
                'Safari Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Vehicle Registration Number Field
              TextFormField(
                controller: _vehicleRegNumberController,
                decoration: InputDecoration(
                  labelText: 'Vehicle Registration Number',
                  hintText: 'Enter vehicle registration number',
                  prefixIcon: const Icon(Icons.directions_car),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter vehicle registration number';
                  }
                  if (value.length < 5) {
                    return 'Registration number must be at least 5 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Vehicle Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedVehicleType,
                decoration: InputDecoration(
                  labelText: 'Vehicle Type',
                  hintText: 'Select vehicle type',
                  prefixIcon: const Icon(Icons.car_rental),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                items: _vehicleTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedVehicleType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a vehicle type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Number of Tourists Field
              TextFormField(
                controller: _numberOfTouristsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of Tourists',
                  hintText: 'Enter maximum number of tourists',
                  prefixIcon: const Icon(Icons.group),
                  suffixText: 'people',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of tourists';
                  }
                  int? tourists = int.tryParse(value);
                  if (tourists == null || tourists <= 0 || tourists > 50) {
                    return 'Please enter a valid number (1-50)';
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
                  hintText: 'Enter hourly rate',
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

              // Full Day Service Rate Field
              TextFormField(
                controller: _fullDayServiceRateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Full Day Service Rate',
                  hintText: 'Enter full day service rate',
                  prefixIcon: const Icon(Icons.today),
                  prefixText: '\$ ',
                  suffixText: '/day',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full day service rate';
                  }
                  double? rate = double.tryParse(value);
                  if (rate == null || rate <= 0) {
                    return 'Please enter a valid full day rate';
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
                        backgroundColor: Colors.orange[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Safari',
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
