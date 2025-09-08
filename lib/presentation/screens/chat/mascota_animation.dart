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

  final String _nombreMaquinaEstado = "Emociones";

  
  SMIBool? _felizInput;
  SMIBool? _sorprendidoInput;
  SMIBool? _neutroInput;

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
      print('🔄 Cargando archivo Rive...');

      final bytes = await rootBundle.load('assets/rive/gatiardilla.riv');
      final file = RiveFile.import(bytes);
      
      print('🎨 Artboards disponibles:');
      final artboard = file.artboardByName(_nombreMaquinaEstado) ?? file.mainArtboard;
      
      if (artboard != null) {
        _controller = StateMachineController.fromArtboard(
          artboard,
          _nombreMaquinaEstado,
        );

        if (_controller != null) {
          artboard.addController(_controller!);
         
          for (final input in _controller!.inputs) {
            if (input is SMIBool) {
              switch (input.name) {
                case 'Feliz':
                  _felizInput = input;
                  break;
                case 'Sorprendido':
                  _sorprendidoInput = input;
                  break;
                case 'Neutro':
                  _neutroInput = input;
                  break;
              }
            }
          }
          _setNeutro();
        }

        setState(() {
          _mascotaArtboard = artboard;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading Rive file: $e');
      setState(() => _isLoading = false);
    }
  }


  void _setFeliz() {
    _felizInput?.value = true;
    _sorprendidoInput?.value = false;
    _neutroInput?.value = false;
  }

  void _setSorprendido() {
    _felizInput?.value = false;
    _sorprendidoInput?.value = true;
    _neutroInput?.value = false;
  }

  void _setNeutro() {
    _felizInput?.value = false;
    _sorprendidoInput?.value = false;
    _neutroInput?.value = true;
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
      _setNeutro();
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

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: _mascotaArtboard != null
          ? Rive(
              artboard: _mascotaArtboard!,
              //fit: BoxFit.contain,
              fit: BoxFit.cover,
              alignment: Alignment.center,
            )
          : const Icon(Icons.error, color: Color.fromARGB(255, 247, 12, 4)),
    );
  }
}