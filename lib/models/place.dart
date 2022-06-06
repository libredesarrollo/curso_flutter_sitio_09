class Place {
  int id = 0;
  String name = "";
  String image = "";

  Place.empty();

  Place({this.id = 0, required this.name, required this.image});

  Map<String, dynamic> toMap() {
    return id == 0
        ? {"name": name, "image": image}
        : {"id": id, "name": name, "image": image};
  }
}
