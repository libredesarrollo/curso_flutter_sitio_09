import 'package:flutter/material.dart';
import 'package:place/helpers/db_helper.dart';
import 'package:place/models/place.dart';

class PlacesProvider with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  Future<void> getAndPlaces() async {
    _places = await DBHelper.places();
    notifyListeners();
  }

  Future<void> addPlace(place) async {
    final id = await DBHelper.insert(place);
    place.id = id;
    _places.add(place);
    notifyListeners();
  }
}
