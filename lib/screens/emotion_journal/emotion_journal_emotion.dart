import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/emotion_journal/emotion_journal_belief.dart';

import 'package:brainfit/screens/vision/screens/current_rating_screen.dart';
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class EmotionJournalEmotion extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool openedFromNotification;
  final bool isEditing;

  const EmotionJournalEmotion({
    Key? key,
    required this.createData,
    this.openedFromNotification = false,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<EmotionJournalEmotion> createState() => _VisionRelationshipState();
}

class _VisionRelationshipState extends State<EmotionJournalEmotion> {
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
        createData["primary_emotion"] = createData["selected_emotion"]
            .map((e) => e["name"])
            .toList()
            .cast<String>()
            .first;
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
                padding: EdgeInsets.all(30.0),
                color: emotionJournalColor.withOpacity(0.9),
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
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 8),
        BubbleNormal(
          text: "What emotions are you feeling?",
          isSender: false,
          color: Colors.black87,
          tail: true,
          textStyle: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.white),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        if (data.isNotEmpty) ...[
          AppPrimarySecondarySelectChip(
            data.map((e) => e["name"]).toList().cast<String>(),
            selectedColor: Colors.black,
            primaryValue: createData["primary_emotion"] ?? "",
            secondaryValue: createData["secondary_emotion"] ?? "",
            onSelectionChanged: (primary, secondary) {
              createData["primary_emotion"] = primary;
              createData["secondary_emotion"] = secondary;
              setState(() {});
            },
            logoUrl: data.map((e) => e["logo"]).toList(),
            maxSelectionWarning:
                "You can only select two emotions, Please tap clear button to reset",
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
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              onTap: () {
                createData["primary_emotion"] = null;
                createData["secondary_emotion"] = null;
                setState(() {});
              },
              child: Container(
                height: 30.0,
                margin: EdgeInsets.symmetric(vertical: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: LightAppColors.blackColor.withOpacity(0.9),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Text(
                    "Clear",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
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
                    if (createData["primary_emotion"] != null) {
                      for (int i = 0; i < data.length; i++) {
                        if (data[i]["name"] == createData["primary_emotion"]) {
                          createData["primary_emotion_id"] = data[i]["id"];
                        }
                        if (data[i]["name"] ==
                            createData["secondary_emotion"]) {
                          createData["secondary_emotion_id"] = data[i]["id"];
                        }
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: "D"),
                          builder: (context) => EmotionJournalBeliefScreen(
                              openedFromNotification:
                                  widget.openedFromNotification,
                              createData: createData,
                              isEditing: widget.isEditing),
                        ),
                      );
                    } else {
                      Utils.showSuccessToast("Please select a Emotion");
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
