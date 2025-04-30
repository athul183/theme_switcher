import 'package:flutter/material.dart' hide ThemeMode;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

class ThemeModel with ChangeNotifier {
  static const _prefsKey = 'app_theme_mode';
  late ThemeData _currentTheme;
  late AppThemeMode _themeMode;

  ThemeData get currentTheme => _currentTheme;
  AppThemeMode get themeMode => _themeMode;

  ThemeModel() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = AppThemeMode
        .values[prefs.getInt(_prefsKey) ?? AppThemeMode.system.index];
    _setThemeMode(mode);
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsKey, mode.index);
    _setThemeMode(mode);
    notifyListeners();
  }

  void _setThemeMode(AppThemeMode mode) {
    _themeMode = mode;
    _currentTheme = _getThemeData();
  }

  ThemeData _getThemeData() {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeData.light();
      case AppThemeMode.dark:
        return ThemeData.dark();
      default:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
                Brightness.dark
            ? ThemeData.dark()
            : ThemeData.light();
    }
  }
}

class ThemeSwitcher extends StatelessWidget {
  final Widget Function(BuildContext, ThemeData) builder;

  const ThemeSwitcher({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, _) {
          return MaterialApp(
            theme: themeModel.currentTheme,
            home: Builder(
              builder: (context) => builder(context, themeModel.currentTheme),
            ),
          );
        },
      ),
    );
  }
}
