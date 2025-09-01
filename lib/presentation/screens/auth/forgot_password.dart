import 'package:flutter/material.dart';
class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}
class _ForgotScreenState extends State<ForgotScreen> { 

   final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
              child: Column (
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  
                  const Icon(Icons.lock,
                   color: Color.fromARGB(255, 229, 47, 47),
                   size: 100,
                   ),
                  const SizedBox(height: 10),
                  
                //Titulo
                Text(
                  'Recuperar Contraseña',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600, 
                    fontSize: 38, 
                    color: const Color.fromARGB(255, 0, 0, 0),
                    letterSpacing: 1.0,
                    height: 1.2, 
                    shadows: [
                      Shadow(
                        blurRadius: 2.0,
                        color: Color.fromARGB(255, 250, 250, 250).withOpacity(0.8),
                        offset: const Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                const Text(
                  'Ingresa tu correo electrónico para restablecer tu acceso',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20, 
                    color: const Color.fromARGB(255, 0, 0, 0),
                    letterSpacing: 1.0,
                    height: 1.2, 
                    
                  ),
                ),
                const SizedBox(height: 40),


                // Campos de texto
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
                const SizedBox(height: 30),

                // Botón de Recuperar
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
                      child: const Text('ENVIAR CÓDIGO'),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        ],
    ),
   );
 }
}