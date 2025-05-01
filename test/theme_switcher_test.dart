import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_switcher/theme_switcher.dart';
import 'package:theme_switcher/themetogglebutton.dart';

void main() {
  group('ThemeModel Tests', () {
    late ThemeModel model;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      model = ThemeModel();
      await Future.microtask(() {});
    });

    test('Initializes with system theme by default', () async {
      expect(model.themeMode, AppThemeMode.system);
    });

    test('Loads saved theme preference', () async {
      SharedPreferences.setMockInitialValues({'app_theme_mode': 1});
      final newModel = ThemeModel();
      await Future.microtask(() {});
      expect(newModel.themeMode, AppThemeMode.dark);
    });

    test('Persists theme change', () async {
      await model.setThemeMode(AppThemeMode.light);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('app_theme_mode'), 0);
    });
  });

  group('ThemeToggleButton Tests', () {
    Future<void> pumpToggleButton(WidgetTester tester,
        [AppThemeMode? initialMode]) async {
      SharedPreferences.setMockInitialValues(
        initialMode != null ? {'app_theme_mode': initialMode.index} : {},
      );

      await tester.pumpWidget(
        ThemeSwitcher(
          builder: (context, theme) => MaterialApp(
            theme: theme,
            home: Scaffold(
              body: ThemeToggleButton(),
            ),
          ),
        ),
      );
    }

    testWidgets('Toggles between light and dark themes', (tester) async {
      await pumpToggleButton(tester, AppThemeMode.light);

      expect(find.byIcon(Icons.dark_mode), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.light_mode), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('Respects system theme setting', (tester) async {
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.platformBrightnessTestValue = Brightness.dark;

      await pumpToggleButton(tester, AppThemeMode.system);
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });
  });
}
