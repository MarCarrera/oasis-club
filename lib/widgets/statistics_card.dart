import 'package:clubfutbol/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/models/models.dart';
import 'statistics_details_dialog.dart';

class StatisticsCard extends StatefulWidget {
  final List<EstadisticasJugador> stats;
  final TextStyle textStyle;
  final bool isPending;

  const StatisticsCard({
    super.key,
    required this.stats,
    required this.textStyle,
    this.isPending = false,
  });

  @override
  _StatisticsCardState createState() => _StatisticsCardState();
}

class _StatisticsCardState extends State<StatisticsCard> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double fontSize = size.width * 0.03;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    if (widget.isPending) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Sin Estadisticas',
              style: GoogleFonts.mulish(
                textStyle: TextStyle(
                  fontSize: fontSize * 1.2,
                  color: !isDarkMode ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            width: size.width * 0.615,
            height: size.height * 0.2,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: primaryColorOrange,
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(113, 0, 0, 0),
                  blurRadius: 6,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/backgroudTorneo.png',
                      width: size.width * 0.62,
                      height: size.height * 0.10,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Sin datos disponibles',
                      style: GoogleFonts.mulish(
                        textStyle: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      final Map<String, List<EstadisticasJugador>> groupedStats = {};
      for (var stat in widget.stats) {
        if (groupedStats.containsKey(stat.equipo)) {
          groupedStats[stat.equipo]!.add(stat);
        } else {
          groupedStats[stat.equipo] = [stat];
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: groupedStats.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  entry.key,
                  style: GoogleFonts.mulish(
                    textStyle: TextStyle(
                      fontSize: fontSize * 1.2,
                      color: !isDarkMode ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        children: entry.value.map((stat) {
                          return GestureDetector(
                            onTap: () {
                              showStatisticsDetailsDialog(context, stat);
                            },
                            child: Container(
                              width: size.width * 0.615,
                              height: size.height * 0.2,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: primaryColorOrange,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(113, 0, 0, 0),
                                    blurRadius: 6,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.asset(
                                        'assets/backgroudTorneo.png',
                                        width: size.width * 0.57,
                                        height: size.height * 0.09,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: Text(
                                            stat.torneo,
                                            style: GoogleFonts.mulish(
                                              textStyle: TextStyle(
                                                fontSize: fontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  if (entry.value.length > 1)
                    Positioned(
                      right: -10,
                      top: 20,
                      bottom: 0,
                      child: Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: isDarkMode ? Colors.white : Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        }).toList(),
      );
    }
  }
}
