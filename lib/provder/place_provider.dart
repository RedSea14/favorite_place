import 'dart:io';

import 'package:favorite_place_app/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart' as pathprovider;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    p.join(dbPath, 'place1.db'),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE Places123 (id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL,lng REAL, address TEXT)');
    },
    version: 1,
  );
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<PlaceModel>> {
  UserPlacesNotifier() : super(const []);
  Future<void> loadPlace() async {
    final db = await _getDatabase();
    final data = await db.query('Places123');
    final places = data
        .map(
          (e) => PlaceModel(
            id: e['id'] as String,
            title: e['title'] as String,
            image: File(e['image'] as String),
            location: PlaceLocation(
              latitude: e['lat'] as double,
              longitude: e['lng'] as double,
              address: e['address'] as String,
            ),
          ),
        )
        .toList();
    state = places;
  }

  void addPlace(String title, File image, PlaceLocation location) async {
    final appDir = await pathprovider.getApplicationDocumentsDirectory();
    final filename = p.basename(image.path);
    final copiedImg = await image.copy('${appDir.path}/$filename');
    final newPlace =
        PlaceModel(title: title, image: copiedImg, location: location);
    final db = await _getDatabase();
    db.insert('Places123', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'lat': newPlace.location.latitude,
      'lng': newPlace.location.longitude,
      'address': newPlace.location.address
    });
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<PlaceModel>>(
  (ref) => UserPlacesNotifier(),
);
