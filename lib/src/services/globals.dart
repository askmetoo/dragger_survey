import 'services.dart';
//import 'package:firebase_analytics/firebase_analytics.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  // App Data
  static final String title = 'Fireship';

  // Services
//  static final FirebaseAnalytics analytics = FirebaseAnalytics();

  // Data Models
  static final Map models = {
    PrismSurveySet: (data) => PrismSurveySet.fromMap(data),
    PrismSurvey: (data) => PrismSurvey.fromMap(data),
    Team: (data) => Team.fromMap(data),
    User: (data) => User.fromMap(data),
  };

  // Firestore References for Writes
//  static final Collection<PrismSurveySet> prismSurveySetsRef =
//      Collection<PrismSurveySet>(path: 'prismSurveySets');
//  static final UserData<Report> reportRef =
//      UserData<Report>(collection: 'reports');
}
