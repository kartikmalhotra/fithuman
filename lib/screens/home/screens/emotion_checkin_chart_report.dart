import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/provider/home_screen_povider.dart';
import 'package:brainfit/screens/emotion_journal/emotion_journal_conversation.dart';
import 'package:brainfit/screens/home/screens/emotion_journel_screen.dart';
import 'package:brainfit/utils/utils.dart';

class EmotionCheckInChartReport extends StatefulWidget {
  final List<Color> availableColors = const [
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];

  final Map<String, dynamic> chartData;
  final List<dynamic> lastTenEmotionsData;

  const EmotionCheckInChartReport({
    Key? key,
    required this.chartData,
    required this.lastTenEmotionsData,
  }) : super(key: key);

  @override
  State<EmotionCheckInChartReport> createState() =>
      EmotionChartState(chartData: chartData);
}

class EmotionChartState extends State<EmotionCheckInChartReport> {
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;
  List<dynamic> emotions = [];
  List<dynamic> lastTenEmotionsData = [];
  List<FlSpot> _lineChartData = [];

  EmotionChartState({required this.chartData});
  bool isPlaying = false;

  List<Color> gradientColors = [
    Colors.orange.withOpacity(0.7),
    Colors.yellow,
  ];
  Map<String, dynamic> chartData;

  List<int> showIndexes = [];

  @override
  void initState() {
    chartData = widget.chartData;
    lastTenEmotionsData = widget.lastTenEmotionsData;
    emotions = context.read<HomeScreenProvider>().emotions;

    for (int i = 0; i < lastTenEmotionsData.length; i++) {
      showIndexes.add(i);
      if (lastTenEmotionsData[i]["primary_emotion"]["name"] == "Ashamed" ||
          lastTenEmotionsData[i]["primary_emotion"]["name"] == "Intrigued" ||
          lastTenEmotionsData[i]["primary_emotion"]["name"] == "Anger" ||
          lastTenEmotionsData[i]["primary_emotion"]["name"] == "Threatened" ||
          lastTenEmotionsData[i]["primary_emotion"]["name"] == "Saddened" ||
          lastTenEmotionsData[i]["primary_emotion"]["name"] == "Disgust") {
        _lineChartData.add(FlSpot(i.toDouble(), 2));
      } else {
        _lineChartData.add(FlSpot(i.toDouble(), 8));
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          if (chartData.isNotEmpty) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 12.0, right: 10.0, top: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            'Emotions',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          OutlinedButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventJournelScreen()),
                              );
                              await context
                                  .read<HomeScreenProvider>()
                                  .getEmotionCheckIn();
                            },
                            child: Text(
                              "View",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(color: Colors.grey[900]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                side: BorderSide(
                                    width: 1, color: Colors.orangeAccent),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EmotionJournalConversationText(
                                            createData: {},
                                            openedFromNotification: true),
                                  ),
                                );
                                await context
                                    .read<HomeScreenProvider>()
                                    .reloadEmotionJournal();
                              },
                              child: Text(
                                "Check-in",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: Colors.grey[900]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: AppScreenConfig.safeBlockHorizontal! *
                            (lastTenEmotionsData.length >= 2 ? 70 : 90),
                        child: BarChart(
                          mainBarData(),
                          swapAnimationDuration: animDuration,
                        ),
                      ),
                      if (lastTenEmotionsData.length >= 2) ...[
                        SizedBox(width: 20.0),
                        Container(
                          width: AppScreenConfig.safeBlockHorizontal! * 70,
                          child: Stack(
                            children: <Widget>[
                              LineChart(
                                mainData(),
                                swapAnimationDuration: animDuration,
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Text("Last 10 Emotion checkin",
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(fontSize: 8)),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ] else ...[
            InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmotionJournalConversationText(
                        createData: {}, openedFromNotification: true),
                  ),
                );
                await context.read<HomeScreenProvider>().reloadEmotionJournal();
              },
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "How are you feeling?",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      "Do Emotion Check-in",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              ),
            )
          ],
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y,
      {bool isTouched = false,
      Color barColor = Colors.white,
      double width = 22,
      List<int> showTooltips = const []}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.orange.withOpacity(0.7),
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Colors.orange.withOpacity(0.7), width: 1)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: Colors.grey.withOpacity(0.4),
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(
        emotions.length,
        (i) {
          return makeGroupData(
              i, chartData[emotions[i]["name"]]?.toDouble() ?? 0,
              width: 12.0, isTouched: i == touchedIndex);
        },
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return Container();
  }

  LineChartData mainData() {
    final List<LineChartBarData> lineBarsData = [
      LineChartBarData(
        showingIndicators: [
          1,
          2,
          3,
        ],
        spots: _lineChartData,
        isCurved: true,
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        barWidth: 5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
      )
    ];

    final tooltipsOnBar = lineBarsData[0];

    return LineChartData(
      showingTooltipIndicators: showIndexes.map((index) {
        return ShowingTooltipIndicators([
          LineBarSpot(tooltipsOnBar, lineBarsData.indexOf(tooltipsOnBar),
              tooltipsOnBar.spots[index]),
        ]);
      }).toList(),
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          maxContentWidth: 50,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          tooltipBgColor: Colors.orange,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final textStyle = TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              );

              return LineTooltipItem(
                  lastTenEmotionsData[touchedSpot.x.toInt()]["primary_emotion"]
                      ["name"],
                  textStyle);
            }).toList();
          },
        ),
        handleBuiltInTouches: true,
        getTouchLineStart: (data, index) => 0,
      ),
      gridData: FlGridData(
        drawHorizontalLine: false,
        drawVerticalLine: false,
        show: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: lastTenEmotionsData.length.toDouble(),
      minY: 0,
      maxY: 10,
      lineBarsData: lineBarsData,
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        allowTouchBarBackDraw: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;

            return BarTooltipItem(
              emotions[groupIndex]?["name"] ?? "" + " " + '\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: " ${(rod.toY).toString()}",
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Container(
        width: 18.0,
        height: 20.0,
        child: CachedNetworkImage(
          imageUrl: "https://api.thegrowthnetwork.com" +
              emotions[value.toInt()]?["logo"],
          errorWidget: (context, url, error) {
            return Container();
          },
        ),
      ),
    );
  }
}
