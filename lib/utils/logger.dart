import 'package:flutter/foundation.dart';

class Logger {
  static void d(String message) {
    if (kDebugMode) {
      print("iiPlannerDebug: $message");
    }
  }
}
