import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/screens/assessment/assessment_info.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class HomePieChartCard extends StatefulWidget {
  final Map<String, dynamic> assessmentResult;

  const HomePieChartCard({Key? key, required this.assessmentResult})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => PieChartCardState();
}

class PieChartCardState extends State<HomePieChartCard> {
  List<Map<String, dynamic>> chartResult = [];
  ScreenshotController _controller = ScreenshotController();
  static GlobalKey previewContainer = new GlobalKey();
  final ScrollController _scrollController = ScrollController();

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
    super.initState();
  }

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.maxFinite,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: _displayChartContents(),
          ),
          Row(
            children: <Widget>[
              _displayShareButton(),
              Spacer(),
              Text(
                  "${DateFormat.yMMMMd('en_US').add_jm().format(DateTime.parse(widget.assessmentResult["created_at"].toString()))}",
                  style: Theme.of(context).textTheme.caption),
              SizedBox(width: 10.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _displayShareButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_showLoader) ...[
          Container(
            height: 20.0,
            width: 20.0,
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: AppCircularProgressIndicator(strokeWidth: 2),
          ),
        ] else ...[
          Container()
        ],
        IconButton(
          onPressed: () async {
            _showLoader = true;

            await _controller
                .captureFromWidget(_displayChartContents())
                .then((image) async {
              String? path =
                  await Utils.screenShotAndSaveToLocal(context, _controller);
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

            setState(() {});
          },
          icon: Icon(
            Icons.share_outlined,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _displayChartContents() {
    return LayoutBuilder(
      builder: ((context, constraints) {
        return Container(
          height: constraints.maxHeight,
          child: Screenshot(
            controller: _controller,
            child: Container(
              color: Colors.white,
              child: Scrollbar(
                controller: _scrollController,
                child: ListView(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
                  controller: _scrollController,
                  children: <Widget>[
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
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
                                    showInfoForString:
                                        "${chartResult[2]["name"]}"),
                              ),
                            );
                          },
                          child: Text(
                            "${chartResult[2]["name"]}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: 16,
                                    color: LightAppColors.primary,
                                    decoration: TextDecoration.underline),
                          ),
                        ),
                        Text(","),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AssessmentInfoScreen(
                                    showInfoForString:
                                        "${chartResult[3]["name"]}"),
                              ),
                            );
                          },
                          child: Text(
                            "${chartResult[3]["name"]}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: LightAppColors.primary,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10.0),
                    AspectRatio(
                      aspectRatio: 2.5,
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
                          sections: showingSections(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
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
                              padding: EdgeInsets.only(left: 5.0),
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
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                chartResult[3]["value"].toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                chartResult[0]["value"].toString(),
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Indicator(
                              color: chartResult[1]["color"],
                              text: chartResult[1]["name"],
                              isSquare: false,
                              size: touchedIndex == 0 ? 18 : 16,
                              textColor: Colors.black,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                chartResult[1]["value"].toString(),
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
            ),
          ),
        );
      }),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == touchedIndex;

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: chartResult[0]["color"],
              value: 25,
              title: '',
              radius: chartResult[0]["value"].toDouble(),
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff044d7c)),
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: chartResult[1]["color"],
              value: 25,
              radius: chartResult[1]["value"].toDouble(),
              title: "",
              titleStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              titlePositionPercentageOffset: 0.55,
            );
          case 2:
            return PieChartSectionData(
              color: chartResult[2]["color"],
              value: 25,
              radius: chartResult[2]["value"].toDouble(),
              title: '',
              titleStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff4c3788)),
              titlePositionPercentageOffset: 0.6,
            );
          case 3:
            return PieChartSectionData(
              color: chartResult[3]["color"],
              value: 25,
              radius: chartResult[3]["value"].toDouble(),
              title: '',
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
