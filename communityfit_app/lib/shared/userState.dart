import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStateStreamProvider = StreamProvider.autoDispose<User>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
