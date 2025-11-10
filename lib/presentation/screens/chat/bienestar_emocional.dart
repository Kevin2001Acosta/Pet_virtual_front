import 'package:flutter/material.dart';
import 'package:yes_no_app/presentation/widgets/bienestar/semaforo_widget.dart';
import 'package:yes_no_app/config/helpers/bienestar_service.dart'; 
import 'package:yes_no_app/presentation/widgets/bienestar/grafica_emocional_widget.dart';
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
  bool _cargandoSemaforo = true;
  bool _cargandoGrafica = true;
  final bienestarService = BienestarService();
  List<DatoGrafica>? _datosSemanales;

  @override
  void initState() {
    super.initState();
    _cargarTodo();
  }

  Future<void> _cargarTodo() async {
    setState(() {
      _cargando = true;
      _cargandoSemaforo = true;
      _cargandoGrafica = true;
    });
    
    await Future.wait([
      _cargarEstadoEmocional(),
      _cargarDatosSemanales(),
    ]);
  }
  
  Future<void> _cargarDatosSemanales() async {
    try {
      final token = await _obtenerToken();
      if (token != null) {
        final now = DateTime.now();
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(Duration(days: 6));
        
        final startDate = '${startOfWeek.year}-${startOfWeek.month.toString().padLeft(2, '0')}-${startOfWeek.day.toString().padLeft(2, '0')}';
        final endDate = '${endOfWeek.year}-${endOfWeek.month.toString().padLeft(2, '0')}-${endOfWeek.day.toString().padLeft(2, '0')}';
        
        print('📅 Consultando niveles emocionales del $startDate al $endDate');
        
        final weekData = await bienestarService.obtenerNivelesSemanales(
          token: token,
          startDate: startDate,
          endDate: endDate,
        );
        
        setState(() {
          _datosSemanales = weekData.toDatosGrafica();
          _cargandoGrafica = false;
          _actualizarEstadoCarga();
        });
        
        print('✅ Datos cargados para la gráfica: ${_datosSemanales?.length} días');
      } else {
        setState(() {
          _cargandoGrafica = false;
          _actualizarEstadoCarga();
        });
      }
    } catch (e) {
      print('❌ Error cargando datos semanales: $e');
      setState(() {
        _cargandoGrafica = false;
        _actualizarEstadoCarga();
      });
    }
  }

  Future<void> _cargarEstadoEmocional() async {
    try {
      final token = await _obtenerToken();
      print('🔑 Token: ${token != null ? "OK" : "NULL"}');
      
      if (token != null) {
        final estado = await bienestarService.obtenerEstadoSemaforoSeguro(token);
        print('🚦 Estado recibido: $estado');
        
        setState(() {
          _estadoActual = estado ?? EstadoSemaforo.verde;
          _cargandoSemaforo = false;
          _actualizarEstadoCarga();
        });
      } else {
        print('⚠️ No hay token disponible');
        setState(() {
          _estadoActual = EstadoSemaforo.verde; 
          _cargandoSemaforo = false;
          _actualizarEstadoCarga();
        });
      }
    } catch (e) {
      print('❌ Error: $e');
      setState(() {
        _estadoActual = EstadoSemaforo.verde; 
        _cargandoSemaforo = false;
        _actualizarEstadoCarga();
      });
    }
  }

  void _actualizarEstadoCarga() {
    if (!_cargandoSemaforo && !_cargandoGrafica) {
      setState(() {
        _cargando = false;
      });
    }
  }

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
    print('🔄 Estado: $_estadoActual, Cargando: $_cargando');
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: const Color(0xFFF35449),
        onPressed: () {
          _cargarTodo();
        },
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
      title: _buildAppBarContent(context),
      centerTitle: true,
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
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
      ],
    );
  }

  // ========== CUERPO PRINCIPAL ==========
  Widget _buildBody(BuildContext context) {
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
                else ...[
                  //  SEMÁFORO EMOCIONAL
                  _buildSectionTitle(
                    icon: Icons.traffic,
                    title: 'Estado Emocional Actual',
                    isTablet: isTablet,
                    isLandscape: isLandscape,
                  ),
                  SizedBox(height: spacing * 0.5),
                  SemaforoWidget(
                    estadoActual: _estadoActual ?? EstadoSemaforo.verde,
                    showAnimation: true,
                  ),
                  
                  SizedBox(height: spacing * 1.5),

                  //  GRÁFICA DE EVOLUCIÓN
                  _buildSectionTitle(
                    icon: Icons.show_chart,
                    title: 'Evolución Semanal',
                    isTablet: isTablet,
                    isLandscape: isLandscape,
                  ),
                  SizedBox(height: spacing * 0.5),
                  GraficaEmocionalWidget(datos: _datosSemanales),
                  SizedBox(height: spacing),
                ],

                SizedBox(height: isTablet ? 24 : 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required bool isTablet,
    required bool isLandscape,
  }) {
    final fontSize = isTablet ? 20.0 : (isLandscape ? 16.0 : 18.0);
    final iconSize = isTablet ? 24.0 : (isLandscape ? 18.0 : 20.0);

    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFF35449),
          size: iconSize,
        ),
        const SizedBox(width: 18),
        Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}