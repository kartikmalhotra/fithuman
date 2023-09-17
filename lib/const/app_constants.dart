// ignore_for_file: constant_identifier_names

enum RestAPIRequestMethods { get, put, post, delete, patch }

enum InputFieldError { empty, invalid, notmatch }

abstract class AppConstants {}

const itemsPerPage = 100;

abstract class AppSecureStoragePreferencesKeys {
  static const String _email = "USERNAME";
  static const String _authToken = "AUTH_TOKEN";
  static const String _password = "USER_PASSWORD";
  static const String _refreshToken = "REFRESH_TOKEN";
  static const String _fcmToken = "FCM_TOKEN";

  static String get email => _email;
  static String get authToken => _authToken;
  static String get userPassword => _password;
  static String get refreshToken => _refreshToken;
  static String get fcmToken => _fcmToken;
}

abstract class AppLocalStoragePreferencesKeys {
  static const String _loggedIn = "LOGGEDIN";
  static const String _takeAssessment = "TAKEASSESSMENT";
  static const String _lastAssessment = "LASTASSESSMENT";

  static String get loggedIn => _loggedIn;
  static String get takeAssessment => _takeAssessment;
  static String get lastAssessment => _lastAssessment;
}

abstract class AppTimezonePreferencesKeys {
  static const String _timezone = "TIMEZONE";

  static String get email => _timezone;
}

/// Media Type
enum MediaType { Image, Video, Gif }

enum SocialMedia {
  Instagram,
  Facebook,
  Snapchat,
  Twitter,
  Tiktok,
  AlexaDevice,
  LinkedIn,
  GoogleMB,
}

/// Image Path
const String facebookImage = "assets/images/logo/facebook_logo.png";
const String googleImage = "assets/images/logo/google_logo2.png";
const String appleImage = "assets/images/logo/apple_logo.png";
const String growthNetworkLogo = "assets/images/GrowthCoach.jpg";

const List<String> actionType = [
  "Learn More",
  "Book",
  "Order",
  "Shop",
  "Sign Up",
  "Call Us"
];

const String PEG = "peg";
const String JPG = "jpg";
const String GIF = "gif";
const String PNG = "png";
const String MP4 = "mp4";
const String MKV = "mkv";

const List<String> hashtags = ["Trending Hashtags", "My First Hashtags"];

const String alreadyPostedError =
    "Oops, looks like you already scheduled something before (in the last or next 30 days) or have a post in your library that’s 100% similar to this post.";

const socialMediaReminders = {
  "instagram": [
    'storyReminder',
    'feedReminder',
    'reelReminder',
    'carouselReminder'
  ],
  "facebook": [
    'storyReminder',
    'personalTimelineReminder',
    'nonAdminGroupsReminder'
  ],
  "tikTok": ['storyReminder', 'feedReminder'],
};

List<Map<String, dynamic>> assessmentQuestions = [
  {
    "question_no": "1",
    "question_title":
        "Rate the following most like you to least like you at home?",
    "answer_list": [
      "commanding",
      "enthusiastic",
      "patient",
      "detailed",
    ]
  },
  {
    "question_no": "2",
    "question_title":
        "Rate the following most like you to least like you at office?",
    "answer_list": [
      "decisive",
      "expressive",
      "lenient",
      "particular",
    ]
  },
  {
    "question_no": "3",
    "question_title": "",
    "answer_list": [
      "tough minded",
      "covincing",
      "kind",
      "meticulous",
    ]
  },
  {
    "question_no": "4",
    "question_title": "",
    "answer_list": [
      "independent",
      "fun loving",
      "loyal",
      "follow rules",
    ]
  },
  {
    "question_no": "5",
    "question_title": "",
    "answer_list": [
      "daring",
      "people oriented",
      "understanding",
      "high standards",
    ]
  },
  {
    "question_no": "6",
    "question_title": "",
    "answer_list": [
      "risk taker",
      "lively",
      "charitable",
      "serious",
    ]
  },
  {
    "question_no": "7",
    "question_title": "",
    "answer_list": [
      "courageous",
      "cheerful",
      "merciful",
      "precise",
    ]
  },
  {
    "question_no": "8",
    "question_title": "",
    "answer_list": [
      "confident",
      "inspiring",
      "supportive",
      "logical",
    ]
  },
  {
    "question_no": "9",
    "question_title": "",
    "answer_list": [
      "fearless",
      "good mixer",
      "quiet",
      "conscientious",
    ]
  },
  {
    "question_no": "10",
    "question_title": "",
    "answer_list": [
      "non conforming",
      "talkative",
      "even paced",
      "analytical",
    ]
  },
  {
    "question_no": "11",
    "question_title": "",
    "answer_list": [
      "assertive",
      "popular",
      "good listener",
      "organized",
    ]
  },
  {
    "question_no": "12",
    "question_title": "",
    "answer_list": [
      "take charge",
      "uninhibited",
      "coorperative",
      "tactical",
    ]
  },
  {
    "question_no": "13",
    "question_title": "",
    "answer_list": [
      "aggressive",
      "vibrant",
      "gracious",
      "accurate",
    ]
  },
  {
    "question_no": "14",
    "question_title": "",
    "answer_list": [
      "direct",
      "excitable",
      "accommodating",
      "efficient",
    ]
  },
  {
    "question_no": "15",
    "question_title": "",
    "answer_list": [
      "frank",
      "influencing",
      "peaceful",
      "focused",
    ]
  },
  {
    "question_no": "16",
    "question_title": "",
    "answer_list": [
      "forceful",
      "animated",
      "agreeable",
      "systematic",
    ]
  }
];

const List<String> frequencyOption = [
  'Daily',
  'Weekly',
  'Monthly',
  'Annually',
];

const List<String> visionDays = [
  '30 days',
  '60 days',
  '90 days',
  '1 year',
  '2 years',
  '3 years'
];
