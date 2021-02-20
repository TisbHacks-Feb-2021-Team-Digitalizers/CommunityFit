import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_fit/models/dish.dart';
import 'package:community_fit/models/userData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class DatabaseService {
  static final usersRef = FirebaseFirestore.instance.collection('users');
  final User user;
  const DatabaseService({
    @required this.user,
  });

  Future<void> addUser() async {
    final userData = UserData(
      uid: user.uid,
    );

    final documentSnapshot = await usersRef.doc(user.uid).get();
    if (!documentSnapshot.exists) {
      await usersRef.doc(user.uid).set(userData.toMap());
    }
  }

  Future<DocumentReference> addDish(Dish dish) async {
    final dishesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('dishes');

    final documentReference = await dishesRef.add(
      dish.toMap(),
    );
    return documentReference;
  }

  List<Dish> _dishesFromQuerySnapshot(QuerySnapshot qs) {
    return qs.docs.map((doc) {
      print(doc.data());
      return Dish.fromMap(
        doc.data(),
      );
    }).toList();
  }

  Stream<List<Dish>> userDishesStream() {
    final dishesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('dishes');

    return dishesRef.snapshots().map(_dishesFromQuerySnapshot);
  }
}
