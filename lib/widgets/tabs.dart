import 'package:clubfutbol/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// *[Tabs] are used to show the tabs in the home page
/// *required props:[title] which is the title of the tab
/// *required props:[isActive] which is the active tab
/// *required props:[onTap] which is the function to be called when the tab is tapped
class Tabs extends StatelessWidget {
  const Tabs({
    Key? key,
    required this.title,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width / 100;
    var _height = MediaQuery.of(context).size.height / 100;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: _width * 5),
        height: _height * 4,
        decoration: BoxDecoration(
            // color: isActive
            //     ? Color.fromARGB(221, 21, 61, 164)
            //     : Colors.transparent,
            borderRadius: BorderRadius.circular(8)),
        child: Center(
            child: Text(
          title,
          style: GoogleFonts.mulish(
              fontSize: isActive ? _width * 4.4 : _width * 4,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
              color: isActive && !isDarkMode
                  ? colorTextTabLighActive
                  : !isActive && !isDarkMode
                      ? Color.fromARGB(255, 32, 32, 32)
                      : isActive && isDarkMode
                          ? colorTextTabLighActive
                          : colorTextTabDarkInactive),
        )),
      ),
    );
  }
}
