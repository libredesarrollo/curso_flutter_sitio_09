import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspath;

import 'package:place/helpers/db_helper.dart';
import 'package:place/models/place.dart';

class AddPlaceScreen extends StatefulWidget {
  static const route = "/place/add";

  AddPlaceScreen({Key? key}) : super(key: key);

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  var _routeImage = "";
  var _showErrorImage = false;
  String _keyImageField = "";

  late Place place;

  _selectedImage(String routeImage) {
    _routeImage = routeImage;
  }

  _init() {
    _nameController.text = place.name;
    _routeImage = place.image;
  }

  @override
  Widget build(BuildContext context) {
    place = ModalRoute.of(context)!.settings.arguments == null
        ? Place.empty()
        : ModalRoute.of(context)!.settings.arguments as Place;

    _init();

    return Scaffold(
      appBar: AppBar(title: const Text("Places")),
      body: Column(children: [
        Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: _nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "You have to put a name to the site";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    labelText: "Name", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 15,
              ),
              _ImageField(
                key: Key(_keyImageField),
                onSelectedImage: _selectedImage,
                imageDefault: _routeImage,
              ),
              if (_showErrorImage)
                const Text("Image not selected",
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ElevatedButton(
                  onPressed: () {
                    if (_routeImage == "") {
                      _showErrorImage = true;
                      setState(() {});
                      return;
                    } else {
                      _showErrorImage = false;
                      setState(() {});
                    }

                    if (_formKey.currentState!.validate()) {
                      // Guardar en la BD

                      place.name = _nameController.text;
                      place.image = _routeImage;

                      if (place.id == 0) {
                        DBHelper.insert(place);
                        place = Place.empty();
                        _init();
                        var ran = Random();
                        _keyImageField = ran.nextInt(100).toString();
                        setState(() {});
                      } else {
                        DBHelper.update(place);
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Added Site")));
                    }
                  },
                  child: const Text("Send"))
            ])),
      ]),
    );
  }
}

class _ImageField extends StatefulWidget {
  final Function onSelectedImage;
  final String imageDefault;

  const _ImageField(
      {Key? key, required this.onSelectedImage, this.imageDefault = ""})
      : super(key: key);

  @override
  State<_ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<_ImageField> {
  File? _imagePlace;

  @override
  void initState() {
    try {
      _imagePlace =
          widget.imageDefault != "" ? File(widget.imageDefault) : null;
    } catch (e) {
      print("Error al convertir el archivo");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 160,
            height: 100,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.purple)),
            child: _imagePlace == null
                ? const Icon(Icons.image, color: Colors.purple)
                : Image.file(_imagePlace!)),
        TextButton(
          onPressed: imagePicker,
          child: const Text("Pick a photo"),
        ),
        TextButton(
          onPressed: cameraPicker,
          child: const Text("Take a photo"),
        )
      ],
    );
  }

  Future imagePicker() async {
    final imageFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 60);

    if (imageFile == null) {
      return;
    }
    setState(() {
      _imagePlace = File(imageFile.path);
    });

    _saveImageLocal();
  }

  Future cameraPicker() async {
    final imageFile = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 60);

    if (imageFile == null) {
      return;
    }
    setState(() {
      _imagePlace = File(imageFile.path);
    });

    _saveImageLocal();
  }

  _saveImageLocal() async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(_imagePlace!.path);
    /*final savedImage = */ await _imagePlace!.copy('${appDir.path}/$fileName');

    widget.onSelectedImage(_imagePlace!.path);
  }
}
