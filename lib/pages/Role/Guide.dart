import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../services/user_service.dart';

class Guide extends StatefulWidget {
  const Guide({super.key});

  @override
  State<Guide> createState() => _GuideState();
}

class _GuideState extends State<Guide> {
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
      'http://localhost:8082/api/users/user-guide-bookings?userId=$userId',
    );
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
  }

  Future<void> _logout() async {
    await UserService.clearUserData();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/login', // Make sure this route exists in your app
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d1b2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d1b2a),
        foregroundColor: Colors.white,
        title: const Text("Guide"),
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
                  const Text(
                    "User Booking Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ...bookings.map(
                    (booking) => Card(
                      color: const Color(0xff1b2a3d),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Name:",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking['fullName'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.credit_card,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "NIC:",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking['nicNumber'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Mobile Number:",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking['mobileNumber'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Booking Date:",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking['bookingDate'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
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
}
