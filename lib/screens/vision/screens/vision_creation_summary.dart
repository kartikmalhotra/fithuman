import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/vision/screens/vision_created_success.dart';
import 'package:brainfit/services/database_helper.dart';

import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class VisionCreationSummary extends StatefulWidget {
  final Map<String, dynamic> createData;
  final String removeScreenUntil;
  final bool isEditing;

  VisionCreationSummary({
    Key? key,
    required this.createData,
    required this.removeScreenUntil,
    required this.isEditing,
  }) : super(key: key);

  @override
  State<VisionCreationSummary> createState() => _VisionDetailState();
}

class _VisionDetailState extends State<VisionCreationSummary> {
  late String visionId;
  final conversationTextController = TextEditingController();
  final relationshipTextController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool showLoader = false;
  List<dynamic> events = [];
  String? _errorMessage;
  Map<String, dynamic>? createData;
  List<dynamic> priceToBe = [];
  List<dynamic> getToBe = [];
  List<dynamic> getRelationships = [];
  List<dynamic> commitments = [];
  List<dynamic> getEmotions = [];

  String dropDownValue = "30 days";

  final ScrollController _relationshipScrollController = ScrollController();
  final ScrollController _emotionsScrollController = ScrollController();
  final ScrollController _getToBeScrollController = ScrollController();
  final ScrollController _priceScrollController = ScrollController();

  double _value = 5;

  @override
  void initState() {
    createData = widget.createData;
    conversationTextController.text =
        Utils.utf8convert(createData?["conversation_text"] ?? "");
    relationshipTextController.text =
        Utils.utf8convert(createData?["importance_text"] ?? "");
    super.initState();
    _callApi();
  }

  Future<void> _callApi() async {
    showLoader = true;

    setState(() {});
    await _fetchPriceToBe();
    await _fetchGetToBe();
    await _fetchRelationships();
    await _fetchEmotions();
    await _fetchCommitments();
    showLoader = false;
    setState(() {});
  }

  Future<void> _fetchCommitments() async {
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.commitments,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      commitments = response["data"];
    }

