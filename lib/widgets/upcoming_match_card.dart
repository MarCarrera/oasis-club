import 'dart:async';
import 'package:clubfutbol/controller/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpcomingMatchCard extends StatefulWidget {
  final String? torneo;
  final String? jornada;
  final String? lugar;
  final String? equipoLocal;
  final String? equipoVisitante;
  final String? hora;
  final String? fecha;
  final String? escudoLocal;
  final String? escudoVisitante;

  const UpcomingMatchCard({
    super.key,
    this.torneo,
    this.jornada,
    this.lugar,
    this.equipoLocal,
    this.equipoVisitante,
    this.hora,
    this.fecha,
    this.escudoLocal,
    this.escudoVisitante,
  });

  @override
  _UpcomingMatchCardState createState() => _UpcomingMatchCardState();
}

class _UpcomingMatchCardState extends State<UpcomingMatchCard> {
  late Timer _timer;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateTimeRemaining() {
    try {
      if (widget.fecha != null && widget.hora != null) {
        print('Fecha y hora recibidas: ${widget.fecha} ${widget.hora}');

        final String formattedHora = widget.hora!.padRight(8, ':00');

        final DateTime matchDateTime =
            DateTime.parse("${widget.fecha}T${formattedHora}");

        final DateTime now = DateTime.now();
        setState(() {
          _timeRemaining = matchDateTime.difference(now);
        });
      }
    } catch (e) {
      print('Error calculating time remaining: $e');
      setState(() {
        _timeRemaining = Duration.zero;
      });
    }
  }

  void _startTimer() {
    try {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _calculateTimeRemaining();
        if (_timeRemaining.isNegative) {
          timer.cancel();
        }
      });
    } catch (e) {
      print('Error starting timer: $e');
    }
  }

  String _formatDuration(Duration duration) {
    final int days = duration.inDays;
    final int hours = duration.inHours.remainder(24);
    final int minutes = duration.inMinutes.remainder(60);
    final int seconds = duration.inSeconds.remainder(60);
    return '${days}d ${hours}h ${minutes}m ${seconds}s';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double imageSize = size.width > 600 ? 120 : 100;
    final double fontSize = size.width > 600 ? 20 : 16;

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: const DecorationImage(
            image: AssetImage(bannerAsset),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.torneo?.isNotEmpty == true
                          ? widget.torneo!
                          : 'Pendiente',
                      style: GoogleFonts.mulish(
                        textStyle: TextStyle(
                          fontSize: fontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.jornada?.isNotEmpty == true
                          ? widget.jornada!
                          : 'Pendiente',
                      style: GoogleFonts.mulish(
                        textStyle: TextStyle(
                          fontSize: fontSize,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      textAlign: TextAlign.end,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.lugar?.isNotEmpty == true ? widget.lugar! : 'Pendiente',
                style: GoogleFonts.mulish(
                  textStyle: TextStyle(
                    fontSize: fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Image.network(
                        widget.escudoLocal != null &&
                                widget.escudoLocal!.isNotEmpty
                            ? '${urlTeamLogos}${widget.escudoLocal}'
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
                      SizedBox(
                        width: imageSize,
                        child: Text(
                          widget.equipoLocal?.isNotEmpty == true
                              ? widget.equipoLocal!
                              : 'Pendiente',
                          style: GoogleFonts.mulish(
                            textStyle: TextStyle(
                              fontSize: fontSize,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'VS',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Image.network(
                        widget.escudoVisitante != null &&
                                widget.escudoVisitante!.isNotEmpty
                            ? '${urlTeamLogos}${widget.escudoVisitante}'
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
                      SizedBox(
                        width: imageSize,
                        child: Text(
                          widget.equipoVisitante?.isNotEmpty == true
                              ? widget.equipoVisitante!
                              : 'Pendiente',
                          style: GoogleFonts.mulish(
                            textStyle: TextStyle(
                              fontSize: fontSize,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                'Tiempo restante: ${_timeRemaining.isNegative ? 'Partido en progreso' : _formatDuration(_timeRemaining)}',
                style: GoogleFonts.mulish(
                  textStyle: TextStyle(
                    fontSize: fontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 9),
            ],
          ),
        ),
      ),
    );
  }
}
