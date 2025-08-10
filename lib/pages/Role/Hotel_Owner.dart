import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../services/user_service.dart';

class HotelOwner extends StatefulWidget {
  const HotelOwner({super.key});

  @override
  State<HotelOwner> createState() => _HotelOwnerState();
}

class _HotelOwnerState extends State<HotelOwner> {
  List<dynamic> bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    final userData = await UserService.getUserData();
    final userId = userData?['id'];
    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final url = Uri.parse(
      'http://localhost:8082/api/users/user-Hotel-bookings?userId=$userId',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          bookings = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getBookingType(dynamic booking) {
    final fullDayFee = booking['fullDayFee'] ?? 0;
    final nightFee = booking['nightFee'] ?? 0;

    if (fullDayFee == 1) {
      return 'Full Day';
    } else if (nightFee == 1) {
      return 'Night';
    } else {
      return 'Unknown';
    }
  }

  Future<void> _logout() async {
    await UserService.clearUserData();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d1b2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d1b2a),
        foregroundColor: Colors.white,
        title: const Text("Hotel Owner"),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : bookings.isEmpty
            ? const Center(
                child: Text(
                  "No bookings found.",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Current Bookings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ...bookings.map(
                    (booking) => Card(
                      color: const Color(0xff1b263b),
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Booking Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildBookingInfo(
                              'Name',
                              booking['fullName'] ?? '',
                            ),
                            _buildBookingInfo(
                              'NIC',
                              booking['nicNumber'] ?? '',
                            ),
                            _buildBookingInfo(
                              'Mobile Number',
                              booking['mobileNumber'] ?? '',
                            ),
                            _buildBookingInfo(
                              'Booking Date',
                              booking['bookingDate'] ?? '',
                            ),
                            _buildBookingInfo(
                              'Booking Type',
                              getBookingType(booking),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildBookingInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
