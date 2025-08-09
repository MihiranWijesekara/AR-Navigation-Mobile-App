import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GuideScreen extends StatefulWidget {
  const GuideScreen({super.key});

  @override
  State<GuideScreen> createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  List<dynamic> guides = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchGuides();
  }

  Future<void> _fetchGuides() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8082/api/users/guides'),
      );

      if (response.statusCode == 200) {
        setState(() {
          guides = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load guides: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching guides: $e';
      });
    }
  }

  // Add this method to handle the booking API call
  Future<void> _submitGuideBooking({
    required String guideId,
    required String fullName,
    required String nicNumber,
    required String mobileNumber,
    required String bookingDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8082/api/users/guide-booking'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullName,
          'nicNumber': nicNumber,
          'mobileNumber': mobileNumber,
          'bookingDate': bookingDate,
          'userId': int.parse(guideId), // Convert guideId to Long/int
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Booking submitted successfully');
        print('Response: ${response.body}');
      } else {
        print('Failed to submit booking: ${response.statusCode}');
        print('Error: ${response.body}');
        throw Exception('Failed to submit booking: ${response.body}');
      }
    } catch (e) {
      print('Error submitting booking: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d1b2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d1b2a),
        foregroundColor: Colors.white,
        title: const Text("Guide Services"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Available Guides",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildGuideList()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xff059669)),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
      );
    }

    if (guides.isEmpty) {
      return const Center(
        child: Text(
          "No guides available",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: guides.length,
      itemBuilder: (context, index) {
        final guide = guides[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildGuideCard(
            context,
            guide['guideId']?.toString() ?? 'unknown', // Pass guide ID
            guide['name'] ?? 'Unknown Guide',
            guide['shortDescription'] ?? 'No description',
            '4.8', // Default rating since API doesn't provide this
            '${guide['numberOfExperienceYears'] ?? 0}+ years experience',
            '\$${guide['hourlyRate']?.toStringAsFixed(2) ?? '0'}/hour',
          ),
        );
      },
    );
  }

  Widget _buildGuideCard(
    BuildContext context,
    String guideId, // Add guide ID parameter
    String guideName,
    String specialty,
    String rating,
    String experience,
    String hourlyRate,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff1b263b),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xff059669).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Guide Avatar
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xff059669),
              borderRadius: BorderRadius.circular(35),
              border: Border.all(
                color: const Color(0xff059669).withOpacity(0.5),
                width: 2,
              ),
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 35),
          ),
          const SizedBox(width: 16),

          // Guide Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  guideName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  experience,
                  style: const TextStyle(
                    color: Color(0xff059669),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff2563eb).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xff2563eb),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    hourlyRate,
                    style: const TextStyle(
                      color: Color(0xff2563eb),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Rating and Action Button
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xffdc2626),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  _showGuideBookingModal(
                    context,
                    guideId,
                    guideName,
                    hourlyRate,
                  ); // Pass guide ID
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2563eb),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(60, 30),
                ),
                child: const Text('Select', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showGuideBookingModal(
    BuildContext context,
    String guideId, // Add guide ID parameter
    String guideName,
    String hourlyRate,
  ) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController nicController = TextEditingController();
    final TextEditingController mobileController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1b263b),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Column(
            children: [
              const Icon(Icons.person, color: Color(0xff059669), size: 40),
              const SizedBox(height: 8),
              Text(
                'Book Guide: $guideName',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Name Input
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.person, color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color(0xff059669).withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xff059669)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // NIC Input
                TextField(
                  controller: nicController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'NIC Number',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.badge, color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color(0xff059669).withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xff059669)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Mobile Number Input
                TextField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.phone, color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color(0xff059669).withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xff059669)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Booking Date Input
                TextField(
                  controller: dateController,
                  readOnly: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Booking Date',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.white70,
                    ),
                    suffixIcon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white70,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: const Color(0xff059669).withOpacity(0.5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xff059669)),
                    ),
                  ),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Color(0xff059669),
                              onPrimary: Colors.white,
                              surface: Color(0xff1b263b),
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      selectedDate = pickedDate;
                      // Format date as YYYY-MM-DD for API
                      String formattedDate =
                          '${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}';
                      dateController.text = formattedDate;
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Price Display
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xff059669).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xff059669).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.attach_money,
                        color: Color(0xff059669),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hourlyRate,
                        style: const TextStyle(
                          color: Color(0xff059669),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Guide Info
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xff0d1b2a),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'You are booking $guideName for guide services',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Validate inputs
                if (nameController.text.isEmpty ||
                    nicController.text.isEmpty ||
                    mobileController.text.isEmpty ||
                    dateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill in all fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                try {
                  // Submit booking to API
                  await _submitGuideBooking(
                    guideId: guideId,
                    fullName: nameController.text,
                    nicNumber: nicController.text,
                    mobileNumber: mobileController.text,
                    bookingDate: dateController.text,
                  );

                  // Process booking - can be connected to backend
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Guide booking confirmed! ${nameController.text} has booked $guideName ($hourlyRate) for ${dateController.text}',
                      ),
                      backgroundColor: const Color(0xff059669),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to book guide: $e'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff059669),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Book Guide'),
            ),
          ],
        );
      },
    );
  }
}

// https://10aaa3a4a84c.ngrok-free.app
