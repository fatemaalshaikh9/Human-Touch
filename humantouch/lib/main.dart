import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_settings_store.dart';
import 'l10n/app_localizations.dart';
import 'Splash_page.dart';

void main() {
  runApp(const HumanTouchApp());
}

class HumanTouchApp extends StatelessWidget {
  const HumanTouchApp({super.key});

  @override
  Widget build(BuildContext context) {
    final AppSettingsStore appSettings = AppSettingsStore.instance;

    return AnimatedBuilder(
      animation: appSettings,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Human Touch',
          locale: appSettings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          themeMode: appSettings.themeMode,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFF4F4F4),
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF87CEEB),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF87CEEB),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(appSettings.textScale),
              ),
              child: child!,
            );
          },
          home: const SplashPage(),
        );
      },
    );
  }
}
