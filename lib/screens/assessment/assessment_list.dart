import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/assessment/assessment_info.dart';
import 'package:brainfit/screens/assessment/assessment_screen.dart';
import 'package:brainfit/screens/assessment/question_screen.dart';
import 'package:brainfit/screens/home/screens/pie_chart_home.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class AssessmentListScreen extends StatefulWidget {
  const AssessmentListScreen({Key? key}) : super(key: key);

  @override
  State<AssessmentListScreen> createState() => _AssessmentListScreenState();
}

class _AssessmentListScreenState extends State<AssessmentListScreen> {
  bool showLoader = false;
  List<dynamic> assessment = [];
  String? _errorMessage;
  final ScrollController _scrollController = ScrollController();

  Future<void> getAssessments() async {
    try {
      showLoader = true;
      setState(() {});
      var response = await Application.restService!.requestCall(
          apiEndPoint: "api/assessments",
          addAutherization: true,
          method: RestAPIRequestMethods.get);
      showLoader = false;
      setState(() {});
      if (response['code'] == 200 || response['code'] == "200") {
        assessment = response["data"];
      } else if (response["error"] != null) {
        _errorMessage = response["error"];
      } else {
        _errorMessage = "Something went wrong";
      }
    } catch (exe) {
      if (kDebugMode) {
        print("Firebase Exeception $exe");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getAssessments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: showLoader ? 0.01 : 1,
            child: _displayContents(),
          ),
          if (showLoader) ...[
            Center(child: AppCircularProgressIndicator()),
          ]
        ],
      ),
    );
  }

  Widget _displayContents() {
    return SafeArea(
      child: Container(
        width: AppScreenConfig.safeBlockHorizontal! * 100,
        height: AppScreenConfig.safeBlockVertical! * 100,
        color: Colors.grey.withOpacity(0.01),
        child: Stack(
          children: <Widget>[
            if (!showLoader && _errorMessage == null) ...[
              if (assessment.length != 0) ...[
                Scrollbar(
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    itemCount: assessment.length,
                    itemBuilder: (context, index) {
                      return _showAssessmentCard(assessment[index]);
                    },
                  ),
                ),
              ] else ...[
                Center(
                  child: Text(
                    "No assessments found",
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.black,
                        ),
                  ),
                )
              ]
            ],
            if (_errorMessage != null) ...[
              Center(
                child: Text(_errorMessage ?? "Something went wrong"),
              )
            ],
          ],
        ),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: LightAppColors.blackColor,
          size: 20,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: TextButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) =>
                      QuestionScreen(routes: AppRoutes.assessmentListScreen)),
                  settings: RouteSettings(name: "AA"),
                ),
              );
              getAssessments();
            },
            child: Text(
              "Take Assessment",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: LightAppColors.secondary),
            ),
          ),
        ),
      ],
    );
  }

  Widget _showAssessmentCard(Map<String, dynamic> data) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Colors.white,
      child: Container(
        height: AppScreenConfig.safeBlockVertical! * 50,
        padding: EdgeInsets.all(10.0),
        child: HomePieChartCard(
          assessmentResult: data,
        ),
      ),
    );
  }
}

class PieChartCard extends StatefulWidget {
  final Map<String, dynamic> assessmentResult;
  final Function(bool) showLoader;

  const PieChartCard({
    Key? key,
    required this.assessmentResult,
    required this.showLoader,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartCardState();
}

class PieChartCardState extends State<PieChartCard> {
  List<Map<String, dynamic>> chartResult = [];
  ScreenshotController _controller = ScreenshotController();
  static GlobalKey previewContainer = new GlobalKey();

  bool _showLoader = false;

  @override
  void initState() {
    chartResult = [
      {
        "type": "controller_score",
        "value": widget.assessmentResult["controller_score"],
        "color": const Color(0xff0293ee),
        "name": "Controller"
      },
      {
        "type": "promoter_score",
        "value": widget.assessmentResult["promoter_score"],
        "color": Colors.orange,
        "name": "Promoter"
      },
      {
        "type": "supporter_score",
        "value": widget.assessmentResult["supporter_score"],
        "color": const Color(0xff845bef),
        "name": "Supporter"
      },
      {
        "type": "analyzer_score",
        "value": widget.assessmentResult["analyzer_score"],
        "color": const Color(0xff13d38e),
        "name": "Analyzer"
      }
    ];

    chartResult.sort((a, b) => a["value"].compareTo(b["value"]));
  }

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_showLoader) ...[
                Center(
                  child: AppCircularProgressIndicator(),
                ),
              ] else ...[
                Container()
              ],
              IconButton(
                onPressed: () async {
                  _showLoader = true;
                  if (mounted) {
                    setState(() {});
                  }
                  widget.showLoader(_showLoader);
                  await _controller
                      .captureFromWidget(_displayChartContents())
                      .then((image) async {
                    String? path = await Utils.screenShotAndSaveToLocal(
                        context, _controller);
                    if (path != null) {
                      /// Share Plugin
                      if (Platform.isIOS) {
                        Clipboard.setData(ClipboardData(
                            text:
                                "Check out the results of my personality assessment that I took on the Growth Coach app. You can take the test by downloading the app - https://google.com"));
                        Utils.showSuccessToast(
                            "Your text is copied to clipboard, you can copy the text from the clipboard");
                      }
                      await Share.shareFiles([path],
                          text:
                              "Check out the results of my personality assessment that I took on the Growth Coach app. You can take the test by downloading the app - https://google.com");
                    }
                  });
                  _showLoader = false;
                  if (mounted) {
                    setState(() {});
                  }
                  widget.showLoader(_showLoader);
                },
                icon: Icon(
                  Icons.share_outlined,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          _displayChartContents()
        ],
      ),
    );
  }

  Widget _displayChartContents() {
    return Expanded(
      child: Screenshot(
        controller: _controller,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // if (_showLoader) ...[
              //   Image.asset(
              //     "assets/images/logo.jpg",
              //     height: 100,
              //     width: double.maxFinite,
              //   ),
              // ],
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 4),
              Text("We think, you are a"),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssessmentInfoScreen(
                          showInfoForString: "${chartResult[2]["name"]}"),
                    ),
                  );
                },
                child: Text("${chartResult[2]["name"]}"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssessmentInfoScreen(
                          showInfoForString: "${chartResult[3]["name"]}"),
                    ),
                  );
                },
                child: Text("${chartResult[3]["name"]}"),
              ),

              AspectRatio(
                aspectRatio: 2,
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
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
                    sections: showingSections(),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          chartResult[2]["value"].toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Indicator(
                        color: chartResult[3]["color"],
                        text: chartResult[3]["name"],
                        isSquare: false,
                        size: touchedIndex == 0 ? 18 : 16,
                        textColor: Colors.black,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          chartResult[3]["value"].toString(),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                    "${DateFormat.yMMMMd('en_US').add_jm().format(DateTime.parse(widget.assessmentResult["created_at"].toString()))}",
                    style: Theme.of(context).textTheme.caption),
              ),
            ],
          ),
        ),
      ),
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
              color: chartResult[0]["color"],
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
              color: chartResult[1]["color"],
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
              color: chartResult[2]["color"],
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
              color: chartResult[3]["color"],
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
        Text(text)
      ],
    );
  }
}
