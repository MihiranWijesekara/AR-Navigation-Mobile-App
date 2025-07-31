import 'package:flutter/material.dart';

class ActiveSafariScreen extends StatefulWidget {
  const ActiveSafariScreen({Key? key}) : super(key: key);

  @override
  State<ActiveSafariScreen> createState() => _ActiveSafariScreenState();
}

class _ActiveSafariScreenState extends State<ActiveSafariScreen> {
  final _formKey = GlobalKey<FormState>();

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
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _vehicleRegNumberController.dispose();
    _numberOfTouristsController.dispose();
    _hourlyRateController.dispose();
    _fullDayServiceRateController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Safari information saved successfully!')),
      );

      // You can add your save logic here
      print('Vehicle Registration Number: ${_vehicleRegNumberController.text}');
      print('Vehicle Type: $_selectedVehicleType');
      print('Number of Tourists: ${_numberOfTouristsController.text}');
      print('Hourly Rate: ${_hourlyRateController.text}');
      print('Full Day Service Rate: ${_fullDayServiceRateController.text}');
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
