import 'package:flutter/material.dart';

class HotelScreen extends StatelessWidget {
  const HotelScreen({super.key});

  // Sample hotel data - can be replaced with backend data
  final List<Map<String, dynamic>> _hotelList = const [
    {
      'name': 'Grand Palace Hotel',
      'icon': Icons.apartment,
      'color': Color(0xff059669),
      'rating': 4.8,
      'Number of rooms': 120,
      'price': '\$120/night & \$150 per day',
    },
    {
      'name': 'Ocean View Resort',
      'icon': Icons.hotel,
      'color': Color(0xff2563eb),
      'rating': 4.6,
      'Number of rooms': 120,
      'price': '\$95/night & \$130 per day',
    },
    {
      'name': 'Mountain Lodge',
      'icon': Icons.cabin,
      'color': Color(0xffdc2626),
      'rating': 4.7,
      'Number of rooms': 120,
      'price': '\$80/night & \$100 per day',
    },
    {
      'name': 'City Center Inn',
      'icon': Icons.business,
      'color': Color(0xff7c3aed),
      'rating': 4.5,
      'Number of rooms': 120,
      'price': '\$65/night & \$90 per day',
    },
    {
      'name': 'Sunset Villa',
      'icon': Icons.villa,
      'color': Color(0xfff59e0b),
      'rating': 4.9,
      'Number of rooms': 120,
      'price': '\$150/night & \$200 per day',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d1b2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d1b2a),
        foregroundColor: Colors.white,
        title: const Text("Hotel Services"),
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
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff1b263b),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xff059669).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.hotel, size: 50, color: Color(0xff059669)),
                  SizedBox(height: 12),
                  Text(
                    "Available Hotels",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Choose your perfect stay",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Hotels Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: _hotelList.length,
                itemBuilder: (context, index) {
                  final hotel = _hotelList[index];
                  return _buildHotelCard(
                    context,
                    hotel['name'],
                    hotel['icon'],
                    hotel['color'],
                    hotel['rating'],
                    hotel['price'],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelCard(
    BuildContext context,
    String hotelName,
    IconData icon,
    Color color,
    double rating,
    String price,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff1b263b),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: () {
          // Handle hotel selection - can be connected to backend
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected: $hotelName'),
              backgroundColor: color,
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hotel Icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: color),
              ),

              const SizedBox(height: 8),

              // Hotel Name
              Text(
                hotelName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // Rating
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 2),
                  Text(
                    rating.toString(),
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Price
              Text(
                price,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Available Guides Screen
class AvailableGuidesScreen extends StatelessWidget {
  const AvailableGuidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d1b2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d1b2a),
        foregroundColor: Colors.white,
        title: const Text("Available Guides"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.group, size: 80, color: Color(0xff059669)),
            SizedBox(height: 20),
            Text(
              "Hello World from Available Guides!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "This is the Available Guides screen",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Book Guide Screen
class BookGuideScreen extends StatelessWidget {
  const BookGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d1b2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d1b2a),
        foregroundColor: Colors.white,
        title: const Text("Book a Guide"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 80, color: Color(0xff2563eb)),
            SizedBox(height: 20),
            Text(
              "Hello World from Book Guide!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "This is the Book a Guide screen",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// Guide Profile Screen
class GuideProfileScreen extends StatelessWidget {
  const GuideProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d1b2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d1b2a),
        foregroundColor: Colors.white,
        title: const Text("Guide Profile"),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 80, color: Color(0xffdc2626)),
            SizedBox(height: 20),
            Text(
              "Hello World from Guide Profile!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "This is the Guide Profile screen",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
