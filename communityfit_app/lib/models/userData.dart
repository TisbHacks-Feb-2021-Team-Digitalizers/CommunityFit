import 'package:meta/meta.dart';

class UserData {
  UserData({
    @required this.uid,
  });

  final String uid;

  factory UserData.fromMap(Map<String, dynamic> json) => UserData(
        uid: json["uid"],
      );

  Map<String, dynamic> toMap() => {
        "uid": uid,
      };
}
