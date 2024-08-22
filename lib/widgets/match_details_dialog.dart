import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../controller/models/models.dart';

class MatchDetailsDialog extends StatelessWidget {
  final String equipoLocal;
  final String equipoVisitante;
  final String golesLocal;
  final String golesVisitante;
  final String estado;
  final String escudoLocal;
  final String escudoVisitante;
  final String defaultLogo;
  final List<Detalle> detalles;

  const MatchDetailsDialog({
    super.key,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.golesLocal,
    required this.golesVisitante,
    required this.estado,
    required this.escudoLocal,
    required this.escudoVisitante,
    required this.defaultLogo,
    required this.detalles,
  });

  @override
  Widget build(BuildContext context) {
    const double padding = 16.0;
    const double fontSize = 14.0;
    const double titleFontSize = 20.0;

    final double screenWidth = MediaQuery.of(context).size.width;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Detalles del Partido',
                style: GoogleFonts.mulish(
                  textStyle: const TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: padding),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTeamColumn(equipoLocal, escudoLocal, defaultLogo),
                Column(
                  children: [
                    Text(
                      '$golesLocal - $golesVisitante',
                      style: GoogleFonts.mulish(
                        textStyle: const TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      estado,
                      style: GoogleFonts.mulish(
                        textStyle: TextStyle(
                          fontSize: fontSize,
                          color: _getEstadoColor(estado),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                _buildTeamColumn(equipoVisitante, escudoVisitante, defaultLogo),
              ],
            ),
            const SizedBox(height: padding),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.9,
              ),
              child: Column(
                children: detalles.map((detalle) {
                  bool isLocal = detalle.tipo == 'local';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: padding / 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLocal) ...[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${detalle.minuto}\' ${detalle.titulo}',
                                  style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                  textAlign: TextAlign.end,
                                ),
                                Text(
                                  detalle.jugador,
                                  style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                  textAlign: TextAlign.end,
                                ),
                                if (detalle.complemento != null &&
                                    detalle.complemento!.isNotEmpty)
                                  Text(
                                    detalle.complemento!,
                                    style: GoogleFonts.mulish(
                                      textStyle: const TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                    textAlign: TextAlign.end,
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: padding),
                          _buildIcon(detalle),
                          const SizedBox(width: padding),
                          const Expanded(flex: 1, child: SizedBox()),
                        ],
                        if (!isLocal) ...[
                          const Expanded(flex: 1, child: SizedBox()),
                          const SizedBox(width: padding),
                          _buildIcon(detalle),
                          const SizedBox(width: padding),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${detalle.minuto}\' ${detalle.titulo}',
                                  style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                                Text(
                                  detalle.jugador,
                                  style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(
                                      fontSize: fontSize,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                ),
                                if (detalle.complemento != null &&
                                    detalle.complemento!.isNotEmpty)
                                  Text(
                                    detalle.complemento!,
                                    style: GoogleFonts.mulish(
                                      textStyle: const TextStyle(
                                        fontSize: fontSize,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    overflow: TextOverflow.visible,
                                    softWrap: true,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: padding),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cerrar',
                  style: GoogleFonts.mulish(
                    textStyle: const TextStyle(
                      fontSize: fontSize,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'victoria':
        return const Color.fromARGB(255, 60, 107, 55);
      case 'derrota':
        return const Color.fromARGB(255, 194, 70, 51);
      case 'empate':
        return const Color.fromARGB(255, 162, 141, 65);
      case 'cancelado':
        return const Color.fromARGB(255, 21, 62, 164);
      default:
        return Colors.black;
    }
  }

  Widget _buildIcon(Detalle detalle) {
    IconData iconData;
    Color iconColor = Colors.white;

    switch (detalle.titulo.toLowerCase()) {
      case 'lesion':
        iconData = FontAwesomeIcons.kitMedical;
        iconColor = Colors.green;
        break;
      case 'tarjeta amarilla':
        iconData = FontAwesomeIcons.solidSquare;
        iconColor = Colors.yellow;
        break;
      case 'tarjeta roja':
        iconData = FontAwesomeIcons.solidSquare;
        iconColor = Colors.red;
        break;
      case 'cambio':
        iconData = FontAwesomeIcons.arrowsRotate;
        iconColor = Colors.white;
        break;
      default:
        iconData = FontAwesomeIcons.futbol;
        iconColor = Colors.white;
        break;
    }

    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(int.parse('0xff${detalle.color.substring(1)}')),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }

  Widget _buildTeamColumn(
      String teamName, String teamLogo, String defaultLogo) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Image.network(
              'http://192.168.1.40/PanelBitalaHidalgo/files/logos_equipos/$teamLogo',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  defaultLogo,
                  fit: BoxFit.contain,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            teamName,
            style: GoogleFonts.mulish(
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            softWrap: true,
          ),
        ],
      ),
    );
  }
}
