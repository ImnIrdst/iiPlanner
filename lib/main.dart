import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:iiplanner/screens/home.dart';
import 'package:iiplanner/widgets/loading.dart';
import 'package:iiplanner/widgets/something_went_wrong.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return IIPlannerApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

class IIPlannerApp extends StatelessWidget {
  final primaryColor = Colors.amber;

  ButtonThemeData _getButtonTheme(context) {
    return Theme.of(context).buttonTheme.copyWith(buttonColor: primaryColor);
  }

  AppBarTheme _getAppBarTheme(context) {
    return Theme.of(context).appBarTheme.copyWith(color: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iiPlanner',
      theme: ThemeData(
          primarySwatch: primaryColor,
          accentColor: primaryColor,
          canvasColor: Colors.black,
          buttonTheme: _getButtonTheme(context),
          appBarTheme: _getAppBarTheme(context),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark),
      home: MyHomePage(title: 'iiPlanner'),
    );
  }
}
