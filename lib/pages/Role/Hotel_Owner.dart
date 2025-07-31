import 'package:flutter/material.dart';

class HotelOwner extends StatelessWidget {
  const HotelOwner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d1b2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d1b2a),
        foregroundColor: Colors.white,
        title: const Text("Hotel Owner"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Hotel Owner Profile Section
            Container(
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: const Color(0xff415a77),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xff778da9),
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  // Hotel Owner Name
                  Text(
                    'Grand Plaza Hotel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Owner Name
                  Text(
                    'Owner: Mr. Ravi Perera',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Location
                  Text(
                    'Colombo, Sri Lanka',
                    style: TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  // Statistics Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Total Rooms', '25'),
                      _buildStatItem('Bookings', '18'),
                      _buildStatItem('Rating', '4.5★'),
                    ],
                  ),
                ],
              ),
            ),
            // Booking Cards Title
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                'Current Bookings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Booking Card 1
            Card(
              color: const Color(0xff1b263b),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBookingInfo('Name', 'John Doe'),
                    _buildBookingInfo('NIC', '123456789V'),
                    _buildBookingInfo('Mobile Number', '+94 77 123 4567'),
                    _buildBookingInfo('Booking Date', '2025-08-05'),
                    _buildBookingInfo('Booking Duration', '2 nights'),
                  ],
                ),
              ),
            ),
            // Booking Card 2
            Card(
              color: const Color(0xff1b263b),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBookingInfo('Name', 'Jane Smith'),
                    _buildBookingInfo('NIC', '987654321V'),
                    _buildBookingInfo('Mobile Number', '+94 71 987 6543'),
                    _buildBookingInfo('Booking Date', '2025-08-08'),
                    _buildBookingInfo('Booking Duration', '1 day'),
                  ],
                ),
              ),
            ),
            // Booking Card 3
            Card(
              color: const Color(0xff1b263b),
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildBookingInfo('Name', 'Mike Johnson'),
                    _buildBookingInfo('NIC', '456789123V'),
                    _buildBookingInfo('Mobile Number', '+94 76 456 7890'),
                    _buildBookingInfo('Booking Date', '2025-08-12'),
                    _buildBookingInfo('Booking Duration', '3 nights'),
                  ],
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

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
