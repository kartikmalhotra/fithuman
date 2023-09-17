import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/emotion_journal/emotion_journal_emotion.dart';
import 'package:brainfit/screens/vision/screens/emotion_vision_screen.dart';
import 'package:brainfit/services/database_helper.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class EmotionJournalRelationshipScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final bool openedFromNotification;

  const EmotionJournalRelationshipScreen({
    Key? key,
    required this.createData,
    this.isEditing = false,
    this.openedFromNotification = false,
  }) : super(key: key);

  @override
  State<EmotionJournalRelationshipScreen> createState() =>
      _EmotionJournalRelationshipScreenState();
}

class _EmotionJournalRelationshipScreenState
    extends State<EmotionJournalRelationshipScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  bool editRelationship = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController _addRelationshipController = TextEditingController();
  Map<String, dynamic> createData = {};

  @override
  void initState() {
    createData = widget.createData;
    super.initState();
    _fetchRelationships(firstCall: true);
  }

  void _fetchRelationships({bool firstCall = false}) async {
    showLoader = true;
    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.relationships,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      data = response["data"];

      if (createData["selected_relationship"]?.isNotEmpty ?? false) {
        data.forEach((element) {
          if (createData["selected_relationship"].contains(element['name'])) {
            if (!createData.containsKey("primary_relationship")) {
              createData["primary_relationship"] = element["name"];
              createData["primary_relationship_id"] = element["id"];
            } else {
              createData["secondary_relationship"] = element["name"];
              createData["secondary_relationship_id"] = element["id"];
            }
          }
        });
      }

      if (_addRelationshipController.text.isNotEmpty) {
        createData["relationship"] = _addRelationshipController.text;
        _addRelationshipController.text = "";
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
                color: emotionJournalColor,
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
      padding: EdgeInsets.all(30.0),
      children: <Widget>[
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 8),
        BubbleNormal(
          text: "Towards what/who?",
          isSender: false,
          color: Colors.black87,
          tail: true,
          textStyle: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.white),
        ),
        if (data.isNotEmpty) ...[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 50.0),
                color: emotionJournalColor.withOpacity(0.4),
                height: AppScreenConfig.safeBlockVertical! * 30,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _scrollController,
                  child: ListView(
                    controller: _scrollController,
                    shrinkWrap: true,
                    children: <Widget>[
                      AppPrimarySecondarySelectChip(
                        data.map((e) => e["name"]).toList().cast<String>(),
                        selectedColor: Colors.black87,
                        primaryValue: createData["primary_relationship"] ?? "",
                        secondaryValue:
                            createData["secondary_relationship"] ?? "",
                        onSelectionChanged: (primary, secondary) {
                          createData["primary_relationship"] = primary;
                          createData["secondary_relationship"] = secondary;
                          setState(() {});
                        },
                        maxSelectionWarning:
                            "You can only select two relationship, Please tap clear button to reset",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 50.0),
            child: Text(
              "You have no relationships create a relationships",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
            ),
          )
        ],
        if (!editRelationship) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    editRelationship = !editRelationship;
                  });
                },
                child: Container(
                  height: 30.0,
                  margin: EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: LightAppColors.blackColor.withOpacity(0.9),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: Text(
                        "Add",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              InkWell(
                onTap: () {
                  createData["primary_relationship"] = null;
                  createData["secondary_relationship"] = null;
                  createData["priamry_relationship_id"] = null;
                  createData["secondary_relationship_id"] = null;
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
        ] else ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      editRelationship = !editRelationship;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.cancel,
                      color: Colors.black,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 35,
                    child: Center(
                      child: TextFormField(
                        controller: _addRelationshipController,
                        cursorColor: LightAppColors.appBlueColor,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.all(8.0),
                          fillColor: LightAppColors.greyColor.withOpacity(0.1),
                          // prefixIcon: Icon(Icons.mail, color: Colors.grey),
                          hintText: "Enter a relationship",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.w700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: (String? text) {
                          if (text?.isEmpty ?? true) {
                            return "Enter your email";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _createRelationship(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
        Row(children: <Widget>[
          Expanded(
            child: Container(
              height: 50.0,
              child: OutlinedButton(
                onPressed: () {
                  createData.remove("primary_relationship");
                  createData.remove("primary_relationship_id");
                  createData.remove("secondary_relationship");
                  createData.remove("secondary_relationship_id");
                  Navigator.pop(context);
                },
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
                  if (createData["primary_relationship"] != null) {
                    data.forEach((element) {
                      if (createData["primary_relationship"] ==
                          element['name']) {
                        createData["primary_relationship_id"] = element["id"];
                      } else if (createData["secondary_relationship"] ==
                          element['name']) {
                        createData["secondary_relationship_id"] = element["id"];
                      }
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: RouteSettings(name: "C"),
                        builder: (context) => EmotionJournalEmotion(
                          createData: createData,
                          isEditing: widget.isEditing,
                          openedFromNotification: widget.openedFromNotification,
                        ),
                      ),
                    );
                  } else {
                    Utils.showSuccessToast("Please select a relationship");
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
        ]),
      ],
    );
  }

  void _createRelationship() async {
    if (!data
        .map((e) => e["name"])
        .toList()
        .cast<String>()
        .contains(_addRelationshipController.text)) {
      var response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.relationships,
          addAutherization: true,
          requestParmas: {"name": _addRelationshipController.text},
          method: RestAPIRequestMethods.post);
      if ((response["code"] == 401 || response["code"] == 403)) {
        await DatabaseHelper().deleteUsers();
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      }
      if (response["code"] == 200) {
        editRelationship = false;
        _fetchRelationships();
      } else {
        Utils.showSuccessToast(response["error"]);
      }
    } else {
      Utils.showSuccessToast("Relationship already present");
    }
  }
}
