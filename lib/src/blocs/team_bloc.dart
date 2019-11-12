import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class TeamBloc extends ChangeNotifier {
  bool updatingTeamData = false;
  String _orderField = 'created';
  bool _descendingOrder = true;

  DocumentSnapshot currentSelectedTeam;
  String currentSelectedTeamId;

  DocumentSnapshot getCurrentSelectedTeam() {
    return currentSelectedTeam;
  }

  String getCurrentSelectedTeamId() {
    return currentSelectedTeamId;
  }

  get orderField => _orderField;
  get descendingOrder => _descendingOrder;

  set orderField(orderField) {
    _orderField = orderField;
    notifyListeners();
  }

  set descendingOrder(descendingOrder) {
    _descendingOrder = descendingOrder;
    notifyListeners();
  }

  setCurrentSelectedTeam(DocumentSnapshot selectedTeam) async {
    currentSelectedTeam = selectedTeam;
    notifyListeners();
  }

  setCurrentSelectedTeamId(String selectedTeamId) {
    log("In TeamBloc setCurrentSelectedTeamId value of selectedTeamId: $selectedTeamId");
    currentSelectedTeamId = selectedTeamId;
    notifyListeners();
  }

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

  Future<DocumentSnapshot> getTeamById({id}) {
    return Collection<Team>(path: 'teams').getDocument(id);
  }

  deleteTeamById({id}) {
    Collection<Team>(path: 'teams').deleteById(id);
    notifyListeners();
  }
}
