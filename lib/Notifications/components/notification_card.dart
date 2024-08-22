import 'package:clubfutbol/Home/inicio_page.dart';
import 'package:clubfutbol/Home/statistics_page.dart';
import 'package:clubfutbol/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../controller/config.dart';
import '../../controller/models/models.dart';
import '../../controller/request/service.dart';

class NotificationCard extends StatefulWidget {
  const NotificationCard({
    super.key,
    required this.notificaciones,
    required this.size,
  });

  final List<Notificaciones> notificaciones;
  final Size size;

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  Color colorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "").replaceAll("0x", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  final DateTime currentDate = DateTime.now();
  String dateNow = '';

  final Map<String, String> colorsDicc = {};
  final NotificationsService _notifService = NotificationsService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    dateNow = formatter.format(currentDate).toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: widget.notificaciones.length,
      itemBuilder: (context, index) {
        final notif = widget.notificaciones[index];
        String formattedDate = formatDateString(notif.fechaEmision);

        return Dismissible(
          key: Key(notif.idNotificacion.toString()),
          direction: DismissDirection.endToStart,
          background: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20.0),
              decoration: BoxDecoration(
                  color: !isDarkMode ? Colors.red : colorDeleteNotifDark,
                  borderRadius: BorderRadius.circular(14)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 40,
                  ),
                  Text(
                    'Eliminar',
                    style: GoogleFonts.mulish(
                      color: Colors.white,
                      fontSize: widget.size.width * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          onDismissed: (direction) async {
            setState(() {
              widget.notificaciones.removeAt(index);
            });
            await _notifService
                .eliminarNotificacionesJugador(notif.idNotificacion);
            if (mounted) {
              setState(() {});
            }
          },
          child: GestureDetector(
            onTap: () {
              var type = notif.tabla;
              print('idEvento: ${type}');

              switch (type) {
                case 'entrenamientos':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => StatisticsPage()),
                  );
                  break;
                case 'noticias':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InicioPage()),
                  );
                  break;
                case 'partidos':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => InicioPage()),
                  );
                  break;
                default:
                  print('Nombre de tabla no existe');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                height: widget.size.height * 0.142,
                width: widget.size.width,
                decoration: BoxDecoration(
                    color: !isDarkMode
                        ? Color.fromARGB(24, 32, 91, 240)
                        : colorCardDark,
                    borderRadius: BorderRadius.circular(8)),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0),
                          child: Container(
                            height: widget.size.height,
                            width: widget.size.width * 0.02,
                            decoration: BoxDecoration(
                                color: colorFromHex(notif.color),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    bottomLeft: Radius.circular(14))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notif.titulo,
                                        maxLines: 2,
                                        style: GoogleFonts.mulish(
                                          color: colorFromHex(notif.color),
                                          fontSize: notif.titulo ==
                                                      "\u00a1ENTRENAMIENTO ACTUALIZADO! \ud83d\udcaa\ud83d\udd04" ||
                                                  notif.titulo ==
                                                      "\u00a1PARTIDO ACTUALIZADO! \u26bd\ud83d\udd04"
                                              ? widget.size.width * 0.03
                                              : widget.size.width * 0.038,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        notif.tabla == "noticias"
                                            ? 'Entérate de ésta y muchas'
                                            : '¡En la categoría',
                                        style: GoogleFonts.mulish(
                                          color: !isDarkMode
                                              ? Colors.black
                                              : colorTextDark2,
                                          fontSize: notif.tabla == "noticias"
                                              ? widget.size.width * 0.036
                                              : widget.size.width * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        notif.tabla == "noticias"
                                            ? 'más noticias!'
                                            : '${notif.categoria}',
                                        style: GoogleFonts.mulish(
                                          color: !isDarkMode
                                              ? Colors.black
                                              : colorTextDark2,
                                          fontSize: notif.tabla == "noticias"
                                              ? widget.size.width * 0.036
                                              : widget.size.width * 0.04,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 10,
                      left: 18,
                      child: Text(
                        dateNow == notif.fechaEmision ? '' : formattedDate,
                        maxLines: 2,
                        style: GoogleFonts.mulish(
                          color: colorFromHex(notif.color),
                          fontSize: widget.size.width * 0.032,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: widget.size.width * 0.02,
                      right: widget.size.width * 0.06,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                              backgroundColor: colorFromHex(notif.color),
                              radius: 36.0,
                              backgroundImage:
                                  NetworkImage('${urlIconsNot}${notif.icon}')),
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 15,
                                ),
                                Text(
                                  notif.horaEmision,
                                  maxLines: 2,
                                  style: GoogleFonts.mulish(
                                    color: colorFromHex(notif.color),
                                    fontSize: widget.size.width * 0.032,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String formatDateString(String dateStr) {
    // Parse the string into a DateTime object
    DateTime date = DateTime.parse(dateStr);

    // Define the format for the day of the week, day of the month, and month
    DateFormat dayFormat = DateFormat('EEEE');
    DateFormat dayNumberFormat = DateFormat('d');
    DateFormat monthFormat = DateFormat('MMMM');

    // Get the day of the week in Spanish
    String dayOfWeek = dayFormat.format(date);
    switch (dayOfWeek) {
      case 'Monday':
        dayOfWeek = 'Lunes';
        break;
      case 'Tuesday':
        dayOfWeek = 'Martes';
        break;
      case 'Wednesday':
        dayOfWeek = 'Miércoles';
        break;
      case 'Thursday':
        dayOfWeek = 'Jueves';
        break;
      case 'Friday':
        dayOfWeek = 'Viernes';
        break;
      case 'Saturday':
        dayOfWeek = 'Sábado';
        break;
      case 'Sunday':
        dayOfWeek = 'Domingo';
        break;
    }

    // Get the day of the month
    String dayOfMonth = dayNumberFormat.format(date);

    // Get the month in Spanish
    String month = monthFormat.format(date);
    switch (month) {
      case 'January':
        month = 'Enero';
        break;
      case 'February':
        month = 'Febrero';
        break;
      case 'March':
        month = 'Marzo';
        break;
      case 'April':
        month = 'Abril';
        break;
      case 'May':
        month = 'Mayo';
        break;
      case 'June':
        month = 'Junio';
        break;
      case 'July':
        month = 'Julio';
        break;
      case 'August':
        month = 'Agosto';
        break;
      case 'September':
        month = 'Septiembre';
        break;
      case 'October':
        month = 'Octubre';
        break;
      case 'November':
        month = 'Noviembre';
        break;
      case 'December':
        month = 'Diciembre';
        break;
    }

    // Combine them into the desired format
    return '$dayOfWeek, $dayOfMonth de $month';
  }
}
