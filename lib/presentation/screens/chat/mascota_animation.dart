import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class MascotaAnimation extends StatefulWidget {
  final bool isSpeaking;
  final double size;

  const MascotaAnimation({
    super.key,
    required this.isSpeaking,
    this.size = 200,
  });

  @override
  State<MascotaAnimation> createState() => _MascotaAnimationState();
}

class _MascotaAnimationState extends State<MascotaAnimation> {
  Artboard? _mascotaArtboard;
  StateMachineController? _controller;
  bool _isLoading = true;
  bool _hasError = false;

  final String _nombreArtboard = "Artboard"; 
  final String _nombreMaquinaEstado = "Emociones";

  SMIBool? _felizInput;
  SMIBool? _sorprendidoInput;
  SMIBool? _tristeInput;

  @override
  void initState() {
    super.initState();
    _loadRiveFile();
  }

  @override
  void didUpdateWidget(covariant MascotaAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSpeaking != widget.isSpeaking) {
      _updateAnimation();
    }
  }

  Future<void> _loadRiveFile() async {
    try {
      print("Cargando archivo Rive...");
      final bytes = await rootBundle.load('assets/rive/mascota.riv');
      final file = RiveFile.import(bytes);
      final artboard = file.artboardByName(_nombreArtboard) ?? file.mainArtboard;

      if (artboard == null) {
        print("⚠️ No se encontró el artboard $_nombreArtboard");
        _setError();
        return;
      }

      print("✅ Artboard encontrado: ${artboard.name}");

      _controller = StateMachineController.fromArtboard(
        artboard,
        _nombreMaquinaEstado,
      );

      if (_controller != null) {
        artboard.addController(_controller!);

        print("✅ Controlador cargado. Inputs encontrados:");
        for (final input in _controller!.inputs) {
          print("   - ${input.name} (${input.runtimeType})");
          if (input is SMIBool) {
            switch (input.name) {
              case 'Feliz':
                _felizInput = input;
                break;
              case 'Sorprendido':
                _sorprendidoInput = input;
                break;
              case 'Triste':
                _tristeInput = input;
                break;
            }
          }
        }
        _setRespirar(); 
      } else {
        print("⚠️ No se encontró la máquina de estados $_nombreMaquinaEstado");
      }

      setState(() {
        _mascotaArtboard = artboard;
        _isLoading = false;
      });

    } catch (e) {
      print("❌ Error cargando Rive: $e");
      _setError();
    }
  }

  void _setError() {
    setState(() {
      _isLoading = false;
      _hasError = true;
    });
  }

  void _setFeliz() {
    print("😃 Activando estado: Feliz");
    _felizInput?.value = true;
    _sorprendidoInput?.value = false;
    _tristeInput?.value = false;
  }

  void _setSorprendido() {
    print("😮 Activando estado: Sorprendido");
    _felizInput?.value = false;
    _sorprendidoInput?.value = true;
    _tristeInput?.value = false;
  }

  void _setTriste() {
    print("😢 Activando estado: Triste");
    _felizInput?.value = false;
    _sorprendidoInput?.value = false;
    _tristeInput?.value = true;
  }

  void _setRespirar() {
    print("🌬 Volviendo al estado base: Respirar");
    _felizInput?.value = false;
    _sorprendidoInput?.value = false;
    _tristeInput?.value = false;
  }

  void _updateAnimation() {
    if (widget.isSpeaking) {
      final random = DateTime.now().millisecond % 2;
      if (random == 0) {
        _setFeliz();
      } else {
        _setSorprendido();
      }
    } else {
      _setRespirar();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const CircularProgressIndicator(),
      );
    }

    if (_hasError || _mascotaArtboard == null) {
      return _buildErrorWidget();
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Rive(
        artboard: _mascotaArtboard!,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 40),
            SizedBox(height: 8),
            Text('Error loading animation', 
                 style: TextStyle(color: Colors.red, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
