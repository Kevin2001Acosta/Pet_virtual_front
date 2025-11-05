import 'package:flutter/material.dart';
import 'package:yes_no_app/infrastructure/models/bienestar_model.dart';

class RecomendacionesWidget extends StatelessWidget {
  final List<Recomendacion>? recomendaciones;

  const RecomendacionesWidget({
    super.key,
    this.recomendaciones,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    final titleFontSize = isTablet ? 20.0 : (isLandscape ? 14.0 : 17.0);
    final textFontSize = isTablet ? 16.0 : (isLandscape ? 12.0 : 14.0);
    final padding = isTablet ? 20.0 : (isLandscape ? 12.0 : 16.0);
    final borderRadius = isTablet ? 20.0 : 16.0;

    // Recomendaciones por defecto
    final items = recomendaciones ??
        [
          Recomendacion(
            emoji: '✨',
            texto: 'Continúa registrando tus emociones diariamente',
          ),
          Recomendacion(
            emoji: '🧘',
            texto: 'Practica 5 minutos de respiración consciente',
          ),
          Recomendacion(
            emoji: '💪',
            texto: 'Comparte tus logros con amigos cercanos',
          ),
        ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: const Color(0xFF0EA5E9).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_rounded,
                color: Color(0xFF0EA5E9),
                size: 24,
              ),
              SizedBox(width: isTablet ? 10 : 8),
              Text(
                'Recomendaciones para ti',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0EA5E9),
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 14 : 12),
          
          // Lista de recomendaciones
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final recomendacion = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index < items.length - 1 ? (isTablet ? 10 : 8) : 0,
              ),
              child: _buildRecomendacion(
                recomendacion.emoji,
                recomendacion.texto,
                textFontSize,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecomendacion(String emoji, String texto, double fontSize) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}