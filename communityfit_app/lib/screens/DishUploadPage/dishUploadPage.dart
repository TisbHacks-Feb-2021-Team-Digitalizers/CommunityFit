import 'dart:io';

import 'package:community_fit/constants/colors.dart';
import 'package:community_fit/shared/storageService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final _imageStateProvider = StateProvider.autoDispose<File>((ref) {
  ref.maintainState = true;
  return null;
});
final _uploadTaskProvider =
    StateProvider.autoDispose.family<UploadTask, File>((ref, file) {
  final storageService = ref.watch(storageServiceProvider);
  ref.maintainState = true;
  return storageService.uploadFile(file);
});

class DishUploadPage extends ConsumerWidget {
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    File selected = await ImagePicker.pickImage(
      source: source,
    );
    context.read(_imageStateProvider).state = selected;
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final imageFile = watch(_imageStateProvider).state;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('Add Dish'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          if (imageFile != null) ...[
            Container(
              padding: EdgeInsets.all(32),
              child: Image.file(imageFile),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  color: Colors.orange,
                  child: Icon(
                    Icons.refresh,
                  ),
                  onPressed: () {
                    context.read(_imageStateProvider).state = null;
                  },
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(32),
              child: Uploader(),
            )
          ],
          Center(
            child: RaisedButton.icon(
              label: Text('Upload Image'),
              icon: Icon(
                Icons.photo_library,
                size: 30,
              ),
              onPressed: () => _pickImage(
                context,
                ImageSource.gallery,
              ),
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

final _dishNameProvider = StateProvider.autoDispose((ref) {
  ref.maintainState = true;
  return '';
});

class Uploader extends ConsumerWidget {
  Container _dishNameField(BuildContext context) {
    return Container(
      child: TextFormField(
        initialValue: '',
        onChanged: (String value) {
          context.read(_dishNameProvider).state = value;
        },
        validator: (String val) {
          if (val.isEmpty) {
            return 'This field cannot be left empty';
          } else if (val.contains("@") == false) {
            return 'Not a valid email';
          } else {
            return null;
          }
        },
        obscureText: false,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
            ),
            hintText: "Enter email here",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final file = watch(_imageStateProvider).state;
    final uploadTask = watch(_uploadTaskProvider(file)).state;
    return StreamBuilder<TaskSnapshot>(
      stream: uploadTask.snapshotEvents,
      builder: (context, snapshot) {
        var taskSnapshot = snapshot.data;

        double progressPercent = taskSnapshot != null
            ? taskSnapshot.bytesTransferred / taskSnapshot.totalBytes
            : 0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (taskSnapshot.state == TaskState.success)
              Text(
                '🎉🎉🎉',
                style: TextStyle(
                  color: Colors.greenAccent,
                  height: 2,
                  fontSize: 30,
                ),
              ),
            if (taskSnapshot.state == TaskState.paused)
              FlatButton(
                child: Icon(Icons.play_arrow, size: 50),
                onPressed: uploadTask.resume,
              ),
            if (taskSnapshot.state == TaskState.running)
              FlatButton(
                child: Icon(Icons.pause, size: 50),
                onPressed: uploadTask.pause,
              ),
            LinearProgressIndicator(
              value: progressPercent,
            ),
            Text(
              '${(progressPercent * 100).toStringAsFixed(2)} % ',
              style: TextStyle(fontSize: 50),
            ),
            if (taskSnapshot.state == TaskState.success) ...[
              _dishNameField(context),
            ]
          ],
        );
      },
    );
  }
}
