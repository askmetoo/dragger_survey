import 'dart:developer';

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

  addUserToDb({User user}) {
    Collection(path: "users").createDocumentWithObject(object: user.toMap());
    notifyListeners();
  }

  updateUserById({object, id}) async {
    Collection(path: 'users').updateDocumentWithObject(object: object, id: id);
    notifyListeners();
  }

  Future<DocumentSnapshot> getUserById({id}) async {
    return Collection<Team>(path: 'users').getDocument(id);
  }

  Future<bool> checkIfUserExists({id}) async {
    // return Collection(path: 'users').checkIfDocumentExists(id);
    return Collection(path: 'users')
        .getDocumentsByQuery(fieldName: 'providersUID', fieldValue: id)
        .then((val) {
      if (val != null) {
        log("----------------> In UserBloc checkIfUserExists val != null - value of val: $val");
        log("----------------> In UserBloc checkIfUserExists val != null - value of val.documents.isNotEmpty: ${val.documents.isNotEmpty}");
        return val.documents.isNotEmpty;
      }
      return false;
    });
  }

  deleteUserByIdQuery({id}) {
    Collection<Team>(path: 'users').deleteDocumentsChildrenByQuery(fieldName: 'providersUID', fieldValue: id);
    notifyListeners();
  }


  deleteUserById({id}) {
    Collection<Team>(path: 'users').deleteById(id);
    notifyListeners();
  }
}
