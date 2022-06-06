import 'package:flutter/material.dart';
import 'package:place/helpers/db_helper.dart';
import 'package:place/screens/add_place_screen.dart';
import 'package:place/screens/index_place_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DBHelper.places();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: const IndexPlaceScreen(),
      routes: {AddPlaceScreen.route: (context) => AddPlaceScreen()},
    );
  }
}
