import 'package:flutter/material.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/screens/assessment/ask_user_to_login.dart';
import 'package:brainfit/screens/assessment/assessment_list.dart';
import 'package:brainfit/screens/assessment/assessment_screen.dart';
import 'package:brainfit/screens/authentication/screens/login.dart';
import 'package:brainfit/screens/home/screens/event_detail_screen.dart';
import 'package:brainfit/screens/home/screens/event_listing.dart';
import 'package:brainfit/screens/home/screens/home_screen.dart';
import 'package:brainfit/screens/home/screens/vison_detail.dart';
import 'package:brainfit/screens/profile/profile.dart';
import 'package:brainfit/screens/splash.dart';
import 'package:brainfit/screens/vision/screens/emotion_vision_screen.dart';
import 'package:brainfit/screens/splash.dart';

class AppRouteSetting {
  static AppRouteSetting? _routeSetting;

  AppRouteSetting._internal();

  static AppRouteSetting? getInstance() {
    _routeSetting ??= AppRouteSetting._internal();
    return _routeSetting;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => HomeScreen(),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginPage(),
        );
      case AppRoutes.askUserToLogin:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AskUserToLogin(),
        );
      case AppRoutes.profileScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => ProfileScreen(),
        );
      case AppRoutes.assessmentScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AssessmentUIScreen(),
        );
      case AppRoutes.assessmentListScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => AssessmentListScreen(),
        );
      case AppRoutes.visionDetailScreen:
        dynamic data = settings.arguments;
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => VisionDetailScreen(visionId: data["vision_id"]));
      case AppRoutes.eventDetailScreen:
        dynamic data = settings.arguments;
        return MaterialPageRoute(
            settings: settings,
            builder: (_) => EventDetailScreen(eventId: data["event_id"]));
      case AppRoutes.eventsListScreen:
        dynamic data = settings.arguments;
        return MaterialPageRoute(
            settings: settings, builder: (_) => EventListingScreen());
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Center(
              child: Text("Hi There", style: TextStyle(color: Colors.white))),
        );
    }
  }
}
