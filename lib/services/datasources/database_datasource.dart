// External dependencies
import 'package:firebase_database/firebase_database.dart';

class LocationModel {
  final double lng;
  final double lat;

  const LocationModel({required this.lng, required this.lat});

  Map<String, dynamic> toMap() {
    return {
      'lng': lng,
      'lat': lat,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      lng: (map['lng'] as num).toDouble(),
      lat: (map['lat'] as num).toDouble(),
    );
  }
}

class DatabaseDatasource {

  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Future<void> create({
    required String path,
    required LocationModel locationModel
  }) async {
    final ref = _firebaseDatabase.ref().child(path);
    await ref.set(locationModel.toMap());
  }

  Stream<DataSnapshot> read({required String path}) {
    final ref = _firebaseDatabase.ref().child(path);
    return ref.onValue.map((DatabaseEvent event) => event.snapshot);
  }

  Future<void> update({
    required String path,
    required LocationModel locationModel
  }) async {
    final ref = _firebaseDatabase.ref().child(path);
    await ref.update(locationModel.toMap());
  }

  Future<void> delete({
    required String path
  }) async {
    final ref = _firebaseDatabase.ref().child(path);
    await ref.remove();
  }

}