import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_switcher/theme_switcher.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return IconButton(
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () => themeModel.setThemeMode(
        isDark ? AppThemeMode.light : AppThemeMode.dark,
      ),
    );
  }
}
