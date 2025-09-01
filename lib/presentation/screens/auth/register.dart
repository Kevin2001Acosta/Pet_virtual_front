import 'package:flutter/material.dart';
import 'package:yes_no_app/infrastructure/models/auth_model.dart';
import 'package:yes_no_app/config/helpers/auth_service.dart';
import 'package:yes_no_app/presentation/widgets/alert.dart';
import 'dart:ui' as ui;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscureText = true;

  Future<void> _registerUser() async {
    print('Botón presionado');

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      showErrorDialog(
        context: context,
        title: 'Campos requeridos',
        message: 'Por favor completa todos los campos',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = UserRegister(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      final authService = AuthService();
      final response = await authService.register(user);

      if (response['success'] == true) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        showErrorDialog(
          context: context,
          title: 'Error',
          message: response['message'] ?? 'Error en el registro',
        );
      }
    } catch (e) {
      showErrorDialog(
        context: context,
        title: 'Error',
        message: 'Ocurrió un error inesperado: $e',
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                Color(0xFFF48A8A), 
                Color(0xFFFDEDED), 
                ],  
              ),
            ),  
          ),
          Center( 
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                        crossAxisAlignment: CrossAxisAlignment.center, 
                        children: [
                          const Expanded(
                            child: Text(
                              'Crear cuenta',
                              textAlign: TextAlign.center, 
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 34,
                                color: Color.fromARGB(255, 10, 10, 10),
                                letterSpacing: 1.0,
                                height: 1.2,
                                shadows: [
                                  ui.Shadow(
                                    blurRadius: 2.0,
                                    color: Color.fromARGB(255, 255, 254, 254),
                                    offset: Offset(2.0, 2.0),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Transform.translate(
                          offset: const Offset(70, 0),
                            child: SizedBox(
                                    width: 200, 
                                    height: 200, 
                                    child: Align(
                                      alignment: Alignment.centerRight, 
                                      child: Transform.rotate(
                                        angle: -0.2,
                                        child: Image.asset(
                                          'assets/images/register.png',
                                         
                                        ),
                                      ),
                                  ),
                              ),
                            ),
                            ],
                          ),     
                        ],
                          ),
                      ),
                    const SizedBox(height: 20),

                  //Campos
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(137, 0, 0, 0),
                      ),
                      prefixIcon: const Icon(Icons.person_outline,
                          color: Color.fromARGB(255, 95, 95, 95)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      labelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black54,
                      ),
                      prefixIcon: Icon(Icons.email, color: Color.fromARGB(255, 95, 95, 95)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black54,
                      ),
                      prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 95, 95, 95)),
                      
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 80),
                  
                  // Botón de degistro
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(25),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 229, 47, 47),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('REGISTRARSE'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),

                  // Botón de login

                TextButton(
                   onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Colors.black, 
                        ),
                        children:  [
                          TextSpan(text: ' ¿Ya tienes cuenta? '),
                          TextSpan(
                            text: 'Inicia sesión',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
