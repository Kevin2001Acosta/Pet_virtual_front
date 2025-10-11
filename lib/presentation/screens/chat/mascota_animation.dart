import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

// Emociones soportadas por la máquina de estados en Rive
enum Emotion { joy, surprise, sadness, disgust, anger, respirar }

Emotion parseEmotion(String value) {
  switch (value.toLowerCase()) {
      case 'joy':
      return Emotion.joy;
      case 'surprise':
      return Emotion.surprise;
      case 'sadness':
      return Emotion.sadness;
      case 'disgust':
      return Emotion.disgust;
      case 'anger':
      return Emotion.anger;
    default:
      return Emotion.respirar;
  }
}

class MascotaAnimation extends StatefulWidget {
  final bool isSpeaking;
  final double? size; 
  final String currentEmotion; 
  final double sizePercentage; 
  final double minSize; 
  final double maxSize; 

  const MascotaAnimation({
    super.key,
    required this.isSpeaking,
    this.size, 
    required this.currentEmotion,
    this.sizePercentage = 0.35, 
    this.minSize = 100.0,
    this.maxSize = 400.0, 
  });

  @override
  State<MascotaAnimation> createState() => _MascotaAnimationState();
}

class _MascotaAnimationState extends State<MascotaAnimation> {
  Artboard? _mascotaArtboard;
  StateMachineController? _controller;
  bool _isLoading = true;
  bool _hasError = false;

  // Constantes de configuración
  static const String _nombreArtboard = "Artboard"; 
  static const String _nombreMaquinaEstado = "Emociones";
  static const String _rutaAssetRive = 'assets/rive/animacion.riv';

  // Inputs
  SMIBool? _joyInput;        
  SMIBool? _surpriseInput;   
  SMIBool? _sadnessInput;    
  SMIBool? _disgustInput;   
  SMIBool? _angerInput;      

  @override
  void initState() {
    super.initState();
    _initializeRive();
  }

  @override
  void didUpdateWidget(covariant MascotaAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentEmotion != widget.currentEmotion) {
      debugPrint(" Emoción cambiada: ${oldWidget.currentEmotion} → ${widget.currentEmotion}");
      _setEmotionFromString(widget.currentEmotion);
    }
  
