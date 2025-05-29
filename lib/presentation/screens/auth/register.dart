import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> { 

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Crear cuenta',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700, 
            fontSize: 32, 
             color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 2.0,
                color: Colors.black.withOpacity(0.3),
                offset: Offset(1.0, 1.0),
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
          
          // Contenido principal
          Center( 
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
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
                  
                  // Campos de texto
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      labelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black54,
                      ),
                      prefixIcon: Icon(Icons.person_outline, color: Color.fromARGB(255, 15, 15, 15)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
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
                      prefixIcon: Icon(Icons.email, color: const Color.fromARGB(255, 15, 15, 15)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      filled: true,
                      fillColor: Colors.white,
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
                      prefixIcon: Icon(Icons.lock, color: const Color.fromARGB(255, 15, 15, 15)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Botón de degistro
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(25),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_emailController.text.isNotEmpty && 
                              _passwordController.text.isNotEmpty) {
                            Navigator.pushReplacementNamed(context, '/');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 229, 47, 47),
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
                        child: const Text('Registrarse'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Botón de login
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: const Text(
                      '¿Ya tienes cuenta?',
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