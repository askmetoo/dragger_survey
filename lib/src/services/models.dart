import 'package:cloud_firestore/cloud_firestore.dart';

class PrismSurveySet {
  String id;
  String created;
  String edited;
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
    this.name,
    this.description,
    this.resolution,
    this.xName,
    this.xDescription,
    this.yName,
    this.yDescription,
    this.prismSurveys,
  });

  factory PrismSurveySet.fromMap(Map data) {
    return PrismSurveySet(
      id: data['id'] ?? '',
      created: (data['created']) ?? DateTime.now().toLocal(),
      edited: (data['edited']) ?? DateTime.now().toLocal(),
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      resolution: data['resolution'] ?? 5,
      xName: data['x_name'] ?? '',
      xDescription: data['x_description'] ?? '',
      yName: data['y_name'] ?? '',
      yDescription: data['y_description'] ?? '',
      prismSurveys: (data['prismSurveys'] as List ?? [])
          // .map((value) => User.fromMap(value))
          // .toList(),
    );
  }
}

class PrismSurvey {
  String uid;
  DateTime created;
  DateTime edited;
  String askedPerson;
  int yValue;
  int xValue;
  dynamic users;

  PrismSurvey({
    this.uid,
    this.created,
    this.edited,
    this.askedPerson,
    this.yValue,
    this.xValue,
    this.users,
  });

  factory PrismSurvey.fromMap(Map data) {
    return PrismSurvey(
      uid: data["uid"] ?? '',
      created: data["created"] ?? DateTime.now(),
      edited: data["edited"] ?? '',
      askedPerson: data["asked_person"] ?? '',
      yValue: data["y_value"] ?? 0,
      xValue: data["x_value"] ?? 0,
      users: (data["users"] as List ?? [])
          .map((value) => User.fromMap(value))
          .toList(),
    );
  }
}

class Team {
  String uid;
  String created;
  String edited;
  String name;
  String description;
  dynamic users;
  dynamic prismSurveySets;

  Team({
    this.uid,
    this.created,
    this.edited,
    this.name,
    this.description,
    this.users,
    this.prismSurveySets,
  });

  factory Team.fromMap(Map data) {
    return Team(
      uid: data["uid"] ?? '',
      created: data["created"] ?? DateTime.now(),
      edited: data["edited"] ?? '',
      name: data["name"] ?? '',
      description: data["description"] ?? '',
      users: (data["users"] as List ?? [])
          .map((value) => User.fromMap(value))
          .toList(),
      prismSurveySets: (data["prism_survey_sets"] as List ?? [])
          .map((value) => PrismSurveySet.fromMap(value))
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
  String username;
  String password;
  String email;
  String displayName;
  String description;
  String company;
  String photoUrl;
  dynamic teams;
  dynamic prismSurveySets;
  dynamic prismSurveys;

  User({
    this.uid,
    this.created,
    this.edited,
    this.firstName,
    this.lastName,
    this.username,
    this.password,
    this.email,
    this.displayName,
    this.description,
    this.company,
    this.photoUrl,
    this.teams,
    this.prismSurveySets,
    this.prismSurveys,
  });

  factory User.fromMap(Map data) {
    return User(
      uid: data["uid"] ?? '',
      created: data["created"] ?? DateTime.now(),
      edited: data["edited"] ?? '',
      firstName: data["first_name"] ?? '',
      lastName: data["last_name"] ?? '',
      username: data["username"] ?? '',
      password: data["password"] ?? '',
      email: data["email"] ?? '',
      displayName: data["display_name"] ?? '',
      description: data["description"] ?? '',
      company: data["company"] ?? '',
      photoUrl: data["photo_url"] ?? '',
      teams: (data["teams"] as List ?? [])
          .map((value) => Team.fromMap(value))
          .toList(),
      prismSurveySets: (data["prism_survey_sets"] as List ?? [])
          .map((value) => PrismSurveySet.fromMap(value))
          .toList(),
      prismSurveys: (data["prism_surveys"] as List ?? [])
          .map((value) => PrismSurvey.fromMap(value))
          .toList(),
    );
  }
}
