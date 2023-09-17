import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';

import 'package:brainfit/screens/event_schedular/screens/create_event.dart';
import 'package:brainfit/screens/event_schedular/screens/event_summary_screen.dart';
import 'package:brainfit/screens/event_schedular/screens/event_title.dart';
import 'package:brainfit/screens/vision/screens/conversation_text.dart';
import 'package:brainfit/screens/vision/screens/vision_creation_summary.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class VisionDetailScreen extends StatefulWidget {
  final String visionId;

  VisionDetailScreen({
    Key? key,
    required this.visionId,
  }) : super(key: key);

  @override
  State<VisionDetailScreen> createState() => _VisionDetailState();
}

class _VisionDetailState extends State<VisionDetailScreen> {
  late String visionId;
  dynamic vision;
  bool showLoader = false;
  List<dynamic> events = [];
  String? _errorMessage;

  @override
  void initState() {
    showLoader = true;
    visionId = widget.visionId;
    super.initState();
    getData();
  }

  Future<dynamic> getData() async {
    setState(() {
      showLoader = true;
    });
    var response = await [
      await Application.restService!.requestCall(
          apiEndPoint:
              "${ApiRestEndPoints.visionPlanner}?vision_id=${visionId}",
          addAutherization: true,
          method: RestAPIRequestMethods.get),
      await Application.restService!.requestCall(
          apiEndPoint: "${ApiRestEndPoints.schedulers}?vision_id=${visionId}",
          addAutherization: true,
          method: RestAPIRequestMethods.get),
    ];

    if (response[0]['code'] == 200 || response[0]['code'] == "200") {
      vision = response[0]['data'];
    }
    if (response[1]['code'] == 200 || response[1]['code'] == "200") {
      events = response[1]['data'];
    }
    if (response[0]['error'] != null) {
      _errorMessage = response[0]['error'];
    }

    if (mounted) {
      setState(() {
        showLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: visionColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        title: Text("Vision",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: LightAppColors.blackColor)),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: LightAppColors.blackColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: InkWell(
              onTap: () async {
                if (vision != null) {
                  Map<String, dynamic> createData = {
                    "vision_id": vision?["id"],
                    "primary_relationship": vision["primary_relationship"]
                        ?["name"],
                    "secondary_relationship": vision["seconday_relationship"]
                        ?["name"],
                    "current_rating": vision["current_rating"],
                    "conversation_with_self": vision["conversation_with_self"],
                    "conversation_text": vision["conversation_with_self"],
                    "importance_text": vision["importance"],
                    "price": vision["price"]["name"],
                    "get_to_be": vision["get_to_be"]["name"],
                    "emotions": vision["emotions"]
                        .map((e) => e["name"])
                        .toList()
                        .cast<String>(),
                    "commitment": vision["commitment"]["name"],
                  };

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: "A"),
                      builder: (context) => VisionCreationSummary(
                        createData: createData,
                        isEditing: true,
                        removeScreenUntil: "/home/vision_detail",
                      ),
                    ),
                  );
                  await getData();
                }
              },
              child:
                  Icon(Icons.edit, color: LightAppColors.blackColor, size: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () async {
                await deleteVision(vision["id"]);
              },
              icon: Icon(Icons.delete_outline,
                  color: LightAppColors.blackColor, size: 20),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          height: AppScreenConfig.safeBlockVertical! * 100,
          width: AppScreenConfig.safeBlockHorizontal! * 100,
          child: Stack(
            children: <Widget>[
              if (_errorMessage == null && !showLoader) ...[
                Opacity(
                  opacity: showLoader ? 0.01 : 1,
                  child: _showVisionDetail(),
                ),
              ],
              if (_errorMessage != null) ...[
                Center(child: Text(_errorMessage ?? "Something went wrong")),
              ],
              if (showLoader) ...[
                Center(child: AppCircularProgressIndicator()),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _showVisionDetail() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      children: [
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.5),
                child: Text(
                  "${Utils.utf8convert(vision["primary_relationship"]?["name"]?.toString() ?? "")}",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.5),
                child: Text(
                  "${Utils.utf8convert(vision["secondary_relationship"]?["name"]?.toString() ?? "")}",
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              "( ${vision["current_rating"].toString()}/10 )",
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  color: LightAppColors.blackColor,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
        SizedBox(height: 20.0),
        Text("What is the conversation you are having with yourself",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.grey)),
        SizedBox(height: 10.0),
        Text(
          Utils.utf8convert(vision["conversation_with_self"].toString()),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.black),
        ),
        SizedBox(height: 30.0),
        Text(
          "Why is this relationship important to you",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey),
        ),
        SizedBox(height: 10.0),
        Text(
          Utils.utf8convert(vision["importance"].toString()),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 30.0),
        Text(
          "What price am I willing to pay to move this relationship forward?",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
                border: Border.all(width: 0.1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.5),
              child: Text(
                Utils.utf8convert(vision["price"]["name"].toString()),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.0),
        Text(
          "Enter a Get to be be",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
                border: Border.all(width: 0.1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.5),
              child: Text(
                Utils.utf8convert(vision["get_to_be"]["name"].toString()),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.0),
        Text(
          "Select Emotion for your vision",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 10.0),
        Wrap(
          runSpacing: 5.0,
          spacing: 5.0,
          children: [
            for (int i = 0; i < (vision["emotions"]?.length ?? 0); i++) ...[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  border: Border.all(width: 0.1),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      Utils.utf8convert(vision["emotions"][i]["name"]),
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.black),
                    ),
                    SizedBox(width: 5.0),
                    Image.network(
                      "https://api.thegrowthnetwork.com" +
                          vision["emotions"][i]["logo"],
                      height: 15.0,
                      width: 15.0,
                    )
                  ],
                ),
              )
            ]
          ],
        ),
        SizedBox(height: 30.0),
        Text(
          "You are committed to building a relationship of",
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 10.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
                border: Border.all(width: 0.1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.5),
              child: Text(
                Utils.utf8convert(vision["commitment"]["name"].toString()),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.0),
        if (events.length != 0) ...[
          if (events.length == 1) ...[
            Text(
              "You have ${events.length} commitment, to help you achieve this vision",
              textAlign: TextAlign.start,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
            ),
          ] else ...[
            Text(
              "You have ${events.length} commitment, to help you achieve this vision",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ],
        ],
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Commitments", style: Theme.of(context).textTheme.subtitle1!),
            OutlinedButton(
              child: Text(
                "Add",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.black),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: RouteSettings(arguments: "EA"),
                    builder: (context) => EventCreateScreen(
                      route: AppRoutes.visionDetailScreen,
                      createData: {"vision_id": vision["id"]},
                    ),
                  ),
                );

                await getData();
              },
            )
          ],
        ),
        if (events.length != 0) ...[
          ListView.builder(
            shrinkWrap: true,
            itemCount: events.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return _displayEventsForVision(index);
            },
          )
        ] else ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "You have no commitments present",
              textAlign: TextAlign.center,
            ),
          ),
        ]
      ],
    );
  }

  Widget _displayEventsForVision(int index) {
    DateTime _startDate =
        DateTime.parse(events[index]["start_datetime"]).toLocal();
    DateTime _endDate = DateTime.parse(events[index]["end_datetime"]).toLocal();

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.5, 1.0],
          colors: [
            commitmentColorGradient1,
            commitmentColorGradient2,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              OutlinedButton(
                onPressed: () {
                  final Event event = Event(
                    title: events[index]["title"],
                    description: events[index]["description"],
                    location: events[index]["location"],
                    recurrence: Recurrence(
                        frequency:
                            calculateFrequency(events[index]["frequency"]),
                        endDate: DateTime.parse(events[index]["end_datetime"])
                            .toLocal()),
                    startDate: DateTime.parse(events[index]["start_datetime"])
                        .toLocal(),
                    endDate: DateTime.parse(events[index]["start_datetime"])
                        .toLocal()
                        .add(Duration(
                            seconds: double.parse(
                                    events[index]["duration"].toString())
                                .toInt())),
                    iosParams: IOSParams(
                      reminder: Duration(
                          seconds:
                              double.parse(events[index]["duration"].toString())
                                  .toInt()),
                    ),
                    androidParams: AndroidParams(
                      emailInvites: [], // on Android, you can add invite emails to your event.
                    ),
                  );

                  Add2Calendar.addEvent2Cal(event);
                },
                child: Text(
                  "Add to Calendar",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.black),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  Map<String, dynamic> createData = {
                    "event_id": events[index]["id"],
                    "created_at": events[index]["created_at"],
                    "title": events[index]["title"],
                    "description": events[index]["description"],
                    "location": events[index]["location"],
                    "start_datetime": events[index]["start_datetime"],
                    "end_datetime": events[index]["end_datetime"],
                    "duration": events[index]["duration"],
                    "recurring": events[index]["recurring"],
                    "frequency": events[index]["frequency"],
                    "vision_id": events[index]["vision_id"],
                  };

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: "EA"),
                      builder: (context) => EventSummaryScreen(
                          route: AppRoutes.visionDetailScreen,
                          createData: createData,
                          isEditing: true),
                    ),
                  );
                  await getData();
                },
                child: Padding(
                  padding: EdgeInsets.all(3.5),
                  child: Icon(Icons.edit, color: Colors.white),
                ),
              ),
              SizedBox(width: 20.0),
              InkWell(
                onTap: () => deleteEvent(events[index]["id"]),
                child: Padding(
                  padding: EdgeInsets.all(3.5),
                  child: Icon(Icons.delete_outline, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
          Text(
            Utils.utf8convert(events[index]["title"].toString()),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            Utils.utf8convert(events[index]["description"].toString()),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.start,
            alignment: WrapAlignment.start,
            children: <Widget>[
              Text(
                "📍",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
              SizedBox(width: 5.0),
              Text(
                Utils.utf8convert(events[index]["location"].toString()),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: <Widget>[
              Text(
                "📅",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
              SizedBox(width: 5.0),
              Text(
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white, fontSize: 12),
                  "${DateFormat.yMMMd().format(_startDate).toString()} (${_startDate.getMonthString().toString()})"),
              if (events[index]["recurring"] ?? false) ...[
                Text(
                  "- ${DateFormat.yMMMd().format(_endDate).toString()} (${_endDate.getMonthString().toString()})",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white, fontSize: 12),
                ),
              ],
              SizedBox(width: 5.0),
              if (events[index]["recurring"] ?? false) ...[
                Image.asset(
                  "assets/images/refresh.png",
                  width: 15.0,
                  height: 15.0,
                  color: Colors.white,
                ),
              ],
            ],
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: <Widget>[
              Text(
                "🕑",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
              SizedBox(width: 5.0),
              Text(
                "${DateFormat.jm().format(_startDate).toString()}" +
                    "-" +
                    "${DateFormat.jm().format(DateTime.parse(events[index]["start_datetime"]).toLocal().add(Duration(seconds: double.parse(events[index]["duration"].toString()).toInt()))).toString()}",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
        ],
      ),
    );
  }

  Future<dynamic> deleteEvent(String id) async {
    setState(() {
      showLoader = true;
    });
    // / If image is picked from galley
    final response = await Application.restService?.requestCall(
        apiEndPoint: ApiRestEndPoints.schedulers,
        requestParmas: {"event_id": id},
        method: RestAPIRequestMethods.delete,
        addAutherization: true);
    setState(() {
      showLoader = false;
    });
    if (response['code'] == 200 || response['code'] == "200") {
      Utils.showSuccessToast("Commitment deleted successfully");
      await getData();
    } else {
      Utils.showSuccessToast("Something went wrong while deleting commitment");
    }
  }

  Future<dynamic> deleteVision(String id) async {
    setState(() {
      showLoader = true;
    });
    // / If image is picked from galley
    final response = await Application.restService?.requestCall(
        apiEndPoint: ApiRestEndPoints.visionPlanner,
        requestParmas: {"vision_id": id},
        method: RestAPIRequestMethods.delete,
        addAutherization: true);

    if (kDebugMode) {
      Utils.showSuccessToast("Vision deleted successfully");
      Navigator.pop(context);
    }
    if (response != null) {
      return response;
    }
  }

  Frequency calculateFrequency(String frequency) {
    if (frequency == "daily") {
      return Frequency.daily;
    } else if (frequency == "monthly") {
      return Frequency.monthly;
    } else if (frequency == "weekly") {
      return Frequency.weekly;
    } else if (frequency == "annually") {
      return Frequency.yearly;
    }
    return Frequency.daily;
  }
}
