import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:brainfit/screens/assessment/assessment_info.dart';
import 'package:brainfit/screens/vision/screens/vision_create.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';
import 'package:confetti/confetti.dart';

class AssessmentChartScreen extends StatefulWidget {
  final Map<String, dynamic> assessmentResult;
  final String? route;
  final bool? assessmentAfterLogin;

  const AssessmentChartScreen({
    Key? key,
    required this.assessmentResult,
    this.route,
    this.assessmentAfterLogin = false,
  }) : super(key: key);

  @override
  State<AssessmentChartScreen> createState() => _AssessmentChartScreenState();
}

class _AssessmentChartScreenState extends State<AssessmentChartScreen> {
  GlobalKey src = new GlobalKey();
  ScreenshotController _controller = ScreenshotController();
  bool _showLoader = false;
  Map<String, dynamic> assessmentResult = {};
  late ConfettiController _controllerBottomCenter;
  late ConfettiController _controllerTopCenter;

  Map<String, double> scores = {};
  List<String> data = [];
  List<Map<String, dynamic>> chartResult = [];

  @override
  void initState() {
    assessmentResult = widget.assessmentResult;
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerBottomCenter.play();

    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter.play();
    chartResult = [
      {
        "type": "controller_score",
        "value": widget.assessmentResult["controller_score"],
        "color": Colors.cyan,
        "name": "Controller"
      },
      {
        "type": "promoter_score",
        "value": widget.assessmentResult["promoter_score"],
        "color": Colors.pink,
        "name": "Promoter"
      },
      {
        "type": "supporter_score",
        "value": widget.assessmentResult["supporter_score"],
        "color": Colors.purple,
        "name": "Supporter"
      },
      {
        "type": "analyzer_score",
        "value": widget.assessmentResult["analyzer_score"],
        "color": visionColor,
        "name": "Analyzer"
      }
    ];

    chartResult.sort((a, b) => a["value"].compareTo(b["value"]));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _displayContents(),
      ),
    );
  }

  Widget _displayContents() {
    return Stack(
      children: <Widget>[
        //TOP CENTER - shoot down
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _controllerTopCenter,
            blastDirection: pi / 2,
            maxBlastForce: 5, // set a lower max blast force
            minBlastForce: 2, // set a lower min blast force
            emissionFrequency: 0.05,
            numberOfParticles: 50, // a lot of particles at once
            gravity: 1,
          ),
        ),

        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controllerBottomCenter,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            shouldLoop:
                true, // start again as soon as the animation is finished
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
            createParticlePath: drawStar, // define a custom shape/path.
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _controllerBottomCenter,
            blastDirectionality: BlastDirectionality
                .explosive, // don't specify a direction, blast randomly
            shouldLoop:
                true, // start again as soon as the animation is finished
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple
            ], // manually specify the colors to be used
            createParticlePath: drawStar, // define a custom shape/path.
          ),
        ),
        Opacity(
          opacity: _showLoader ? 0.1 : 1,
          child: Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.cancel_outlined),
                      color: Colors.black,
                      onPressed: () {
                        if (widget.route == null) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VisionCreateScreen(
                                      fromAssessmentScreen: true)),
                              (route) => false);
                        } else if (widget.assessmentAfterLogin ?? false) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, AppRoutes.home, ((route) => false));
                        } else {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ),
                  _displayAssessmentsContents(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        height: 45,
                        width: AppScreenConfig.safeBlockHorizontal! * 30,
                        child: OutlinedButton(
                          onPressed: () async {
                            _showLoader = true;
                            setState(() {});
                            await _controller
                                .captureFromWidget(_showChart(context))
                                .then((image) async {
                              String? path =
                                  await Utils.screenShotAndSaveToLocal(
                                      context, _controller);
                              Clipboard.setData(ClipboardData(
                                  text:
                                      "Check out the results of my personality assessment that I took on the Growth Coach app. You can take the test by downloading the app - https://google.com"));
                              Utils.showSuccessToast(
                                  "Your text is successfully copied to clipboard");

                              /// Share Plugin
                              await Share.shareFiles([path!],
                                  text:
                                      "Check out the results of my personality assessment that I took on the Growth Coach app. You can take the test by downloading the app - https://google.com");
                              // text:
                              //     "Check out the results of my personality assessment that I took on the Growth Coach app. You can take the test by downloading the app - https://google.com");
                            });
                            _showLoader = false;
                            setState(() {});
                          },
                          child: Text(
                            "Share",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: LightAppColors.secondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_showLoader) ...[
          Center(child: AppCircularProgressIndicator()),
        ]
      ],
    );
  }

  // A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  Widget _displayAssessmentsContents() {
    return Screenshot(
      controller: _controller,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
            if (_showLoader) ...[
              Image.asset("assets/images/logo.jpg",
                  height: 100, width: double.maxFinite),
            ],
            assessmentResultTitle(),
            SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 0.0,
              children: <Widget>[
                Text(
                  "We think, you are a ",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(fontSize: 16),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssessmentInfoScreen(
                            showInfoForString: "${chartResult[2]["name"]}"),
                      ),
                    );
                  },
                  child: Text(
                    "${chartResult[2]["name"]}",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 16,
                        color: LightAppColors.primary,
                        decoration: TextDecoration.underline),
                  ),
                ),
                Text(", "),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AssessmentInfoScreen(
                            showInfoForString: "${chartResult[3]["name"]}"),
                      ),
                    );
                  },
                  child: Text(
                    "${chartResult[3]["name"]}",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: LightAppColors.primary,
                        decoration: TextDecoration.underline,
                        fontSize: 16),
                  ),
                )
              ],
            ),
            SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
            _showChart(context),
            SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
          ],
        ),
      ),
    );
  }

  Widget _showChart(context) {
    return PieChartSample1(assessmentResult: widget.assessmentResult);
  }

  Widget assessmentResultTitle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            "Personality Assessment",
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(height: 10.0),
        // Text(
        //   "Here is the result of your assessment",
        //   style: Theme.of(context)
        //       .textTheme
        //       .caption!
        //       .copyWith(color: LightAppColors.greyColor),
        // )
      ],
    );
  }
}

