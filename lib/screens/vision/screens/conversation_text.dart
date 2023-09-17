import 'dart:async';

import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:brainfit/classes/singleton/speech_to_text.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';

import 'package:brainfit/screens/vision/screens/relationship_vision_screen.dart';
import 'package:brainfit/services/database_helper.dart';
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class ConversationText extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String removeScreenUntil;

  const ConversationText(
      {Key? key,
      required this.createData,
      required this.removeScreenUntil,
      this.isEditing = false})
      : super(key: key);

  @override
  State<ConversationText> createState() => _ConversationTextState();
}

class _ConversationTextState extends State<ConversationText> {
  bool showLoader = false;
  List<dynamic> data = [];
  double _value = 5;
  TextEditingController? conversationTextController;
  Map<String, dynamic> createData = {};
  bool _speechEnabled = false;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _keyboardVisible = false;

  @override
  void initState() {
    conversationTextController = TextEditingController();
    createData = widget.createData;
    conversationTextController?.text =
        Utils.utf8convert(createData["conversation_with_self"] ?? "");
    super.initState();
    SpeechToTextSingleton.controller.stream.listen((event) {
      if (event == "notListening" ||
          event == "done" ||
          event == "error_speech_timeout") {
        if (mounted) {
          setState(() {
            _speechEnabled = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
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
              Center(
                child: AppCircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
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
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          StepProgressIndicator(
            totalSteps: 8,
            currentStep: 0,
            size: 5.5,
            selectedColor: Colors.white,
            unselectedColor: Colors.grey,
            roundedEdges: Radius.circular(10),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 8),
          BubbleNormal(
            text: 'What is the conversation you are having with yourself',
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: TextFormField(
              maxLines: 4,
              focusNode: _focusNode,
              controller: conversationTextController,
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
          ),
          GestureDetector(
            onLongPress: () async {
              try {
                await SpeechToTextSingleton.getInstance();
                _speechEnabled = !_speechEnabled;
                setState(() {});
                if (_speechEnabled) {
                  await SpeechToTextSingleton.speechToText.listen(
                    listenFor: Duration(seconds: 10),
                    cancelOnError: true,
                    pauseFor: Duration(seconds: 15),
                    onResult: (SpeechRecognitionResult result) {
                      if (result.finalResult) {
                        conversationTextController?.text =
                            (conversationTextController?.text ?? "") +
                                " " +
                                result.recognizedWords;
                        _speechEnabled = false;
                        setState(() {});
                      }
                    },
                  );
                } else {
                  await SpeechToTextSingleton.stopListening();
                  _speechEnabled = false;
                  setState(() {});
                }
              } catch (exe) {}
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                if (!_speechEnabled) ...[
                  Text(
                    "Long press to speak",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.black),
                  ),
                ] else ...[
                  Image.asset(
                    "assets/gif/wave.gif",
                    height: 50,
                    width: 100,
                    color: Colors.black,
                  ),
                ],
                IconButton(
                  onPressed: () async {},
                  icon: Icon(Icons.mic, color: Colors.black),
                )
              ],
            ),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
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
                    onPressed: () async {
                      if (conversationTextController?.text.isNotEmpty ??
                          false) {
                        createData["conversation_text"] =
                            conversationTextController!.text;
                        if (!widget.isEditing) {
                          await _sendTextForAnalysis();
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: RouteSettings(name: "B"),
                            builder: (context) => VisionRelationship(
                              createData: createData,
                              isEditing: widget.isEditing,
                              removeScreenUntil: widget.removeScreenUntil,
                            ),
                          ),
                        );
                      } else {
                        Utils.showFailureToast(
                            "You have not entered a conversation text");
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
      ),
    );
  }

  Future<void> _sendTextForAnalysis() async {
    showLoader = true;

    setState(() {});
    var response = [
      await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.relationAnalysis,
          addAutherization: true,
          requestParmas: {"text": conversationTextController?.text ?? ""},
          method: RestAPIRequestMethods.post),
      await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.emotionAnalysis,
          addAutherization: true,
          requestParmas: {"text": conversationTextController?.text ?? ""},
          method: RestAPIRequestMethods.post),
    ];
    if ((response[0]["code"] == 401 ||
        response[0]["code"] == 403 ||
        response[1]["code"] == 401 ||
        response[1]["code"] == 403)) {
      await DatabaseHelper().deleteUsers();

      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    }

    if (response[0]["relationships"] != null) {
      createData["selected_relationship"] = response[0]["relationships"]
              ?.map((e) => e["name"])
              .toList()
              .cast<String>() ??
          [];
    }
    if (response[1]["data"] != null) {
      createData["selected_emotion"] = response[1]["data"] ?? [];
    }

    if (response[1]["code"] == 200) {
    } else {}
    showLoader = false;
    setState(() {});
  }

  /// Each time to start a speech recognition session
  static Future<String> startListening() async {
    String result = "";
    await SpeechToTextSingleton.speechToText.listen(
      onResult: (onResult) {
        result = onResult.recognizedWords;
      },
      listenFor: Duration(seconds: 5),
    );
    return result;
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  static void onSpeechResult(SpeechRecognitionResult result) {
    // conversationTextController.text = result.recognizedWords;
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  static stopListening() async {
    await SpeechToTextSingleton.speechToText.stop();
  }
}
