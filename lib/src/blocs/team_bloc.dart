import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class TeamBloc extends ChangeNotifier {
  bool updatingTeamData = false;
  String _orderField = 'created';
  bool _descendingOrder = true;
  DocumentSnapshot _currentSelectedTeam;
  String _currentSelectedTeamId;

  DocumentSnapshot get currentSelectedTeam => _currentSelectedTeam;
  DocumentSnapshot getCurrentSelectedTeam() => _currentSelectedTeam;
  String get currentSelectedTeamId => _currentSelectedTeamId;
  String getCurrentSelectedTeamId() => _currentSelectedTeamId;
  get orderField => _orderField;
  get descendingOrder => _descendingOrder;

  set orderField(orderField) {
    _orderField = orderField;
    // notifyListeners();
  }

  set descendingOrder(descendingOrder) {
    _descendingOrder = descendingOrder;
    // notifyListeners();
  }

  set currentSelectedTeamId(selectedTeamId) {
    _currentSelectedTeamId = selectedTeamId;
    // notifyListeners();
  }
  setCurrentSelectedTeamId(selectedTeamId) {
    _currentSelectedTeamId = selectedTeamId;
    notifyListeners();
  }
  
  set currentSelectedTeam(selectedTeam) {
    _currentSelectedTeam = selectedTeam;
    // notifyListeners();
  }

  

  // setCurrentSelectedTeam(DocumentSnapshot selectedTeam) {
  //   _currentSelectedTeam = selectedTeam;
  //   //// This call for notifyListeners produces an assertion:
  //   ///    setState() or markNeedsBuild() called during build.
  //   ///  But leaving it out won't update the SurveySets list after
  //   ///  selecting a team from the teams dropdown.
  //   notifyListeners();
  // }

  // setCurrentSelectedTeamId(String selectedTeamId) {
  //   _currentSelectedTeamId = selectedTeamId;
  //   //// This call for notifyListeners produces an assertion exeption:
  //   ///    setState() or markNeedsBuild() called during build.
  //   ///  But leaving it out won't update the SurveySets list after
  //   ///  selecting a team from the teams dropdown.
  //   notifyListeners();
  // }

  Stream<QuerySnapshot> get streamTeams {
    return Collection<Team>(path: 'teams').streamDocuments();
  }

  Future<QuerySnapshot> getTeamsQuery({String fieldName, String fieldValue}) {
    return Collection<Team>(path: 'teams')
        .getDocumentsByQuery(fieldName: fieldName, fieldValue: fieldValue);
  }

  Future<QuerySnapshot> getTeamsQueryByArray(
      {String fieldName, String arrayValue}) async {
    QuerySnapshot _queriedTeam = await Collection<Team>(path: 'teams')
        .getDocumentsByQueryArray(fieldName: fieldName, arrayValue: arrayValue);
    return _queriedTeam;
  }

  Stream<QuerySnapshot> streamTeamsQueryByArray(
      {String fieldName, String arrayValue}) {
    Stream<QuerySnapshot> _queriedTeam = Collection<Team>(path: 'teams')
        .streamDocumentsByQueryArray(
            fieldName: fieldName, arrayValue: arrayValue);
    return _queriedTeam;
  }

  addTeamToDb({Map<String, dynamic> team}) {
    Collection(path: "teams").createDocumentWithObject(object: team);
    notifyListeners();
  }

  updateTeamById({object, id}) {
    Collection(path: 'teams').updateDocumentWithObject(object: object, id: id);
    notifyListeners();
  }

  updateTeamByIdWithFieldAndValue({id, field, value}) async {
    Collection(path: "teams").updateDocumentByIdWithFieldAndValue(
        id: id, field: field, value: value);
    notifyListeners();
  }

  updateTeamArrayFieldByIdWithFieldAndValue({id, field, value}) async {
    Collection(path: "teams").updateArrayInDocumentByIdWithFieldAndValue(
      id: id,
      field: field,
      value: value,
    );
    notifyListeners();
  }

  Future<QuerySnapshot> deleteUserFromTeamsArrayById({id}) async {
    QuerySnapshot returnedValue = await Collection(path: "teams")
        .deleteItemsFromDocumentsArrayById(fieldName: 'users', id: id);
    notifyListeners();
    return returnedValue;
  }

  Future<DocumentSnapshot> getTeamById({id}) {
    return Collection<Team>(path: 'teams').getDocument(id);
  }

  Stream<DocumentSnapshot> streamTeamById({id}) {
    return Collection<Team>(path: 'teams').streamDocumentById(id);
  }

  Future<bool> deleteTeamByIdOnlyIfUserIsOwner(
      {@required id, @required currentUserId}) async {
    DocumentSnapshot _team =
        await Collection<Team>(path: 'teams').getDocument(id);

    String ownerId = _team.data['createdByUser'];

    if (currentUserId != ownerId) {
      log("In TeamBloc - deleteTeamByIdOnlyIfUserIsOwner - currentUserId is not equal to ownerId");
      log("In TeamBloc - deleteTeamByIdOnlyIfUserIsOwner - team not deleted!");
      return false;
    }
    if (currentUserId == null || currentUserId == '') {
      log("In TeamBloc - deleteTeamByIdOnlyIfUserIsOwner - currentUserId is: $currentUserId");
      log("In TeamBloc - deleteTeamByIdOnlyIfUserIsOwner - team not deleted!");
      return false;
    }

    log("In TeamBloc - deleteTeamByIdOnlyIfUserIsOwner - 'currentUserId == ownerId'? ${currentUserId == ownerId}");
    await Collection<Team>(path: 'teams').deleteById(id);
    notifyListeners();
    log("In TeamBloc - deleteTeamByIdOnlyIfUserIsOwner - team has been deleted!");
    return true;
  }
}
