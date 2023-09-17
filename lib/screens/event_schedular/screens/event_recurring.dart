import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/event_schedular/screens/event_summary_screen.dart';
import 'package:brainfit/screens/event_schedular/screens/event_time_screen.dart';
import 'package:brainfit/screens/home/screens/home_screen.dart';
import 'package:brainfit/services/database_helper.dart';
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class EventRecurringScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String? route;

  const EventRecurringScreen({
    Key? key,
    required this.createData,
    this.isEditing = false,
    this.route,
  }) : super(key: key);

  @override
  State<EventRecurringScreen> createState() => _EventRecurringScreenState();
}

class _EventRecurringScreenState extends State<EventRecurringScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  bool _selectedValue = false;
  double _value = 5;
  Map<String, dynamic> createData = {};
  String dropDownValue = "Daily";
  final TextEditingController _importantTextController =
      TextEditingController();

  late DateTime _startDate;
  late DateTime _endDate;

  late DateTime _startTime;
  late DateTime _endTime;

  late DateTime _initialDate;
  late DateTime _initialTime;

  late DateTime _initialDateTime;
  late DateTime _startDateTime;
  late DateTime _endDateTime;

  @override
  void initState() {
    final dateTime = DateTime.now();
    _startDate = dateTime;
    _endDate = dateTime.add(Duration(days: 1));
    _initialDate = dateTime;

    _startTime = _startDate;
    _endTime = dateTime.add(Duration(days: 1));
    _initialTime = dateTime;

    _initialDateTime = dateTime;
    _startDateTime = dateTime;
    _endDateTime = dateTime.add(Duration(days: 1));

    createData = widget.createData;
    _selectedValue = createData["recurring"] ?? false;
    initDropdownValue();

    super.initState();
  }

  void initDropdownValue() {
    if (createData["frequency"] == null) {
      dropDownValue = "Daily";
    } else if (createData["frequency"] != null &&
        (createData["frequency"]?.isNotEmpty ?? false)) {
      if (createData["frequency"] == "daily") {
        dropDownValue = "Daily";
      } else if (createData["frequency"] == "weekly") {
        dropDownValue = "Weekly";
      }
      if (createData["frequency"] == "monthly") {
        dropDownValue = "Monthly";
      }
      if (createData["frequency"] == "annually") {
        dropDownValue = "Annually";
      }
    }
  }

  void initDateTime() {
    if (createData.isNotEmpty) {
      if (createData["start_datetime"] != null) {
        if (_selectedValue) {
          _startDate = widget.createData["start_datetime"] is String
              ? DateTime.parse(widget.createData["start_datetime"])
              : widget.createData["start_datetime"];
          _startDate =
              DateTime(_startDate.year, _startDate.month, _startDate.day);
        } else {
          _startDateTime = widget.createData["start_datetime"] is String
              ? DateTime.parse(widget.createData["start_datetime"])
              : widget.createData["start_datetime"];
        }
      }
      if (createData["end_datetime"] != null) {
        if (_selectedValue) {
          _endDate = widget.createData["end_datetime"] is String
              ? DateTime.parse(widget.createData["end_datetime"])
              : widget.createData["end_datetime"];
          _endDate = DateTime(_endDate.year, _endDate.month, _endDate.day);
        } else {
          _endDateTime = widget.createData["end_datetime"] is String
              ? DateTime.parse(widget.createData["end_datetime"])
              : widget.createData["end_datetime"];
        }
      }
    }
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
                padding: EdgeInsets.all(20.0),
                color: commitmentColor.withOpacity(0.8),
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
        StepProgressIndicator(
          totalSteps: 2,
          currentStep: 2,
          size: 5.5,
          selectedColor: Colors.white,
          unselectedColor: Colors.grey,
          roundedEdges: Radius.circular(10),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 7),
        BubbleNormal(
          text: 'Is this a recurring commitment?',
          isSender: false,
          color: Colors.white,
          tail: true,
          textStyle: Theme.of(context).textTheme.subtitle1!,
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
        Wrap(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio<bool>(
                  value: true,
                  activeColor: LightAppColors.cardBackground,
                  groupValue: _selectedValue,
                  fillColor: MaterialStateProperty.all(Colors.white),
                  onChanged: (value) {
                    _selectedValue = value!;
                    _initialDate = DateTime.now();
                    _initialDate = DateTime(_initialDate.year,
                        _initialDate.month, _initialDate.day);
                    _startDate = _initialDate;
                    _initialTime = _initialDate;

                    setState(() {});
                  },
                ),
                Text(
                  "Yes",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
            SizedBox(width: 20.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio<bool>(
                  value: false,
                  activeColor: LightAppColors.cardBackground,
                  groupValue: _selectedValue,
                  fillColor: MaterialStateProperty.all(Colors.white),
                  onChanged: (value) {
                    _selectedValue = value!;
                    _initialDateTime = DateTime.now();
                    _startDateTime = _initialDateTime;
                    _endDateTime = _startDateTime.add(Duration(days: 1));
                    setState(() {});
                  },
                ),
                Text(
                  "No",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        if (_selectedValue) ...[
          BubbleNormal(
            text: 'Please select a Frequency',
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: DropdownButton<String>(
                      value: dropDownValue,
                      focusColor: Colors.white,
                      iconEnabledColor: Colors.white,
                      dropdownColor: Colors.white,
                      iconDisabledColor: Colors.white,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white),
                      items: frequencyOption
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(
                                  e.toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.black),
                                ),
                              ))
                          .toList()
                          .cast(),
                      isExpanded: true,
                      onChanged: (value) {
                        dropDownValue = value!;
                        createData["frequency"] = value;
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          BubbleNormal(
            text: 'Please select start date for the commitment',
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 100,
            child: CupertinoDatePicker(
              use24hFormat: true,
              key: UniqueKey(),
              mode: CupertinoDatePickerMode.date,
              minimumDate: _initialDate,
              initialDateTime: _startDate,
              onDateTimeChanged: (DateTime newDateTime) {
                _startDate = DateTime(
                    newDateTime.year, newDateTime.month, newDateTime.day);
                print("Start date is ${_startDate.toString()}");
                print("Initil date is ${_initialDate.toString()}");

                if (_startDate.isBefore(_initialDate)) {
                  _startDate = _initialDate;
                }
                if (_startDate.isAfter(_endDate)) {
                  _startDate = _endDate;
                }
                setState(() {});
              },
            ),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          BubbleNormal(
            text: 'Please select end date for the commitment',
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 100,
            child: CupertinoDatePicker(
              use24hFormat: true,
              key: UniqueKey(),
              mode: CupertinoDatePickerMode.date,
              minimumDate: _startDate,
              initialDateTime: _endDate,
              onDateTimeChanged: (DateTime newDateTime) {
                _endDate = DateTime(
                    newDateTime.year, newDateTime.month, newDateTime.day);
                if (_endDate.isBefore(_startDate)) {
                  _endDate = _startDate;
                }

                setState(() {});
              },
            ),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          BubbleNormal(
            text: 'At what time does the commitment start?',
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
          SizedBox(
            height: 100,
            child: CupertinoDatePicker(
              use24hFormat: false,
              key: UniqueKey(),
              mode: CupertinoDatePickerMode.time,
              initialDateTime: _initialTime,
              onDateTimeChanged: (DateTime newDateTime) {
                _startTime = newDateTime;
                setState(() {});
              },
            ),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          BubbleNormal(
            text: "At what time does the commitment end?",
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
          SizedBox(
            height: 100,
            child: CupertinoDatePicker(
              key: UniqueKey(),
              use24hFormat: false,
              initialDateTime: _endTime,
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (DateTime newDateTime) {
                _endTime = newDateTime;
                setState(() {});
              },
            ),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        ] else ...[
          BubbleNormal(
            text: "When does it start",
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: 20.0),
          SizedBox(
            height: 100,
            child: CupertinoDatePicker(
              use24hFormat: true,
              mode: CupertinoDatePickerMode.dateAndTime,
              minimumDate: _initialDateTime,
              initialDateTime: _startDateTime,
              onDateTimeChanged: (DateTime newDateTime) {
                _startDateTime = newDateTime;
                if (_startDateTime.isBefore(_initialDateTime)) {
                  _startDateTime = _initialDateTime;
                }
                if (_startDateTime.isAfter(_endDateTime)) {
                  _startDateTime = _endDateTime;
                }
                setState(() {});
              },
            ),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          BubbleNormal(
            text: "When does it end",
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: 20.0),
          SizedBox(
            height: 100,
            child: CupertinoDatePicker(
              use24hFormat: true,
              mode: CupertinoDatePickerMode.dateAndTime,
              minimumDate: _startDateTime,
              initialDateTime: _endDateTime,
              onDateTimeChanged: (DateTime newDateTime) {
                _endDateTime = newDateTime;
                if (_endDateTime.isBefore(_startDateTime)) {
                  _endDateTime = _startDateTime;
                }
                setState(() {});
              },
            ),
          ),
        ],
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
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
                    if (!_selectedValue) {
                      createData["recurring"] = false;
                      createData["start_datetime"] =
                          _startDateTime.toIso8601String();
                      createData["end_datetime"] =
                          _endDateTime.toIso8601String();
                    } else {
                      createData["recurring"] = true;
                      createData["start_datetime"] = DateTime(_startDate.year,
                              _startDate.month, _startDate.day, 0, 0, 0)
                          .toIso8601String();
                      _endDate = DateTime(_endDate.year, _endDate.month,
                          _endDate.day, 23, 59, 59);
                      createData["end_datetime"] = _endDate.toIso8601String();
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventSummaryScreen(
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
        ),
        SizedBox(height: 30.0),
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
