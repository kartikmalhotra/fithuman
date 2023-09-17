import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';

import 'package:brainfit/screens/event_schedular/screens/event_frequency.dart';
import 'package:brainfit/screens/event_schedular/screens/event_time_screen.dart';
import 'package:brainfit/screens/home/screens/home_screen.dart';
import 'package:brainfit/services/database_helper.dart';
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class EventDateTimeScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String? route;

  const EventDateTimeScreen({
    Key? key,
    required this.createData,
    this.isEditing = false,
    this.route,
  }) : super(key: key);

  @override
  State<EventDateTimeScreen> createState() => _EventDateTimeScreenState();
}

class _EventDateTimeScreenState extends State<EventDateTimeScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  DateTime _initialDate = DateTime.now();

  Map<String, dynamic> createData = {};

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
            child: Text('When does the commitment start and end date time?',
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Text(
          "Start date Time",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 20.0),
        SizedBox(
          height: 100,
          child: CupertinoDatePicker(
            use24hFormat: true,
            backgroundColor: emotionColor.withOpacity(0.2),
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: _initialDate,
            initialDateTime: _initialDate,
            onDateTimeChanged: (DateTime newDateTime) {
              _startDate = newDateTime;
              setState(() {});
            },
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Text(
          "End Date Time",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 20.0),
        SizedBox(
          height: 100,
          child: CupertinoDatePicker(
            use24hFormat: true,
            backgroundColor: emotionColor.withOpacity(0.2),
            mode: CupertinoDatePickerMode.dateAndTime,
            minimumDate: _startDate,
            initialDateTime: _startDate,
            onDateTimeChanged: (DateTime newDateTime) {
              _endDate = newDateTime;
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
                    createData["start_datetime"] = _startDate.toIso8601String();
                    createData["end_datetime"] = _endDate.toIso8601String();
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

  void _editEvent() async {
    showLoader = true;

    createData["duration"] = _endDate.difference(_startDate).inSeconds;
    createData["frequency"] = null;

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
      Utils.showSuccessToast("Event edited successfully");
      if (widget.route != null) {
        Navigator.of(context).popUntil((route) {
          return route.settings.name == widget.route;
          // Use defined route like Dashboard.routeName
        });
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      }
    } else {
      Utils.showSuccessToast(response["error"]);
      setState(() {
        showLoader = false;
      });
      if (widget.route != null) {
        Navigator.of(context).popUntil((route) {
          return route.settings.name == widget.route;
          // Use defined route like Dashboard.routeName
        });
      }
    }
  }

  void _createEvent() async {
    showLoader = true;

    createData["duration"] = _endDate.difference(_startDate).inSeconds;
    createData["frequency"] = null;

    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.schedulers,
        addAutherization: true,
        requestParmas: createData,
        method: RestAPIRequestMethods.post);
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventCreationSuccess(createData: createData),
          ),
        );
      }
    } else {
      Utils.showSuccessToast(response["error"]);
    }
    showLoader = false;
    setState(() {});
  }
}
