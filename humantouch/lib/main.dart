import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// pages
import 'Splash_page.dart';
import 'Welcome_page.dart';
import 'Login_page.dart';
import 'SignUp_page.dart';
import 'SignUpVolunteer_page.dart';
import 'SignUpCompanion_page.dart';
import 'SignUpPatient_page.dart';
import 'ForgetPassword_page.dart';
import 'Dashboard_page.dart';
import 'Reminders_page.dart';
import 'CompanionReminders_page.dart';
import 'Health_page.dart';
import 'Communication_page.dart';
import 'Emergency_page.dart';
import 'Map_page.dart';
import 'VolunteerHelp_page.dart';
import 'Profile_page.dart';
import 'Profile2_page.dart';
import 'Settings_page.dart';
import 'AddHealthTip_page.dart';

// stores
import 'emergency_settings_store.dart';
import 'profile_store.dart';
// import 'reminder_store.dart';

// notification
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp();

  // Localization
  await initializeDateFormatting('en', null);
  await initializeDateFormatting('ar', null);

  // Local Notifications
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();

  const InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await notificationsPlugin.initialize(initSettings);

  runApp(const HumanTouchApp());
}

class HumanTouchApp extends StatelessWidget {
  const HumanTouchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EmergencySettingsStore>.value(
          value: EmergencySettingsStore.instance,
        ),
        ChangeNotifierProvider<ProfileStore>.value(
          value: ProfileStore.instance,
        ),

        // لو فعلتيه بعدين
        // ChangeNotifierProvider<ReminderStore>.value(
        //   value: ReminderStore.instance,
        // ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Human Touch',

        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('ar')],

        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF4F4F4),
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF87CEEB)),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF87CEEB),
            elevation: 0,
            centerTitle: true,
            foregroundColor: Colors.black,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFFF4F4F4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF87CEEB),
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF87CEEB),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 3,
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        initialRoute: '/splash',

        routes: {
          '/splash': (context) => const SplashPage(),
          '/welcome': (context) => const WelcomePage(),
          '/login': (context) => const LoginPage(),
          '/signup': (context) => const SignUpPage(),
          '/signupVolunteer': (context) => const SignUpVolunteerPage(),
          '/signupCompanion': (context) => const SignUpCompanionPage(),
          '/signupPatient': (context) => const SignUpPatientPage(),
          '/forgetPassword': (context) => const ForgetPasswordPage(),
          '/dashboard': (context) => const DashboardPage(),
          '/reminders': (context) => const RemindersPage(),
          '/companionReminders': (context) => const CompanionRemindersPage(),
          '/health': (context) => const HealthPage(),
          '/communication': (context) => const CommunicationPage(),
          '/emergency': (context) => const EmergencyPage(),
          '/map': (context) => const MapPage(),
          '/volunteerHelp': (context) => const VolunteerHelpPage(),
          '/profile': (context) => const ProfilePage(),
          '/profile2': (context) => const Profile2Page(),
          '/settings': (context) => const SettingsPage(),
          '/addHealthTip': (context) => const AddHealthTipPage(),
        },

        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(
                child: Text('Page not found', style: TextStyle(fontSize: 20)),
              ),
            ),
          );
        },
      ),
    );
  }
}
