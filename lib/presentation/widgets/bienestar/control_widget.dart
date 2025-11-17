import 'package:flutter/material.dart';

class NavigationControlsWidget extends StatelessWidget {
  final DateTime fechaInicioSemana;
  final bool puedeAnterior;
  final bool puedeSiguiente;
  final bool cargando;
  final VoidCallback onAnterior;
  final VoidCallback onSiguiente;
  final VoidCallback onHoy;

  const NavigationControlsWidget({
    Key? key,
    required this.fechaInicioSemana,
    required this.puedeAnterior,
    required this.puedeSiguiente,
    required this.cargando,
    required this.onAnterior,
    required this.onSiguiente,
    required this.onHoy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón semana anterior
          IconButton(
            icon: cargando 
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFF35449),
                    ),
                  )
                : Icon(Icons.chevron_left,
                    color: puedeAnterior ? Color(0xFFF35449) : Colors.grey[400]),
            onPressed: puedeAnterior && !cargando ? onAnterior : null,
            tooltip: 'Semana anterior',
          ),

          // Fecha actual y botón "Hoy"
          Expanded(
            child: Column(
              children: [
                Text(
                  _formatearRangoSemana(fechaInicioSemana),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                if (!cargando)
                  GestureDetector(
                    onTap: onHoy,
                    child: Text(
                      'Hoy',
                      style: TextStyle(
                        color: Color(0xFFF35449),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Botón semana siguiente
          IconButton(
            icon: cargando
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFFF35449),
                    ),
                  )
                : Icon(Icons.chevron_right,
                    color: puedeSiguiente ? Color(0xFFF35449) : Colors.grey[400]),
            onPressed: puedeSiguiente && !cargando ? onSiguiente : null,
            tooltip: 'Semana siguiente',
          ),
        ],
      ),
    );
  }

  String _formatearRangoSemana(DateTime fechaInicio) {
    final fechaFin = fechaInicio.add(const Duration(days: 6));
    
    if (fechaInicio.month == fechaFin.month) {
      return '${fechaInicio.day} - ${fechaFin.day} ${_nombreMes(fechaInicio.month)} ${fechaInicio.year}';
    } else {
      return '${fechaInicio.day} ${_nombreMes(fechaInicio.month)} - ${fechaFin.day} ${_nombreMes(fechaFin.month)} ${fechaInicio.year}';
    }
  }

  String _nombreMes(int mes) {
    const meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    return meses[mes - 1];
  }
}