import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import './globals.dart';

class Document<T> {
  final Firestore _db = Firestore.instance;
  final String path;
  DocumentReference ref;

  Document({this.path}) {
    ref = _db.document(path);
  }

  Future<T> getData() {
    return ref.get().then((value) => Global.models[T](value.data) as T);
  }

  Stream<T> streamData() {
    return ref.snapshots().map((value) => Global.models[T](value.data) as T);
  }

  Future<void> upsert(Map data) {
    return ref.setData(Map<String, dynamic>.from(data), merge: true);
  }
}

class Collection<T> {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  Collection({this.path}) {
    ref = _db.collection(path);
  }

  Future<List<T>> getData() async {
    var snapshots = await ref.getDocuments();
    return snapshots.documents
        .map((doc) => Global.models[T](doc.data) as T)
        .toList();
  }

  Future<List<DocumentSnapshot>> getDocuments() async {
    var snapshots = await ref.getDocuments();
    return snapshots.documents;
  }

  Future<QuerySnapshot> getDocumentsByQuery({
    String fieldName, 
    String fieldValue
    }) async {
    var snapshots = ref.where(fieldName, isEqualTo: fieldValue);
    return snapshots.getDocuments();
  }

  Future<QuerySnapshot> getDocumentsByQueryArray({
    String fieldName, 
    String arrayValue
    }) async {
    var snapshots = ref.where(fieldName, arrayContains: arrayValue);
    return snapshots.getDocuments();
  }

  Future<DocumentSnapshot> getDocument(id) async {
    return await ref.document('$id').get();
  }
  

  createDocumentWithValues({
    @required name,
    description = "",
    resolution = 5,
    @required xName,
    xDescription = "",
    @required yName,
    yDescription = "",
  }) async {
    return _db.collection(path).add({
      "created": DateTime.now(),
      "name": name,
      "description": description,
      "resolution": resolution,
      "xName": xName,
      "xDescription": xDescription,
      "yName": yName,
      "yDescription": yDescription,
    });
  }

  createDocumentWithObject({object}) async {
    try {
      debugPrint("----> In TRY of createDocumentWithObject");
      ref.add(object as Map<String, dynamic>);
      debugPrint(
          "----> In TRY of createDocumentWithObject - after calling collection");
    } catch (error) {
      print("!!! ----> In db.dart - ERROR at createDocumentWithObject: $error");
    }
    print("3) ----> Form values have been sent to data base");
  }

  updateDocumentWithObject({object, id}) async {
    try {
      ref.document('$id').updateData(object);
    } catch (error) {
      print('Error occured while updating data: $error');
    } finally {
      print("End of Update");
    }
  }

  Stream<QuerySnapshot> streamDocuments() {
    return ref.snapshots();
  }

  Stream<List<T>> streamData() {
    return ref
        .snapshots()
        .map((list) => list.documents.map((doc) => Global.models[T] as T));
  }

  deleteById(id) {
    ref.document('$id').delete();
  }
}

class UserData<T> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection;

  UserData({this.collection});

  Stream<T> get documentStream {
    return Observable(_auth.onAuthStateChanged).switchMap((user) {
      if (user != null) {
        Document<T> doc = Document<T>(path: '$collection/${user.uid}');
        return doc.streamData();
      } else {
        return Observable<T>.just(null);
      }
    });
  }

  Future<T> getDocument() async {
    FirebaseUser user = await _auth.currentUser();

    if (user != null) {
      Document doc = Document<T>(path: '$collection/${user.uid}');
      return doc.getData();
    } else {
      return null;
    }
  }

  Future<void> upsert(Map data) async {
    FirebaseUser user = await _auth.currentUser();
    Document<T> ref = Document(path: '$collection/${user.uid}');
    return ref.upsert(data);
  }
}
