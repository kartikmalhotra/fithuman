import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';

import 'package:brainfit/screens/event_schedular/screens/event_time_screen.dart';

import 'package:brainfit/widget/widget.dart';

class EventDateScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String? route;

  const EventDateScreen({
    Key? key,
    required this.createData,
    this.isEditing = false,
    this.route,
  }) : super(key: key);

  @override
  State<EventDateScreen> createState() => _EventDateScreenState();
}

class _EventDateScreenState extends State<EventDateScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  double _value = 5;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 1));

  Map<String, dynamic> createData = {};
  final TextEditingController _importantTextController =
      TextEditingController();

  @override
  void initState() {
    createData = widget.createData;
    if (createData.isNotEmpty) {
      if (createData["start_datetime"] != null) {
        _startDate = DateTime.parse(widget.createData["start_datetime"]);
        _startDate =
            DateTime(_startDate.year, _startDate.month, _startDate.day);
      }
      if (createData["end_datetime"] != null) {
        _endDate = DateTime.parse(widget.createData["end_datetime"]);
        _endDate = DateTime(_endDate.year, _endDate.month, _endDate.day);
      }
    }
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
            child: Text('When is the commitment ?',
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Text(
          "Start",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 20.0),
        SizedBox(
          height: 100,
          child: CupertinoDatePicker(
            use24hFormat: true,
            backgroundColor: emotionColor.withOpacity(0.2),
            mode: CupertinoDatePickerMode.date,
            minimumDate: _startDate,
            initialDateTime: _startDate,
            onDateTimeChanged: (DateTime newDateTime) {
              _startDate = newDateTime;
              _startDate =
                  DateTime(_startDate.year, _startDate.month, _startDate.day);
              setState(() {});
            },
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Text(
          "End",
          style: Theme.of(context).textTheme.subtitle1,
        ),
        SizedBox(height: 20.0),
        SizedBox(
          height: 100,
          child: CupertinoDatePicker(
            use24hFormat: true,
            backgroundColor: emotionColor.withOpacity(0.2),
            mode: CupertinoDatePickerMode.date,
            minimumDate: _startDate,
            initialDateTime: _endDate,
            onDateTimeChanged: (DateTime newDateTime) {
              if (_endDate.isBefore(_startDate)) {
                _endDate = _startDate;
              } else {
                _endDate = newDateTime;
              }

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
                    createData["start_datetime"] = DateTime(_startDate.year,
                            _startDate.month, _startDate.day, 0, 0, 0)
                        .toIso8601String();

                    _endDate = DateTime(_endDate.year, _endDate.month,
                        _endDate.day, 23, 59, 59);
                    createData["end_datetime"] =
                        _endDate.toUtc().toIso8601String();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: RouteSettings(name: "EE"),
                        builder: (context) => EventTimeScreen(
                          createData: createData,
                          isEditing: widget.isEditing,
                          route: widget.route,
                        ),
                      ),
                    );
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
}
