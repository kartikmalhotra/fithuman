import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/screens/event_schedular/screens/event_location.dart';
import 'package:brainfit/screens/event_schedular/screens/event_recurring.dart';
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class EventTitleScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final String? route;
  final bool isEditing;

  const EventTitleScreen({
    Key? key,
    required this.createData,
    this.route,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<EventTitleScreen> createState() => _EventTitleScreenState();
}

class _EventTitleScreenState extends State<EventTitleScreen> {
  bool showLoader = false;
  List<dynamic> data = [];

  final ScrollController _scrollController = ScrollController();

  Map<String, dynamic> createData = {};
  final TextEditingController _importantTextController =
      TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _discriptionTextController =
      TextEditingController();
  bool _keyboardVisible = false;

  @override
  void initState() {
    createData = widget.createData;
    if (createData["title"] != null) {
      _importantTextController.text = Utils.utf8convert(createData["title"]);
    }
    if (createData["location"] != null) {
      _locationTextController.text = Utils.utf8convert(createData["location"]);
    }
    if (createData["description"] != null) {
      _discriptionTextController.text =
          Utils.utf8convert(createData["description"]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Opacity(
            opacity: showLoader ? 0.1 : 1,
            child: Container(
              padding: EdgeInsets.all(20.0),
              color: commitmentColor.withOpacity(0.8),
              child: _displayContents(context),
            ),
          ),
          if (showLoader) ...[
            Center(child: AppCircularProgressIndicator()),
          ]
        ],
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
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          StepProgressIndicator(
            totalSteps: 2,
            currentStep: 1,
            size: 5.5,
            selectedColor: Colors.white,
            unselectedColor: Colors.grey,
            roundedEdges: Radius.circular(10),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 7),
          BubbleNormal(
            text: 'What do you want to call this commitment?',
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: AppScreenConfig.safeBlockHorizontal! * 70,
              child: TextFormField(
                controller: _importantTextController,
                maxLines: 1,
                cursorColor: LightAppColors.blackColor,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  filled: true,
                  hintMaxLines: 3,
                  fillColor: LightAppColors.cardBackground,
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
                    return "Enter a title";
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          BubbleNormal(
            text: 'Where is this commitment ?',
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: AppScreenConfig.safeBlockHorizontal! * 70,
              child: TextFormField(
                controller: _locationTextController,
                maxLines: 1,
                cursorColor: LightAppColors.appBlueColor,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  filled: true,
                  hintMaxLines: 3,
                  fillColor: LightAppColors.cardBackground,
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
                    return "Enter a location";
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          BubbleNormal(
            text: 'Any additional details?',
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: AppScreenConfig.safeBlockHorizontal! * 70,
              child: TextFormField(
                controller: _discriptionTextController,
                maxLines: 2,
                cursorColor: LightAppColors.appBlueColor,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontWeight: FontWeight.w700),
                maxLength: 500,
                decoration: InputDecoration(
                  filled: true,
                  hintMaxLines: 3,

                  fillColor: LightAppColors.cardBackground,
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
                    return "Enter commitment description";
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
          Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 50.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
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
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white)),
                    onPressed: () {
                      createData["title"] = _importantTextController.text;
                      createData["location"] = _locationTextController.text;
                      createData["description"] =
                          _discriptionTextController.text;

                      if (createData["title"] != null &&
                          createData["location"] != null &&
                          createData["description"] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: RouteSettings(name: "EC"),
                            builder: (context) => EventRecurringScreen(
                                createData: createData,
                                route: widget.route,
                                isEditing: widget.isEditing),
                          ),
                        );
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
}
