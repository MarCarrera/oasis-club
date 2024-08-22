import 'package:clubfutbol/controller/config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/models/models.dart';
import '../home/news_detail_page.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';

class NewsCard extends StatelessWidget {
  final Noticia noticia;

  const NewsCard({
    super.key,
    required this.noticia,
  });

  String timeAgo(DateTime date) {
    Duration diff = DateTime.now().difference(date);

    if (diff.inDays > 365) {
      int years = (diff.inDays / 365).floor();
      return 'Publicado hace $years año${years > 1 ? "s" : ""}';
    } else if (diff.inDays > 30) {
      int months = (diff.inDays / 30).floor();
      return 'Publicado hace $months mes${months > 1 ? "es" : ""}';
    } else if (diff.inDays > 7) {
      int weeks = (diff.inDays / 7).floor();
      return 'Publicado hace $weeks semana${weeks > 1 ? "s" : ""}';
    } else if (diff.inDays > 0) {
      return 'Publicado hace ${diff.inDays} día${diff.inDays > 1 ? "s" : ""}';
    } else if (diff.inHours > 0) {
      return 'Publicado hace ${diff.inHours} hora${diff.inHours > 1 ? "s" : ""}';
    } else if (diff.inMinutes > 0) {
      return 'Publicado hace ${diff.inMinutes} minuto${diff.inMinutes > 1 ? "s" : ""}';
    } else {
      return 'Publicado hace unos momentos';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 400;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    DateTime? fechaEmision =
        noticia.fechaEmision.isNotEmpty && noticia.fechaEmision != 'Pendiente'
            ? DateFormat("yyyy-MM-dd").parse(noticia.fechaEmision)
            : null;

    String imageUrl = noticia.fotoNoticia?.isNotEmpty == true
        ? '$urlNewsImages${noticia.fotoNoticia}'
        : '';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              title: noticia.titulo.isNotEmpty ? noticia.titulo : 'Pendiente',
              description:
                  noticia.cuerpo.isNotEmpty ? noticia.cuerpo : 'Pendiente',
              date: noticia.fechaParseada.isNotEmpty
                  ? noticia.fechaParseada
                  : 'Pendiente',
              time: noticia.horaEmision.isNotEmpty
                  ? noticia.horaEmision
                  : 'Pendiente',
              category: noticia.categoria.isNotEmpty
                  ? noticia.categoria
                  : 'Pendiente',
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    cardNewsImageAsset,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Text(
                                  noticia.titulo.isNotEmpty
                                      ? noticia.titulo
                                      : 'Pendiente',
                                  style: GoogleFonts.mulish(
                                    textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 3
                                        ..color = colorTextDark2,
                                    ),
                                  ),
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                                Text(
                                  noticia.titulo.isNotEmpty
                                      ? noticia.titulo
                                      : 'Pendiente',
                                  style: GoogleFonts.mulish(
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      color: NoticiaTitulo,
                                    ),
                                  ),
                                  maxLines: 2,
                                  softWrap: true,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            noticia.fechaParseada.isNotEmpty
                                ? noticia.fechaParseada
                                : 'Pendiente',
                            style: GoogleFonts.mulish(
                              textStyle: TextStyle(
                                fontSize: 12,
                                color:
                                    !isDarkMode ? Colors.white : colorTextDark2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Divider(color: Colors.white, thickness: 2),
                      const SizedBox(height: 8),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: noticia.fotoNoticia != null &&
                                  noticia.fotoNoticia!.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  width: isSmallScreen ? 300 : double.infinity,
                                  height: isSmallScreen ? 150 : 200,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  defaultNewsImageAsset,
                                  width: isSmallScreen ? 300 : double.infinity,
                                  height: isSmallScreen ? 150 : 200,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            fechaEmision != null
                                ? timeAgo(fechaEmision)
                                : 'Fecha no disponible',
                            style: GoogleFonts.mulish(
                              textStyle: TextStyle(
                                fontSize: 12,
                                color:
                                    !isDarkMode ? Colors.white : colorTextDark2,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewsDetailPage(
                                    title: noticia.titulo.isNotEmpty
                                        ? noticia.titulo
                                        : 'Pendiente',
                                    description: noticia.cuerpo.isNotEmpty
                                        ? noticia.cuerpo
                                        : 'Pendiente',
                                    date: noticia.fechaParseada.isNotEmpty
                                        ? noticia.fechaParseada
                                        : 'Pendiente',
                                    time: noticia.horaEmision.isNotEmpty
                                        ? noticia.horaEmision
                                        : 'Pendiente',
                                    category: noticia.categoria.isNotEmpty
                                        ? noticia.categoria
                                        : 'Pendiente',
                                    imageUrl: imageUrl,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Ver detalles',
                              style: GoogleFonts.mulish(
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  color: !isDarkMode
                                      ? Colors.white
                                      : colorTextDark2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