    if (oldWidget.isSpeaking != widget.isSpeaking) {
      _updateAnimation();
    }
  }

  void _setEmotionFromString(String emotion) {
    debugPrint(" Aplicando emoción desde widget: $emotion");
    _applyEmotion(parseEmotion(emotion));
  }

  void _applyEmotion(Emotion emotion) {
    switch (emotion) {
      case Emotion.joy:
        _setJoy();
        return;
      case Emotion.surprise:
        _setSurprise();
        return;
      case Emotion.sadness:
        _setSadness();
        return;
      case Emotion.disgust:
        _setDisgust();
        return;
      case Emotion.anger:
        _setAnger();
        return;
      case Emotion.respirar:
        _setRespirar();
        return;
    }
  }

  Future<void> _initializeRive() async {
    await RiveFile.initialize(); 
    _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    try {
      debugPrint("Cargando archivo Rive....");
      final bytes = await rootBundle.load(_rutaAssetRive);
      final file = RiveFile.import(bytes);
      final artboard = file.artboardByName(_nombreArtboard) ?? file.mainArtboard;

      if (artboard == null) {
        debugPrint(" No se encontró el artboard $_nombreArtboard");
        _setError();
        return;
      }

      debugPrint(" Artboard encontrado: ${artboard.name}");

      _controller = StateMachineController.fromArtboard(
        artboard,
        _nombreMaquinaEstado,
      );

      if (_controller != null) {
        artboard.addController(_controller!);

        debugPrint(" Controlador cargado. Inputs encontrados:");
        for (final input in _controller!.inputs) {
          debugPrint("   - ${input.name} (${input.runtimeType})");
          if (input is SMIBool) {
            switch (input.name) {
              case 'Joy':        
                _joyInput = input;
                debugPrint("    Joy encontrado");
                break;
              case 'Surprise':  
                _surpriseInput = input;
                debugPrint("   Surprise encontrado");
                break;
              case 'Sadness':   
                _sadnessInput = input;
                debugPrint("   Sadness encontrado");
                break;
              case 'Disgust':   
                _disgustInput = input;
                debugPrint("   Disgust encontrado");
                break;
              case 'Anger':    
                _angerInput = input;
                debugPrint("   Anger encontrado");
                break;
            }
          }
        }

        assert(
          _joyInput != null &&
              _surpriseInput != null &&
              _sadnessInput != null &&
              _disgustInput != null &&
              _angerInput != null,
          'Faltan inputs de la StateMachine en Rive. Verifica los nombres de las entradas.'
        );
        
        // APLICAR LA EMOCIÓN INICIAL
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _setEmotionFromString(widget.currentEmotion);
          }
        });
        
      } else {
        debugPrint("No se encontró la máquina de estados $_nombreMaquinaEstado");
      }

      setState(() {
        _mascotaArtboard = artboard;
        _isLoading = false;
      });

    } catch (e) {
      debugPrint(" Error cargando Rive: $e");
      _setError();
    }
  }

  void _setError() {
    setState(() {
      _isLoading = false;
      _hasError = true;
    });
  }

  // MÉTODOS DE EMOCIONES
  void _setJoy() {
    debugPrint(" Activando estado: Joy");
    _resetAllEmotions();
    _joyInput?.value = true;
  }

  void _setSurprise() {
    debugPrint(" Activando estado: Surprise");
    _resetAllEmotions();
    _surpriseInput?.value = true;
  }

  void _setSadness() {
    debugPrint(" Activando estado: Sadness");
    _resetAllEmotions();
    _sadnessInput?.value = true;
  }

  void _setRespirar() {
    debugPrint(" Activando estado: Respirar");
    _resetAllEmotions();
  }

  void _setDisgust() {
    debugPrint(" Activando estado: Disgust");
    _resetAllEmotions();
    _disgustInput?.value = true;
  }

  void _setAnger() {
    debugPrint(" Activando estado: Anger");
    _resetAllEmotions();
    _angerInput?.value = true;
  }

  void _resetAllEmotions() {
    _joyInput?.value = false;
    _surpriseInput?.value = false;
    _sadnessInput?.value = false;
    _disgustInput?.value = false;
    _angerInput?.value = false;
  }

  void _updateAnimation() {
    if (widget.isSpeaking) {
      _setRespirar();
    } else {
      _setEmotionFromString(widget.currentEmotion);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  
  double _getResponsiveSize(BuildContext context) {
  
    if (widget.size != null) {
      return widget.size!;
    }

    
    final screenWidth = MediaQuery.of(context).size.width;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    
    
    double percentage = widget.sizePercentage;
    if (isPortrait) {
      percentage = (widget.sizePercentage * 1.3).clamp(0.25, 0.6); 
    }
    
    final calculatedSize = screenWidth * percentage;
    
    
    return calculatedSize.clamp(widget.minSize, widget.maxSize);
  }

  @override
  Widget build(BuildContext context) {
    final size = _getResponsiveSize(context);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final finalSize = size.clamp(0.0, constraints.maxWidth).clamp(0.0, constraints.maxHeight);
        
    if (_isLoading) {
      return SizedBox(
            width: finalSize,
            height: finalSize,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
      );
    }

    if (_hasError || _mascotaArtboard == null) {
          return _buildErrorWidget(finalSize);
    }

    return SizedBox(
          width: finalSize,
          height: finalSize,
          child: RepaintBoundary(
      child: Rive(
        artboard: _mascotaArtboard!,
        fit: BoxFit.contain,
      ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(double size) {
    final iconSize = (size * 0.2).clamp(24.0, 60.0);
    final fontSize = (size * 0.06).clamp(10.0, 16.0);
    final borderRadius = (size * 0.06).clamp(8.0, 16.0);
    
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: iconSize),
            SizedBox(height: size * 0.04),
            Text(
              'Error al cargar la animación', 
              style: TextStyle(
                color: Colors.red, 
                fontSize: fontSize,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: size * 0.04),
            TextButton(
              onPressed: _loadRiveFile, 
              child: Text(
                'Reintentar',
                style: TextStyle(fontSize: fontSize * 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

