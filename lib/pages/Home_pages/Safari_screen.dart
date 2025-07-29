import 'package:flutter/material.dart';

class SafariScreen extends StatelessWidget {
  const SafariScreen({super.key});

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
            Expanded(
              child: ListView(
                children: [
                  _buildSafariCard(
                    context,
                    "Rajesh Kumar",
                    "Jeep Wrangler - 4WD",
                    "ABC-1234",
                    "\$80/hour • \$600/day",
                    Icons.directions_car,
                  ),
                  const SizedBox(height: 16),
                  _buildSafariCard(
                    context,
                    "Sunil Fernando",
                    "Toyota Land Cruiser",
                    "XYZ-5678",
                    "\$90/hour • \$700/day",
                    Icons.airport_shuttle,
                  ),
                  const SizedBox(height: 16),
                  _buildSafariCard(
                    context,
                    "Mahesh Silva",
                    "Safari Van - 8 Seater",
                    "DEF-9012",
                    "\$120/hour • \$950/day",
                    Icons.rv_hookup,
                  ),
                  const SizedBox(height: 16),
                  _buildSafariCard(
                    context,
                    "Pradeep Wijesekara",
                    "Off-Road Defender",
                    "GHI-3456",
                    "\$85/hour • \$650/day",
                    Icons.local_shipping,
                  ),
                  const SizedBox(height: 16),
                  _buildSafariCard(
                    context,
                    "Chaminda Perera",
                    "Mini Bus - 15 Seater",
                    "JKL-7890",
                    "\$150/hour • \$1200/day",
                    Icons.directions_bus,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSafariCard(
    BuildContext context,
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
                  // TODO: Navigate to booking or vehicle details
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Selected vehicle: $vehicleType by $ownerName',
                      ),
                      backgroundColor: const Color(0xff059669),
                    ),
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
