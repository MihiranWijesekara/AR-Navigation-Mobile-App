import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';

// --- Configuration ---
final Map<String, Point<double>> beaconCoordinates = {
  "f4:27:d8:18:c4:e5": const Point(0.0, 0.0),
  "d2:5e:58:10:6c:48": const Point(0.0, 7.3),
  "f5:88:5e:ee:60:ad": const Point(3.1, 7.3),
};

final Point<double> destinationPoint = const Point(0.0, 7.3);
const String destinationName = "Lecture Hall 07";
const double arrivalThreshold = 1.8;

enum ArrowType { forward, arrived, none }

enum NavigationState {
  idle,
  scanning,
  locating,
  navigating,
  lostSignal,
  arrived,
  error,
}

class BeaconDataPoint {
  final Point<double> position;
  final double distance;
  BeaconDataPoint({required this.position, required this.distance});
}

class HomeScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;
  const HomeScreen({super.key, this.cameras});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const HomeContentScreen(),
      widget.cameras != null && widget.cameras!.isNotEmpty
          ? NavigationScreen(cameras: widget.cameras!)
          : const NoNavigationScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d1b2a),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d1b2a),
        foregroundColor: Colors.white,
        title: const Text("WildRetreat"),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: const Color(0xff0d1b2a),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.navigation),
            label: 'Navigation',
          ),
        ],
      ),
    );
  }
}

