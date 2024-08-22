import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/models/models.dart';
import '../controller/request/service.dart';
import '../utils/shared_prefs_util.dart';
import '../widgets/statistics_card.dart';
import '../widgets/tabs.dart';
import '../widgets/training_card.dart';
import '../widgets/training_details_dialog.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final HomeService _homeService = HomeService();
  final PlayerStatsService _statsService = PlayerStatsService();
  late Future<Map<String, List<Entrenamiento>>> _entrenamientosPorEquipo;
  late Future<List<EstadisticasJugador>> _estadisticas;
  String equipoSeleccionado = '';

  @override
  void initState() {
    super.initState();
    _entrenamientosPorEquipo = Future.value({});
    _estadisticas = Future.value([]);
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      String userId = await SharedPrefsUtil.getUserId();
      if (userId.isNotEmpty) {
        setState(() {
          _estadisticas =
              _statsService.obtenerEstadisticasJugador(userId).timeout(
                    const Duration(seconds: 5),
                    onTimeout: () => [],
                  );
          _entrenamientosPorEquipo =
              _homeService.cargarEntrenamientosPorEquipo(userId).timeout(
                    const Duration(seconds: 5),
                    onTimeout: () => {},
                  );
        });
      }
    } catch (e) {
      _showSnackBar(e.toString());
      setState(() {
        _estadisticas = Future.value([]);
        _entrenamientosPorEquipo = Future.value({});
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadStats();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildShimmerStatisticsCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildShimmerTrainingCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 150,
        height: 150,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildPendingStatisticsCard() {
    return StatisticsCard(
      stats: [],
      textStyle: GoogleFonts.mulish(
        textStyle: const TextStyle(color: Colors.white),
      ),
      isPending: true,
    );
  }

  Widget _buildPendingTrainingCard() {
    return TrainingCard(
      lugar: 'Pendiente',
      fecha: 'Pendiente',
      hora: 'Pendiente',
      estado: 'Pendiente',
      responsable: 'Pendiente',
      imageUrl: 'assets/entrenPendiente.png',
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.04;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              children: [
                FadeInUp(
                  duration: const Duration(seconds: 1),
                  child: FutureBuilder<List<EstadisticasJugador>>(
                    future: _estadisticas,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildShimmerStatisticsCard();
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (snapshot.data!.isEmpty) {
                        return _buildPendingStatisticsCard();
                      } else {
                        return StatisticsCard(
                          stats: snapshot.data!,
                          textStyle: GoogleFonts.mulish(
                            textStyle: const TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: padding),
                FadeInDown(
                  duration: const Duration(seconds: 1),
                  child: Text(
                    'Entrenamientos del Mes',
                    style: GoogleFonts.mulish(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FutureBuilder<Map<String, List<Entrenamiento>>>(
                  future: _entrenamientosPorEquipo,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) =>
                              _buildShimmerTrainingCard(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.data!.isEmpty) {
                      return SizedBox(
                        height: 230,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: 185,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: _buildPendingTrainingCard(),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      final equipos = snapshot.data!.keys.toList();
                      if (equipoSeleccionado.isEmpty && equipos.isNotEmpty) {
                        equipoSeleccionado = equipos.first;
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: equipos.map((equipo) {
                            return Tabs(
                              title: equipo,
                              isActive: equipoSeleccionado == equipo,
                              onTap: () {
                                setState(() {
                                  equipoSeleccionado = equipo;
                                });
                              },
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
                FutureBuilder<Map<String, List<Entrenamiento>>>(
                  future: _entrenamientosPorEquipo,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: 300,
                        child: GridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: size.width > 900
                                ? 4
                                : size.width > 600
                                    ? 3
                                    : 2,
                            childAspectRatio: size.width > 900
                                ? 0.9
                                : size.width > 600
                                    ? 0.8
                                    : 0.75,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: 4,
                          itemBuilder: (context, index) =>
                              _buildShimmerTrainingCard(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final entrenamientosList =
                          snapshot.data![equipoSeleccionado] ?? [];
                      if (entrenamientosList.isEmpty) {
                        return SizedBox(
                          height: 300,
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: size.width > 900
                                  ? 4
                                  : size.width > 600
                                      ? 3
                                      : 2,
                              childAspectRatio: size.width > 900
                                  ? 0.9
                                  : size.width > 600
                                      ? 0.8
                                      : 0.75,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: 2,
                            itemBuilder: (context, index) =>
                                _buildPendingTrainingCard(),
                          ),
                        );
                      } else {
                        return FadeInUp(
                          duration: const Duration(seconds: 1),
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: size.width > 600 ? 3 : 2,
                              childAspectRatio: size.width > 600 ? 0.8 : 0.75,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: entrenamientosList.length,
                            itemBuilder: (context, index) {
                              final entrenamiento = entrenamientosList[index];
                              final imageUrl =
                                  'assets/training${index % 4 + 1}.png';
                              return TrainingCard(
                                lugar: entrenamiento.lugar,
                                fecha: entrenamiento.fechaParseada,
                                hora: entrenamiento.hora,
                                estado: entrenamiento.estado,
                                responsable: entrenamiento.responsable,
                                imageUrl: imageUrl,
                                onTap: () {
                                  showTrainingDetailsDialog(
                                      context, entrenamiento);
                                },
                              );
                            },
                          ),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
