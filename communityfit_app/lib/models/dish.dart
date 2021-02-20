import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Dish {
  Dish({
    @required this.dishId,
    @required this.photoURL,
    @required this.name,
    @required this.createdAt,
  });

  final String dishId;
  final String photoURL;
  final String name;
  final Timestamp createdAt;

  factory Dish.fromMap(Map<String, dynamic> json) => Dish(
        dishId: json["dishId"],
        photoURL: json["photoURL"],
        name: json["name"],
        createdAt: Timestamp.fromDate(
          DateTime.parse(
            json["createdAt"],
          ),
        ),
      );

  Map<String, dynamic> toMap() => {
        "dishId": dishId,
        "photoURL": photoURL,
        "name": name,
        "createdAt": createdAt.toDate().toIso8601String(),
      };
}
