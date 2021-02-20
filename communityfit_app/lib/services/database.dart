import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_fit/models/dish.dart';
import 'package:community_fit/models/edamamApiResponse.dart';
import 'package:community_fit/models/userData.dart';
import 'package:community_fit/utils.dart';
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
      photoUrl: user.photoURL,
      displayName: user.displayName,
      email: user.email,
      score: 0,
    );

    final documentSnapshot = await usersRef.doc(user.uid).get();
    if (!documentSnapshot.exists) {
      await usersRef.doc(user.uid).set(userData.toMap());
    }
  }

  Future<void> updateScore(EdamamApiResponse edamamApiResponse) async {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(usersRef.doc(user.uid));
      transaction.update(freshSnapshot.reference, {
        'score': calculateScoreFromEdamamResponse(
          freshSnapshot['score'],
          edamamApiResponse,
        )
      });
    });
  }

  UserData _userDataFromDocumentSnapshot(DocumentSnapshot ds) {
    return UserData.fromMap(ds.data());
  }

  Stream<UserData> get userDataStream {
    print('The value of user is');
    print(user);
    return usersRef
        .doc(user.uid)
        .snapshots()
        .map(_userDataFromDocumentSnapshot);
  }

  Future<DocumentReference> addDish(Dish dish) async {
    final dishesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('dishes');

    final documentReference = await dishesRef.add({
      'photoURL': dish.photoUrl,
      'name': dish.name,
    });
    return documentReference;
  }

  Future<List<UserData>> getTopUsers() async {
    final querySnapshot = await usersRef
        .orderBy(
          'score',
          descending: false,
        )
        .limit(30)
        .get();
    return _usersFromQuerySnapshot(querySnapshot);
  }

  Future<List<Dish>> getDishesByUser(String uid) async {
    final querySnapshot =
        await usersRef.doc(uid).collection('dishes').limit(20).get();
    return _dishesFromQuerySnapshot(querySnapshot);
  }

  List<UserData> _usersFromQuerySnapshot(QuerySnapshot qs) {
    print(qs.docs);
    return qs.docs.map((doc) {
      print(doc.data());
      return UserData.fromMap(
        doc.data(),
      );
    }).toList();
  }

  List<Dish> _dishesFromQuerySnapshot(QuerySnapshot qs) {
    return qs.docs.map((doc) {
      return Dish.fromMap(
        {
          ...doc.data(),
          'dishId': doc.id,
        },
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
