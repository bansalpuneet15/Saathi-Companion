import 'package:elderlycompanion/screens/documents/view_documents.dart';
import 'package:elderlycompanion/screens/elders/link_elder.dart';
import 'package:elderlycompanion/screens/home/home_screen.dart';
import 'package:elderlycompanion/screens/loading/loading_screen.dart';
import 'package:elderlycompanion/screens/login/login_screen.dart';
import 'package:elderlycompanion/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // if (Firebase.apps.length == 0) {
  //   Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // } else {
  //   Firebase.app(); // if already initialized, use that one
  // }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterDownloader.initialize(debug: false);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elderly Companion',
      theme: ThemeData(
          fontFamily: GoogleFonts.lato().fontFamily,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme:
              TextTheme().apply(fontFamily: GoogleFonts.lato().fontFamily)),
      debugShowCheckedModeBanner: false,
      initialRoute: LoadingScreen.id,
      routes: {
        LoadingScreen.id: (context) => LoadingScreen(
              auth: Auth(),
            ),
        LoginScreen.id: (context) => LoginScreen(
              auth: Auth(),
            ),
        HomeScreen.id: (context) => HomeScreen(),
        LinkElder.id: (context) => LinkElder(),
        ViewDocuments.id: (context) => ViewDocuments(),
      },
      // home: LoadingScreen(
      //   auth: Auth(),
      // ),
    );
  }
}
