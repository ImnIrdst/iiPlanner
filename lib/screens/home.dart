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
  void dispose() {
    _calendar.release();
    super.dispose();
  }

  @override
  void initState() {
    _calendar.hasIIPlannerCalendar();
    super.initState();
  }

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
            StreamBuilder<CalendarState>(
              initialData: CalendarState(isLoading: true),
              stream: _calendar.calendarStateStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.isLoading == true) {
                  return Loading();
                } else {
                  final calendar = snapshot.data.calendar;
                  if (calendar != null) {
                    return Center(
                      child: Text(calendar),
                    );
                  } else {
                    return RaisedButton(
                      onPressed: () async {
                        await _calendar.createCalendar();
                        setState(() {});
                      },
                      child: Text('Create iiPlanner Google Calendar'),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
