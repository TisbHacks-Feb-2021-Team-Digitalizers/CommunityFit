import 'dart:io';

import 'package:community_fit/constants/colors.dart';
import 'package:community_fit/models/dish.dart';
import 'package:community_fit/shared/apiServiceProvider.dart';
import 'package:community_fit/shared/databaseService.dart';
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
    StateProvider.autoDispose.family<UploadTask, List>((ref, params) {
  final storageService = ref.watch(storageServiceProvider);
  ref.maintainState = true;
  return storageService.uploadFile(params);
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
          if (imageFile == null)
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
  final _formKey = GlobalKey<FormState>();
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
          } else {
            return null;
          }
        },
        obscureText: false,
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
            ),
            hintText: "Enter dish name here",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(40.0))),
      ),
    );
  }

  Container _form(BuildContext context, String filePath) {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 30.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _dishNameField(context),
            SizedBox(
              height: 20,
            ),
            _submitButton(context, filePath),
          ],
        ),
      ),
    );
  }

  InkWell _submitButton(BuildContext context, String filePath) {
    return InkWell(
      borderRadius: BorderRadius.circular(80.0),
      onTap: () async {
        if (_formKey.currentState.validate()) {
          // incur database service
          final storageService = context.read(storageServiceProvider);
          final apiService = context.read(apiServiceProvider);
          final dishName = context.read(_dishNameProvider).state;
          final edamamApiResponse = await apiService.searchEdamam(dishName);
          print('the edamam response is');
          print(edamamApiResponse);
          final databaseService =
              await context.read(databaseServiceProvider.future);
          await databaseService.updateScore(edamamApiResponse);
          await databaseService.addDish(
            Dish(
              photoUrl: await storageService.getPhotoUrlForDish(filePath),
              name: dishName,
            ),
          );
          Navigator.pop(context);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.green, Colors.green]),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: Text(
          "Submit",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final file = watch(_imageStateProvider).state;
    final filePath = 'images/${DateTime.now()}.jpeg';
    final uploadTask = watch(_uploadTaskProvider([filePath, file])).state;
    return StreamBuilder<TaskSnapshot>(
      stream: uploadTask.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
              if (taskSnapshot.state == TaskState.success)
                _form(context, filePath)
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
