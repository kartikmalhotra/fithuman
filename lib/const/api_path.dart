/// class for having API Endpoints used in the application
abstract class ApiRestEndPoints {
  /// API end points for the user service

  static const String login = 'api/login';
  static const String logout = 'api/logout';
  static const String signup = 'api/signup';
  static const String forgetPassword = 'api/forgot-password';
  static const String changePassword = 'api/change-password';
  static const String changeName = 'api/change-name';
  static const String facebookLogin = 'api/end-user-oauth/facebook';
  static const String googleLogin = 'api/end-user-oauth/google';
  static const String appleLogin = 'api/oauth/apple';
  static const String profile = 'api/profile';
  static const String visionPlanner = 'api/vision-planner';
  static const String schedulers = 'api/events';
  static const String relationships = 'api/relationships';
  static const String emotions = 'api/emotions';
  static const String commitments = 'api/commitments';
  static const String price = 'api/price';
  static const String getToBe = 'api/get-to-be';
  static const String emotionAnalysis = "api/emotion-analysis";
  static const String relationAnalysis = "api/relationship-extractor";
  static const String emotionCheckIn = 'api/emotion-check-in';
  static const String emotionJournel = 'api/emotion-check-in';
  static const String remindarNotification = 'api/check-in-reminder';
}
