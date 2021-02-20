class Dish {
  Dish({
    this.dishId,
    this.photoUrl,
    this.name,
  });

  final String dishId;
  final String photoUrl;
  final String name;

  factory Dish.fromMap(Map<String, dynamic> json) => Dish(
        dishId: json["dishId"],
        photoUrl: json["photoURL"],
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "dishId": dishId,
        "photoURL": photoUrl,
        "name": name,
      };
}
