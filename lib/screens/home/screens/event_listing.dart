import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/event_schedular/screens/event_summary_screen.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class EventListingScreen extends StatefulWidget {
  const EventListingScreen({Key? key}) : super(key: key);

  @override
  State<EventListingScreen> createState() => EventListingScreenState();
}

class EventListingScreenState extends State<EventListingScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool toggleOff = false;
  bool showLoader = false;

  Map<String, dynamic> dailyEvents = {};
  Map<String, dynamic> weeklyEvents = {};
  Map<String, dynamic> monthlyEvents = {};
  DateTime dateTime = DateTime.now();
  late DateTime dayStartDateTime;
  late DateTime dayEndDateTime;
  late DateTime weekStartDateTime;
  late DateTime weekEndDateTime;
  late DateTime monthStartDateTime;
  late DateTime monthEndDateTime;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    dateTime = DateTime.now();
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    dayStartDateTime = dateTime;
    dayEndDateTime =
        dateTime.add(Duration(hours: 23, minutes: 59, seconds: 59));
    weekStartDateTime = getDate(dayStartDateTime
        .subtract(Duration(days: dayStartDateTime.weekday - 1)));
    weekEndDateTime = getDate(dayStartDateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday)));
    monthStartDateTime = DateTime(dateTime.year, dateTime.month, 1);
    monthEndDateTime = DateTime(dateTime.year, dateTime.month, 30);
    super.initState();
    getData();
    _tabController?.animateTo(1);
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> getData() async {
    setState(() {
      showLoader = true;
    });

    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.schedulers +
              "?start_datetime=${dayStartDateTime.toUtc().toIso8601String()}&end_datetime=${(dayEndDateTime).toUtc().toIso8601String()}",
          addAutherization: true,
          method: RestAPIRequestMethods.get);

      if (response['code'] == 200 || response['code'] == "200") {
        dailyEvents = response["data"] ?? [];
        setState(() {});
      }
    } catch (exe) {}

    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.schedulers +
              "?start_datetime=${weekStartDateTime.toUtc().toIso8601String()}&end_datetime=${(weekEndDateTime).toUtc().toIso8601String()}",
          addAutherization: true,
          method: RestAPIRequestMethods.get);

      if (response['code'] == 200 || response['code'] == "200") {
        weeklyEvents = response["data"] ?? [];
        setState(() {});
      }
    } catch (exe) {}

    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.schedulers +
              "?start_datetime=${monthStartDateTime.toUtc().toIso8601String()}&end_datetime=${(monthEndDateTime).toUtc().toIso8601String()}",
          addAutherization: true,
          method: RestAPIRequestMethods.get);

      if (response['code'] == 200 || response['code'] == "200") {
        monthlyEvents = response["data"] ?? [];
        setState(() {});
      }
    } catch (exe) {}

    if (mounted) {
      setState(() {
        showLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _displayAppBar(),
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: showLoader ? 0.01 : 1,
            child: TabBarView(
              controller: _tabController,
              children: [
                _dailyEventList(),
                _weeklyEventList(),
                _monthlyEventList(),
              ],
            ),
          ),
          if (showLoader) ...[
            Center(
              child: AppCircularProgressIndicator(),
            ),
          ]
        ],
      ),
    );
  }

  Widget _dailyEventList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
              onPressed: () {
                dayStartDateTime = dayStartDateTime.subtract(Duration(days: 1));
                dayEndDateTime = dayStartDateTime.subtract(Duration(days: 1));
                getData();
              },
            ),
            Text(
              "${DateFormat.yMMMMd('en_US').format(dayStartDateTime)}",
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(width: 20.0),
            Text(
              "${DateFormat.yMMMMd('en_US').format(dayEndDateTime)}",
              style: Theme.of(context).textTheme.caption,
            ),
            IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
              icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onPressed: () {
                dayStartDateTime = dayStartDateTime.add(Duration(days: 1));
                dayEndDateTime = dayStartDateTime.add(Duration(days: 1));
                getData();
              },
            )
          ],
        ),
        (toggleOff
                ? dailyEvents["events"]?.length != 0
                : dailyEvents["listed_events"]?.length != 0)
            ? Expanded(
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: toggleOff
                      ? dailyEvents["events"]?.length ?? 0
                      : dailyEvents["listed_events"]?.length ?? 0,
                  itemBuilder: (context, index) {
                    return _showEventCard(toggleOff
                        ? dailyEvents["events"][index]
                        : dailyEvents["listed_events"][index]);
                  },
                ),
              )
            : Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text("No Commitments found",
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _weeklyEventList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
              onPressed: () {
                weekStartDateTime =
                    weekStartDateTime.subtract(Duration(days: 7));
                weekEndDateTime = weekEndDateTime.subtract(Duration(days: 7));
                getData();
              },
            ),
            Text(
              "${DateFormat.yMMMMd('en_US').format(weekStartDateTime)}",
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(width: 20.0),
            Text(
              "${DateFormat.yMMMMd('en_US').format(weekEndDateTime)}",
              style: Theme.of(context).textTheme.caption,
            ),
            IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 4.0),
              icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onPressed: () {
                weekStartDateTime = weekStartDateTime.add(Duration(days: 7));
                weekEndDateTime = weekEndDateTime.add(Duration(days: 7));
                getData();
              },
            )
          ],
        ),
        (toggleOff
                ? weeklyEvents["events"]?.length != 0
                : weeklyEvents["listed_events"]?.length != 0)
            ? Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  physics: ClampingScrollPhysics(),
                  itemCount: toggleOff
                      ? weeklyEvents["events"]?.length ?? 0
                      : weeklyEvents["listed_events"]?.length ?? 0,
                  itemBuilder: (context, index) {
                    return _showEventCard(toggleOff
                        ? weeklyEvents["events"][index]
                        : weeklyEvents["listed_events"][index]);
                  },
                ),
              )
            : Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text("No Commitments found",
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
              )
      ],
    );
  }

  Widget _monthlyEventList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
              icon: Icon(Icons.arrow_back_ios, color: Colors.grey),
              onPressed: () {
                monthStartDateTime = DateTime(monthStartDateTime.year,
                    monthStartDateTime.month - 1, monthStartDateTime.day);
                monthEndDateTime = DateTime(monthEndDateTime.year,
                    monthEndDateTime.month - 1, monthEndDateTime.day);
                getData();
              },
            ),
            Text(
              "${DateFormat.yMMMMd('en_US').format(monthStartDateTime)}",
              style: Theme.of(context).textTheme.caption,
            ),
            SizedBox(width: 20.0),
            Text(
              "${DateFormat.yMMMMd('en_US').format(monthEndDateTime)}",
              style: Theme.of(context).textTheme.caption,
            ),
            IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
              icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),
              onPressed: () {
                monthStartDateTime = DateTime(monthStartDateTime.year,
                    monthStartDateTime.month + 1, monthStartDateTime.day);
                monthEndDateTime = DateTime(monthEndDateTime.year,
                    monthEndDateTime.month + 1, monthEndDateTime.day);
                getData();
              },
            )
          ],
        ),
        (toggleOff
                ? monthlyEvents["events"]?.length != 0
                : monthlyEvents["listed_events"]?.length != 0)
            ? Expanded(
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  itemCount: toggleOff
                      ? monthlyEvents["events"]?.length ?? 0
                      : monthlyEvents["listed_events"]?.length ?? 0,
                  itemBuilder: (context, index) {
                    return _showEventCard(toggleOff
                        ? monthlyEvents["events"][index]
                        : monthlyEvents["listed_events"][index]);
                  },
                ),
              )
            : Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text("No Commitments found",
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
              )
      ],
    );
  }

  Widget _showEventCard(dynamic data) {
    Duration _duration =
        Duration(seconds: double.parse(data["duration"]).toInt());
    DateTime _startDate = DateTime.parse(data["start_datetime"]).toLocal();
    DateTime _endDate = DateTime.parse(data["end_datetime"]).toLocal();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: emotionColor,
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
      width: double.maxFinite,
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
                    title: data["title"],
                    description: data["description"],
                    location: data["location"],
                    recurrence: Recurrence(
                        frequency: Utils.calculateFrequency(data["frequency"]),
                        endDate:
                            DateTime.parse(data["end_datetime"]).toLocal()),
                    startDate: DateTime.parse(data["start_datetime"]).toLocal(),
                    endDate: DateTime.parse(data["start_datetime"])
                        .toLocal()
                        .add(Duration(
                            seconds: double.parse(data["duration"].toString())
                                .toInt())),
                    iosParams: IOSParams(
                      reminder: Duration(
                          seconds: double.parse(data["duration"].toString())
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
                    "event_id": data["id"],
                    "created_at": data["created_at"],
                    "title": data["title"],
                    "description": data["description"],
                    "location": data["location"],
                    "start_datetime": data["start_datetime"],
                    "end_datetime": data["end_datetime"],
                    "duration": data["duration"],
                    "recurring": data["recurring"],
                    "frequency": data["frequency"],
                    "vision_id": data["vision_id"],
                  };

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: "EA"),
                      builder: (context) => EventSummaryScreen(
                          route: AppRoutes.eventsListScreen,
                          createData: createData,
                          isEditing: true),
                    ),
                  );
                  await getData();
                },
                child: Icon(Icons.edit, color: Colors.white),
              ),
              SizedBox(width: 20.0),
              InkWell(
                onTap: () => deleteEvent(data["id"]),
                child: Icon(Icons.delete_outline, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
          Text(
            Utils.utf8convert(data["title"].toString()),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            Utils.utf8convert(data["description"].toString()),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white),
          ),
          SizedBox(height: 10),
          if (data["location"] != null &&
              data["location"] != "" &&
              !toggleOff) ...[
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
                  Utils.utf8convert(data["location"].toString()),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ],
          if (!toggleOff) ...[
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
                if (data["recurring"] ?? false) ...[
                  Text(
                    "- ${DateFormat.yMMMd().format(_endDate).toString()} (${_endDate.getMonthString().toString()})",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white, fontSize: 12),
                  ),
                ],
                SizedBox(width: 5.0),
                if (data["recurring"] ?? false) ...[
                  Image.asset(
                    "assets/images/refresh.png",
                    width: 15.0,
                    height: 15.0,
                    color: Colors.white,
                  ),
                ],
              ],
            ),
          ],
          if (!toggleOff) ...[
            SizedBox(height: 10.0),
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
                      "${DateFormat.jm().format(DateTime.parse(data["start_datetime"]).toLocal().add(Duration(seconds: double.parse(data["duration"].toString()).toInt()))).toString()}",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
          SizedBox(height: 10.0),
        ],
      ),
    );
  }

  AppBar _displayAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: commitmentColor,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "Commitments",
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(color: Colors.white),
      ),
      actions: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Compact",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white)),
            IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              onPressed: () {
                toggleOff = !toggleOff;
                setState(() {});
              },
              icon: Icon(
                toggleOff ? Icons.toggle_off : Icons.toggle_on,
                size: 30,
                color: Colors.white,
              ),
            ),
            Text("List",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white)),
            SizedBox(width: 10.0)
          ],
        )
      ],
      bottom: TabBar(
        unselectedLabelColor: Colors.grey[400],
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelStyle: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: LightAppColors.cardBackground),
        labelStyle: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: LightAppColors.blackColor),
        controller: _tabController,
        tabs: [
          Tab(text: "Day"),
          Tab(text: "Week"),
          Tab(text: "Month"),
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
      getData();
    } else {
      Utils.showSuccessToast("Something went wrong while deleting commitment");
    }
  }
}
