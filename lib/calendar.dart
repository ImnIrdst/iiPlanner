import 'dart:io';

import "package:googleapis/calendar/v3.dart" as googleCalendar;
import "package:googleapis_auth/auth_io.dart" as googleAuth;
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class Credentials {
  googleAuth.ClientId _credentials;

  static const _scopes = const [googleCalendar.CalendarApi.CalendarScope];

  Credentials() {
    if (Platform.isAndroid) {
      _credentials = new googleAuth.ClientId("", "");
    } else if (Platform.isIOS) {
      throw Exception("Not implemented");
    }
  }

  void createCalendar() {
    try {
      googleAuth
          .clientViaUserConsent(_credentials, _scopes, prompt)
          .then((googleAuth.AuthClient client) {
        var calendarApi = googleCalendar.CalendarApi(client);
        var calendar = googleCalendar.Calendar();
        calendar.summary = "iiplanner";
        calendarApi.calendars.insert(calendar).then((value) {
          print("ADDEDDD_________________$value");
        });
      });
    } catch (e) {
      print('Error creating event $e');
    }
  }

  void prompt(String url) async {
    print("Please go to the following URL and grant access:");
    print("  => $url");
    print("");

    if (await urlLauncher.canLaunch(url)) {
      await urlLauncher.launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
