import 'package:flutter/material.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/screens/assessment/question_screen.dart';
import 'package:brainfit/screens/authentication/screens/login.dart';

class AskUserToLogin extends StatefulWidget {
  AskUserToLogin({Key? key}) : super(key: key);

  @override
  State<AskUserToLogin> createState() => _AskUserToLoginState();
}

class _AskUserToLoginState extends State<AskUserToLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(30.0),
          color: Colors.white,
          child: _displayContents(),
        ),
      ),
    );
  }

  Widget _displayContents() {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: AppScreenConfig.safeBlockVertical! * 10,
        ),
        Image.asset("assets/images/logo.jpg",
            height: 100, width: double.maxFinite),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        SizedBox(
          height: AppScreenConfig.safeBlockVertical! * 20,
          child: Text(
            "You need to signup to save the assessment",
            style: Theme.of(context).textTheme.subtitle1,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 15),
        Center(
          child: SizedBox(
            height: 50,
            width: AppScreenConfig.safeBlockHorizontal! * 70,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              },
              child: Text(
                'Signup',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