    if (kDebugMode) {
      print(response);
    }
  }

  Future<void> _fetchPriceToBe() async {
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.price,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      priceToBe = response["data"];
    }
  }

  Future<void> _fetchGetToBe() async {
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.getToBe,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      getToBe = response["data"];
    }

    if (kDebugMode) {
      print(response);
    }
  }

  Future<void> _fetchRelationships({bool firstCall = false}) async {
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
  }

  Future<void> _fetchEmotions({bool firstCall = false}) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: visionColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
        ),
        title: Text("Vision",
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
              onPressed: () => _validateData(),
              child: Text(
                "Save",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          height: AppScreenConfig.safeBlockVertical! * 100,
          width: AppScreenConfig.safeBlockHorizontal! * 100,
          decoration: BoxDecoration(color: Colors.white
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   end: Alignment.bottomCenter,
              //   stops: [0.0, 1.0],
              //   colors: [
              //     visionColorGradient1,
              //     visionColorGradient2,
              //   ],
              // ),
              ),
          child: Stack(
            children: <Widget>[
              if (_errorMessage == null && !showLoader) ...[
                Opacity(
                  opacity: showLoader ? 0.01 : 1,
                  child: _showVisionDetail(),
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

  Widget _showVisionDetail() {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        children: [
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
          Text(
            "What is the conversation you are having with yourself",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
          TextFormField(
            maxLines: 1,
            controller: conversationTextController,
            cursorColor: LightAppColors.appBlueColor,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w700),
            onChanged: (value) => {
              {
                createData?["conversation_text"] = value,
              }
            },
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
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Select a Relationship',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.w400)),
              OutlinedButton(
                onPressed: () {
                  createData?["primary_relationship"] = null;
                  createData?["secondary_relationship"] = null;
                  createData?["primary_relationship_id"] = null;
                  createData?["secondary_relationship_id"] = null;
                  setState(() {});
                },
                child: Text(
                  "Clear All",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
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
                    selectedColor: Colors.black87,
                    primaryValue: createData?["primary_relationship"] ?? "",
                    secondaryValue: createData?["secondary_relationship"] ?? "",
                    onSelectionChanged: (primary, secondary) {
                      createData?["primary_relationship"] = primary;
                      createData?["secondary_relationship"] = secondary;
                      setState(() {});
                    },
                    maxSelectionWarning:
                        "You can only select two relationship, Please tap clear button to reset",
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 4),
          Row(
            children: [
              Expanded(
                child: Text('Select Emotion for your vision',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w400)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: OutlinedButton(
                  onPressed: () {
                    createData?["emotions"] = <String>[];
                    setState(() {});
                  },
                  child: Text(
                    "Clear All",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20.0),
          if (getEmotions.isNotEmpty) ...[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0),
              height: AppScreenConfig.safeBlockVertical! * 20,
              child: Scrollbar(
                thumbVisibility: true,
                controller: _emotionsScrollController,
                child: ListView(
                  controller: _emotionsScrollController,
                  children: <Widget>[
                    AppMultiSelectChip(
                      getEmotions.map((e) => e["name"]).toList().cast<String>(),
                      logoUrl: getEmotions.map((e) => e["logo"]).toList(),
                      selectedColor: Colors.black87,
                      selectedValue: createData?["emotions"] ?? <String>[],
                      onSelectionChanged: (value) {
                        createData?["emotions"] = value;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppScreenConfig.safeBlockVertical! * 4),
            Text(
                "Where do you see this relationship right now on a scale of 1 to 10",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.grey, fontWeight: FontWeight.w400)),
            SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          10,
                          (index) => Text(
                            "${index + 1}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Slider(
                            min: 1.0,
                            max: 10.0,
                            activeColor: LightAppColors.greyColor,
                            thumbColor: Colors.grey,
                            inactiveColor:
                                LightAppColors.greyColor.withOpacity(0.2),
                            divisions: 10,
                            value: _value,
                            label: '${_value.round()}',
                            onChanged: (value) {
                              _value = value;
                              // createData["current_rating"] = value.toInt();
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppScreenConfig.safeBlockVertical! * 4),
            Row(
              children: [
                Expanded(
                  child: Text('You are committed to building a relationship of',
                      style: Theme.of(context).textTheme.bodyText1?.copyWith(
                          color: Colors.grey, fontWeight: FontWeight.w400)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: OutlinedButton(
                    onPressed: () {
                      createData?["commitment"] = null;
                      setState(() {});
                    },
                    child: Text(
                      "Clear All",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
            if (commitments.isNotEmpty) ...[
              AppSingleSelectChip(
                commitments.map((e) => e["name"]).toList().cast<String>(),
                "commitments",
                selectedValue: createData?["commitment"] ?? "",
                selectedColor: Colors.black87,
                onSelectionChanged: (value) {
                  createData?["commitment"] = value;
                  setState(() {});
                },
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 4),
              Text(
                "Why is this relationship important to you",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
              TextFormField(
                maxLines: 1,
                controller: relationshipTextController,
                cursorColor: LightAppColors.appBlueColor,
                onChanged: (value) {
                  createData?["importance_text"] = value;
                },
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  filled: true,
                  hintMaxLines: 3,
                  fillColor: LightAppColors.greyColor.withOpacity(0.1),
                  // prefixIcon: Icon(Icons.mail, color: Colors.grey),

                  hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.grey),
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
                    return "Enter the field";
                  }
                  return null;
                },
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 4),
              Text(
                "What price am I willing to pay to move this relationship forward?",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
              Container(
                height: AppScreenConfig.safeBlockVertical! * 10,
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _priceScrollController,
                  child: ListView(
                      controller: _priceScrollController,
                      children: <Widget>[
                        AppSingleSelectChip(
                          priceToBe
                              .map((e) => e["name"])
                              .toList()
                              .cast<String>(),
                          "Price",
                          selectedValue: createData?["price"] ?? "",
                          selectedColor: Colors.black87,
                          onSelectionChanged: (value) {
                            createData?["price"] = value;
                            setState(() {});
                          },
                        ),
                      ]),
                ),
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "What is your vision for the next",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
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
                                      .bodyText1!
                                      .copyWith(),
                                ),
                              ))
                          .toList()
                          .cast(),
                      isExpanded: true,
                      onChanged: (value) {
                        dropDownValue = value!;
                        createData?["duration"] = value;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Enter a Get to be be",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.grey, fontWeight: FontWeight.w400),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      createData?["get_to_be"] = null;
                      setState(() {});
                    },
                    child: Text(
                      "Clear All",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  )
                ],
              ),
              SizedBox(height: 10.0),
              Container(
                height: AppScreenConfig.safeBlockVertical! * 20,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: Scrollbar(
                  thumbVisibility: true,
                  controller: _getToBeScrollController,
                  child: ListView(
                    controller: _getToBeScrollController,
                    children: <Widget>[
                      AppSingleSelectChip(
                        getToBe.map((e) => e["name"]).toList().cast<String>(),
                        "type",
                        selectedValue: createData?["get_to_be"] ?? "",
                        selectedColor: Colors.black87,
                        onSelectionChanged: (String value) {
                          createData?["get_to_be"] = value;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ],
        ],
      ),
    );
  }

  void _validateData() {
    showLoader = true;
    setState(() {});
    if (createData?["primary_relationship"] == null) {
      showLoader = false;
      setState(() {});
      Utils.showSuccessToast('Please select a relationship');
      return;
    }

    if (createData?["emotions"]?.isEmpty ?? true) {
      showLoader = false;
      setState(() {});
      Utils.showSuccessToast('Please select an emotion');
      return;
    }

    if (createData?["commitment"] == null) {
      showLoader = false;
      setState(() {});
      Utils.showSuccessToast('Please select a commitment');

      return;
    }

    if (createData?["get_to_be"] == null) {
      showLoader = false;
      setState(() {});
      Utils.showSuccessToast('Please select a get to be');
      return;
    }

    widget.isEditing ? _editVision() : _createVision();
  }

  Future<dynamic> deleteEvent(String id) async {
    setState(() {});
    // / If image is picked from galley
    final response = await Application.restService?.requestCall(
        apiEndPoint: ApiRestEndPoints.schedulers,
        requestParmas: {"event_id": id},
        method: RestAPIRequestMethods.delete,
        addAutherization: true);
    setState(() {
      showLoader = false;
    });
    if (response['code'] == 200 || response['code'] == "200") {
      Utils.showSuccessToast("Commitment deleted successfully");
    } else {
      Utils.showSuccessToast("Something went wrong while deleting commitment");
    }
  }

  Future<dynamic> deleteVision(String id) async {
    setState(() {});
    // / If image is picked from galley
    final response = await Application.restService?.requestCall(
        apiEndPoint: ApiRestEndPoints.visionPlanner,
        requestParmas: {"vision_id": id},
        method: RestAPIRequestMethods.delete,
        addAutherization: true);

    if (kDebugMode) {
      Utils.showSuccessToast("Vision deleted successfully");
      Navigator.pop(context);
    }
    if (response != null) {
      return response;
    }
  }

  void _createVision() async {
    Map<String, dynamic>? _sendData;
    _sendData = createData;
    _sendData?["emotions"] = _sendData["emotions"].toList();

    if (_sendData?["secondary_emotion_id"] == null) {
      _sendData?.remove("secondary_emotion_id");
    }

    if (_sendData?["secondary_relationship_id"] == null) {
      _sendData?.remove("secondary_relationship_id");
    }

    print(_sendData);
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.visionPlanner,
        addAutherization: true,
        requestParmas: createData,
        method: RestAPIRequestMethods.post);
    setState(() {
      showLoader = false;
    });

    if ((response["code"] == 401 || response["code"] == 403)) {
      await DatabaseHelper().deleteUsers();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    }
    if (response["code"] == 200) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => VisionCreatedSuccess(
                  createData: {"vision_id": response["data"]["id"]})),
          (route) => false);
    } else {
      Utils.showSuccessToast(response["reason"] ?? "Something went wrong");
    }
  }

  void _editVision() async {
    createData?["id"] = createData?["vision_id"];

    if (createData?["secondary_emotion_id"] == null) {
      createData?.remove("secondary_emotion_id");
    }

    if (createData?["secondary_relationship_id"] == null) {
      createData?.remove("secondary_relationship_id");
    }
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.visionPlanner,
        addAutherization: true,
        requestParmas: createData,
        method: RestAPIRequestMethods.put);
    setState(() {
      showLoader = false;
    });

    if ((response["code"] == 401 || response["code"] == 403)) {
      await DatabaseHelper().deleteUsers();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    }
    if (response["code"] == 200) {
      Utils.showSuccessToast("Vision edited successfully");
      Navigator.of(context).popUntil((route) {
        return route.settings.name == widget.removeScreenUntil;
        // Use defined route like Dashboard.routeName
      });
    } else {
      Utils.showSuccessToast(response["reason"] ?? "Something went wrong");
    }
  }
}
