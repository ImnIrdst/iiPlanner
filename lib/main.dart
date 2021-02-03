import 'package:flutter/material.dart';
import 'package:iiplanner/calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.amber,
          accentColor: Colors.amber,
          canvasColor: Colors.black,
          appBarTheme:
              Theme.of(context).appBarTheme.copyWith(color: Colors.black),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.dark),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to iiPlanner',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Credentials().createCalendar();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
