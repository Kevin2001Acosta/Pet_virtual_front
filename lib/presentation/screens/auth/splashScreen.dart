// lib/presentation/screens/auth/splashScreen.dart
import 'package:flutter/material.dart';
import 'package:yes_no_app/config/helpers/secureStorage_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(milliseconds: 1500));

    final isLoggedIn = await SecureStorageService.isLoggedIn();
    debugPrint('Usuario autenticado: $isLoggedIn');
    debugPrint("montado: $mounted");
    if (mounted) {
      if (isLoggedIn) {
        final token = await SecureStorageService.getToken();
        debugPrint('Token obtenido: $token');
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/chat',
          arguments: {'token': token},
        );
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF48A8A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
                border: Border.all(color: const Color(0xFFE52E2E), width: 4),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/mascota.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Mascota Virtual',
              style: TextStyle(
                fontFamily: 'ComicNeue',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
