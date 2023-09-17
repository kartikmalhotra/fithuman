import 'dart:convert';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
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
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  EventDetailScreen({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetailScreen> {
  dynamic event;
  bool showLoader = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      setState(() {
        showLoader = true;
      });
      var response = await Application.restService!.requestCall(
          apiEndPoint:
              "${ApiRestEndPoints.schedulers}?event_id=${widget.eventId}",
          addAutherization: true,
          method: RestAPIRequestMethods.get);

      if (response['code'] == 200 || response['code'] == "200") {
        event = response["data"] ?? [];
      } else if (response["error"] != null) {
        _errorMessage = response["error"];
      }
    } catch (exe) {}

    if (mounted) {
      setState(() {
        showLoader = false;
      });
    }
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
      Navigator.pop(context);
    } else {
      Utils.showSuccessToast("Something went wrong while deleting commitment");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: commitmentColorGradient1,
        title: Text("Commitment",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white)),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        actions: [
          Center(
            child: IconButton(
              constraints: BoxConstraints(),
              icon: Icon(Icons.edit, color: Colors.white, size: 20),
              onPressed: () async {
                Map<String, dynamic> createData = {
                  "event_id": event["id"],
                  "created_at": event["created_at"],
                  "title": event["title"],
                  "description": event["description"],
                  "location": event["location"],
                  "start_datetime": event["start_datetime"],
                  "end_datetime": event["end_datetime"],
                  "duration": event["duration"],
                  "recurring": event["recurring"],
                  "frequency": event["frequency"],
                  "vision_id": event["vision_id"],
                };

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: RouteSettings(name: "EA"),
                    builder: (context) => EventSummaryScreen(
                        route: AppRoutes.eventDetailScreen,
                        createData: createData,
                        isEditing: true),
                  ),
                );

                await getData();
              },
            ),
          ),
          Center(
            child: IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              icon: Icon(Icons.add, color: Colors.white, size: 20),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: RouteSettings(arguments: "EA"),
                    builder: (context) => EventCreateScreen(
                      route: AppRoutes.eventDetailScreen,
                      createData: {"vision_id": event["vision_id"]},
                    ),
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              icon: Icon(Icons.delete_outline, color: Colors.white, size: 20),
              onPressed: () async {
                await deleteEvent(event["id"]);
              },
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
              if (!showLoader && _errorMessage == null) ...[
                _displayEventDetail(),
              ],
              if (showLoader) ...[
                Center(child: AppCircularProgressIndicator()),
              ],
              if (_errorMessage != null) ...[
                Center(
                  child: Text(_errorMessage ?? "Something went wrong"),
                )
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayEventDetail() {
    Duration _duration =
        Duration(seconds: double.parse(event["duration"]).toInt());

    DateTime _startDate = DateTime.parse(event["start_datetime"]).toLocal();
    DateTime _endDate = DateTime.parse(event["end_datetime"]).toLocal();

    return ListView(
      padding: EdgeInsets.all(25.0),
      children: [
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
        Text(
          Utils.utf8convert(event["title"].toString()),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.black),
        ),
        SizedBox(height: 20),
        Text(
          Utils.utf8convert(event["description"].toString()),
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.black, fontWeight: FontWeight.w400),
        ),
        SizedBox(height: 20),
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
                  .copyWith(color: Colors.black),
            ),
            SizedBox(width: 5.0),
            Text(
              Utils.utf8convert(event["location"].toString()),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        SizedBox(height: 20),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
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
                    .copyWith(color: Colors.black, fontSize: 12),
                "${DateFormat.yMMMd().format(_startDate).toString()} (${_startDate.getMonthString().toString()})"),
            if (event["recurring"] ?? false) ...[
              Text(
                "- ${DateFormat.yMMMd().format(_endDate).toString()} (${_endDate.getMonthString().toString()})",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.black, fontSize: 12),
              ),
            ],
            SizedBox(width: 5.0),
            if (event["recurring"] ?? false) ...[
              Image.asset(
                "assets/images/refresh.png",
                width: 15.0,
                height: 15.0,
                color: Colors.black,
              ),
            ],
          ],
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
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
                  "${DateFormat.jm().format(DateTime.parse(event["start_datetime"]).toLocal().add(Duration(seconds: double.parse(event["duration"].toString()).toInt()))).toString()}",
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                final Event eventCalendar = Event(
                  title: event["title"],
                  description: event["description"],
                  location: event["location"],
                  startDate: DateTime.parse(event["start_datetime"]),
                  endDate: DateTime.parse(event["end_datetime"]),
                  iosParams: IOSParams(
                    reminder: Duration(
                        seconds:
                            double.parse(event["duration"].toString()).toInt()),
                  ),
                  androidParams: AndroidParams(
                    emailInvites: [], // on Android, you can add invite emails to your event.
                  ),
                );

                Add2Calendar.addEvent2Cal(eventCalendar);
              },
              child: Text(
                "Add to Calender",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.black),
              ),
            )
          ],
        ),
      ],
    );
  }
}
