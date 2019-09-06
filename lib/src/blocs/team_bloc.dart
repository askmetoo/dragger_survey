

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dragger_survey/src/services/models.dart';
import 'package:dragger_survey/src/services/services.dart';
import 'package:flutter/material.dart';

class TeamBloc extends ChangeNotifier {

  bool updatingTeamData = false;
  String _currentTeamId = '';
  Team _currentSelectedTeam;

  Team get currentSelectedTeam => _currentSelectedTeam;

  set currentSelectedTeam(Team currentSelectedTeam) {
    _currentSelectedTeam = currentSelectedTeam;
  }

  String get currentTeamId => _currentTeamId;

  set currentTeamId(String currentTeamId) {
    _currentTeamId = currentTeamId;
  }
  

  Stream<QuerySnapshot> get streamTeams {
    return Collection<Team>(path: 'teams').streamDocuments();
  }

  Future<QuerySnapshot> getTeamsQuery({String fieldName, String fieldValue}) {
    return Collection<Team>(path: 'teams').getDocumentsByQuery(fieldName: fieldName, fieldValue: fieldValue);
  }

  Future<QuerySnapshot> getTeamsQueryByArray({String fieldName, String arrayValue}) {
    return Collection<Team>(path: 'teams').getDocumentsByQueryArray(fieldName: fieldName, arrayValue: arrayValue);
  }

  addTeamToDb({Map<String, dynamic> team}) {
    Collection(path: "teams").createDocumentWithObject(object: team);
    print("2) ----> Team values have been sent to data base");
  }

  updateTeamById({object, id}) {
    Collection(path: 'teams').updateDocumentWithObject(object: object, id: id);
  }

  Future<DocumentSnapshot> getTeamById({id}) async {
    var _teamQuery = await Collection<Team>(path: 'teams').getDocument(id).then( (value) {
      Team _team = Team(
        created: value?.data['created'].toString(),
        createdByUser: value?.data['createdByUser'], 
        description: value?.data['description'], 
        edited: value?.data['edited'].toString(),
        id: value?.data['id'], 
        lastEditedByUser: value?.data['lastEditedByUser'],
        name: value?.data['name'],
        prismSurveySets: value?.data['prismSurveySets'],
        users: value?.data['users'],
      );
      _currentSelectedTeam = _team;
    });
    return _teamQuery as Future<DocumentSnapshot>;
  }

  deleteTeamById({id}) {
    Collection<Team>(path: 'teams').deleteById(id);
  }

}