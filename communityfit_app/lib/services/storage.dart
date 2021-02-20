import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static final _storage = FirebaseStorage.instance;

  UploadTask uploadFile(List<dynamic> params) {
    String filePath = params[0];
    File file = params[1];
    return _storage.ref().child(filePath).putFile(file);
  }

  Future<String> getPhotoUrlForDish(String filePath) async {
    String downloadURL = await _storage.ref().child(filePath).getDownloadURL();
    return downloadURL;
  }
}
