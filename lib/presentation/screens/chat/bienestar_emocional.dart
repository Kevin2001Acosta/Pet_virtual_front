import 'package:flutter/material.dart';

class BienestarEmocionalScreen extends StatelessWidget {
  const BienestarEmocionalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: _buildBody(context), 
    );
  }

  //  APP BAR 
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

  // CONTENIDO DEL APP BAR 
  Widget _buildAppBarContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Tamaños adaptativos
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
        // Avatar de mascota 
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
            errorBuilder: (context, error, stackTrace) => 
              Container(
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

  // INDICADOR DE PROGRESO
  Widget _buildProgressIndicator(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Tamaños adaptativos
    final iconSize = isTablet ? 20.0 : (isLandscape ? 14.0 : 16.0);
    final fontSize = isTablet ? 18.0 : (isLandscape ? 12.0 : 14.0);
    final horizontalPadding = isTablet ? 16.0 : (isLandscape ? 8.0 : 12.0);
    final verticalPadding = isTablet ? 12.0 : (isLandscape ? 6.0 : 8.0);
    final spacing = isTablet ? 6.0 : (isLandscape ? 3.0 : 4.0);
    final margin = isTablet ? 20.0 : (isLandscape ? 12.0 : 16.0);
    
  return Container(
      margin: EdgeInsets.only(right: margin),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(isTablet ? 25 : 20),
      border: Border.all(color: Colors.white.withOpacity(0.3)),
    ),
      child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
              Icon(Icons.trending_up, color: Colors.white, size: iconSize),
              SizedBox(width: spacing),
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
      ],
    ),
  );
}

  // UERPO PRINCIPAL 
  Widget _buildBody(BuildContext context) {
    final emociones = _getEmocionesData();
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Límite de ancho para tablets/desktop
    final maxWidth = isTablet ? 800.0 : screenWidth;
    
    // Padding adaptativo
    final padding = isTablet ? 24.0 : (isLandscape ? 12.0 : 20.0);
    final spacing = isTablet ? 32.0 : (isLandscape ? 20.0 : 28.0);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              _buildChartSection(context),
              SizedBox(height: spacing),
              _buildEmotionsSection(emociones, context),
            ],
          ),
        ),
      ),
    );
  }

  // SECCIÓN DE GRÁFICA RESPONSIVE
  Widget _buildChartSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Tamaños adaptativos
    final iconSize = isTablet ? 70.0 : (isLandscape ? 40.0 : 54.0);
    final titleFontSize = isTablet ? 22.0 : (isLandscape ? 15.0 : 17.0);
    final subtitleFontSize = isTablet ? 18.0 : (isLandscape ? 12.0 : 14.0);
    final padding = isTablet ? 32.0 : (isLandscape ? 16.0 : 24.0);
    final spacing1 = isTablet ? 20.0 : (isLandscape ? 12.0 : 16.0);
    final spacing2 = isTablet ? 8.0 : (isLandscape ? 4.0 : 6.0);
    final borderRadius = isTablet ? 25.0 : 20.0;
    final borderWidth = isTablet ? 2.0 : 1.5;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFF35449).withOpacity(0.08),
            const Color(0xFFF35449).withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.grey.shade200, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: isTablet ? 15 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insights_rounded,
            size: iconSize,
            color: const Color(0xFFF35449),
          ),
          SizedBox(height: spacing1),
          Text(
            'Tu estado emocional esta semana',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF35449),
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: spacing2),
          Text(
            'Gráfica de progreso emocional',
            style: TextStyle(
              fontSize: subtitleFontSize,
              color: Colors.grey,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // SECCIÓN DE EMOCIONES 
  Widget _buildEmotionsSection(List<Map<String, dynamic>> emociones, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Tamaños adaptativos
    final titleFontSize = isTablet ? 24.0 : (isLandscape ? 16.0 : 19.0);
    final spacing = isTablet ? 24.0 : (isLandscape ? 12.0 : 18.0);
    final padding = isTablet ? 6.0 : 4.0;
    
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: padding),
            child: Text(
              '💬 Emociones más frecuentes',
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFF35449),
                height: 1.2,
              ),
            ),
          ),
          SizedBox(height: spacing),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                ...emociones.map((emocion) => _buildEmotionItem(emocion, context)),
                SizedBox(height: isTablet ? 12 : 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ITEM DE EMOCIÓN 
  Widget _buildEmotionItem(Map<String, dynamic> emocion, BuildContext context) {
    final porcentaje = emocion['porcentaje'] as int;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Tamaños adaptativos
    final emojiSize = isTablet ? 50.0 : (isLandscape ? 35.0 : 40.0);
    final emojiFontSize = isTablet ? 24.0 : (isLandscape ? 16.0 : 18.0);
    final textFontSize = isTablet ? 20.0 : (isLandscape ? 14.0 : 16.0);
    final percentageFontSize = isTablet ? 20.0 : (isLandscape ? 14.0 : 16.0);
    final horizontalPadding = isTablet ? 18.0 : (isLandscape ? 10.0 : 14.0);
    final verticalPadding = isTablet ? 16.0 : (isLandscape ? 8.0 : 12.0);
    final spacing = isTablet ? 18.0 : (isLandscape ? 10.0 : 14.0);
    final margin = isTablet ? 14.0 : (isLandscape ? 6.0 : 10.0);
    final borderRadius = isTablet ? 20.0 : 16.0;
    final borderWidth = isTablet ? 2.0 : 1.5;
    
    return Container(
      margin: EdgeInsets.only(bottom: margin),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F8),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: const Color(0xFFF35449).withOpacity(0.15),
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: isTablet ? 8 : 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: emojiSize,
            height: emojiSize,
            decoration: BoxDecoration(
              color: const Color(0xFFF35449).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                emocion['emoji'] as String,
                style: TextStyle(fontSize: emojiFontSize),
              ),
            ),
          ),
          SizedBox(width: spacing),
          Expanded(
            child: Text(
              emocion['nombre'] as String,
              style: TextStyle(
                fontSize: textFontSize,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF333333),
                height: 1.3,
              ),
            ),
          ),
          Text(
            "$porcentaje%",
            style: TextStyle(
              fontSize: percentageFontSize,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFF35449),
            ),
          ),
        ],
      ),
    );
  }

  // DATOS DE EMOCIONES
  List<Map<String, dynamic>> _getEmocionesData() {
    return [
      {'emoji': '😊', 'nombre': 'Alegría', 'porcentaje': 35},
      {'emoji': '😌', 'nombre': 'Calma', 'porcentaje': 25},
      {'emoji': '💕', 'nombre': 'Gratitud', 'porcentaje': 18},
      {'emoji': '🤔', 'nombre': 'Reflexión', 'porcentaje': 12},
    ];
  }
}