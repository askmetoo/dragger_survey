

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class TeamBloc extends ChangeNotifier {

  bool updatingTeamData = false;

  DocumentSnapshot currentSelectedTeam;
  Future<String> currentSelectedTeamId;

  DocumentSnapshot getCurrentSelectedTeam () => currentSelectedTeam;
  Future<String> getCurrentSelectedTeamId () => currentSelectedTeamId;

  setCurrentSelectedTeam(selectedTeam) async {
    currentSelectedTeam = selectedTeam;
  }

  setCurrentSelectedTeamId(Future<String> selectedTeamId) {
    currentSelectedTeamId = selectedTeamId;
  }

  Stream<QuerySnapshot> get streamTeams {
    return Collection<Team>(path: 'teams').streamDocuments();
  }

  Future<QuerySnapshot> getTeamsQuery({String fieldName, String fieldValue}) {
    return Collection<Team>(path: 'teams').getDocumentsByQuery(fieldName: fieldName, fieldValue: fieldValue);
  }

  Future<QuerySnapshot> getTeamsQueryByArray({String fieldName, String arrayValue}) async {
    return await Collection<Team>(path: 'teams').getDocumentsByQueryArray(fieldName: fieldName, arrayValue: arrayValue);
  }

  addTeamToDb({Map<String, dynamic> team}) {
    Collection(path: "teams").createDocumentWithObject(object: team);
  }

  updateTeamById({object, id}) {
    Collection(path: 'teams').updateDocumentWithObject(object: object, id: id);
  }

  Future<DocumentSnapshot> getTeamById({id}) {
    return Collection<Team>(path: 'teams').getDocument(id);
  }

  deleteTeamById({id}) {
    Collection<Team>(path: 'teams').deleteById(id);
  }

}