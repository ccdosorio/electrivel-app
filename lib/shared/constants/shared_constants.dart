import 'package:flutter/material.dart';

// External dependencies
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SharedConstants {

  static final Map<String, IconData> iconNative = {
    "alarm": Icons.alarm,
    "build": Icons.build,
    "ambulance": Icons.fire_truck_outlined,
    "group": Icons.group,
    "pending_actions": Icons.pending_actions
  };

  static String get urlBase => '${dotenv.get('API_URL')}:${dotenv.get('API_URL_PORT')}/api/v1';
  static bool get isDev => dotenv.get('ENV') == 'dev';
}
