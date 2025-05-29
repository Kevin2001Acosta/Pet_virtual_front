import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  //bool _isLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Mascota virtual',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700, 
            fontSize: 32, 
             color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(1.0, 1.0),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      
      body: Stack(
        children: [
          Positioned(
            top: -MediaQuery.of(context).size.width * 0.7,
            left: -MediaQuery.of(context).size.width * 0.3,
            child: Container(
              width: MediaQuery.of(context).size.width * 1.5,
              height: MediaQuery.of(context).size.width * 1.5,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 229, 47, 47),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  const Icon(
                    Icons.pets,
                    size: 150,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 80),
                  
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      labelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black54,
                      ),
                      prefixIcon: const Icon(Icons.email, color:  Color.fromARGB(255, 15, 15, 15)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      labelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black54,
                      ),
                      prefixIcon: const Icon(Icons.lock, color:Color.fromARGB(255, 15, 15, 15)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/forgot_password'),
                      child: const Text(
                        'Recuperar contraseña',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Color.fromARGB(255, 229, 47, 47)
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),

                //Iniciar sesion  
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(25),
                      child: ElevatedButton(
                        onPressed: () {
                         Navigator.pushReplacementNamed(context, '/chat');
                          if (_emailController.text.isNotEmpty && 
                              _passwordController.text.isNotEmpty) {
                            
                            //Navigator.pushReplacementNamed(context, '/chat');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 229, 47, 47),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          textStyle: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text('Iniciar Sesión'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),        
                  
                  //Registarse
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      '¿No tienes cuenta? Regístrate',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color.fromARGB(255, 229, 47, 47),
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
}