import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_application_1/home_screen.dart';
import 'package:flutter_application_1/login_screen.dart';
import 'package:flutter_application_1/pages/Role/Active_Guide_Screen.dart';
import 'package:flutter_application_1/pages/Role/Active_Hotel_Screen.dart';
import 'package:flutter_application_1/pages/Role/Active_Safari_Screen.dart';
import 'package:flutter_application_1/signup_screen.dart';
import 'package:flutter_application_1/pages/Role/Hotel_Owner.dart';
import 'package:flutter_application_1/pages/Role/Guide.dart';
import 'package:flutter_application_1/pages/Role/safari_owner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  List<CameraDescription> cameras = [];
  try {
    cameras = await availableCameras();
  } catch (e) {
    print('Error initializing cameras: $e');
  }

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login & Signup UI',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignUpScreen(),
        '/home': (context) => HomeScreen(cameras: cameras),
        '/hotel-owner': (_) => const HotelOwner(),
        '/guide': (_) => const Guide(),
        '/safari-owner': (_) => const SafariOwner(),
        '/active-safari': (_) => const ActiveSafariScreen(),
        '/active-guide': (_) => const ActiveGuideScreen(),
        '/active-hotel': (_) => const ActiveHotelScreen(),
      },
    );
  }
}

