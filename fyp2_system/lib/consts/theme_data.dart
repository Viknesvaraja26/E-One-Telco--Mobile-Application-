import 'package:flutter/material.dart';
import 'package:flutter/src/services/system_chrome.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context,
      SystemUiOverlayStyle systemUiOverlayStyle) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return ThemeData(
      fontFamily: 'Brand-Bold',
      scaffoldBackgroundColor:
          isDarkTheme ? const Color(0xFF00001a) : const Color(0xFFFFFFFF),
      primaryColor: Colors.purple[800],
      colorScheme: ThemeData().colorScheme.copyWith(
            secondary:
                isDarkTheme ? const Color(0xFF1a1f3c) : const Color(0xFFE8FDFD),
            brightness: isDarkTheme ? Brightness.dark : Brightness.light,
          ),
      cardColor: isDarkTheme
          ? Color.fromARGB(255, 26, 10, 44)
          : Color.fromARGB(255, 250, 242, 253),
      canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: isDarkTheme
              ? const ColorScheme.dark()
              : const ColorScheme.light()),
    );
  }
}
