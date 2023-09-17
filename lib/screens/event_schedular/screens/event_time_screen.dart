import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/home/screens/home_screen.dart';
import 'package:brainfit/screens/vision/screens/vision_create.dart';
import 'package:brainfit/services/database_helper.dart';
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class EventTimeScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String? route;

  const EventTimeScreen({
    Key? key,
    required this.createData,
    this.isEditing = false,
    this.route,
  }) : super(key: key);

  @override
  State<EventTimeScreen> createState() => _EventTimeScreenState();
}

class _EventTimeScreenState extends State<EventTimeScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  double _value = 5;

  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  DateTime _initialDate = DateTime.now();

  Map<String, dynamic> createData = {};
  final TextEditingController _importantTextController =
      TextEditingController();

  @override
  void initState() {
    createData = widget.createData;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Opacity(
              opacity: showLoader ? 0.1 : 1,
              child: Container(
                padding: EdgeInsets.all(30.0),
                color: emotionColor.withOpacity(0.8),
                child: _displayContents(context),
              ),
            ),
            if (showLoader) ...[
              Center(child: AppCircularProgressIndicator()),
            ]
          ],
        ),
      ),
    );
  }

  Widget _displayContents(context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Card(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('At what time does the commitment start and end ?',
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Text(
          "Start time",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 20.0),
        SizedBox(
          height: 100,
          child: CupertinoDatePicker(
            use24hFormat: false,
            backgroundColor: emotionColor.withOpacity(0.3),
            mode: CupertinoDatePickerMode.time,
            initialDateTime: _initialDate,
            onDateTimeChanged: (DateTime newDateTime) {
              _startTime = newDateTime;
              setState(() {});
            },
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Text(
          "End time",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 20.0),
        SizedBox(
          height: 100,
          child: CupertinoDatePicker(
            use24hFormat: false,
            backgroundColor: emotionColor.withOpacity(0.3),
            mode: CupertinoDatePickerMode.time,
            onDateTimeChanged: (DateTime newDateTime) {
              _endTime = newDateTime;
              setState(() {});
            },
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 50.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        LightAppColors.cardBackground),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Back',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(width: 30.0),
            Expanded(
              child: Container(
                height: 50.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        LightAppColors.cardBackground),
                  ),
                  onPressed: () {
                    Duration duration;

                    var format = DateFormat("HH:mm");
                    DateTime start = _startTime;
                    DateTime end = _endTime;

                    if (start.isAfter(end)) {
                      duration = start.difference(end);
                    } else if (start.isBefore(end)) {
                      duration = end.difference(start);
                    } else {
                      duration = end.difference(start);
                    }

                    createData["start_datetime"] =
                        (DateTime.parse(createData["start_datetime"]).add(
                      Duration(
                          hours: start.hour,
                          seconds: start.second,
                          minutes: start.minute),
                    )).toUtc().toIso8601String();

                    createData["duration"] =
                        _endTime.difference(_startTime).inSeconds.abs();

                    widget.isEditing ? _editEvent() : _createEvent();
                  },
                  child: Text(
                    'Next',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _createEvent() async {
    showLoader = true;

    createData["frequency"] = createData["frequency"]?.toLowerCase() ?? "daily";

    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.schedulers,
        addAutherization: true,
        requestParmas: createData,
        method: RestAPIRequestMethods.post);
    showLoader = false;
    if (kDebugMode) {
      print(createData);
    }
    if ((response["code"] == 401 || response["code"] == 403)) {
      await DatabaseHelper().deleteUsers();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    }

    if (response["error"] != null) {
      await Utils.showSuccessToast(response["error"]);
    }
    if (response["code"] == 200) {
      if (widget.route != null) {
        Navigator.of(context).popUntil((route) {
          return route.settings.name == widget.route;
          // Use defined route like Dashboard.routeName
        });
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventCreationSuccess(createData: createData),
          ),
        );
      }
    }
    setState(() {});
  }

  void _editEvent() async {
    showLoader = true;
    if (createData["frequency"] == "No") {
      createData["frequency"] = "None";
    } else {
      createData["frequency"] =
          createData["frequency"]?.toLowerCase() ?? "None";
    }

    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.schedulers,
        addAutherization: true,
        requestParmas: createData,
        addParams: {"event_id": createData["id"]},
        method: RestAPIRequestMethods.put);
    if ((response["code"] == 401 || response["code"] == 403)) {
      await DatabaseHelper().deleteUsers();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    }
    if (response["code"] == 200) {
      if (widget.route != null) {
        Navigator.of(context).popUntil((route) {
          return route.settings.name == widget.route;
          // Use defined route like Dashboard.routeName
        });
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
            (route) => false);
      }
    } else {
      Utils.showSuccessToast(response["reason"] ?? "Somthing went wrong");
      setState(() {
        showLoader = false;
      });
    }
  }
}

class EventCreationSuccess extends StatelessWidget {
  final Map<String, dynamic> createData;
  const EventCreationSuccess({Key? key, required this.createData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: _displayContents(context),
        ),
      ),
    );
  }

  Widget _displayContents(context) {
    return ListView(
      padding: EdgeInsets.all(30.0),
      children: <Widget>[
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Card(
          elevation: 1.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Your Event is created successfully',
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: Text(
            "You can create more events",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.grey),
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(LightAppColors.cardBackground),
              ),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                  (route) => false),
              child: Container(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  child: Text(
                    'Cancel',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(emotionColor.withOpacity(0.8)),
              ),
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AskVisionCreate(),
                  ),
                  (route) => false),
              child: Container(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                  child: Text(
                    'Create',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AskVisionCreate extends StatelessWidget {
  const AskVisionCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(20.0),
          color: Colors.white,
          child: _displayContents(context),
        ),
      ),
    );
  }

  Widget _displayContents(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 250.0,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.headline5!,
            child: Card(
              elevation: 0.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('You can create more Visions',
                    style: Theme.of(context).textTheme.headline6),
              ),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VisionCreateScreen()),
                    (route) => false);
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 1.0],
                    colors: [
                      visionColorGradient1,
                      visionColorGradient2,
                    ],
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                  child: Text(
                    'Create',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context, AppRoutes.home, (route) => false),
                child: Container(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
