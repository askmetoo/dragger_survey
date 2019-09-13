import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class UserBloc extends ChangeNotifier {
  bool updatingUserData = false;
  String currentUserId;

  Stream<QuerySnapshot> get streamUsers {
    return Collection<User>(path: 'users').streamDocuments();
  }

  Future<QuerySnapshot> getUsersQuery({String fieldName, String fieldValue}) {
    return Collection<User>(path: 'users')
        .getDocumentsByQuery(fieldName: fieldName, fieldValue: fieldValue);
  }

  addUserToDb({Map<String, dynamic> user}) {
    Collection(path: "users").createDocumentWithObject(object: user);
    notifyListeners();
  }

  updateUserById({object, id}) {
    Collection(path: 'users').updateDocumentWithObject(object: object, id: id);
    notifyListeners();
  }

  Future<DocumentSnapshot> getUserById({id}) {
    return Collection<Team>(path: 'users').getDocument(id);
  }

  deleteUserById({id}) {
    Collection<Team>(path: 'users').deleteById(id);
    notifyListeners();
  }
}
