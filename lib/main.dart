import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:learn_flutter/splashScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}


Future<void> onSelectNotification(String? payload) async {
  // Handle notification click here (optional)
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'CulturTap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        fontFamily: 'Poppins',
        

        primaryColor: Color(0xFF001B33), // Change the primary color
        // accentColor: Colors.orange, // Change the accent color
        backgroundColor: Colors.white, // Change the background color
        scaffoldBackgroundColor: Colors.grey[200], // Change the scaffold background color
        // Add more color properties as needed

        // Custom Text Styles
        textTheme: TextTheme(
          bodyText1: TextStyle(fontSize: 16.0), // Adjust the font size as needed
          bodyText2: TextStyle(fontSize: 14.0), // Adjust the font size as needed
          headline1: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold), // Adjust the font size and weight as needed
        ),

        // Optional: Define colors for specific components
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // Change the AppBar background color
          foregroundColor: Colors.white, // Change the AppBar text color
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.orange, // Change the FloatingActionButton color
        ),
      ),

      home: splashScreen(),
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override


  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
}
