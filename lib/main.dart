import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicify/pages/homepage.dart';
import 'package:musicify/welcome.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musicify',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        // primarySwatch: Colors.blue,
      ),
      // debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
