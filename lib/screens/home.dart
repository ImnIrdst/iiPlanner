import 'package:flutter/material.dart';
import 'package:iiplanner/bloc/calendar_bloc.dart';
import 'package:iiplanner/widgets/loading.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _calendar = CalendarBloc();

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
            FutureBuilder(
              future: _calendar.hasIIPlannerCalendar(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    return Container();
                  } else {
                    return RaisedButton(
                      onPressed: () async {
                        await _calendar.createCalendar();
                        setState(() {});
                      },
                      child: Text('Create iiPlanner Google Calendar'),
                    );
                  }
                } else {
                  return Loading();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
