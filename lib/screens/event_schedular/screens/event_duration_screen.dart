import 'package:flutter/material.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/screens/event_schedular/screens/event_recurring.dart';

import 'package:brainfit/widget/widget.dart';

class EventDurationScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;

  const EventDurationScreen(
      {Key? key, required this.createData, this.isEditing = false})
      : super(key: key);

  @override
  State<EventDurationScreen> createState() => _EventDurationScreenState();
}

class _EventDurationScreenState extends State<EventDurationScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  double _value = 5;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

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
                color: visionColor.withOpacity(0.8),
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
            child: Text('Please select a duration for the commitment',
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(LightAppColors.secondary),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Back',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            SizedBox(width: 30.0),
            Expanded(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(LightAppColors.secondary),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventRecurringScreen(
                        createData: createData,
                        isEditing: widget.isEditing,
                      ),
                    ),
                  );
                },
                child: Text(
                  'Next',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
