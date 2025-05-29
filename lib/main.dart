import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:yes_no_app/config/theme/app_theme.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart'; 
import 'package:yes_no_app/presentation/screens/chat/chat_screen.dart';
import 'package:yes_no_app/presentation/screens/auth/login.dart';
import 'package:yes_no_app/presentation/screens/auth/register.dart';
import 'package:yes_no_app/presentation/screens/auth/forgot_password.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        // Puedes añadir más providers aquí si los necesitas
      ],
      child: MaterialApp(
        title: 'Mascota Virtual',
        debugShowCheckedModeBanner: false,
        theme: AppTheme(selectedColor: 0).theme(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/chat': (context) => const ChatScreen(),
          '/forgot_password': (context) => const ForgotScreen(),
        },
      ),
    );
  }
}