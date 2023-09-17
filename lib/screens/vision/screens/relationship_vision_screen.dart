import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/vision/screens/emotion_vision_screen.dart';
import 'package:brainfit/services/database_helper.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class VisionRelationship extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String removeScreenUntil;

  const VisionRelationship(
      {Key? key,
      required this.createData,
      required this.removeScreenUntil,
      this.isEditing = false})
      : super(key: key);

  @override
  State<VisionRelationship> createState() => _VisionRelationshipState();
}

class _VisionRelationshipState extends State<VisionRelationship> {
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
        createData["relationship"] = data.firstWhere((element) =>
                createData["selected_relationship"]
                    .contains(element['name'])) ??
            [];
        createData["relationship"] = (createData["relationship"] is Map)
            ? createData["relationship"]["name"]
            : createData["relationship"];
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
      padding: EdgeInsets.all(30.0),
      children: <Widget>[
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        StepProgressIndicator(
          totalSteps: 8,
          currentStep: 1,
          size: 5.5,
          selectedColor: Colors.white,
          unselectedColor: Colors.grey,
          roundedEdges: Radius.circular(10),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 8),
        BubbleNormal(
          text: 'Select a Relationship',
          isSender: false,
          color: Colors.white,
          tail: true,
          textStyle: Theme.of(context).textTheme.subtitle1!,
        ),
        SizedBox(height: 20.0),
        if (data.isNotEmpty) ...[
          Container(
            height: AppScreenConfig.safeBlockVertical! * 35,
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
                    secondaryValue: createData["secondary_relationship"] ?? "",
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
        ] else ...[
          Text(
            "You have no relationships create a relationships",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
          )
        ],
        if (!editRelationship) ...[
          SizedBox(height: 30.0),
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
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: LightAppColors.blackColor.withOpacity(0.2),
                  ),
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
              SizedBox(width: 20.0),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    createData["primary_relationship"] = null;
                    createData["secondary_relationship"] = null;
                    createData["primary_relationship_id"] = null;
                    createData["secondary_relationship_id"] = null;
                  });
                },
                child: Text("Clear All",
                    style: Theme.of(context).textTheme.bodyText1),
              ),
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
                      color: Colors.grey,
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
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 1.5),
        Row(children: <Widget>[
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
                        builder: (context) => VisionEmotionScreen(
                          createData: createData,
                          isEditing: widget.isEditing,
                          removeScreenUntil: widget.removeScreenUntil,
                        ),
                      ),
                    );
                  } else {
                    Utils.showSuccessToast(
                        "Please select a primary and secondary relationship");
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
      Utils.showSuccessToast(response["reason"]);
    }
  }
}
