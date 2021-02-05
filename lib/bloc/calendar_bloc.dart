import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:googleapis/calendar/v3.dart";
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';

class CalendarBloc {
  static const IIPLANNER_CALENDAR_SUMMARY = "iiplanner";

  AuthClient _client;
  GoogleSignInAccount _currentUser;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const ["https://www.googleapis.com/auth/calendar.app.created"],
  );

  Calendar _calendar;

  Future<void> _init() async {
    await signInWithGoogle();
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    _currentUser = await _googleSignIn.signIn();
    _client ??= await _googleSignIn.authenticatedClient();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await _currentUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> createCalendar() async {
    await _init();

    final calendarApi = CalendarApi(_client);

    final calendar = Calendar();
    calendar.summary = "iiplanner";

    _calendar = await calendarApi.calendars.insert(calendar);
    print("ADDEDDD_________________${_calendar.summary} ${_calendar.id}");
  }

  Future<bool> hasIIPlannerCalendar() async {
    print("hasIIPlannerCalendar");

    await _init();

    final calendarApi = CalendarApi(_client);
    final calendarList = await calendarApi.calendarList.list();
    print("calendarList ${calendarList.items}");
    CalendarListEntry calendarEntry;
    calendarList.items.forEach((it) {
      if (it.summary == IIPLANNER_CALENDAR_SUMMARY) {
        calendarEntry = it;
      }
    });
    print("for finished");
    print("calendarEntry $calendarEntry");
    if (calendarEntry != null) {
      _calendar = await calendarApi.calendars.get(calendarEntry.id);
    }

    print("_calendar $_calendar");

    return _calendar != null;
  }
}
