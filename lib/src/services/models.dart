import 'package:cloud_firestore/cloud_firestore.dart';

class PrismSurveySet {
  String id;
  DateTime created;
  DateTime edited;
  String createdByTeam;
  String createdByUser;
  DateTime lastEditedByUser;
  String name;
  String description;
  int resolution;
  String xName;
  String xDescription;
  String yName;
  String yDescription;
  dynamic prismSurveys;

  PrismSurveySet({
    this.id,
    this.created,
    this.edited,
    this.createdByTeam,
    this.createdByUser,
    this.lastEditedByUser,
    this.name,
    this.description,
    this.resolution,
    this.xName,
    this.xDescription,
    this.yName,
    this.yDescription,
    this.prismSurveys,
  });

  factory PrismSurveySet.fromDocument(DocumentSnapshot doc) {
    return PrismSurveySet(
      id: doc.documentID,
      created: doc['created'],
      edited: doc['edited'],
      name: doc['name'],
      lastEditedByUser: (doc['lastEditedByUser']),
      createdByTeam: doc['createdByTeam'],
      createdByUser: doc['createdByUser'],
      description: doc['description'],
      resolution: doc['resolution'],
      xName: doc['xName'],
      xDescription: doc['xDescription'],
      yName: doc['yName'],
      yDescription: doc['yDescription'],
      prismSurveys: (doc['prismSurveys'] as List ?? [])
          .map((value) => PrismSurvey.fromDocument(doc))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'created': this.created,
        'edited': this.edited,
        'name': this.name,
        'lastEditedByUser': this.lastEditedByUser,
        'createdByTeam': this.createdByTeam,
        'createdByUser': this.createdByUser,
        'description': this.description,
        'resolution': this.resolution,
        'xName': this.xName,
        'xDescription': this.xDescription,
        'yName': this.yName,
        'yDescription': this.yDescription,
        'prismSurveys': this.prismSurveys,
      };
}

class PrismSurvey {
  String id;
  int counter;
  DateTime created;
  DateTime edited;
  String askedPerson;
  String team;
  int yValue;
  int xValue;
  dynamic users;

  PrismSurvey({
    this.id,
    this.counter,
    this.created,
    this.edited,
    this.askedPerson,
    this.team,
    this.yValue,
    this.xValue,
    this.users,
  });

  factory PrismSurvey.fromDocument(DocumentSnapshot doc) {
    return PrismSurvey(
      id: doc.documentID,
      counter: doc["counter"],
      created: doc["created"],
      edited: doc["edited"],
      askedPerson: doc["askedPerson"],
      team: doc["team"],
      yValue: doc["yValue"],
      xValue: doc["xValue"],
      users: (doc["users"] as List ?? [])
          .map((value) => User.fromDocument(value))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        "counter": this.counter,
        "created": this.created,
        "edited": this.edited,
        "askedPerson": this.askedPerson,
        "team": this.team,
        "yValue": this.yValue,
        "xValue": this.xValue,
        "users": this.users,
      };
}

class Team {
  String id;
  String created;
  String edited;
  String createdByUser;
  String lastEditedByUser;
  String name;
  String description;
  dynamic users;
  dynamic prismSurveySets;

  Team({
    this.id,
    this.created,
    this.edited,
    this.createdByUser,
    this.lastEditedByUser,
    this.name,
    this.description,
    this.users,
    this.prismSurveySets,
  });

  factory Team.fromDocument(DocumentSnapshot doc) {
    return Team(
      id: doc.documentID,
      created: doc["created"],
      edited: doc["edited"],
      name: doc["name"],
      createdByUser: doc["createdByUser"],
      lastEditedByUser: doc["lastEditedByUser"],
      description: doc["description"],
      users: (doc["users"] as List ?? [])
          .map((value) => User.fromDocument(value))
          .toList(),
      prismSurveySets: (doc["prismSurveySets"] as List ?? [])
          .map((value) => PrismSurveySet.fromDocument(value))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        "created": this.created,
        "edited": this.edited,
        "name": this.name,
        "createdByUser": this.createdByUser,
        "lastEditedByUser": this.lastEditedByUser,
        "description": this.description,
        "users": this.users,
        "prismSurveySets": this.prismSurveySets,
      };
}

class User {
  String uid;
  String id;
  DateTime created;
  DateTime edited;
  String firstName;
  String lastName;
  String lastEditedByUser;
  String password;
  String email;
  String displayName;
  String description;
  String company;
  String photoUrl;
  String
      providersUID; // UID of User prvided by Auth Provider (e.g. Google SignIn)
  String providerId;
  DateTime originCreationTime;
  dynamic teams;
  dynamic prismSurveySets;
  dynamic prismSurveys;

  User(
      {this.uid,
      this.id,
      this.created,
      this.edited,
      this.firstName,
      this.lastName,
      this.lastEditedByUser,
      this.password,
      this.email,
      this.displayName,
      this.description,
      this.company,
      this.photoUrl,
      this.providersUID,
      this.providerId,
      this.teams,
      this.prismSurveySets,
      this.prismSurveys,
      this.originCreationTime});

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      uid: doc["uid"],
      id: doc.documentID,
      created: doc["created"],
      edited: doc["edited"],
      firstName: doc["firstName"],
      lastName: doc["lastName"],
      lastEditedByUser: doc["lastEditedByUser"],
      password: doc["password"],
      email: doc["email"],
      displayName: doc["displayName"],
      description: doc["description"],
      company: doc["company"],
      photoUrl: doc["photoUrl"],
      providersUID: doc["providersUID"],
      providerId: doc["providerId"],
      originCreationTime: doc["originCreationTime"],
      teams: (doc["teams"] as List ?? [])
          .map((value) => Team.fromDocument(value))
          .toList(),
      prismSurveySets: (doc["prismCurveySets"] as List ?? [])
          .map((value) => PrismSurveySet.fromDocument(value))
          .toList(),
      prismSurveys: (doc["prismSurveys"] as List ?? [])
          .map((value) => PrismSurvey.fromDocument(value))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'uid': this.uid,
        'created': this.created,
        'edited': this.edited,
        'firstName': this.firstName,
        'lastName': this.lastName,
        'lastEditedByUser': this.lastEditedByUser,
        'password': this.password,
        'email': this.email,
        'displayName': this.displayName,
        'description': this.description,
        'company': this.company,
        'photoUrl': this.photoUrl,
        'providersUID': this.providersUID,
        'providerId': this.providerId,
        'teams': this.teams,
        'prismSurveySets': this.prismSurveySets,
        'prismSurveys': this.prismSurveys,
        'originCreationTime': this.originCreationTime,
      };
}
