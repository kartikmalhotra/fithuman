import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/event_schedular/screens/event_dateTime.dart';
import 'package:brainfit/screens/event_schedular/screens/event_date_screen.dart';

import 'package:brainfit/widget/widget.dart';

class EventFrequencyScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String? route;

  const EventFrequencyScreen({
    Key? key,
    required this.createData,
    this.isEditing = false,
    this.route,
  }) : super(key: key);

  @override
  State<EventFrequencyScreen> createState() => _EventFrequencyScreenState();
}

class _EventFrequencyScreenState extends State<EventFrequencyScreen> {
  bool showLoader = false;
  List<dynamic> data = [];

  String dropDownValue = "Daily";
  Map<String, dynamic> createData = {};
  final TextEditingController _importantTextController =
      TextEditingController();

  @override
  void initState() {
    createData = widget.createData;
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
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Card(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Please select a Frequency',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: DropdownButton<String>(
                value: dropDownValue,
                style: Theme.of(context).textTheme.caption,
                items: frequencyOption
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(),
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
          ],
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 20),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: RouteSettings(name: "EE"),
                        builder: (context) => createData["recurring"]
                            ? EventDateScreen(
                                route: widget.route,
                                createData: createData,
                                isEditing: widget.isEditing)
                            : EventDateTimeScreen(
                                createData: createData,
                                route: widget.route,
                                isEditing: widget.isEditing),
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
