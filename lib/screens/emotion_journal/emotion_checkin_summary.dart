import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/emotion_coach/screens/emotion_coach_screen.dart';
import 'package:brainfit/screens/vision/screens/vision_created_success.dart';
import 'package:brainfit/services/database_helper.dart';

import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class EmotionCheckinSummary extends StatefulWidget {
  final Map<String, dynamic> createData;

  EmotionCheckinSummary({
    Key? key,
    required this.createData,
  }) : super(key: key);

  @override
  State<EmotionCheckinSummary> createState() => _EmotionCheckinSummary();
}

class _EmotionCheckinSummary extends State<EmotionCheckinSummary> {
  late String visionId;
  final conversationTextController = TextEditingController();
  final beliefConversationTextController = TextEditingController();

  bool editMode = true;

  bool showLoader = false;
  List<dynamic> events = [];
  String? _errorMessage;
  Map<String, dynamic>? createData;
  List<dynamic> getRelationships = [];
  List<dynamic> getEmotions = [];

  String dropDownValue = "30 days";

  final ScrollController _relationshipScrollController = ScrollController();
  final ScrollController _emotionsScrollController = ScrollController();

  double _value = 5;

  @override
  void initState() {
    createData = widget.createData;
    conversationTextController.text =
        createData?["internal_conversation"] ?? "";
    beliefConversationTextController.text =
        createData?["eventual_outcome"] ?? "";
    super.initState();
    _fetchRelationships();
    _fetchEmotions();
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
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        title: Text("Emotion Check-in",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: LightAppColors.blackColor)),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: LightAppColors.blackColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextButton(
              onPressed: () {
                _sendDataToBackend();
              },
              child: Text(
                "Save",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          height: AppScreenConfig.safeBlockVertical! * 100,
          width: AppScreenConfig.safeBlockHorizontal! * 100,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: <Widget>[
              if (_errorMessage == null && !showLoader) ...[
                Opacity(
                  opacity: showLoader ? 0.01 : 1,
                  child: _showEmotionCheckinDetail(),
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

  Future<void> _sendDataToBackend() async {
    for (int i = 0; i < getEmotions.length; i++) {
      if (getEmotions[i]["name"] == createData?["primary_emotion"]) {
        createData?["primary_emotion_id"] = getEmotions[i]["id"];
      }
      if (getEmotions[i]["name"] == createData?["secondary_emotion"]) {
        createData?["secondary_emotion_id"] = getEmotions[i]["id"];
      }
    }
    getRelationships.forEach((element) {
      if (createData?["primary_relationship"] == element['name']) {
        createData?["primary_relationship_id"] = element["id"];
      } else if (createData?["secondary_relationship"] == element['name']) {
        createData?["secondary_relationship_id"] = element["id"];
      }
    });

    if (createData?["primary_relationship_id"] == null) {
      Utils.showSuccessToast("Please select a Relationship");
      return;
    }

    if (createData?["primary_emotion_id"] == null) {
      Utils.showSuccessToast("Please select a Emotion");
      return;
    }

    showLoader = true;
    setState(() {});

    Map<String, dynamic>? _sendData = {
      "internal_conversation": createData?["internal_conversation"],
      "primary_emotion_id": createData?["primary_emotion_id"],
      "secondary_emotion_id": createData?["secondary_emotion_id"],
      "primary_relationship_id": createData?["primary_relationship_id"],
      "secondary_relationship_id": createData?["secondary_relationship_id"],
      "eventual_outcome": createData?["eventual_outcome"]
    };

    if (_sendData["secondary_emotion_id"] == null) {
      _sendData.remove("secondary_emotion_id");
    }

    if (_sendData["secondary_relationship_id"] == null) {
      _sendData.remove("secondary_relationship_id");
    }

    print(_sendData);
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.emotionCheckIn,
        addAutherization: true,
        requestParmas: _sendData,
        method: RestAPIRequestMethods.post);

    if ((response["code"] == 401 || response["code"] == 403)) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    }
    if (response['code'] == 200 || response['code'] == "200") {
      Utils.showSuccessToast("Your Emotion check is successfully done");
      print("Emotion Coach Needed ${response["data"]['coach_needed']}");

      if (response["data"]['coach_needed'] == true) {
        response["data"] = widget.createData["relationship_id"];
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            settings: RouteSettings(name: "EC"),
            builder: (context) => EmotionCoachScreen(data: widget.createData),
          ),
          (route) => route != AppRoutes.home,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, (route) => false);
      }
    }

    showLoader = false;
    setState(() {});
  }

  Widget _showEmotionCheckinDetail() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      children: [
        Text("How are you feeling?",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.grey, fontWeight: FontWeight.w400)),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
        TextFormField(
          maxLines: 1,
          readOnly: !editMode,
          controller: conversationTextController,
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
              return "Enter conversation text";
            }
            return null;
          },
          onChanged: (value) {
            createData?["internal_conversation"] = value;
          },
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Towards what/who?',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.grey, fontWeight: FontWeight.w400)),
            if (editMode) ...[
              InkWell(
                onTap: () {
                  createData?["primary_relationship"] = null;
                  createData?["secondary_relationship"] = null;
                  createData?["primary_relationship_id"] = null;
                  createData?["secondary_relationship_id"] = null;
                  setState(() {});
                },
                child: Container(
                  height: 30.0,
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: LightAppColors.blackColor.withOpacity(0.9),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text("Clear",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
        Container(
          height: AppScreenConfig.safeBlockVertical! * 20,
          child: Scrollbar(
            thumbVisibility: true,
            controller: _relationshipScrollController,
            child: ListView(
              controller: _relationshipScrollController,
              shrinkWrap: true,
              children: <Widget>[
                AppPrimarySecondarySelectChip(
                  getRelationships
                      .map((e) => e["name"])
                      .toList()
                      .cast<String>(),
                  isEditable: editMode,
                  selectedColor: Colors.black87,
                  primaryValue: createData?["primary_relationship"] ?? "",
                  secondaryValue: createData?["secondary_relationship"] ?? "",
                  onSelectionChanged: (primary, secondary) {
                    createData?["primary_relationship"] = primary;
                    createData?["secondary_relationship"] = secondary;
                    setState(() {});
                  },
                  maxSelectionWarning:
                      "You can only select two relationships, Please tap clear button to reset",
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text('What emotions are you feeling?',
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.w400)),
            ),
            if (editMode) ...[
              InkWell(
                onTap: () {
                  createData?["primary_emotion"] = null;
                  createData?["secondary_emotion"] = null;
                  createData?["primary_emotion_id"] = null;
                  createData?["secondary_emotion_id"] = null;
                  setState(() {});
                },
                child: Container(
                  height: 30.0,
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: LightAppColors.blackColor.withOpacity(0.9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: Text("Clear",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white)),
                    ),
                  ),
                ),
              ),
            ]
          ],
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
        if (getEmotions.isNotEmpty) ...[
          Container(
            height: AppScreenConfig.safeBlockVertical! * 20,
            child: Scrollbar(
              thumbVisibility: true,
              controller: _emotionsScrollController,
              child: ListView(
                controller: _emotionsScrollController,
                children: <Widget>[
                  AppPrimarySecondarySelectChip(
                    getEmotions.map((e) => e["name"]).toList().cast<String>(),
                    logoUrl: getEmotions.map((e) => e["logo"]).toList(),
                    selectedColor: Colors.black87,
                    isEditable: editMode,
                    primaryValue: createData?["primary_emotion"] ?? "",
                    secondaryValue: createData?["secondary_emotion"] ?? "",
                    onSelectionChanged: (primary, secondary) {
                      createData?["primary_emotion"] = primary;
                      createData?["secondary_emotion"] = secondary;
                      setState(() {});
                    },
                    maxSelectionWarning:
                        "You can only select two emotions, Please tap clear button to reset",
                  ),
                ],
              ),
            ),
          ),
        ],
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Text("What belief do you have?",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.grey)),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: TextFormField(
            maxLines: 4,
            controller: beliefConversationTextController,
            cursorColor: LightAppColors.appBlueColor,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w700),
            // maxLength: 500,
            decoration: InputDecoration(
              filled: true,
              hintMaxLines: 3,
              fillColor: LightAppColors.greyColor.withOpacity(0.2),
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
                return "Enter conversation text";
              }
              return null;
            },
            onChanged: (value) {
              createData?["eventual_outcome"] = value;
            },
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}
