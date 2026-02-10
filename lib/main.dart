import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:univtime/provider/google_sign_in.dart';
import 'package:univtime/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:calendar_view/calendar_view.dart';
import 'screens/checklist.dart';
import 'package:provider/provider.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferences.getInstance();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: CalendarControllerProvider(
        controller: EventController(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'UnivTime',
          theme: appTheme,
          home: const WelcomeScreen(),
        ),
      ),
    );
  }
}
