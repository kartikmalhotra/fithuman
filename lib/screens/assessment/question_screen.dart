import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/assessment/chart_assessment.dart';
import 'package:brainfit/shared/models/user.model.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class QuestionScreen extends StatefulWidget {
  final String? routes;
  QuestionScreen({Key? key, this.routes}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  PageController _pageController = PageController();

  bool showLoader = false;
  int page = 0;

  List<String> _answersList = List.generate(
      assessmentQuestions[0]["answer_list"].length,
      (index) => assessmentQuestions[0]["answer_list"][index]);
  Map<String, dynamic> answerValue = {
    'commanding': 4,
    'decisive': 4,
    'tough minded': 4,
    'independent': 4,
    'daring': 4,
    'risk taker': 4,
    'courageous': 4,
    'confident': 4,
    'fearless': 4,
    'non conforming': 4,
    'assertive': 4,
    'take charge': 4,
    'aggressive': 4,
    'direct': 4,
    'frank': 4,
    'forceful': 4,
    'enthusiastic': 3,
    'expressive': 3,
    'convincing': 3,
    'fun loving': 3,
    'people oriented': 3,
    'lively': 3,
    'cheerful': 3,
    'inspiring': 3,
    'good mixer': 3,
    'popular': 3,
    'uninhibited': 3,
    'vibrant': 3,
    'excitable': 3,
    'influencing': 3,
    'animated': 3,
    'patient': 2,
    'lenient': 2,
    'kind': 2,
    'loyal': 2,
    'understanding': 2,
    'charitable': 2,
    'merciful': 2,
    'supportive': 2,
    'quiet': 2,
    'even paced': 2,
    'good listener': 0,
    'cooperative': 2,
    'gracious': 2,
    'accommodating': 2,
    'peaceful': 2,
    'agreeable': 2,
    'detailed': 1,
    'particular': 1,
    'meticulous': 1,
    'follow rules': 1,
    'high standards': 1,
    'serious': 1,
    'precise': 1,
    'logical': 1,
    'conscientious': 1,
    'analytical': 1,
    'organized': 1,
    'tactical': 1,
    'accurate': 1,
    'efficient': 1,
    'focussed': 1,
    'systematic': 1
  };

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20.0),
          color: LightAppColors.secondary.withOpacity(0.8),
          child: Stack(
            children: <Widget>[
              _displayContents(),
              if (showLoader) ...[
                Center(
                    child: AppCircularProgressIndicator(
                  color: Colors.white,
                )),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayContents() {
    return Opacity(
      opacity: showLoader ? 0.01 : 1,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          if (index < 16) {
            page = index;
            _answersList = List.generate(
                assessmentQuestions[page]["answer_list"].length,
                (index) => assessmentQuestions[page]["answer_list"][index]);
            setState(() {});
          }
        },
        itemBuilder: ((context, index) {
          return ListView(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: AppScreenConfig.safeBlockVertical! * 4,
                  ),
                  StepProgressIndicator(
                    totalSteps: 16,
                    currentStep: index,
                    size: 5.0,
                    selectedColor: Colors.white,
                    unselectedColor: Colors.grey,
                    roundedEdges: Radius.circular(10),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    "Sort these behaviours from most describes you to least describes you.",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      "You can hold each option to move them.",
                      style: Theme.of(context)
                          .textTheme
                          .caption!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: ReorderableListView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        for (int i = 0; i < _answersList.length; i++) ...[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            key: Key('$i'),
                            children: [
                              if (i == 0) ...[
                                Text(
                                  "Most describes you",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Colors.white),
                                )
                              ],
                              Card(
                                elevation: 3,
                                color: Colors.white,
                                shadowColor: LightAppColors.borderColor,
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 10.0),
                                  height: 50,
                                  decoration: BoxDecoration(
                                    boxShadow: [],
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        '${_answersList[i]}'.capitalize(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.black54),
                                      ),
                                      Spacer(),
                                      Icon(Icons.reorder,
                                          color: LightAppColors.greyColor),
                                    ],
                                  ),
                                ),
                              ),
                              if (i == (_answersList.length - 1)) ...[
                                Text(
                                  "Least describes you",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(color: Colors.white),
                                )
                              ]
                            ],
                          ),
                        ]
                      ],
                      onReorder: (int oldIndex, int newIndex) {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final String item = _answersList.removeAt(oldIndex);
                        _answersList.insert(newIndex, item);
                        updateAnswerValue();
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if (page == 0 && widget.routes != null) ...[
                        SizedBox(
                          height: 50,
                          width: AppScreenConfig.safeBlockHorizontal! * 40,
                          child: OutlinedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Previous",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        )
                      ],
                      if (page != 0) ...[
                        SizedBox(
                          height: 50,
                          width: AppScreenConfig.safeBlockHorizontal! * 40,
                          child: OutlinedButton(
                            onPressed: () async {
                              page--;
                              if (page >= 0) {
                                _pageController.animateToPage(page,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.ease);
                              }
                            },
                            child: Text(
                              "Previous",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                      SizedBox(
                        height: 50,
                        width: AppScreenConfig.safeBlockHorizontal! * 40,
                        child: OutlinedButton(
                          onPressed: () async {
                            page++;
                            if (page != 16) {
                              _pageController.animateToPage(page,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.ease);
                            } else {
                              page = 15;
                              if (User.isLoggedIn ?? false) {
                                await sendAssessmentToServer();
                              } else {
                                await saveAssessmentInDatabase();
                                Navigator.pushNamedAndRemoveUntil(context,
                                    AppRoutes.askUserToLogin, (route) => false);
                              }
                            }
                          },
                          child: Text(
                            page != 15 ? 'Next' : "Submit",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> saveAssessmentInDatabase() async {
    answerValue["fun_loving"] = answerValue["fun loving"];
    answerValue['tough_minded'] = answerValue["tough minded"];
    answerValue['risk_taker'] = answerValue["risk taker"];
    answerValue['non_conforming'] = answerValue['non conforming'];
    answerValue['take_charge'] = answerValue["take charge"];
    answerValue['fun_loving'] = answerValue["fun loving"];
    answerValue['people_oriented'] = answerValue['people oriented'];
    answerValue['good_mixer'] = answerValue['good mixer'];
    answerValue['even_paced'] = answerValue['even paced'];
    answerValue['good_listener'] = answerValue['good listener'];
    answerValue['follow_rules'] = answerValue['follow rules'];
    answerValue['high_standards'] = answerValue['high standards'];
    Application.localStorageService?.lastAssessment = jsonEncode(answerValue);
  }

  Future<void> sendAssessmentToServer() async {
    try {
      showLoader = true;
      setState(() {});
      answerValue["fun_loving"] = answerValue["fun loving"];
      answerValue['tough_minded'] = answerValue["tough minded"];
      answerValue['risk_taker'] = answerValue["risk taker"];
      answerValue['non_conforming'] = answerValue['non conforming'];
      answerValue['take_charge'] = answerValue["take charge"];
      answerValue['fun_loving'] = answerValue["fun loving"];
      answerValue['people_oriented'] = answerValue['people oriented'];
      answerValue['good_mixer'] = answerValue['good mixer'];
      answerValue['even_paced'] = answerValue['even paced'];
      answerValue['good_listener'] = answerValue['good listener'];
      answerValue['follow_rules'] = answerValue['follow rules'];
      answerValue['high_standards'] = answerValue['high standards'];

      var response = await Application.restService!.requestCall(
          apiEndPoint: "api/assessments",
          requestParmas: answerValue,
          addAutherization: true,
          method: RestAPIRequestMethods.post);
      showLoader = false;
      setState(() {});
      if (response['code'] == 200 || response['code'] == "200") {
        if (widget.routes == null) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                settings: RouteSettings(name: "AB"),
                builder: (context) => AssessmentChartScreen(
                    assessmentResult: response["data"], route: widget.routes),
              ),
              (route) => false);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: RouteSettings(name: "AB"),
              builder: (context) => AssessmentChartScreen(
                  assessmentResult: response["data"], route: widget.routes),
            ),
          );
        }
      }
    } catch (exe) {
      if (kDebugMode) {
        print("Firebase Exeception $exe");
      }
    }
  }

  void updateAnswerValue() {
    for (int i = 0; i < _answersList.length; i++) {
      answerValue[_answersList[i]] = _answersList.length - i;
    }
  }
}
