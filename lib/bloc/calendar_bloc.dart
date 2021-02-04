import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import "package:googleapis/calendar/v3.dart" as googleCalendar;
import "package:googleapis_auth/auth_io.dart" as googleAuth;
import 'package:url_launcher/url_launcher.dart' as urlLauncher;

class CalendarBloc {
  static const KEY_G_CALENDAR_API_KEY_ANDROID = "gcalendar_api_key_android";
  static const IIPLANNER_CALENDAR_SUMMARY = "iiplanner_calendar_summary";

  static const _scopes = const [googleCalendar.CalendarApi.CalendarScope];

  googleAuth.ClientId _credentials;
  googleAuth.AuthClient _client;
  googleCalendar.CalendarApi _calendarApi;
  googleCalendar.Calendar _calendar;

  void createCalendar() async {
    await _init();

    final calendar = googleCalendar.Calendar();
    calendar.summary = "iiplanner";

    _calendar = await _calendarApi.calendars.insert(calendar);
    print("ADDEDDD_________________${_calendar.summary} ${_calendar.id}");
  }

  Future<bool> hasIIPlannerCalendar() async {
    print("hasIIPlannerCalendar");

    await _init();

    print("hasIIPlannerCalendar");
    final calendarList = await _calendarApi.calendarList.list();
    print("calendarList $calendarList");
    final calendarEntry = calendarList.items
        .firstWhere((it) => it.summary == IIPLANNER_CALENDAR_SUMMARY);
    print("calendarEntry $calendarEntry");
    if (calendarEntry != null) {
      _calendar = await _calendarApi.calendars.get(calendarEntry.id);
    }

    print("_calendar $_calendar");

    return _calendar != null;
  }

  void prompt(String url) async {
    if (await urlLauncher.canLaunch(url)) {
      await urlLauncher.launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _init() async {
    _credentials ??= await _initCredentials();
    _client ??= await _iniAuthClient();
    _calendarApi ??= googleCalendar.CalendarApi(_client);
  }

  Future<googleAuth.ClientId> _initCredentials() async {
    if (Platform.isAndroid) {
      final remoteConfig = await RemoteConfig.instance;
      await remoteConfig.setDefaults(<String, dynamic>{
        KEY_G_CALENDAR_API_KEY_ANDROID: "",
      });
      await remoteConfig.fetch();
      await remoteConfig.activateFetched();
      final apiKey = remoteConfig.getString(KEY_G_CALENDAR_API_KEY_ANDROID);

      print("$apiKey received");

      if (apiKey.isEmpty) {
        throw Exception("failed to get api key");
      }

      return googleAuth.ClientId(apiKey, "");
    } else if (Platform.isIOS) {
      throw Exception("Not implemented");
    }
    throw Exception("failed to return auth client");
  }

  Future<googleAuth.AuthClient> _iniAuthClient() async {
    return googleAuth.clientViaUserConsent(
      _credentials,
      _scopes,
      prompt,
    );
  }
}
