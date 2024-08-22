import 'package:clubfutbol/controller/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/models/models.dart';
import 'match_details_dialog.dart';

class MatchCard extends StatelessWidget {
  final String? equipoLocal;
  final String? equipoVisitante;
  final String? golesLocal;
  final String? golesVisitante;
  final String? estado;
  final String? escudoLocal;
  final String? escudoVisitante;
  final String? fechaParseada;
  final List<Detalle>? detalles;

  const MatchCard({
    super.key,
    this.equipoLocal,
    this.equipoVisitante,
    this.golesLocal,
    this.golesVisitante,
    this.estado,
    this.escudoLocal,
    this.escudoVisitante,
    this.fechaParseada,
    this.detalles,
  });

  void _showMatchDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MatchDetailsDialog(
          equipoLocal: equipoLocal ?? 'Pendiente',
          equipoVisitante: equipoVisitante ?? 'Pendiente',
          golesLocal: golesLocal ?? '-',
          golesVisitante: golesVisitante ?? '-',
          estado: estado ?? 'Pendiente',
          escudoLocal: escudoLocal ?? defaultLogoAsset,
          escudoVisitante: escudoVisitante ?? defaultLogoAsset,
          defaultLogo: defaultLogoAsset,
          detalles: detalles ?? [],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double cardWidth = size.width * 0.85;
    final double cardHeight = size.height * 0.35;
    final double imageSize = size.width * 0.1;
    final double padding = size.width * 0.03;
    final double fontSize = size.width * 0.03;
    final double titleFontSize = size.width * 0.04;

    return GestureDetector(
      onTap: () => _showMatchDetails(context),
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          elevation: 6,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage(bannerAsset),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      estado?.isNotEmpty == true ? estado! : 'Pendiente',
                      style: GoogleFonts.mulish(
                        textStyle: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: [
                          Container(
                            width: cardWidth / 3 - padding,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  equipoLocal?.isNotEmpty == true
                                      ? equipoLocal!
                                      : 'Pendiente',
                                  style: GoogleFonts.mulish(
                                    textStyle: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: padding),
                                Image.network(
                                  escudoLocal?.isNotEmpty == true
                                      ? '$urlTeamLogos$escudoLocal'
                                      : defaultLogoAsset,
                                  width: imageSize,
                                  height: imageSize,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      defaultLogoAsset,
                                      width: imageSize,
                                      height: imageSize,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: cardWidth / 3 - padding,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${golesLocal ?? '-'} - ${golesVisitante ?? '-'}',
                                  style: TextStyle(
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: cardWidth / 3 - padding,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  equipoVisitante?.isNotEmpty == true
                                      ? equipoVisitante!
                                      : 'Pendiente',
                                  style: GoogleFonts.mulish(
                                    textStyle: TextStyle(
                                      fontSize: fontSize,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: padding),
                                Image.network(
                                  escudoVisitante?.isNotEmpty == true
                                      ? '$urlTeamLogos$escudoVisitante'
                                      : defaultLogoAsset,
                                  width: imageSize,
                                  height: imageSize,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      defaultLogoAsset,
                                      width: imageSize,
                                      height: imageSize,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: padding),
                    Text(
                      fechaParseada?.isNotEmpty == true
                          ? fechaParseada!
                          : 'Pendiente',
                      style: GoogleFonts.mulish(
                        textStyle: TextStyle(
                          fontSize: fontSize,
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
