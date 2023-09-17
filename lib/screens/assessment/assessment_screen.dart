import 'package:flutter/material.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/screens/assessment/question_screen.dart';

class AssessmentUIScreen extends StatefulWidget {
  AssessmentUIScreen({Key? key}) : super(key: key);

  @override
  State<AssessmentUIScreen> createState() => _AssessmentUIScreenState();
}

class _AssessmentUIScreenState extends State<AssessmentUIScreen> {
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
          height: AppScreenConfig.safeBlockVertical! * 5,
        ),
        Image.asset("assets/images/logo.jpg",
            height: 100, width: double.maxFinite),
        SizedBox(
          height: AppScreenConfig.safeBlockVertical! * 5,
        ),
        SizedBox(
          height: AppScreenConfig.safeBlockVertical! * 20,
          child: Text(
            "Before we get going, let\'s start with your personality assessment.",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(
          height: AppScreenConfig.safeBlockVertical! * 10,
        ),
        Center(
          child: SizedBox(
            height: 50,
            width: AppScreenConfig.safeBlockHorizontal! * 70,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: ((context) => QuestionScreen()),
                    settings: RouteSettings(name: "AA"),
                  ),
                );
              },
              child: Text(
                'Start Assessment',
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
