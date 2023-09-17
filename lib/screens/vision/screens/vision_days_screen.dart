import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/vision/screens/get_to_be.dart';

import 'package:brainfit/widget/widget.dart';

class VisionDaysScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String removeScreenUntil;

  const VisionDaysScreen({
    Key? key,
    required this.createData,
    this.isEditing = false,
    required this.removeScreenUntil,
  }) : super(key: key);

  @override
  State<VisionDaysScreen> createState() => _VisionDaysScreenState();
}

class _VisionDaysScreenState extends State<VisionDaysScreen> {
  bool showLoader = false;
  List<dynamic> data = [];

  String dropDownValue = "30 days";
  Map<String, dynamic> createData = {};
  final TextEditingController _importantTextController =
      TextEditingController();

  @override
  void initState() {
    createData = widget.createData;
    if (createData.containsKey("duration")) {
      dropDownValue = createData["duration"];
    }
    createData["duration"] = dropDownValue;
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
                decoration: BoxDecoration(
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
          totalSteps: 8,
          currentStep: 7,
          size: 5.5,
          selectedColor: Colors.white,
          unselectedColor: Colors.grey,
          roundedEdges: Radius.circular(10),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        BubbleNormal(
          text: 'What is your vision for the next',
          isSender: false,
          color: Colors.white,
          tail: true,
          textStyle: Theme.of(context).textTheme.subtitle1!,
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: DropdownButton<String>(
                value: dropDownValue,
                style: Theme.of(context).textTheme.caption,
                items: visionDays
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
                  createData["duration"] = value;
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
                        builder: (context) => GetToBeScreen(
                          createData: createData,
                          isEditing: widget.isEditing,
                          removeScreenUntil: widget.removeScreenUntil,
                        ),
                        settings: RouteSettings(name: "G"),
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
