import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final _storage = FirebaseStorage.instance;

  UploadTask uploadFile(File file) {
    return _storage.ref().child('images/${DateTime.now()}.jpeg').putFile(file);
  }
}
