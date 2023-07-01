import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AppController extends GetxController {
  final RxList<String> _images = RxList<String>([]);
  final Rxn<File?> _pickedImage = Rxn<File?>();

  List<String> get images => _images.value;

  File? get pickedImage => _pickedImage.value;

  @override
  void onReady() {
    super.onReady();
    _images.bindStream(getUrls());
  }

  Stream<List<String>> getUrls() {
    return FirebaseFirestore.instance
        .collection('Images')
        .snapshots()
        .map((QuerySnapshot query) {
      List<String> urls = [];
      for (var doc in query.docs) {
        urls.add(doc['url']);
      }
      return urls;
    });
  }

  void pickImage() {
    final ImagePicker _picker = ImagePicker();
    _picker.pickImage(source: ImageSource.gallery).then((result) {
      if (result != null) {
        _pickedImage.value = File(result.path);
      }
    });
  }

  void upload() async {
    if (_pickedImage.value != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      final now = DateTime.now();
      storage
          .ref()
          .child('images/$now.jpg')
          .putFile(_pickedImage.value!)
          .whenComplete(() {})
          .then((snapshot) {
        snapshot.ref.getDownloadURL().then((url) {
          debugPrint(url);
          if (url != "") {
            firebaseFirestore.collection('Images').doc().set({'url': url});
          }
        });
      });
    }
  }
}
