// Dart
import 'dart:async';

// Internal dependencies
import 'package:electrivel_app/services/services.dart';
import 'package:electrivel_app/shared/shared.dart';
import 'package:firebase_core/firebase_core.dart';

// External dependencies
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';

import 'firebase_options.dart';

// The callback function should always be a top-level or static function.
@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(MyTaskHandler());
}

class MyTaskHandler extends TaskHandler {
  StreamSubscription<Position>? _sub;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform
    );
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await FlutterForegroundTask.updateService(
        notificationTitle: 'GPS desactivado',
        notificationText: 'Activa la ubicación para continuar.',
      );
      return;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      await FlutterForegroundTask.updateService(
        notificationTitle: 'Permiso denegado',
        notificationText: 'Otorga permisos de ubicación en la app.',
      );
      return;
    }

    const settings = LocationSettings(accuracy: LocationAccuracy.bestForNavigation);
    _sub = Geolocator.getPositionStream(locationSettings: settings).listen((pos) async {
      final model = LocationModel(
        lat: pos.latitude,
        lng: pos.longitude
      );

      final username = await SharedPreferencesPlugin.getStringValue(key: SharedPreferencesConstants.username);
      DatabaseDatasource().create(path: username, locationModel: model);
    });
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _sub?.cancel();
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}
}
