import 'dart:io';

import 'package:flutter/material.dart';
import 'package:place/helpers/db_helper.dart';

import 'package:place/models/place.dart';
import 'package:place/providers/PlacesProvider.dart';
import 'package:place/screens/add_place_screen.dart';
import 'package:provider/provider.dart';

class IndexPlaceScreen extends StatefulWidget {
  const IndexPlaceScreen({Key? key}) : super(key: key);

  @override
  State<IndexPlaceScreen> createState() => _IndexPlaceScreenState();
}

class _IndexPlaceScreenState extends State<IndexPlaceScreen> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() async {
    //places = await DBHelper.places();
    await Provider.of<PlacesProvider>(context, listen: false).getAndPlaces();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // places = Provider.of<PlacesProvider>(context).places;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Places"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPlaceScreen.route);
              },
              icon: const Icon(Icons.add_location))
        ],
      ),
      body: Consumer<PlacesProvider>(
        child: const Text("Not places to show"),
        builder: (_, placesProvider, child) =>
            (child != null && placesProvider.places.length == 0)
                ? child
                : ListView.builder(
                    itemCount: placesProvider.places.length,
                    itemBuilder: (context, index) => Dismissible(
                          background: Container(),
                          secondaryBackground: Container(
                            color: Colors.red,
                            child: const Center(
                              child: Text(
                                "Borrar",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          key: Key(placesProvider.places[index].id.toString()),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            setState(() {
                              // DBHelper.delete(placesProvider.places[index]);
                              placesProvider
                                  .deletePlace(placesProvider.places[index]);

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text("Site Removed")));

                              //placesProvider.places.removeAt(index);
                            });
                          },
                          child: ListTile(
                            onLongPress: () => Navigator.pushNamed(
                                context, AddPlaceScreen.route,
                                arguments: placesProvider.places[index]),
                            title: Text(placesProvider.places[index].name),
                            leading: CircleAvatar(
                                backgroundImage: FileImage(
                                    File(placesProvider.places[index].image))),
                          ),
                        )),
      ),
    );
  }
}
