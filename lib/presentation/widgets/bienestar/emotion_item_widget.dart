import 'package:flutter/material.dart';
import 'package:yes_no_app/infrastructure/models/bienestar_model.dart';


class EmotionItemWidget extends StatelessWidget {
  final Emocion emocion;
  final VoidCallback? onTap;

  const EmotionItemWidget({
    super.key,
    required this.emocion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    final emojiSize = isTablet ? 50.0 : (isLandscape ? 35.0 : 40.0);
    final emojiFontSize = isTablet ? 24.0 : (isLandscape ? 16.0 : 18.0);
    final textFontSize = isTablet ? 18.0 : (isLandscape ? 13.0 : 15.0);
    final percentageFontSize = isTablet ? 18.0 : (isLandscape ? 13.0 : 15.0);
    final margin = isTablet ? 12.0 : (isLandscape ? 6.0 : 8.0);
    final borderRadius = isTablet ? 18.0 : 14.0;
    final spacing = isTablet ? 16.0 : (isLandscape ? 10.0 : 12.0);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: margin),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 18.0 : (isLandscape ? 10.0 : 14.0),
          vertical: isTablet ? 14.0 : (isLandscape ? 8.0 : 11.0),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8F8),
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: const Color(0xFFF35449).withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Contenedor del emoji
            Container(
              width: emojiSize,
              height: emojiSize,
              decoration: BoxDecoration(
                color: const Color(0xFFF35449).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  emocion.emoji,
                  style: TextStyle(fontSize: emojiFontSize),
                ),
              ),
            ),
            SizedBox(width: spacing),
            
            // Nombre y barra de progreso
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    emocion.nombre,
                    style: TextStyle(
                      fontSize: textFontSize,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: emocion.porcentaje / 100,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFF35449),
                      ),
                      minHeight: isTablet ? 8 : 6,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: spacing),
            
            // Porcentaje
            Text(
              "${emocion.porcentaje}%",
              style: TextStyle(
                fontSize: percentageFontSize,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFF35449),
              ),
            ),
          ],
        ),
      ),
    );
  }
}