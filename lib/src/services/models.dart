
import 'package:cloud_firestore/cloud_firestore.dart';

class PrismSurveySet {
  String id;
  String created;
  String createdByTeam;
  String createdByUser;
  String lastEditedByUser;
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

  factory PrismSurveySet.fromFirestore(DocumentSnapshot doc) {

    doc = doc ?? { };

    return PrismSurveySet(
      id: doc.documentID,
      created: (doc['created']) ?? DateTime.now().toLocal(),
      name: doc['name'] ?? '',
      lastEditedByUser: (doc['lastEditedByUser']) ?? DateTime.now().toLocal(),
      createdByTeam: doc['createdByTeam'] ?? '',
      createdByUser: doc['createdByUser'] ?? '',
      description: doc['description'] ?? '',
      resolution: doc['resolution'] ?? 5,
      xName: doc['xName'] ?? '',
      xDescription: doc['xDescription'] ?? '',
      yName: doc['yName'] ?? '',
      yDescription: doc['yDescription'] ?? '',
      prismSurveys: (doc['prismSurveys'] as List ?? [])
    );
  }
}

class PrismSurvey {
  String id;
  DateTime created;
  DateTime edited;
  String askedPerson;
  int yValue;
  int xValue;
  dynamic users;

  PrismSurvey({
    this.id,
    this.created,
    this.edited,
    this.askedPerson,
    this.yValue,
    this.xValue,
    this.users,
  });

  factory PrismSurvey.fromFirestore(DocumentSnapshot doc) {

    doc = doc ?? { };

    return PrismSurvey(
      id: doc.documentID,
      created: doc["created"] ?? DateTime.now(),
      edited: doc["edited"] ?? '',
      askedPerson: doc["askedPerson"] ?? '',
      yValue: doc["yValue"] ?? 0,
      xValue: doc["xValue"] ?? 0,
      users: (doc["users"] as List ?? [])
          .map((value) => User.fromFirestore(value))
          .toList(),
    );
  }
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

  factory Team.fromFirestore(DocumentSnapshot doc) {
    // doc = doc ?? { };
    print("In Models Team.fromFirestore");
    return Team(
      id: doc["id"] ?? '',
      created: doc["created"] ?? DateTime.now(),
      edited: doc["edited"] ?? '',
      name: doc["name"] ?? '',
      createdByUser: doc["createdByUser"] ?? '',
      lastEditedByUser: doc["lastEditedByUser"] ?? '',
      description: doc["description"] ?? '',
      users: (doc["users"] as List ?? [])
          .map((value) => User.fromFirestore(value))
          .toList(),
      prismSurveySets: (doc["prismSurveySets"] as List ?? [])
          .map((value) => PrismSurveySet.fromFirestore(value))
          .toList(),
    );
  }
}

class User {
  String uid;
  DateTime created;
  DateTime edited;
  String firstName;
  String lastName;
  String createdByUser;
  String lastEditedByUser;
  String password;
  String email;
  String displayName;
  String description;
  String company;
  String photoUrl;
  String providersUID; // UID of User prvided by Auth Provider (e.g. Google SignIn)
  String providerId;
  DateTime originCreationTime;
  dynamic teams;
  dynamic prismSurveySets;
  dynamic prismSurveys;

  User({
    this.uid,
    this.created,
    this.edited,
    this.firstName,
    this.lastName,
    this.createdByUser,
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
    this.originCreationTime
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    doc = doc ?? { };
    return User(
      uid: doc["uid"] ?? '',
      created: doc["created"] ?? DateTime.now(),
      edited: doc["edited"] ?? '',
      firstName: doc["firstName"] ?? '',
      lastName: doc["lastName"] ?? '',
      createdByUser: doc["createdByUser"] ?? '',
      lastEditedByUser: doc["lastEditedByUser"] ?? '',
      password: doc["password"] ?? '',
      email: doc["email"] ?? '',
      displayName: doc["displayName"] ?? '',
      description: doc["description"] ?? '',
      company: doc["company"] ?? '',
      photoUrl: doc["photoUrl"] ?? '',
      providersUID: doc["providersUID"] ?? '',
      providerId: doc["providerId"] ?? '',
      originCreationTime: doc["originCreationTime"] ?? '',
      teams: (doc["teams"] as List ?? [])
          .map((value) => Team.fromFirestore(value))
          .toList(),
      prismSurveySets: (doc["prismCurveySets"] as List ?? [])
          .map((value) => PrismSurveySet.fromFirestore(value))
          .toList(),
      prismSurveys: (doc["prismSurveys"] as List ?? [])
          .map((value) => PrismSurvey.fromFirestore(value))
          .toList(),
    );
  }
}
