import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clubfutbol/utils/constants.dart';

class WavePainter extends CustomPainter {
  final bool isDarkMode;
  final Color color1;
  final Color color2;

  WavePainter(
      {required this.isDarkMode, required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode ? color1 : color2
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.25, size.height * 0.75,
          size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * 0.25, size.width, size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class WavePainter2 extends CustomPainter {
  final bool isDarkMode;
  final Color color1;
  final Color color2;

  WavePainter2(
      {required this.isDarkMode, required this.color1, required this.color2});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDarkMode ? color1 : color2
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.5)
      ..quadraticBezierTo(
          size.width * 0.25, size.height, size.width * 0.5, size.height * 0.5)
      ..quadraticBezierTo(size.width * 0.75, size.height * 0.0625, size.width,
          size.height * 0.5)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class NewsDetailPage extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String time;
  final String category;
  final String imageUrl;

  const NewsDetailPage({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.category,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? colorCardDark2 : Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 400,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/background_login.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  top: 250,
                  child: CustomPaint(
                    painter: WavePainter(
                        color1: colorCardDark3,
                        color2: colorCardLight3,
                        isDarkMode: isDarkMode),
                  ),
                ),
                Positioned.fill(
                  top: 320,
                  child: CustomPaint(
                    painter: WavePainter2(
                        color1: colorCardDark2,
                        color2: colorCardLight2,
                        isDarkMode: isDarkMode),
                  ),
                ),
                Positioned(
                  top: 60,
                  left: 16,
                  right: 16,
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(36.0),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        height: 220,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/no-notice.png',
                            fit: BoxFit.cover,
                            height: 220,
                            width: double.infinity,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mulish(
                      textStyle: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Publicado el $date a las $time',
                          style: GoogleFonts.mulish(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Categoría:\n$category',
                          style: GoogleFonts.mulish(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.mulish(
                      textStyle: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
