import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/constants.dart';

class TeamsExpansionCard extends StatelessWidget {
  final List<String> categories;

  const TeamsExpansionCard({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.all(screenWidth * 0.05),
      decoration: BoxDecoration(
        color: isDarkMode ? colorCardDark : colorCardLight2,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: isDarkMode ? primaryColorOrange : primaryColorOrange,
          width: 2.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: ExpansionTileCard(
          leading: Icon(
            Icons.sports_soccer,
            color: isDarkMode ? primaryColorOrange : primaryColorOrange,
          ),
          title: Text(
            'Mis Equipos',
            style: GoogleFonts.mulish(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? primaryColorOrange : primaryColorOrange,
            ),
          ),
          baseColor: isDarkMode ? colorCardDark : colorCardLight2,
          expandedColor: isDarkMode ? colorCardDark : colorCardLight2,
          shadowColor: Colors.transparent,
          elevation: 0.0,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: categories.isNotEmpty
                  ? Column(
                      children: categories.map((category) {
                        final parts = category.split(',');
                        final categoryName = parts.isNotEmpty
                            ? parts[0]
                            : 'Categoría desconocida';
                        final teamName =
                            parts.length > 1 ? parts[1] : 'Equipo desconocido';
                        final shirtNumber =
                            parts.length > 2 ? parts[2] : 'Número no asignado';

                        return Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01,
                              horizontal: screenWidth * 0.02,
                            ),
                            leading: Icon(
                              Icons.sports_soccer,
                              color: isDarkMode
                                  ? primaryColorOrange
                                  : primaryColorOrange,
                            ),
                            title: Text(
                              'Categoría: $categoryName\nEquipo: $teamName',
                              style: GoogleFonts.mulish(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode
                                    ? colorTextDark2
                                    : colorTextLight,
                              ),
                            ),
                            subtitle: Text(
                              'Número de Camiseta: $shirtNumber',
                              style: GoogleFonts.mulish(
                                fontSize: screenWidth * 0.04,
                                color: isDarkMode
                                    ? colorTextDark2
                                    : colorTextLight,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : Text(
                      'No estás en ningún equipo actualmente.',
                      style: GoogleFonts.mulish(
                        fontSize: screenWidth * 0.045,
                        color: isDarkMode ? colorTextDark1 : colorTextLight,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
