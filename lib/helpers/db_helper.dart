import 'package:place/models/place.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart' as path;

class DBHelper {
  static Future<Database> _openDB() async {
    return openDatabase(path.join(await getDatabasesPath(), 'sites.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE places (id INTEGER PRIMARY KEY, name TEXT, image TEXT)");
    }, version: 1);
  }

  static Future<int> insert(Place place) async {
    Database database = await _openDB();
    return database.insert("places", place.toMap());
  }

  static Future<int> update(Place place) async {
    Database database = await _openDB();
    return database.update("places", place.toMap(),
        where: 'id = ?', whereArgs: [place.id]);
  }

  static Future<int> delete(Place place) async {
    Database database = await _openDB();
    return database.delete("places", where: 'id = ?', whereArgs: [place.id]);
  }

  static Future<List<Place>> places() async {
    Database database = await _openDB();

    final List<Map<String, dynamic>> placesMap = await database.query("places");

    for (var p in placesMap) {
      print("${p['id']}  ${p['name']} ");
    }

    return List.generate(
        placesMap.length,
        (i) => Place(
            id: placesMap[i]['id'],
            name: placesMap[i]['name'],
            image: placesMap[i]['image']));
  }
}
