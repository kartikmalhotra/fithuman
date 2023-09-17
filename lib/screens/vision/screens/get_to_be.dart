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
import 'package:brainfit/screens/home/screens/home_screen.dart';

import 'package:brainfit/screens/vision/screens/vision_created_success.dart';
import 'package:brainfit/screens/vision/screens/vision_creation_summary.dart';
import 'package:brainfit/services/database_helper.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class GetToBeScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final String removeScreenUntil;
  final bool isEditing;

  const GetToBeScreen(
      {Key? key,
      required this.createData,
      required this.removeScreenUntil,
      this.isEditing = false})
      : super(key: key);

  @override
  State<GetToBeScreen> createState() => _GetToBeScreenState();
}

class _GetToBeScreenState extends State<GetToBeScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  bool editRelationship = false;
  TextEditingController _addRelationshipController = TextEditingController();
  Map<String, dynamic>? createData;
  final ScrollController _scrollController = ScrollController();
  bool _keyboardVisible = false;

  @override
  void initState() {
    createData = widget.createData;

    super.initState();
    _fetchRelationships();
  }

  void _fetchRelationships() async {
    showLoader = true;
    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.getToBe,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      data = response["data"];
      if (_addRelationshipController.text.isNotEmpty) {
        createData?["get_to_be"] = _addRelationshipController.text;
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
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
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
                padding: EdgeInsets.all(20.0),
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
    if (_keyboardVisible) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 50),
        curve: Curves.fastOutSlowIn,
      );
    }
    return InkWell(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: ListView(
        controller: _scrollController,
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false),
              icon: Icon(Icons.cancel_outlined, color: Colors.black),
            ),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          StepProgressIndicator(
            totalSteps: 8,
            currentStep: 8,
            size: 5.5,
            selectedColor: Colors.white,
            unselectedColor: Colors.grey,
            roundedEdges: Radius.circular(10),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          BubbleNormal(
            text: 'Who do you get to be to create it',
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          if (data.isNotEmpty) ...[
            AppSingleSelectChip(
              data.map((e) => e["name"]).toList().cast<String>(),
              "type",
              selectedValue: createData?["get_to_be"] ?? "",
              selectedColor: Colors.black87,
              onSelectionChanged: (String value) {
                createData?["get_to_be"] = value;
                setState(() {});
              },
            ),
          ] else ...[
            Text(
              "You have no get to be present for a vision, please create a get to be",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
            )
          ],
          SizedBox(height: 10.0),
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
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    height: 30.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: LightAppColors.blackColor.withOpacity(0.2),
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
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      createData?["get_to_be"] = null;
                    });
                  },
                  child: Text("Clear All",
                      style: Theme.of(context).textTheme.bodyText1),
                )
              ],
            ),
          ] else ...[
            Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      editRelationship = !editRelationship;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 40,
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
                          contentPadding: EdgeInsets.all(10),
                          fillColor: LightAppColors.greyColor.withOpacity(0.1),
                          // prefixIcon: Icon(Icons.mail, color: Colors.grey),
                          hintText: "Enter a Get to be ",
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
                            return "Enter your price";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => _createGetToBe(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.check,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            )
          ],
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 1.5),
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
                      if (createData?["get_to_be"] != null) {
                        if (!widget.isEditing) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VisionCreationSummary(
                                  isEditing: widget.isEditing,
                                  removeScreenUntil: widget.removeScreenUntil,
                                  createData: createData ?? {}),
                            ),
                          );
                        }
                      } else {
                        Utils.showFailureToast(
                            "You have not selected a get to be");
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
      ),
    );
  }

  void _createGetToBe() async {
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.getToBe,
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
  }
}