class PieChartSample1 extends StatefulWidget {
  final Map<String, dynamic> assessmentResult;
  const PieChartSample1({Key? key, required this.assessmentResult})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartSample1State();
}

class PieChartSample1State extends State<PieChartSample1> {
  int touchedIndex = -1;

  List<Map<String, dynamic>> chartResult = [];

  @override
  void initState() {
    chartResult = [
      {
        "type": "controller_score",
        "value": widget.assessmentResult["controller_score"],
        "color": Colors.cyan,
        "name": "Controller"
      },
      {
        "type": "promoter_score",
        "value": widget.assessmentResult["promoter_score"],
        "color": Colors.pink,
        "name": "Promoter"
      },
      {
        "type": "supporter_score",
        "value": widget.assessmentResult["supporter_score"],
        "color": Colors.purple,
        "name": "Supporter"
      },
      {
        "type": "analyzer_score",
        "value": widget.assessmentResult["analyzer_score"],
        "color": visionColor,
        "name": "Analyzer"
      }
    ];

    chartResult.sort((a, b) => a["value"].compareTo(b["value"]));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.3,
          child: Column(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: new MediaQuery(
                    data: new MediaQueryData(),
                    child: PieChart(
                      PieChartData(
                          pieTouchData: PieTouchData(touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          }),
                          startDegreeOffset: 180,
                          borderData: FlBorderData(
                            show: false,
                          ),
                          sectionsSpace: 1,
                          centerSpaceRadius: 0,
                          sections: showingSections()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Indicator(
                        color: chartResult[0]["color"],
                        text: chartResult[0]["name"],
                        isSquare: false,
                        size: touchedIndex == 0 ? 18 : 16,
                        textColor: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          chartResult[0]["value"].toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Indicator(
                        color: chartResult[1]["color"],
                        text: chartResult[1]["name"],
                        isSquare: false,
                        size: touchedIndex == 0 ? 18 : 16,
                        textColor: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          chartResult[1]["value"].toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.0),
              Row(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Indicator(
                        color: chartResult[2]["color"],
                        text: chartResult[2]["name"],
                        isSquare: false,
                        size: touchedIndex == 0 ? 18 : 16,
                        textColor: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          chartResult[2]["value"].toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Indicator(
                        color: chartResult[3]["color"],
                        text: chartResult[3]["name"],
                        isSquare: false,
                        size: touchedIndex == 0 ? 18 : 16,
                        textColor: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Text(
                          chartResult[3]["value"].toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == touchedIndex;
        final opacity = isTouched ? 1.0 : 0.6;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: chartResult[0]["color"].withOpacity(opacity),
              value: chartResult[0]["value"].toDouble(),
              title: '',
              radius: 80,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: chartResult[1]["color"].withOpacity(opacity),
              value: chartResult[1]["value"].toDouble(),
              title: "",
              radius: 65,
              titleStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              titlePositionPercentageOffset: 0.55,
            );
          case 2:
            return PieChartSectionData(
              color: chartResult[2]["color"].withOpacity(opacity),
              value: chartResult[2]["value"].toDouble(),
              title: '',
              radius: 60,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
            );
          case 3:
            return PieChartSectionData(
              color: chartResult[3]["color"].withOpacity(opacity),
              value: chartResult[3]["value"].toDouble(),
              title: '',
              radius: 70,
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0c7f55)),
              titlePositionPercentageOffset: 0.55,
            );
          default:
            throw Error();
        }
      },
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
