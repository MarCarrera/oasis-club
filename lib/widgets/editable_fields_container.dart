import 'package:clubfutbol/Theme/theme_notifier.dart';
import 'package:clubfutbol/utils/constants.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditableFieldsContainer extends StatefulWidget {
  final String email;
  final VoidCallback onEdit;

  const EditableFieldsContainer({
    super.key,
    required this.email,
    required this.onEdit,
  });

  @override
  State<EditableFieldsContainer> createState() =>
      _EditableFieldsContainerState();
}

class _EditableFieldsContainerState extends State<EditableFieldsContainer> {
  bool isDarkModeEnabled = themeNotifier.value == ThemeMode.dark;

  void onStateChanged(bool isDarkMode) {
    setState(() {
      isDarkModeEnabled = isDarkMode;
      themeNotifier.value = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: !isDarkMode ? Colors.white : colorCardDark,
        borderRadius: BorderRadius.circular(screenWidth * 0.02),
        border:
            Border.all(color: primaryColorOrange, width: screenWidth * 0.005),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: primaryColorOrange),
                  onPressed: widget.onEdit,
                  iconSize: screenWidth * 0.08,
                ),
                Container(
                  width: screenWidth * 0.1,
                  height: screenHeight * 0.005,
                  color: primaryColorOrange,
                ),
              ],
            ),
          ),
          _buildField(
            context,
            label: 'Correo Electrónico',
            value: widget.email,
            icon: Icons.email,
            screenWidth: screenWidth,
          ),
          Divider(
            color: primaryColorOrange,
            thickness: screenHeight * 0.001,
          ),
          _buildField(
            context,
            label: 'Contraseña',
            value: '********',
            icon: Icons.lock,
            screenWidth: screenWidth,
          ),
          Divider(
            color: primaryColorOrange,
            thickness: screenHeight * 0.001,
          ),
          _buildFieldTheme(context,
              label:
                  isDarkMode ? 'Cambiar a tema claro' : 'Cambiar a tema oscuro',
              value: '',
              screenWidth: screenWidth),
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context,
      {required String label,
      required String value,
      required IconData icon,
      required double screenWidth}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryColorOrange,
            size: screenWidth * 0.07,
          ),
          SizedBox(width: screenWidth * 0.02),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.mulish(
                  color: primaryColorOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.04,
                ),
              ),
              SizedBox(height: screenWidth * 0.01),
              Text(
                value,
                style: GoogleFonts.mulish(
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFieldTheme(BuildContext context,
      {required String label,
      required String value,
      required double screenWidth}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
      child: Row(
        children: [
          SizedBox(width: screenWidth * 0.02),
          Row(
            children: [
              Text(
                label,
                style: GoogleFonts.mulish(
                  color: primaryColorOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.04,
                ),
              ),
              SizedBox(width: screenWidth * 0.1),
              Padding(
                padding: EdgeInsets.only(top: screenWidth * 0.005),
                child: DayNightSwitcherIcon(
                  isDarkModeEnabled: isDarkModeEnabled,
                  onStateChanged: onStateChanged,
                  dayBackgroundColor: const Color.fromARGB(207, 244, 193, 122),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
