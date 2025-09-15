import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yes_no_app/config/theme/app_theme.dart';
import 'package:yes_no_app/presentation/providers/chat_provider.dart';
import 'package:yes_no_app/presentation/screens/chat/chat_screen.dart';
import 'package:yes_no_app/presentation/screens/auth/login.dart';
import 'package:yes_no_app/presentation/screens/auth/register.dart';
import 'package:yes_no_app/presentation/screens/auth/forgot_password.dart';
import 'package:yes_no_app/presentation/screens/auth/change_password.dart';
import 'dart:async';

void main() => runApp(
      MultiProvider(providers: [
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
      ], child: const MyApp()),
    );

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    /* _handleInitialUri();
    _handleIncomingLinks(); */
  }

  /*  Future<void> _handleInitialUri() async {
    try {
      final uri = await getInitialUri();
      if (uri != null) {
        _handleDeepLink(uri);
      }
    } catch (e) {
      print('Failed to get initial uri: $e');
    }
  } */

  /* void _handleIncomingLinks() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      print('Error on incoming link: $err');
    });
  } */

  /* void _handleDeepLink(Uri uri) {
    if (uri.scheme == 'mychatbot' && uri.host == 'changePassword') {
      final token = uri.queryParameters['token'];
      if (token != null) {
        // Usa `pushReplacementNamed` para que no se pueda volver a la pantalla anterior
        Navigator.of(context).pushReplacementNamed('/changePassword',
            arguments: {'token': token});
      }
    }
  } */

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(
        title: 'Mascota Virtual',
        debugShowCheckedModeBanner: false,
        theme: AppTheme(selectedColor: 0).theme(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/chat': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>?;
            final email = args?['email'] ?? '';
            return ChatScreen(email: email);
          },
          '/forgot_password': (context) => const ForgotScreen(),
          //'/changePassword': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>?;
            final token = args?['token'] ?? '';
            return ChangePasswordScreen(token: token);
          },
        },
      ),
    );
  }
}
