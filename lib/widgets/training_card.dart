import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TrainingCard extends StatelessWidget {
  final String lugar;
  final String fecha;
  final String hora;
  final String estado;
  final String responsable;
  final String imageUrl;
  final VoidCallback onTap;

  const TrainingCard({
    super.key,
    required this.lugar,
    required this.fecha,
    required this.hora,
    required this.estado,
    required this.responsable,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double fontSize = size.width * 0.04;

    final Color color;
    final String imageAsset;

    if (estado == 'Programado') {
      color = const Color.fromARGB(255, 162, 141, 65);
      imageAsset = 'assets/programadoEntren.png';
    } else if (estado == 'Finalizado') {
      color = const Color.fromARGB(255, 60, 107, 55);
      imageAsset = 'assets/finalizadoEntren.png';
    } else if (estado == 'Pendiente') {
      color = Colors.grey;
      imageAsset = 'assets/entrenPendiente.png';
    } else {
      color = Color.fromARGB(255, 196, 59, 59);
      imageAsset = 'assets/cancelado.png';
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(113, 0, 0, 0),
              blurRadius: 6,
              offset: Offset(0, 8),
            ),
          ],
        ),
        margin: EdgeInsets.all(size.width * 0.02),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.only(top: 0),
                child: Image.asset(
                  imageAsset,
                  width: size.width * 0.55,
                  height: size.height * 0.14,
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: AutoSizeText(
                    lugar,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mulish(
                      textStyle: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    maxLines: 1,
                    minFontSize: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/calendar.png',
                        height: size.height * 0.017,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: AutoSizeText(
                          fecha,
                          style: GoogleFonts.mulish(
                            textStyle: TextStyle(
                              fontSize: fontSize - 2,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          maxLines: 1,
                          minFontSize: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/clock.png',
                        height: size.height * 0.017,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                        child: AutoSizeText(
                          hora,
                          style: GoogleFonts.mulish(
                            textStyle: TextStyle(
                              fontSize: fontSize - 4,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          maxLines: 1,
                          minFontSize: 8,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
