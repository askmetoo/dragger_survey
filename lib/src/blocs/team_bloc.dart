import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class TeamBloc extends ChangeNotifier {
  bool updatingTeamData = false;

  DocumentSnapshot currentSelectedTeam;
  String currentSelectedTeamId;

  DocumentSnapshot getCurrentSelectedTeam() => currentSelectedTeam;
  String getCurrentSelectedTeamId() => currentSelectedTeamId;

  setCurrentSelectedTeam(DocumentSnapshot selectedTeam) async {
    currentSelectedTeam = selectedTeam;
    notifyListeners();
  }

  setCurrentSelectedTeamId(String selectedTeamId) {
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
    return await Collection<Team>(path: 'teams')
        .getDocumentsByQueryArray(fieldName: fieldName, arrayValue: arrayValue);
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
