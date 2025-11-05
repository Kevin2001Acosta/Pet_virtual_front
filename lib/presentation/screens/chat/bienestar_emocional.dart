import 'package:flutter/material.dart';
import 'package:yes_no_app/presentation/widgets/bienestar/semaforo_widget.dart';
import 'package:yes_no_app/config/helpers/bienestar_service.dart'; 
import 'package:yes_no_app/presentation/widgets/bienestar/grafica_emocional_widget.dart';
import 'package:yes_no_app/presentation/widgets/bienestar/emotion_item_widget.dart';
import 'package:yes_no_app/infrastructure/models/bienestar_model.dart';
import 'package:yes_no_app/config/helpers/secureStorage_service.dart';

class BienestarEmocionalScreen extends StatefulWidget {
  const BienestarEmocionalScreen({super.key});

  @override
  State<BienestarEmocionalScreen> createState() => _BienestarEmocionalScreenState();
}

class _BienestarEmocionalScreenState extends State<BienestarEmocionalScreen> {
  EstadoSemaforo? _estadoActual;
  bool _cargando = true;
  final bienestarService = BienestarService();

  @override
  void initState() {
    super.initState();
    _cargarEstadoEmocional();
  }

  Future<void> _cargarEstadoEmocional() async {
    setState(() => _cargando = true);
    
    try {
      final token = await _obtenerToken();
      print(' Token: ${token != null ? "OK" : "NULL"}');
      
      if (token != null) {
        final estado = await bienestarService.obtenerEstadoSemaforoSeguro(token);
        print(' Estado recibido: $estado');
        
        setState(() {
          _estadoActual = estado ?? EstadoSemaforo.verde;
          _cargando = false;
        });
      } else {
        print(' No hay token disponible');
        setState(() {
          _estadoActual = EstadoSemaforo.verde; 
          _cargando = false;
        });
      }
    } catch (e) {
      print(' Error: $e');
      setState(() {
        _estadoActual = EstadoSemaforo.verde; 
        _cargando = false;
      });
    }
  }

  // Método para obtener token
  Future<String?> _obtenerToken() async {
    try {
      return await SecureStorageService.getToken();
    } catch (e) {
      print('Error obteniendo token: $e');
      return null;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    print(' Estado: $_estadoActual, Cargando: $_cargando');
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: const Color(0xFFF35449),
        onPressed: _cargarEstadoEmocional,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  // ========== APP BAR ==========
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final toolbarHeight = isLandscape ? 100.0 : (isTablet ? 160.0 : 140.0);

    return AppBar(
      backgroundColor: const Color(0xFFF35449),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.3),
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: isTablet ? 24.0 : (isLandscape ? 18.0 : 20.0),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 0),
        child: _buildAppBarContent(context),
      ),
      actions: [_buildProgressIndicator(context)],
    );
  }

  Widget _buildAppBarContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final avatarSize = isLandscape ? 60.0 : (isTablet ? 100.0 : 90.0);
    final titleFontSize = isTablet ? 26.0 : (isLandscape ? 18.0 : 22.0);
    final subtitleFontSize = isTablet ? 22.0 : (isLandscape ? 16.0 : 18.0);
    final spacing = isTablet ? 20.0 : (isLandscape ? 12.0 : 16.0);
    final borderWidth = isTablet ? 4.0 : 3.0;
    final iconSize = isTablet ? 80.0 : (isLandscape ? 40.0 : 60.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: isTablet ? 12 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 8 : 6),
            child: ClipOval(
              child: Image.asset(
                'assets/images/mascota.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.white.withOpacity(0.1),
                  child: Icon(
                    Icons.emoji_emotions,
                    color: Colors.white,
                    size: iconSize,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: spacing),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Tu bienestar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              SizedBox(height: isLandscape ? 1 : 2),
              Text(
                'importa 💖',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: subtitleFontSize,
                  color: Colors.white.withOpacity(0.95),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final iconSize = isTablet ? 20.0 : (isLandscape ? 14.0 : 16.0);
    final fontSize = isTablet ? 18.0 : (isLandscape ? 12.0 : 14.0);
    final margin = isTablet ? 20.0 : (isLandscape ? 12.0 : 16.0);

    return Container(
      margin: EdgeInsets.only(right: margin),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16.0 : (isLandscape ? 8.0 : 12.0),
        vertical: isTablet ? 12.0 : (isLandscape ? 6.0 : 8.0),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(isTablet ? 25 : 20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up, color: Colors.white, size: iconSize),
          SizedBox(width: isTablet ? 6.0 : (isLandscape ? 3.0 : 4.0)),
          Text(
            '+15%',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  // ========== CUERPO PRINCIPAL ==========
  Widget _buildBody(BuildContext context) {
    final emociones = [
      Emocion(emoji: '😊', nombre: 'Alegría', porcentaje: 35),
      Emocion(emoji: '😌', nombre: 'Calma', porcentaje: 25),
      Emocion(emoji: '💕', nombre: 'Gratitud', porcentaje: 18),
      Emocion(emoji: '🤔', nombre: 'Reflexión', porcentaje: 12),
      Emocion(emoji: '😰', nombre: 'Ansiedad', porcentaje: 10),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final maxWidth = isTablet ? 800.0 : screenWidth;
    final padding = isTablet ? 24.0 : (isLandscape ? 12.0 : 20.0);
    final spacing = isTablet ? 24.0 : (isLandscape ? 16.0 : 20.0);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_cargando)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(
                            color: Color(0xFFF35449),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Analizando tu estado emocional...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  // Mostrar semáforo con el estado cargado
                  SemaforoWidget(
                    estadoActual: _estadoActual ?? EstadoSemaforo.verde,
                    showAnimation: true,
                  ),
                
                SizedBox(height: spacing),

                // 📊 Gráfica de evolución
                const GraficaEmocionalWidget(),
                SizedBox(height: spacing),

                // 💬 Lista de emociones frecuentes
                _buildEmotionsSection(emociones, context),
                SizedBox(height: spacing),

                SizedBox(height: isTablet ? 24 : 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionsSection(List<Emocion> emociones, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    final titleFontSize = isTablet ? 20.0 : (isLandscape ? 14.0 : 17.0);
    final spacing = isTablet ? 18.0 : (isLandscape ? 10.0 : 14.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('💬', style: TextStyle(fontSize: 24)),
            SizedBox(width: isTablet ? 10 : 8),
            Text(
              'Emociones más frecuentes',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF35449),
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        ...emociones.map((emocion) => EmotionItemWidget(emocion: emocion)),
      ],
    );
  }
}