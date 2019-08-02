class PrismSurveySet {
  String id;
  DateTime created;
  DateTime edited;
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
      created: data['created'] ?? DateTime.now(),
      edited: data['edited'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      resolution: data['resolution'] ?? 5,
      xName: data['xName'] ?? '',
      xDescription: data['xDescription'] ?? '',
      yName: data['yName'] ?? '',
      yDescription: data['yDescription'] ?? '',
      prismSurveys: (data['prismSurveys'] as List ?? [])
          .map((value) => User.fromMap(value))
          .toList(),
    );
  }
}

class PrismSurvey {
  int id;
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

  factory PrismSurvey.fromMap(Map data) {
    return PrismSurvey(
      id: data["id"] ?? '',
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
  int id;
  String created;
  String edited;
  String name;
  String description;
  dynamic users;
  dynamic prismSurveySets;

  Team({
    this.id,
    this.created,
    this.edited,
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
  int id;
  String created;
  String edited;
  String firstName;
  String lastName;
  String username;
  String password;
  String email;
  String description;
  String company;
  String avatarUrl;
  dynamic teams;
  dynamic prismSurveySets;
  dynamic prismSurveys;

  User({
    this.id,
    this.created,
    this.edited,
    this.firstName,
    this.lastName,
    this.username,
    this.password,
    this.email,
    this.description,
    this.company,
    this.avatarUrl,
    this.teams,
    this.prismSurveySets,
    this.prismSurveys,
  });

  factory User.fromMap(Map data) {
    return User(
      id: data["id"] ?? '',
      created: data["created"] ?? DateTime.now(),
      edited: data["edited"] ?? '',
      firstName: data["first_name"] ?? '',
      lastName: data["last_name"] ?? '',
      username: data["username"] ?? '',
      password: data["password"] ?? '',
      email: data["email"] ?? '',
      description: data["description"] ?? '',
      company: data["company"] ?? '',
      avatarUrl: data["avatar_url"] ?? '',
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
