import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/models/models.dart';
import '../controller/request/service.dart';
import '../utils/constants.dart';
import '../widgets/match_card.dart';
import '../widgets/news_card.dart';
import '../widgets/upcoming_match_card.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  _InicioPageState createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  late Future<List<ProximoPartido>> _upcomingMatchesFuture;
  late Future<List<PartidoJugado>> _playedMatchesFuture;
  late Future<List<Noticia>> _newsFuture;

  final NextMatchService _nextMatchService = NextMatchService();
  final PartidosJugadosService _partidosJugadosService =
      PartidosJugadosService();
  final NoticiasService _noticiasService = NoticiasService();

  @override
  void initState() {
    super.initState();
    _upcomingMatchesFuture = _nextMatchService
        .obtenerProximosPartidos()
        .timeout(const Duration(seconds: 3), onTimeout: () {
      return [];
    });
    _playedMatchesFuture = _partidosJugadosService
        .cargarPartidosJugados()
        .timeout(const Duration(seconds: 3), onTimeout: () {
      return [];
    });
    _newsFuture = _noticiasService
        .obtenerNoticias()
        .timeout(const Duration(seconds: 3), onTimeout: () {
      return [];
    });
  }

  Future<String> _getGreeting() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('userName') ?? 'Usuario';
    return getGreeting(userName);
  }

  String getGreeting(String userName) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Buenos días, $userName';
    } else if (hour < 18) {
      return 'Buenas tardes, $userName';
    } else {
      return 'Buenas noches, $userName';
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _upcomingMatchesFuture = _nextMatchService
          .obtenerProximosPartidos()
          .timeout(const Duration(seconds: 5), onTimeout: () {
        return [];
      });
      _playedMatchesFuture = _partidosJugadosService
          .cargarPartidosJugados()
          .timeout(const Duration(seconds: 5), onTimeout: () {
        return [];
      });
      _newsFuture = _noticiasService
          .obtenerNoticias()
          .timeout(const Duration(seconds: 5), onTimeout: () {
        return [];
      });
    });
  }

  Widget _buildShimmerCard(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;
    final double padding = isTablet ? 32 : 16;
    final double cardWidth = isTablet ? 500 : 370;
    final double upcomingMatchCardHeight = isTablet ? 330 : 345;
    final double matchCardHeight = isTablet ? 300 : 150;
    final double newsCardHeight = isTablet ? 150 : 315;

    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeInRight(
                  duration: const Duration(seconds: 1),
                  child: Text(
                    'Próximos Partidos',
                    style: GoogleFonts.mulish(
                      textStyle: !isDarkMode ? subtitles : subtitlesDark,
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                FadeInUp(
                  duration: const Duration(seconds: 1),
                  child: FutureBuilder<List<ProximoPartido>>(
                    future: _upcomingMatchesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: upcomingMatchCardHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) => _buildShimmerCard(
                                cardWidth, upcomingMatchCardHeight),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.data!.isEmpty) {
                        return SizedBox(
                          height: upcomingMatchCardHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: cardWidth,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: UpcomingMatchCard(
                                    torneo: 'Sin asignar',
                                    jornada: 'Sin asignar',
                                    lugar: 'Sin asignar',
                                    equipoLocal: 'Sin asignar',
                                    equipoVisitante: 'Sin asignar',
                                    hora: 'Sin asignar',
                                    fecha: 'Sin asignar',
                                    escudoLocal: '',
                                    escudoVisitante: '',
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        List<ProximoPartido> partidos = snapshot.data!;
                        partidos.sort((a, b) {
                          DateTime fechaA =
                              DateTime.parse('${a.fecha} ${a.hora}');
                          DateTime fechaB =
                              DateTime.parse('${b.fecha} ${b.hora}');
                          return fechaA.compareTo(fechaB);
                        });
                        return Stack(
                          children: [
                            SizedBox(
                              height: upcomingMatchCardHeight,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: partidos.length,
                                itemBuilder: (context, index) {
                                  var partido = partidos[index];
                                  return SizedBox(
                                    width: cardWidth,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: UpcomingMatchCard(
                                        torneo: partido.torneo,
                                        jornada: partido.detalle,
                                        lugar: partido.lugar,
                                        equipoLocal: partido.equipoLocal,
                                        equipoVisitante:
                                            partido.equipoVisitante,
                                        hora: partido.hora,
                                        fecha: partido.fecha,
                                        escudoLocal: partido.escudoLocal,
                                        escudoVisitante:
                                            partido.escudoVisitante,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (partidos.length > 1)
                              Positioned(
                                right: -10,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 30,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    size: 18,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                FadeInLeft(
                  duration: const Duration(seconds: 1),
                  child: Text(
                    'Partidos Jugados',
                    style: GoogleFonts.mulish(
                      textStyle: !isDarkMode ? subtitles : subtitlesDark,
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                FadeInUp(
                  duration: const Duration(seconds: 1),
                  child: FutureBuilder<List<PartidoJugado>>(
                    future: _playedMatchesFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox(
                          height: matchCardHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 2,
                            itemBuilder: (context, index) =>
                                _buildShimmerCard(cardWidth, matchCardHeight),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.data!.isEmpty) {
                        return SizedBox(
                          height: matchCardHeight,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: cardWidth,
                                child: const Padding(
                                  padding: EdgeInsets.only(right: 8.0),
                                  child: MatchCard(
                                    equipoLocal: 'Pendiente',
                                    equipoVisitante: 'Pendiente',
                                    golesLocal: '0',
                                    golesVisitante: '0',
                                    fechaParseada: 'Pendiente',
                                    estado: 'Pendiente',
                                    escudoLocal: '',
                                    escudoVisitante: '',
                                    detalles: [],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        List<PartidoJugado> partidos = snapshot.data!;
                        return Stack(
                          children: [
                            SizedBox(
                              height: matchCardHeight,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: partidos.length,
                                itemBuilder: (context, index) {
                                  var partido = partidos[index];
                                  return SizedBox(
                                    width: cardWidth,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: MatchCard(
                                        equipoLocal: partido.equipoLocal,
                                        equipoVisitante:
                                            partido.equipoVisitante,
                                        golesLocal:
                                            partido.golesLocal.toString(),
                                        golesVisitante:
                                            partido.golesVisitante.toString(),
                                        fechaParseada: partido.fechaParseada,
                                        estado: partido.estado,
                                        escudoLocal: partido.escudoLocal,
                                        escudoVisitante:
                                            partido.escudoVisitante,
                                        detalles: partido.detalles,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (partidos.length > 1)
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 30,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                FadeInUp(
                  duration: const Duration(seconds: 1),
                  child: FutureBuilder<List<Noticia>>(
                    future: _newsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(
                          children: List.generate(
                            1,
                            (index) =>
                                _buildShimmerCard(size.width, newsCardHeight),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.data!.isEmpty) {
                        return Column(
                          children: List.generate(
                            3,
                            (index) {
                              return SizedBox(
                                width: size.width,
                                height: newsCardHeight,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: NewsCard(
                                    noticia: Noticia(
                                      idNoticia: '',
                                      idCategoria: '',
                                      categoria: 'Pendiente',
                                      titulo: 'Pendiente',
                                      cuerpo: '',
                                      fechaEmision: 'Pendiente',
                                      horaEmision: 'Pendiente',
                                      fotoNoticia: '',
                                      fechaParseada: 'Pendiente',
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        List<Noticia> noticias = snapshot.data!;
                        noticias.sort((a, b) {
                          DateTime fechaA = DateTime.parse(a.fechaEmision);
                          DateTime fechaB = DateTime.parse(b.fechaEmision);
                          return fechaB.compareTo(fechaA);
                        });

                        return Column(
                          children: List.generate(
                            noticias.length,
                            (index) => NewsCard(noticia: noticias[index]),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
