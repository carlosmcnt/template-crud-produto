import 'package:flutter/material.dart';

// Definição de paletas de cores
class Cores {
  // Paleta de cores para o modo claro
  static const Color primaryLight = Color(0xFFFFC107);
  static const Color accentLight = Color(0xFFFF4081);
  static const Color backgroundLight = Color(0xFFFAFABA);
  static const Color textPrimaryLight = Color(0xFF4E342E);
  static const Color textSecondaryLight = Color(0xFF000000);
  static const Color shadowLight = Color(0xFFFFD740);
  static const Color inputBackgroundLight = Colors.white;

  // Paleta de cores para o modo escuro
  static const Color primaryDark = Color(0xFFFFC107);
  static const Color accentDark = Color(0xFFFF4081);
  static const Color backgroundDark = Color(0xFF303030);
  static const Color textPrimaryDark = Colors.white70;
  static const Color textSecondaryDark = Colors.white60;
  static const Color shadowDark = Color(0xFF000000);
  static const Color inputBackgroundDark = Color(0xFF616161);
}

// Função para criar temas com base nas cores
class Tema {
  static ThemeData lightTheme = _buildTheme(
    primaryColor: Cores.primaryLight,
    accentColor: Cores.accentLight,
    backgroundColor: Cores.backgroundLight,
    textPrimaryColor: Cores.textPrimaryLight,
    textSecondaryColor: Cores.textSecondaryLight,
    shadowColor: Cores.shadowLight,
    inputBackgroundColor: Cores.inputBackgroundLight,
  );

  static ThemeData darkTheme = _buildTheme(
    primaryColor: Cores.primaryDark,
    accentColor: Cores.accentDark,
    backgroundColor: Cores.backgroundDark,
    textPrimaryColor: Cores.textPrimaryDark,
    textSecondaryColor: Cores.textSecondaryDark,
    shadowColor: Cores.shadowDark,
    inputBackgroundColor: Cores.inputBackgroundDark,
  );

  static ThemeData _buildTheme({
    required Color primaryColor,
    required Color accentColor,
    required Color backgroundColor,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required Color shadowColor,
    required Color inputBackgroundColor,
  }) {
    return ThemeData(
      brightness: primaryColor == Cores.primaryDark
          ? Brightness.dark
          : Brightness.light,
      primaryColor: primaryColor,
      hintColor: accentColor,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textPrimaryColor),
        bodyMedium: TextStyle(color: textPrimaryColor),
        labelLarge:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: backgroundColor,
        iconColor: accentColor,
        textColor: textPrimaryColor,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: accentColor,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        textStyle: const TextStyle(color: Colors.white),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: backgroundColor,
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 16,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: backgroundColor,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: accentColor,
        textTheme: ButtonTextTheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(accentColor),
          foregroundColor: WidgetStateProperty.all(backgroundColor),
          iconColor: WidgetStateProperty.all(backgroundColor),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: accentColor,
        selectionColor: accentColor.withOpacity(0.5),
        selectionHandleColor: accentColor,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(accentColor),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBackgroundColor,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: textSecondaryColor),
        ),
        hintStyle: TextStyle(color: textSecondaryColor),
        labelStyle: TextStyle(color: textPrimaryColor),
        prefixIconColor: accentColor,
        suffixIconColor: accentColor,
      ),
      iconTheme: IconThemeData(color: accentColor),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
      ),
      shadowColor: shadowColor,
    );
  }

  static AppBar appBarSemVoltar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Image.asset(
        'logo.png',
        fit: BoxFit.cover,
        height: 100,
      ),
    );
  }

  static AppBar appBar() {
    return AppBar(
      centerTitle: true,
      title: Image.asset(
        'logo.png',
        fit: BoxFit.cover,
        height: 100,
      ),
    );
  }
}
