import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/services/database_helper.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class CheckInRemindarScreen extends StatefulWidget {
  const CheckInRemindarScreen({Key? key}) : super(key: key);

  @override
  State<CheckInRemindarScreen> createState() => _CheckInRemindarScreenState();
}

class _CheckInRemindarScreenState extends State<CheckInRemindarScreen> {
  DateTime? _endDateTime;
  bool _showLoader = false;
  bool checkRemindarAdded = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _endDateTime = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.grey.withOpacity(0.01),
        leading: IconButton(
          padding: EdgeInsets.all(0.0),
          constraints: BoxConstraints(),
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: AppScreenConfig.safeBlockHorizontal! * 100,
        height: AppScreenConfig.safeBlockVertical! * 100,
        color: Colors.grey.withOpacity(0.01),
        child: Stack(
          children: <Widget>[
            if (!_showLoader) ...[
              Scrollbar(
                controller: _scrollController,
                child: ListView(
                  padding: EdgeInsets.all(20.0),
                  controller: _scrollController,
                  children: [
                    SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
                    Text("Check in",
                        style: Theme.of(context).textTheme.headline5),
                    Text("Reminder for",
                        style: Theme.of(context).textTheme.headline5),
                    SizedBox(height: 50.0),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 250,
                              child: CupertinoDatePicker(
                                use24hFormat: false,
                                initialDateTime: DateTime(_endDateTime!.hour,
                                    (_endDateTime!.minute % 15 * 15)),
                                backgroundColor: Colors.white,
                                minuteInterval: 15,
                                mode: CupertinoDatePickerMode.time,
                                onDateTimeChanged: (DateTime newDateTime) {
                                  checkRemindarAdded = true;
                                  _endDateTime = newDateTime;
                                  print(_endDateTime);
                                  setState(() {});
                                },
                              ),
                            ),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: () => _createNotification(),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    LightAppColors.secondary.withOpacity(0.6)),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                height: 50,
                                child: Center(
                                  child: Text(
                                    "Create",
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Center(
                child: AppCircularProgressIndicator(),
              )
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _createNotification() async {
    if (checkRemindarAdded) {
      DateTime? _sendDateTime = _endDateTime ?? DateTime.now();

      setState(() {
        _showLoader = true;
      });

      _sendDateTime = _sendDateTime.toUtc();
      final response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.remindarNotification,
        method: RestAPIRequestMethods.post,
        addAutherization: true,
        requestParmas: {
          "time": "${_sendDateTime.hour}:${_sendDateTime.minute}"
        },
      );
      setState(() {
        _showLoader = false;
      });

      if ((response["code"] == 401 || response["code"] == 403)) {
        await DatabaseHelper().deleteUsers();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      }
      if (response["code"] == 200) {
        Utils.showSuccessToast("Your Remindar is successfully created.");
      } else {
        Utils.showSuccessToast(response?["error"] ?? "Somthing went wrong");
      }

      return response;
    } else {
      Utils.showSuccessToast("Please select time for the reminder");
    }
  }

  Future<void> deleteReminder(String id) async {
    _showLoader = true;
    setState(() {});
    final response = await Application.restService!.requestCall(
      apiEndPoint: ApiRestEndPoints.remindarNotification,
      requestParmas: {'reminder_id': id},
      method: RestAPIRequestMethods.delete,
      addAutherization: true,
    );

    if (response["status"] == 200) {
      Utils.showSuccessToast("Remindar successfully deleted");
    }

    return response;
  }
}
