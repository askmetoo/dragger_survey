
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
      xName: data['xName'] ?? '',
      xDescription: data['xDescription'] ?? '',
      yName: data['yName'] ?? '',
      yDescription: data['yDescription'] ?? '',
      prismSurveys: (data['prismSurveys'] as List ?? [])
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
      askedPerson: data["askedPerson"] ?? '',
      yValue: data["yValue"] ?? 0,
      xValue: data["xValue"] ?? 0,
      users: (data["users"] as List ?? [])
          .map((value) => User.fromMap(value))
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

  factory Team.fromMap(Map data) {
    return Team(
      id: data["id"] ?? '',
      created: data["created"] ?? DateTime.now(),
      edited: data["edited"] ?? '',
      name: data["name"] ?? '',
      createdByUser: data["createdByUser"] ?? '',
      lastEditedByUser: data["lastEditedByUser"] ?? '',
      description: data["description"] ?? '',
      users: (data["users"] as List ?? [])
          .map((value) => User.fromMap(value))
          .toList(),
      prismSurveySets: (data["prismSurveySets"] as List ?? [])
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
  String createdByUser;
  String lastEditedByUser;
  String password;
  String email;
  String displayName;
  String description;
  String company;
  String photoUrl;
  String providersUID; // ID of User prvided by Auth Provider (e.g. Google SignIn)
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

  factory User.fromMap(Map data) {
    return User(
      uid: data["uid"] ?? '',
      created: data["created"] ?? DateTime.now(),
      edited: data["edited"] ?? '',
      firstName: data["firstName"] ?? '',
      lastName: data["lastName"] ?? '',
      createdByUser: data["createdByUser"] ?? '',
      lastEditedByUser: data["lastEditedByUser"] ?? '',
      password: data["password"] ?? '',
      email: data["email"] ?? '',
      displayName: data["displayName"] ?? '',
      description: data["description"] ?? '',
      company: data["company"] ?? '',
      photoUrl: data["photoUrl"] ?? '',
      providersUID: data["providersUID"] ?? '',
      providerId: data["providerId"] ?? '',
      originCreationTime: data["originCreationTime"] ?? '',
      teams: (data["teams"] as List ?? [])
          .map((value) => Team.fromMap(value))
          .toList(),
      prismSurveySets: (data["prismCurveySets"] as List ?? [])
          .map((value) => PrismSurveySet.fromMap(value))
          .toList(),
      prismSurveys: (data["prismSurveys"] as List ?? [])
          .map((value) => PrismSurvey.fromMap(value))
          .toList(),
    );
  }
}
