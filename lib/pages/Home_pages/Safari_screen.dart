import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SafariScreen extends StatefulWidget {
  const SafariScreen({super.key});

  @override
  State<SafariScreen> createState() => _SafariScreenState();
}

class _SafariScreenState extends State<SafariScreen> {
  List<dynamic> safariVehicles = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSafariVehicles();
  }

  Future<void> _fetchSafariVehicles() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8082/api/users/safari'),
      );

      if (response.statusCode == 200) {
        setState(() {
          safariVehicles = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage =
              'Failed to load safari vehicles: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching safari vehicles: $e';
      });
    }
  }

  // Add this method to handle the safari booking API call
  Future<void> _submitSafariBooking({
    required String safariId,
    required String fullName,
    required String nicNumber,
    required String mobileNumber,
    required String bookingDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8082/api/users/safari-booking'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullName': fullName,
          'nicNumber': nicNumber,
          'mobileNumber': mobileNumber,
          'bookingDate': bookingDate,
          'userId': int.parse(safariId), // Convert safariId to Long/int
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Safari booking submitted successfully');
        print('Response: ${response.body}');
      } else {
        print('Failed to submit safari booking: ${response.statusCode}');
        print('Error: ${response.body}');
        throw Exception('Failed to submit safari booking: ${response.body}');
      }
    } catch (e) {
      print('Error submitting safari booking: $e');
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
        title: const Text("Safari Services"),
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
              "Available Safari Vehicles",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildSafariList()),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSafariList() {
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

    if (safariVehicles.isEmpty) {
      return const Center(
        child: Text(
          "No safari vehicles available",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return ListView.builder(
      itemCount: safariVehicles.length,
      itemBuilder: (context, index) {
        final vehicle = safariVehicles[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _buildSafariCard(
            context,
            vehicle['safariId']?.toString() ?? 'unknown', // Pass safari ID
            vehicle['name'] ?? 'Unknown Owner',
            vehicle['vehicleType'] ?? 'Unknown Vehicle',
            vehicle['vehicleRegNumber'] ?? 'N/A',
            '\$${vehicle['hourlyRate']?.toStringAsFixed(2) ?? '0'}/hour • \$${vehicle['fullDayServiceRate']?.toStringAsFixed(2) ?? '0'}/day',
            _getVehicleIcon(vehicle['vehicleType']),
          ),
        );
      },
    );
  }

  IconData _getVehicleIcon(String? vehicleType) {
    if (vehicleType == null) return Icons.directions_car;

    if (vehicleType.toLowerCase().contains('jeep')) {
      return Icons.directions_car;
    } else if (vehicleType.toLowerCase().contains('van')) {
      return Icons.airport_shuttle;
    } else if (vehicleType.toLowerCase().contains('bus')) {
      return Icons.directions_bus;
    } else if (vehicleType.toLowerCase().contains('defender') ||
        vehicleType.toLowerCase().contains('4wd')) {
      return Icons.local_shipping;
    } else {
      return Icons.directions_car;
    }
  }

  Widget _buildSafariCard(
    BuildContext context,
    String safariId, // Add safari ID parameter
    String ownerName,
    String vehicleType,
    String regNumber,
    String pricingInfo,
    IconData vehicleIcon,
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
          // Vehicle Icon
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
            child: Icon(vehicleIcon, color: Colors.white, size: 35),
          ),
          const SizedBox(width: 16),

          // Vehicle and Owner Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ownerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vehicleType,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Text(
                  pricingInfo,
                  style: const TextStyle(
                    color: Color(0xff2563eb),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Registration Number and Action Button
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
                    const Icon(
                      Icons.confirmation_number,
                      color: Colors.white,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      regNumber,
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
                  _showSafariBookingModal(
                    context,
                    safariId, // Pass safari ID
                    ownerName,
                    vehicleType,
                    regNumber,
                    pricingInfo,
                  );
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
                child: const Text('Book', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showSafariBookingModal(
    BuildContext context,
    String safariId, // Add safari ID parameter
    String ownerName,
    String vehicleType,
    String regNumber,
    String pricingInfo,
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
              Icon(
                _getVehicleIcon(vehicleType),
                color: const Color(0xff059669),
                size: 40,
              ),
              const SizedBox(height: 8),
              Text(
                'Book Safari Vehicle',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                vehicleType,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Owner and Vehicle Info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xff0d1b2a),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xff059669).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Owner: $ownerName',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.confirmation_number,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Registration: $regNumber',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

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

                // Safari Date Input
                TextField(
                  controller: dateController,
                  readOnly: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Safari Date',
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
                      // Format date as YYYY-MM-DD for API consistency
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
                    color: const Color(0xff2563eb).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xff2563eb).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.attach_money,
                        color: Color(0xff2563eb),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pricingInfo,
                        style: const TextStyle(
                          color: Color(0xff2563eb),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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

                // Console log the safari booking data
                print('=== SAFARI BOOKING DATA ===');
                print('Safari ID: $safariId');
                print('Customer Name: ${nameController.text}');
                print('NIC Number: ${nicController.text}');
                print('Mobile Number: ${mobileController.text}');
                print('Safari Date: ${dateController.text}');
                print('Selected Date Object: $selectedDate');
                print('Owner Name: $ownerName');
                print('Vehicle Type: $vehicleType');
                print('Registration Number: $regNumber');
                print('Pricing Info: $pricingInfo');
                print('============================');

                try {
                  // Submit safari booking to API
                  await _submitSafariBooking(
                    safariId: safariId,
                    fullName: nameController.text,
                    nicNumber: nicController.text,
                    mobileNumber: mobileController.text,
                    bookingDate: dateController.text,
                  );

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Safari booking confirmed! ${nameController.text} has booked $vehicleType ($regNumber) with $ownerName on ${dateController.text}',
                      ),
                      backgroundColor: const Color(0xff059669),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to book safari: $e'),
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
              child: const Text('Book Safari'),
            ),
          ],
        );
      },
    );
  }
}
