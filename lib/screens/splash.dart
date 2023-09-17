import 'package:flutter/material.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/shared/models/user.model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    /// Get the calendars
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (User.isLoggedIn ?? false) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, ((route) => false));
      } else {
        if ((Application.localStorageService?.lastAssessment?.isNotEmpty ??
                false) &&
            (Application.localStorageService?.lastAssessment != "null")) {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.login, ((route) => false));
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.assessmentScreen, ((route) => false));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    AppScreenConfig.init(context);
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset(
          growthNetworkLogo,
          height: 200,
          width: 200,
          errorBuilder: ((context, error, stackTrace) {
            return Container();
          }),
        ),
      ),
    );
  }
}
