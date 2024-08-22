import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controller/models/models.dart';
import '../controller/request/service.dart';
import '../utils/shared_prefs_util.dart';
import 'components/notification_card.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key, required this.id});
  final String id;

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  late Future<List<Notificaciones>> _notificaciones;
  final NotificationsService _notifService = NotificationsService();

  final DateTime currentDate = DateTime.now();
  String dateNow = '';

  @override
  void initState() {
    super.initState();
    _notificaciones = Future.value([]);
    _loadNotifications();

    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    dateNow = formatter.format(currentDate).toString();
  }

  Future<void> _loadNotifications() async {
    try {
      String userId = await SharedPrefsUtil.getUserId();
      if (userId.isNotEmpty) {
        List<Notificaciones> notificaciones =
            await _notifService.obtenerNotificacionesJugador(userId);
        // Ordenar las notificaciones por fechaParseada desde la más reciente a la más antigua
        notificaciones
            .sort((a, b) => b.fechaParseada.compareTo(a.fechaParseada));
        setState(() {
          _notificaciones = Future.value(notificaciones);
        });
      } else {
        setState(() {
          _notificaciones = Future.value([]);
        });
      }
    } catch (e) {
      _notificaciones = Future.error('Error al cargar notificaciones');
    }
  }

  Future<void> _refreshData() async {
    await _loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                FadeInUp(
                  duration: const Duration(seconds: 1),
                  child: FutureBuilder<List<Notificaciones>>(
                    future: _notificaciones,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No hay notificaciones disponibles.'));
                      } else {
                        final todasLasNotificaciones = snapshot.data!;
                        // Tomar las primeras 10 notificaciones y ordenarlas por hora de emisión
                        final notificacionesMostradas =
                            todasLasNotificaciones.take(10).toList();
                        final notificacionesHoy = notificacionesMostradas
                            .where((notif) => notif.fechaEmision == dateNow)
                            .toList()
                          ..sort((a, b) => _compareHoraEmision(
                              b.horaEmision, a.horaEmision));
                        final notificacionesAnteriores = notificacionesMostradas
                            .where((notif) => notif.fechaEmision != dateNow)
                            .toList()
                          ..sort((a, b) => _compareHoraEmision(
                              b.horaEmision, a.horaEmision));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (notificacionesHoy.isNotEmpty) ...[
                              Padding(
                                padding: EdgeInsets.all(padding),
                                child: Text(
                                  'Hoy',
                                  style: GoogleFonts.lato(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              NotificationCard(
                                  size: size,
                                  notificaciones: notificacionesHoy),
                            ],
                            if (notificacionesAnteriores.isNotEmpty) ...[
                              Padding(
                                padding: EdgeInsets.all(padding),
                                child: Text(
                                  'Anteriores',
                                  style: GoogleFonts.lato(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              NotificationCard(
                                  size: size,
                                  notificaciones: notificacionesAnteriores),
                            ],
                          ],
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

  // Método para comparar dos horas en formato "hh:mm a"
  int _compareHoraEmision(String horaEmisionA, String horaEmisionB) {
    final DateFormat format = DateFormat('hh:mm a');
    final DateTime timeA = format.parse(horaEmisionA);
    final DateTime timeB = format.parse(horaEmisionB);
    return timeA.compareTo(timeB);
  }
}
