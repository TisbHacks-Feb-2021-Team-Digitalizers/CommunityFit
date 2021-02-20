import 'package:meta/meta.dart';

class UserData {
  UserData({
    @required this.uid,
    @required this.photoUrl,
    @required this.email,
    @required this.displayName,
    @required this.score,
  });

  final String uid;
  final String photoUrl;
  final String email;
  final String displayName;
  final double score;

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        uid: json["uid"],
        photoUrl: json["photoURL"],
        email: json["email"],
        displayName: json["displayName"],
        score: json["score"].toDouble(),
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
        "photoURL": photoUrl,
        "email": email,
        "displayName": displayName,
        "score": score,
      };
}
