import 'package:atmos/controllers/auth_controller.dart';
import 'package:atmos/firebase_options.dart';
import 'package:atmos/pages/weather_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:atmos/pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Atmos",
      debugShowCheckedModeBanner: false,
      home: AuthController.user != null ? const WeatherPage() : const LoginPage(),
      builder: (context, child) {
        return Scaffold(
          body: child,
        );
      },
    );
  }
}
