import 'package:flutter/material.dart';

class ActiveGuideScreen extends StatefulWidget {
  const ActiveGuideScreen({Key? key}) : super(key: key);

  @override
  State<ActiveGuideScreen> createState() => _ActiveGuideScreenState();
}

class _ActiveGuideScreenState extends State<ActiveGuideScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final _ageController = TextEditingController();
  final _guideRegNumberController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _experienceController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _ageController.dispose();
    _guideRegNumberController.dispose();
    _hourlyRateController.dispose();
    _experienceController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guide information saved successfully!')),
      );

      // You can add your save logic here
      print('Age: ${_ageController.text}');
      print('Guide Registration Number: ${_guideRegNumberController.text}');
      print('Hourly Rate: ${_hourlyRateController.text}');
      print('Years of Experience: ${_experienceController.text}');
      print('Title: ${_titleController.text}');
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _ageController.clear();
    _guideRegNumberController.clear();
    _hourlyRateController.clear();
    _experienceController.clear();
    _titleController.clear();
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

              // Years of Experience Field
              TextFormField(
                controller: _experienceController,
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

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter your professional title',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your title';
                  }
                  if (value.length < 2) {
                    return 'Title must be at least 2 characters';
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
