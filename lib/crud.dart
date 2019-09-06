import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class crudMedthods {
  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser() != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> addData(carData) async {
    if (isLoggedIn()) {
      Firestore.instance.collection('testcrud').add(carData).catchError((e) {
        print(e);
      });
    } else {
      print('You need to be logged in');
    }
  }

  getData(collection) async {
    return await Firestore.instance.collection(collection).snapshots();
  }

  updateData( col,doc, newValues) {
    Firestore.instance
        .collection(col)
        .document(doc)
        .updateData(newValues)
        .catchError((e) {
      print(e);
    });
  }

  deleteData(col,docId) {
    Firestore.instance
        .collection(col)
        .document(docId)
        .delete()
        .catchError((e) {
      print(e);
    });
  }
}