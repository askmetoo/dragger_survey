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
    PrismSurveySet: (data) => PrismSurveySet.fromFirestore(data),
    PrismSurvey: (data) => PrismSurvey.fromFirestore(data),
    Team: (data) => Team.fromFirestore(data),
    User: (data) => User.fromFirestore(data),
  };

  // Firestore References for Writes
//  static final Collection<PrismSurveySet> prismSurveySetsRef =
//      Collection<PrismSurveySet>(path: 'prismSurveySets');
//  static final UserData<Report> reportRef =
//      UserData<Report>(collection: 'reports');
}
