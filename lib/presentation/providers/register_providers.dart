import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

final clockProvider = StreamProvider<DateTime>((ref) {
  return Stream<DateTime>.periodic(
    const Duration(seconds: 1),
        (_) => DateTime.now(),
  );
});


final formattedDateProvider = StreamProvider<String>((ref) async* {
  await initializeDateFormatting('es_ES');

  yield* Stream.periodic(const Duration(seconds: 1), (_) {
    final now = DateTime.now();
    return DateFormat("EEEE d 'de' MMMM 'del' y", 'es_ES').format(now);
  });
});

final validateAccessToLocation = FutureProvider<bool>((ref) async {
  var permissions = await Geolocator.checkPermission();
  if (permissions == LocationPermission.deniedForever) {
    Geolocator.openAppSettings();
    return false;
  }

  if (permissions == LocationPermission.always || permissions == LocationPermission.always) {
    return true;
  }

  permissions = await Geolocator.requestPermission();
  if (permissions == LocationPermission.denied || permissions == LocationPermission.deniedForever) {
    Geolocator.openAppSettings();
    return false;
  }

  return true;
});

final locationStreamProvider = StreamProvider<Position>((ref) {
  const settings = LocationSettings(
    accuracy: LocationAccuracy.best,
  );
  return Geolocator.getPositionStream(locationSettings: settings);
});

final locationProvider = FutureProvider<Position>((ref) {
  const settings = LocationSettings(
    accuracy: LocationAccuracy.best,
  );
  return Geolocator.getCurrentPosition(locationSettings: settings);
});