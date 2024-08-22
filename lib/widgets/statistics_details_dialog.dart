import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/models/models.dart';
import '../utils/constants.dart';

void showStatisticsDetailsDialog(
    BuildContext context, EstadisticasJugador estadisticas) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: primaryColorOrange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.all(16.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Torneo ${estadisticas.torneo}',
                style: GoogleFonts.mulish(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                estadisticas.equipo,
                style: GoogleFonts.mulish(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
              },
              border: TableBorder.symmetric(
                inside: const BorderSide(width: 0.5, color: Colors.grey),
              ),
              children: [
                _buildTableRow('Minutos Jugados', estadisticas.minutos),
                _buildTableRow('Goles', estadisticas.goles),
                _buildTableRow('Goles Penal', estadisticas.golesPenal),
                _buildTableRow('Autogoles', estadisticas.autogoles),
                _buildTableRow('Asistencias', estadisticas.asistencias),
                _buildTableRow('Lesiones', estadisticas.lesiones),
                _buildTableRow('Tarjetas Rojas', estadisticas.tarjetasRojas),
                _buildTableRow(
                    'Tarjetas Amarillas', estadisticas.tarjetasAmarillas),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cerrar',
              style: GoogleFonts.mulish(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      );
    },
  );
}

TableRow _buildTableRow(String label, String value) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          label,
          style: GoogleFonts.mulish(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          value,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