class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Text(
            'Welcome to WildRetreat',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Choose your service',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 30),

          Expanded(
            child: GridView.count(
              crossAxisCount: 1,
              childAspectRatio: 2.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildServiceCard(
                  context,
                  'Hotel',
                  'Find and book comfortable accommodations',
                  Icons.hotel,
                  const Color(0xff2563eb), // Blue
                ),
                _buildServiceCard(
                  context,
                  'Guide',
                  'Connect with experienced local guides',
                  Icons.person_pin_circle,
                  const Color(0xff059669), // Green
                ),
                _buildServiceCard(
                  context,
                  'Safari Vehicle',
                  'Book safari vehicles for your adventure',
                  Icons.directions_car,
                  const Color(0xffdc2626), // Red
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 8,
      color: const Color(0xff1b263b),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$title service selected'),
              backgroundColor: color,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class NoNavigationScreen extends StatelessWidget {
  const NoNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, size: 64, color: Colors.white54),
          SizedBox(height: 16),
          Text(
            "Navigation not available",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Camera not found",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  const NavigationScreen({super.key, required this.cameras});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late CameraController _cameraController;
  NavigationState _navState = NavigationState.idle;
  String _errorMessage = "";
  Point<double>? _userPosition;
  double _distanceToDestination = 0.0;
  ArrowType _currentArrow = ArrowType.none;
  Timer? _signalLossTimer;

  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<CompassEvent>? _compassSubscription;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initCompass();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _scanSubscription?.cancel();
    _compassSubscription?.cancel();
    _signalLossTimer?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  void _initCamera() async {
    try {
      _cameraController = CameraController(
        widget.cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController.initialize();
    } catch (e) {
      _handleError("Camera error: $e");
    }
  }

  void _initCompass() {
    if (FlutterCompass.events == null) {
      _handleError("Compass not available");
      return;
    }
    _compassSubscription = FlutterCompass.events!.listen((event) {
      // Compass events are received but not currently used for display
      // Could be used for directional navigation in the future
    });
  }

  void _handleError(String message) {
    if (mounted) {
      setState(() {
        _navState = NavigationState.error;
        _errorMessage = message;
        _currentArrow = ArrowType.none;
      });
    }
  }

  Future<void> _startNavigation() async {
    setState(() {
      _navState = NavigationState.scanning;
      _errorMessage = "";
      _currentArrow = ArrowType.forward;
    });

    try {
      if (!await FlutterBluePlus.isSupported)
        throw Exception("Bluetooth not supported");
      if (!await FlutterBluePlus.adapterState.first.then(
        (s) => s == BluetoothAdapterState.on,
      ))
        throw Exception("Bluetooth is off");

      var locationStatus = await Permission.location.request();
      if (!locationStatus.isGranted)
        throw Exception("Location permission required");
      if (!await Permission.location.serviceStatus.isEnabled)
        throw Exception("Location services disabled");

      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        final validBeacons = results
            .where(
              (r) =>
                  beaconCoordinates.containsKey(
                    r.device.remoteId.str.toLowerCase(),
                  ) &&
                  r.rssi > -95,
            )
            .toList();

        if (validBeacons.length >= 3) {
          FlutterBluePlus.stopScan();
          _calculatePosition(validBeacons);
        }
      }, onError: (e) => _handleError("Scan Error: $e"));

      await FlutterBluePlus.startScan(androidUsesFineLocation: true);

      _signalLossTimer = Timer(const Duration(seconds: 15), () {
        if (mounted && _navState == NavigationState.scanning) {
          _handleError("Could not find enough beacons");
          _stopNavigation();
        }
      });
    } catch (e) {
      _handleError(e.toString());
    }
  }

  void _stopNavigation() {
    FlutterBluePlus.stopScan();
    _scanSubscription?.cancel();
    _signalLossTimer?.cancel();
    if (mounted) {
      setState(() {
        _navState = NavigationState.idle;
        _currentArrow = ArrowType.none;
        _userPosition = null;
        _errorMessage = "";
      });
    }
  }

  void _calculatePosition(List<ScanResult> scanResults) {
    _signalLossTimer?.cancel();
    setState(() => _navState = NavigationState.locating);

    try {
      final Map<String, ScanResult> bestResults = {};
      for (var r in scanResults) {
        final id = r.device.remoteId.str.toLowerCase();
        if (!bestResults.containsKey(id) || r.rssi > bestResults[id]!.rssi) {
          bestResults[id] = r;
        }
      }

      final dataPoints = bestResults.values.map((beacon) {
        final distance = _calculateDistance(beacon.rssi);
        final position =
            beaconCoordinates[beacon.device.remoteId.str.toLowerCase()]!;
        return BeaconDataPoint(position: position, distance: distance);
      }).toList();

      final position = TrilaterationService.calculatePosition(dataPoints);

      if (mounted) {
        setState(() {
          _userPosition = position;
          _navState = NavigationState.navigating;
          _currentArrow = ArrowType.forward;
          _updateDistance();
        });
      }

      _signalLossTimer = Timer(const Duration(seconds: 7), () {
        if (mounted && _navState == NavigationState.navigating) {
          _startNavigation();
        }
      });
    } catch (e) {
      _startNavigation();
    }
  }

  double _calculateDistance(int rssi) {
    const txPower = -59;
    const n = 2.5;
    return pow(10, (txPower - rssi) / (10 * n)).toDouble();
  }

  void _updateDistance() {
    if (_userPosition == null) return;

    final dx = destinationPoint.x - _userPosition!.x;
    final dy = destinationPoint.y - _userPosition!.y;
    _distanceToDestination = sqrt(dx * dx + dy * dy);

    if (_distanceToDestination < arrivalThreshold) {
      _handleArrival();
    }
  }

  void _handleArrival() {
    _stopNavigation();
    if (mounted) {
      setState(() {
        _navState = NavigationState.arrived;
        _currentArrow = ArrowType.arrived;
        _distanceToDestination = 0;
      });
    }
  }

  String _getStatusText() {
    switch (_navState) {
      case NavigationState.idle:
        return "Press Start to begin";
      case NavigationState.scanning:
        return "Scanning for beacons...";
      case NavigationState.locating:
        return "Calculating position...";
      case NavigationState.navigating:
        return "Navigate to $destinationName";
      case NavigationState.lostSignal:
        return "Signal lost, searching...";
      case NavigationState.arrived:
        return "Arrived at $destinationName!";
      case NavigationState.error:
        return "Error: $_errorMessage";
    }
  }

  Color _getStatusColor() {
    switch (_navState) {
      case NavigationState.arrived:
        return Colors.greenAccent;
      case NavigationState.lostSignal:
        return Colors.orangeAccent;
      case NavigationState.error:
        return Colors.redAccent;
      case NavigationState.navigating:
        return Colors.lightBlueAccent;
      default:
        return Colors.white;
    }
  }

  IconData _getArrowIcon() {
    switch (_currentArrow) {
      case ArrowType.forward:
        return Icons.arrow_upward_rounded;
      case ArrowType.arrived:
        return Icons.check_circle_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isNavigating =
        _navState != NavigationState.idle &&
        _navState != NavigationState.arrived &&
        _navState != NavigationState.error;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('Navigation'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            if (_cameraController.value.isInitialized)
              Positioned.fill(
                child: AspectRatio(
                  aspectRatio: _cameraController.value.aspectRatio,
                  child: CameraPreview(_cameraController),
                ),
              )
            else
              Container(color: Colors.black),

            Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: Colors.black.withOpacity(0.5),
                  child: Column(
                    children: [
                      Text(
                        _getStatusText(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: _getStatusColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_userPosition != null)
                        Text(
                          "Distance: ${_distanceToDestination.toStringAsFixed(1)}m",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _currentArrow != ArrowType.none
                          ? Container(
                              key: ValueKey<ArrowType>(_currentArrow),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getArrowIcon(),
                                size: 120,
                                color: _currentArrow == ArrowType.arrived
                                    ? Colors.greenAccent
                                    : Colors.lightBlueAccent,
                                shadows: const [
                                  Shadow(
                                    color: Colors.black,
                                    blurRadius: 20,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isNavigating
                          ? Colors.redAccent
                          : Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: isNavigating
                        ? _stopNavigation
                        : _startNavigation,
                    child: Text(
                      isNavigating ? "Stop Navigation" : "Start Navigation",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
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
    );
  }
}

class TrilaterationService {
  static Point<double> calculatePosition(List<BeaconDataPoint> beacons) {
    if (beacons.length < 3) throw Exception("Need at least 3 beacons");

    beacons.sort((a, b) => a.distance.compareTo(b.distance));
    final p1 = beacons[0].position;
    final p2 = beacons[1].position;
    final p3 = beacons[2].position;
    final r1 = beacons[0].distance;
    final r2 = beacons[1].distance;
    final r3 = beacons[2].distance;

    final A = 2 * (p2.x - p1.x);
    final B = 2 * (p2.y - p1.y);
    final C =
        r1 * r1 -
        r2 * r2 +
        p2.x * p2.x -
        p1.x * p1.x +
        p2.y * p2.y -
        p1.y * p1.y;
    final D = 2 * (p3.x - p2.x);
    final E = 2 * (p3.y - p2.y);
    final F =
        r2 * r2 -
        r3 * r3 +
        p3.x * p3.x -
        p2.x * p2.x +
        p3.y * p3.y -
        p2.y * p2.y;

    final denominator = (A * E - B * D);
    if (denominator.abs() < 1e-6) throw Exception("Beacons are collinear");

    final x = (C * E - F * B) / denominator;
    final y = (C * D - A * F) / (B * D - A * E);

    return Point(x, y);
  }
}
