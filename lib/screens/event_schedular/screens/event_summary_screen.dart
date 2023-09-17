import 'package:flutter/cupertino.dart';
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
import 'package:brainfit/screens/home/screens/home_screen.dart';
import 'package:brainfit/services/database_helper.dart';

import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class EventSummaryScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String? route;

  EventSummaryScreen({
    Key? key,
    required this.createData,
    required this.isEditing,
    this.route,
  }) : super(key: key);

  @override
  State<EventSummaryScreen> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventSummaryScreen> {
  late String visionId;
  final _importantTextController = TextEditingController();
  final _localtionTextController = TextEditingController();
  final _addtionalDetailTextController = TextEditingController();

  bool editMode = true;

  bool showLoader = false;
  List<dynamic> events = [];
  String? _errorMessage;
  Map<String, dynamic>? createData;
  List<dynamic> priceToBe = [];
  List<dynamic> getToBe = [];
  List<dynamic> getRelationships = [];
  List<dynamic> commitments = [];
  List<dynamic> getEmotions = [];

  String dropDownValue = "Daily";

  bool _selectedValue = true;
  double _value = 5;

  late DateTime _startDate;
  late DateTime _endDate;

  late DateTime _startTime;
  late DateTime _endTime;

  late DateTime _startDateTime;
  late DateTime _endDateTime;
  late DateTime _initialDate;
  late DateTime _initialDateTime;
  late DateTime _initialTime;

  @override
  void initState() {
    final dateTime = DateTime.now();

    _initialDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    _startDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    _endDate = _startDate.add(Duration(days: 1));

    _startTime = dateTime;
    _endTime = _startTime.add(Duration(days: 1));

    _startDateTime = dateTime;
    _endDateTime = dateTime;

    _initialDateTime = _startDateTime;
    _initialTime = dateTime;

    createData = widget.createData;
    _initializeValue();
    super.initState();
    _fetchData();
  }

  void _initializeValue() {
    _selectedValue = createData?["recurring"] ?? false;

    initializeDropDownValue();
    _importantTextController.text =
        Utils.utf8convert(createData?["title"] ?? "");
    _localtionTextController.text =
        Utils.utf8convert(createData?["location"] ?? "");
    _addtionalDetailTextController.text =
        Utils.utf8convert(createData?["description"] ?? "");
    initDateTime();
  }

  void initializeDropDownValue() {
    if (createData?["frequency"] == null) {
      dropDownValue = "Daily";
    } else if (createData?["frequency"] != null &&
        (createData?["frequency"]?.isNotEmpty ?? false)) {
      if (createData?["frequency"] == "daily") {
        dropDownValue = "Daily";
      } else if (createData?["frequency"] == "weekly") {
        dropDownValue = "Weekly";
      }
      if (createData?["frequency"] == "monthly") {
        dropDownValue = "Monthly";
      }
      if (createData?["frequency"] == "annually") {
        dropDownValue = "Annually";
      }
    }
  }

  void initDateTime() {
    if (createData?.isNotEmpty ?? false) {
      if (createData!["start_datetime"] != null) {
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
      if (createData!["end_datetime"] != null) {
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

  void _fetchData() {
    _fetchRelationships();
    _fetchEmotions();
    _fetchCommitments();
  }

  void _fetchCommitments() async {
    showLoader = true;
    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.commitments,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      commitments = response["data"];
    }

    if (kDebugMode) {
      print(response);
    }

    setState(() {
      showLoader = false;
    });
  }

  void _fetchPriceToBe() async {
    showLoader = true;
    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.price,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      priceToBe = response["data"];
    }
  }

  void _fetchGetToBe() async {
    showLoader = true;
    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.getToBe,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      getToBe = response["data"];
    }

    if (kDebugMode) {
      print(response);
    }

    setState(() {
      showLoader = false;
    });
  }

  void _fetchRelationships({bool firstCall = false}) async {
    showLoader = true;
    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.relationships,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      getRelationships = response["data"];
    }

    if (kDebugMode) {
      print(response);
    }
    setState(() {
      showLoader = false;
    });
  }

  void _fetchEmotions({bool firstCall = false}) async {
    showLoader = true;

    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.emotions,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      getEmotions = response["data"];
    }

    if (kDebugMode) {
      print(response);
    }

    setState(() {
      showLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: commitmentColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        title: Text("Commitment",
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: LightAppColors.cardBackground)),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: LightAppColors.cardBackground,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextButton(
              onPressed: () {
                editMode = false;
                Map<String, dynamic> sendData = {};
                sendData["vision_id"] = createData?["vision_id"];
                sendData["recurring"] = createData?["recurring"];
                sendData["location"] = _localtionTextController.text;
                sendData["description"] = _addtionalDetailTextController.text;
                sendData["title"] = _importantTextController.text;

                if (!_selectedValue) {
                  sendData["start_datetime"] =
                      _startDateTime.toUtc().toIso8601String();
                  sendData["end_datetime"] =
                      _endDateTime.toUtc().toIso8601String();
                  sendData["duration"] =
                      _endDate.difference(_startDate).inSeconds;
                  sendData["frequency"] = null;
                } else {
                  var format = DateFormat("HH:mm");
                  DateTime start = _startTime;
                  DateTime end = _endTime;

                  _startDate = DateTime(_startDate.year, _startDate.month,
                      _startDate.day, 0, 0, 0);
                  sendData["start_datetime"] = (_startDate.add(
                    Duration(
                        hours: start.hour,
                        seconds: start.second,
                        minutes: start.minute),
                  )).toUtc().toIso8601String();
                  _endDate = DateTime(
                      _endDate.year, _endDate.month, _endDate.day, 23, 59, 59);
                  sendData["end_datetime"] = _endDate.toUtc().toIso8601String();
                  sendData["duration"] =
                      _endTime.difference(_startTime).inSeconds.abs();
                  sendData["frequency"] = createData?["frequency"];
                }

                if (widget.isEditing) {
                  sendData["event_id"] = createData?["event_id"];
                  _editEvent(sendData);
                } else {
                  _createEvent(sendData);
                }
              },
              child: Text(
                "Save",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: AppScreenConfig.safeBlockVertical! * 100,
          width: AppScreenConfig.safeBlockHorizontal! * 100,
          decoration: BoxDecoration(color: Colors.white
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   stops: [0.0, 1.0],
              //   colors: [
              //     visionColorGradient1,
              //     visionColorGradient2,
              //   ],
              // ),
              ),
          child: Stack(
            children: <Widget>[
              if (_errorMessage == null && !showLoader) ...[
                Opacity(
                  opacity: showLoader ? 0.01 : 1,
                  child: _showCommitmentSummary(),
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

  Widget _showCommitmentSummary() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      children: [
        SizedBox(height: 20.0),
        Text(
          'What do you want to call this commitment?',
          style: Theme.of(context).textTheme.bodyText1!,
        ),
        SizedBox(height: 10),
        TextFormField(
          enabled: editMode,
          controller: _importantTextController,
          maxLines: 1,
          cursorColor: LightAppColors.blackColor,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            filled: true,
            hintMaxLines: 3,
            fillColor: LightAppColors.greyColor.withOpacity(0.1),
            // prefixIcon: Icon(Icons.mail, color: Colors.grey),

            hintStyle: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
            labelStyle: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),

            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          validator: (String? text) {
            if (text?.isEmpty ?? true) {
              return "Enter a title";
            }
            return null;
          },
        ),
        SizedBox(height: 30),
        Text('Where is this commitment?',
            style: Theme.of(context).textTheme.bodyText1),
        SizedBox(height: 10),
        TextFormField(
          enabled: editMode,
          controller: _localtionTextController,
          maxLines: 1,
          cursorColor: LightAppColors.appBlueColor,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            filled: true,
            fillColor: LightAppColors.greyColor.withOpacity(0.1),

            hintMaxLines: 3,
            // prefixIcon: Icon(Icons.mail, color: Colors.grey),

            hintStyle: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
            labelStyle: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),

            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          validator: (String? text) {
            if (text?.isEmpty ?? true) {
              return "Enter a location";
            }
            return null;
          },
        ),
        SizedBox(height: 30),
        Text('Any additional details?',
            style: Theme.of(context).textTheme.bodyText1),
        SizedBox(height: 10),
        TextFormField(
          enabled: editMode,
          controller: _addtionalDetailTextController,
          maxLines: 2,
          cursorColor: LightAppColors.appBlueColor,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            filled: true,
            hintMaxLines: 3,

            fillColor: LightAppColors.greyColor.withOpacity(0.1),

            // prefixIcon: Icon(Icons.mail, color: Colors.grey),

            hintStyle: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
            labelStyle: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w700),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),

            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          validator: (String? text) {
            if (text?.isEmpty ?? true) {
              return "Enter commitment description";
            }
            return null;
          },
        ),
        SizedBox(height: 30),
        Text('Is this a recurring commitment ?',
            style: Theme.of(context).textTheme.bodyText1),
        SizedBox(height: 10),
        Wrap(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio<bool>(
                  value: true,
                  activeColor: LightAppColors.blackColor,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    if (editMode) {
                      _selectedValue = value!;
                      _initialDate = DateTime.now();
                      _initialDate = DateTime(_initialDate.year,
                          _initialDate.month, _initialDate.day);
                      _startDate = _initialDate;
                      _initialTime = _initialDate;
                      setState(() {});
                    }
                  },
                ),
                Text("Yes"),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Radio<bool>(
                  value: false,
                  activeColor: LightAppColors.blackColor,
                  groupValue: _selectedValue,
                  onChanged: (value) {
                    if (editMode) {
                      _selectedValue = value!;
                      _startDateTime = _initialDateTime;
                      _endDateTime = _startDateTime.add(Duration(days: 1));
                      setState(() {});
                      setState(() {});
                    }
                  },
                ),
                Text("No"),
              ],
            ),
          ],
        ),
        SizedBox(height: 30),
        if (_selectedValue) ...[
          Text(
            'Please select a Frequency',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: DropdownButton<String>(
                  value: dropDownValue,
                  focusColor: Colors.white,
                  style: Theme.of(context).textTheme.caption,
                  items: frequencyOption
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(),
                            ),
                          ))
                      .toList()
                      .cast(),
                  isExpanded: true,
                  onChanged: (value) {
                    if (editMode) {
                      dropDownValue = value!;
                      createData?["frequency"] = value;
                      setState(() {});
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          Text(
            'Please select start date for the commitment',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 20.0),
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
                if (editMode) {
                  setState(() {});
                  _startDate = DateTime(
                      newDateTime.year, newDateTime.month, newDateTime.day);
                  if (_startDate.isBefore(_initialDate)) {
                    _startDate = _initialDate;
                  }
                  if (_startDate.isAfter(_endDate)) {
                    _startDate = _endDate;
                  }
                }
              },
            ),
          ),
          SizedBox(height: 30.0),
          Text(
            "Please select end date for the commitment",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 20.0),
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
                if (editMode) {
                  _endDate = DateTime(
                      newDateTime.year, newDateTime.month, newDateTime.day);
                  if (_endDate.isBefore(_startDate)) {
                    _endDate = _startDate;
                  }
                }
              },
            ),
          ),
          SizedBox(height: 30.0),
          Text('At what time does the commitment start?',
              style: Theme.of(context).textTheme.bodyText1),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 100,
            child: CupertinoDatePicker(
              use24hFormat: false,
              key: UniqueKey(),
              mode: CupertinoDatePickerMode.time,
              initialDateTime: _initialTime,
              onDateTimeChanged: (DateTime newDateTime) {
                if (editMode) {
                  _startTime = newDateTime;
                }
              },
            ),
          ),
          SizedBox(height: 30.0),
          Text(
            "At what time does the commitment end?",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 100,
            child: CupertinoDatePicker(
              key: UniqueKey(),
              use24hFormat: false,
              initialDateTime: _endTime,
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (DateTime newDateTime) {
                if (editMode) {
                  _endTime = newDateTime;
                }
              },
            ),
          ),
        ] else ...[
          Text('When does it start',
              style: Theme.of(context).textTheme.bodyText1),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 100,
            child: CupertinoDatePicker(
              use24hFormat: true,
              key: UniqueKey(),
              mode: CupertinoDatePickerMode.dateAndTime,
              minimumDate: _startDateTime,
              initialDateTime: _startDateTime,
              onDateTimeChanged: (DateTime newDateTime) {
                if (editMode) {
                  _startDateTime = newDateTime;
                  if (_startDateTime.isBefore(_initialDateTime)) {
                    _startDateTime = _initialDateTime;
                  }
                  if (_startDateTime.isAfter(_endDateTime)) {
                    _startDateTime = _endDateTime;
                  }
                }
              },
            ),
          ),
          SizedBox(height: 30),
          Text('When does it end',
              style: Theme.of(context).textTheme.bodyText1),
          SizedBox(height: 10.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            height: 100,
            child: CupertinoDatePicker(
              use24hFormat: true,
              key: UniqueKey(),
              mode: CupertinoDatePickerMode.dateAndTime,
              minimumDate: _startDateTime,
              initialDateTime: _endDateTime,
              onDateTimeChanged: (DateTime newDateTime) {
                if (editMode) {
                  _endDateTime = newDateTime;
                  if (_endDateTime.isBefore(_startDateTime)) {
                    _endDateTime = _startDateTime;
                  }
                }
              },
            ),
          ),
        ],
        SizedBox(height: 30),
      ],
    );
  }

  void _editEvent(Map<String, dynamic> sendData) async {
    showLoader = true;
    if (sendData["frequency"] == "No") {
      sendData["frequency"] = null;
    } else {
      sendData["frequency"] = sendData["frequency"]?.toLowerCase();
    }

    if (sendData["recurring"]) print("Edit event data");
    print(sendData);

    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.schedulers,
        addAutherization: true,
        requestParmas: sendData,
        addParams: {"event_id": sendData["event_id"]},
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

  // Future<dynamic> deleteEvent(String id) async {
  //   setState(() {
  //     showLoader = true;
  //   });
  //   // / If image is picked from galley
  //   final response = await Application.restService?.requestCall(
  //       apiEndPoint: ApiRestEndPoints.schedulers,
  //       requestParmas: {"event_id": id},
  //       method: RestAPIRequestMethods.delete,
  //       addAutherization: true);
  //   setState(() {
  //     showLoader = false;
  //   });
  //   if (response['code'] == 200 || response['code'] == "200") {
  //     Utils.showSuccessToast("Commitment deleted successfully");
  //   } else {
  //     Utils.showSuccessToast("Something went wrong while deleting commitment");
  //   }
  // }

  void _createEvent(Map<String, dynamic> sendData) async {
    print("------------------------");
    print("${sendData.toString()}");
    showLoader = true;
    sendData["frequency"] = sendData["frequency"]?.toLowerCase() ?? "daily";
    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.schedulers,
        addAutherization: true,
        requestParmas: sendData,
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
            builder: (context) => HomeScreen(),
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
