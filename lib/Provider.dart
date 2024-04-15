import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users/provider2.dart';

class ThemeProvider extends ChangeNotifier {
  void toggleTheme(BuildContext context) {
    final themeProvider = Provider.of<ThemePersistenceProvider>(context, listen: false);
    themeProvider.saveTheme(themeProvider.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
