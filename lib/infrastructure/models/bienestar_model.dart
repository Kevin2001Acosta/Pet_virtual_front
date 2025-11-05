import 'package:flutter/material.dart';

enum EstadoSemaforo { verde, amarillo, rojo }

extension EstadoSemaforoExtension on EstadoSemaforo {
  static EstadoSemaforo fromString(String value) {
    switch (value.toLowerCase()) {
      case 'verde':
        return EstadoSemaforo.verde;
      case 'amarillo':
        return EstadoSemaforo.amarillo;
      case 'rojo':
        return EstadoSemaforo.rojo;
      default:
        return EstadoSemaforo.amarillo;
    }
  }

  String get stringValue {
    switch (this) {
      case EstadoSemaforo.verde:
        return 'verde';
      case EstadoSemaforo.amarillo:
        return 'amarillo';
      case EstadoSemaforo.rojo:
        return 'rojo';
    }
  }
}

class Emocion {
  final String emoji;
  final String nombre;
  final int porcentaje;

  Emocion({
    required this.emoji,
    required this.nombre,
    required this.porcentaje,
  });

  factory Emocion.fromJson(Map<String, dynamic> json) {
    return Emocion(
      emoji: json['emoji'] as String,
      nombre: json['nombre'] as String,
      porcentaje: json['porcentaje'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'emoji': emoji,
      'nombre': nombre,
      'porcentaje': porcentaje,
    };
  }
}

// ========== MODELO DE DATOS PARA LA GRÁFICA ==========
class DatoGrafica {
  final int dia; // 0 = Lunes, 6 = Domingo
  final double valor; // 1.0 a 5.0 (estado emocional)
  final String? nota; // Nota opcional del día

  DatoGrafica({
    required this.dia,
    required this.valor,
    this.nota,
  });

  factory DatoGrafica.fromJson(Map<String, dynamic> json) {
    return DatoGrafica(
      dia: json['dia'] as int,
      valor: (json['valor'] as num).toDouble(),
      nota: json['nota'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dia': dia,
      'valor': valor,
      if (nota != null) 'nota': nota,
    };
  }
}

// Esta del semaforo info
class EstadoSemaforoInfo {
  final EstadoSemaforo estado;
  final Color color;
  final String emoji;
  final String titulo;
  final String mensaje;

  EstadoSemaforoInfo({
    required this.estado,
    required this.color,
    required this.emoji,
    required this.titulo,
    required this.mensaje,
  });

  // Factory para obtener info según el estado
  static EstadoSemaforoInfo fromEstado(EstadoSemaforo estado) {
    switch (estado) {
      case EstadoSemaforo.verde:
        return EstadoSemaforoInfo(
          estado: estado,
          color: const Color(0xFF4CAF50),
          emoji: '😊',
          titulo: '¡Excelente estado emocional!',
          mensaje: 'Tu bienestar está en un nivel óptimo. ¡Sigue así!',
        );
      case EstadoSemaforo.amarillo:
        return EstadoSemaforoInfo(
          estado: estado,
          color: const Color(0xFFFFC107),
          emoji: '😌',
          titulo: 'Estado emocional moderado',
          mensaje: 'Es normal sentirse así. Considera tomar un descanso.',
        );
      case EstadoSemaforo.rojo:
        return EstadoSemaforoInfo(
          estado: estado,
          color: const Color(0xFFF44336),
          emoji: '😔',
          titulo: 'Necesitas apoyo',
          mensaje: 'Tus emociones indican que podrías necesitar ayuda profesional.',
        );
    }
  }
}


class Recomendacion {
  final String emoji;
  final String texto;
  final String? accion; 
  Recomendacion({
    required this.emoji,
    required this.texto,
    this.accion,
  });

  factory Recomendacion.fromJson(Map<String, dynamic> json) {
    return Recomendacion(
      emoji: json['emoji'] as String,
      texto: json['texto'] as String,
      accion: json['accion'] as String?,
    );
  }
}