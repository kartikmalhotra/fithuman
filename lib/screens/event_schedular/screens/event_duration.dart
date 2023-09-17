import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/screens/event_schedular/screens/event_frequency.dart';
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class EventDurationScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String? route;

  const EventDurationScreen(
      {Key? key, required this.createData, this.isEditing = false, this.route})
      : super(key: key);

  @override
  State<EventDurationScreen> createState() => _EventDurationScreenState();
}

class _EventDurationScreenState extends State<EventDurationScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  double _value = 5;
  String hours = "", minutes = "";
  Map<String, dynamic> createData = {};

  Duration? _duration;

  @override
  void initState() {
    createData = widget.createData;
    if (createData["duration"] != null) {
      _duration = Duration(
          seconds: double.parse(createData["duration"].toString()).toInt());
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
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Card(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Please select a Duration for your commitment in hours',
                style: Theme.of(context).textTheme.bodyText1),
          ),
        ),
        if (_duration != null) ...[
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
          Text("You have selected duration as ${format(_duration!)}")
        ],
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        OutlinedButton(
          onPressed: () {
            onTap();
          },
          child: Text("Please select a duration"),
        ),
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
                    if (_duration != null) {
                      createData["duration"] = _duration!.inSeconds;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EventFrequencyScreen(
                              createData: createData,
                              route: widget.route,
                              isEditing: widget.isEditing),
                        ),
                      );
                    } else {
                      Utils.showSuccessToast("Please select a Duration");
                    }
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
      ],
    );
  }

  void onTap() {
    Picker(
      adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
        const NumberPickerColumn(begin: 0, end: 999, suffix: Text(' hours')),
        const NumberPickerColumn(
            begin: 0, end: 60, suffix: Text(' minutes'), jump: 15),
      ]),
      delimiter: <PickerDelimiter>[
        PickerDelimiter(
          child: Container(
            width: 30.0,
            alignment: Alignment.center,
            child: Icon(Icons.more_vert),
          ),
        )
      ],
      hideHeader: true,
      confirmText: 'Ok',
      title: const Text('Select duration'),
      selectedTextStyle: TextStyle(color: LightAppColors.secondary),
      onConfirm: (Picker picker, List<int> value) {
        // You get your duration here
        _duration = Duration(
            hours: picker.getSelectedValues()[0],
            minutes: picker.getSelectedValues()[1]);
        setState(() {});
      },
    ).showDialog(context);
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
}
