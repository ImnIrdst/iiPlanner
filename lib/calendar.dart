import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import "package:googleapis/calendar/v3.dart" as googleCalendar;
import "package:googleapis_auth/auth_io.dart" as googleAuth;
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class Credentials {
  googleAuth.ClientId _credentials;

  static const _scopes = const [googleCalendar.CalendarApi.CalendarScope];
  static const KEY_G_CALENDAR_API_KEY_ANDROID = "gcalendar_api_key_android";

  void createCalendar() async {
    try {
      if (_credentials == null) {
        if (Platform.isAndroid) {
          final remoteConfig = await RemoteConfig.instance;
          await remoteConfig.setDefaults(
              <String, dynamic>{KEY_G_CALENDAR_API_KEY_ANDROID: ""});
          await remoteConfig.fetch();
          await remoteConfig.activateFetched();
          final apiKey = remoteConfig.getString(KEY_G_CALENDAR_API_KEY_ANDROID);

          print("$apiKey received");

          if (apiKey.isEmpty) {
            throw Exception("failed to get api key");
          }

          _credentials = new googleAuth.ClientId(apiKey, "");
        } else if (Platform.isIOS) {
          throw Exception("Not implemented");
        }
      }

      var client = await googleAuth.clientViaUserConsent(
        _credentials,
        _scopes,
        prompt,
      );

      final calendarApi = googleCalendar.CalendarApi(client);
      final calendar = googleCalendar.Calendar();
      calendar.summary = "iiplanner";

      final value = await calendarApi.calendars.insert(calendar);
      print("ADDEDDD_________________$value");
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
