// External dependencies
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SharedConstants {
  static String get urlBase => '${dotenv.get('API_URL')}:${dotenv.get('API_URL_PORT')}/api/v1';
  static bool get isDev => dotenv.get('ENV') == 'dev';
}
