import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:brainfit/classes/singleton/speech_to_text.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/emotion_coach/screens/emotion_coach_screen.dart';
import 'package:brainfit/screens/emotion_journal/emotion_checkin_summary.dart';

import 'package:brainfit/services/database_helper.dart';
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class EmotionJournalBeliefScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool openedFromNotification;
  final bool isEditing;

  const EmotionJournalBeliefScreen({
    Key? key,
    required this.createData,
    this.openedFromNotification = false,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<EmotionJournalBeliefScreen> createState() => _ConversationTextState();
}

class _ConversationTextState extends State<EmotionJournalBeliefScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  bool _speechEnabled = false;
  bool _keyboardVisible = false;
  double _value = 5;
  TextEditingController? conversationTextController;
  Map<String, dynamic> createData = {};
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    conversationTextController = TextEditingController();
    createData = widget.createData;
    conversationTextController?.text =
        createData["conversation_with_self"] ?? "";
    _focusNode.requestFocus();

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
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Opacity(
              opacity: showLoader ? 0.1 : 1,
              child: Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
                color: emotionJournalColor.withOpacity(0.9),
                child: _displayContents(context),
              ),
            ),
            if (showLoader) ...[
              Center(
                  child: AppCircularProgressIndicator(
                color: Colors.black,
              )),
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
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
          BubbleNormal(
            text: 'What belief do you have ?',
            isSender: false,
            color: Colors.black87,
            tail: true,
            textStyle: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
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
                        createData["eventual_outcome"] =
                            conversationTextController!.text;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: RouteSettings(name: "E"),
                            builder: (context) =>
                                EmotionCheckinSummary(createData: createData),
                          ),
                        );
                      } else {
                        Utils.showFailureToast(
                            "Please enter a belief that you have");
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
}
