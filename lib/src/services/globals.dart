import 'services.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  // App Data
  static final String title = 'Dragger';

  // Services
//  static final FirebaseAnalytics analytics = FirebaseAnalytics();

  // Data Models
  static final Map models = {
    PrismSurveySet: (data) => PrismSurveySet.fromDocument(data),
    PrismSurvey: (data) => PrismSurvey.fromDocument(data),
    Team: (data) => Team.fromDocument(data),
    User: (data) => User.fromDocument(data),
  };

  // Firestore References for Writes
//  static final Collection<PrismSurveySet> prismSurveySetsRef =
//      Collection<PrismSurveySet>(path: 'prismSurveySets');
//  static final UserData<Report> reportRef =
//      UserData<Report>(collection: 'reports');
}
