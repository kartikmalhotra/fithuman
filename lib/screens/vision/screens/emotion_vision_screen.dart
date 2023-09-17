import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/vision/screens/current_rating_screen.dart';

import 'package:brainfit/screens/vision/screens/imortance_text_vision.dart';
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class VisionEmotionScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String removeScreenUntil;

  const VisionEmotionScreen({
    Key? key,
    required this.createData,
    required this.removeScreenUntil,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<VisionEmotionScreen> createState() => _VisionRelationshipState();
}

class _VisionRelationshipState extends State<VisionEmotionScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  bool editRelationship = false;
  Map<String, dynamic> createData = {};

  @override
  void initState() {
    createData = widget.createData;
    super.initState();
    _fetchEmotions(firstCall: true);
  }

  void _fetchEmotions({bool firstCall = false}) async {
    showLoader = true;

    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.emotions,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      data = response["data"];
      if (createData["selected_emotion"] != null) {
        createData["emotions"] = createData["selected_emotion"]
            .map((e) => e["name"])
            .toList()
            .cast<String>();
      }
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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Opacity(
              opacity: showLoader ? 0.1 : 1,
              child: Container(
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
                padding: EdgeInsets.all(30.0),
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
          currentStep: 2,
          size: 5.5,
          selectedColor: Colors.white,
          unselectedColor: Colors.grey,
          roundedEdges: Radius.circular(10),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        BubbleNormal(
          text: 'Select Emotion for your vision',
          isSender: false,
          color: Colors.white,
          tail: true,
          textStyle: Theme.of(context).textTheme.subtitle1!,
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        if (data.isNotEmpty) ...[
          AppMultiSelectChip(
            data.map((e) => e["name"]).toList().cast<String>(),
            logoUrl: data.map((e) => e["logo"]).toList(),
            selectedColor: Colors.black87,
            selectedValue: createData["emotions"] ?? [],
            onSelectionChanged: (value) {
              createData["emotions"] = value;
              setState(() {});
            },
          ),
        ] else ...[
          Text(
            "Hey looks like no emotion is present",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
          )
        ],
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
        Row(
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                setState(() {
                  createData["emotions"] = <String>[];
                });
              },
              child: Text("Clear All",
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 50.0,
                child: OutlinedButton(
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
                child: OutlinedButton(
                  onPressed: () {
                    if (createData["emotions"] != null &&
                        (createData["emotions"]?.isNotEmpty ?? false)) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: "D"),
                          builder: (context) => CurrentRating(
                              createData: createData,
                              removeScreenUntil: widget.removeScreenUntil,
                              isEditing: widget.isEditing),
                        ),
                      );
                    } else {
                      Utils.showSuccessToast("Please select an emotion");
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
        )
      ],
    );
  }
}
