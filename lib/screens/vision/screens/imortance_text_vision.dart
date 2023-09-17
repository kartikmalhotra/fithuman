import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:brainfit/classes/singleton/speech_to_text.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/screens/vision/screens/price_for_vision.dart';
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class ImportanceTextScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String removeScreenUntil;

  const ImportanceTextScreen({
    Key? key,
    required this.createData,
    this.isEditing = false,
    required this.removeScreenUntil,
  }) : super(key: key);

  @override
  State<ImportanceTextScreen> createState() => _ImportanceTextScreenState();
}

class _ImportanceTextScreenState extends State<ImportanceTextScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  double _value = 5;
  Map<String, dynamic> createData = {};
  TextEditingController? _importantTextController;
  bool _speechEnabled = false;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  bool _keyboardVisible = false;

  @override
  void initState() {
    _importantTextController = TextEditingController();
    createData = widget.createData;
    _importantTextController?.text = createData["conversation_with_self"] ??
        Utils.utf8convert(createData["importance_text"] ?? "");
    createData = widget.createData;
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
            currentStep: 5,
            size: 5.5,
            selectedColor: Colors.white,
            unselectedColor: Colors.grey,
            roundedEdges: Radius.circular(10),
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          BubbleNormal(
            text: 'Why is this relationship important to you',
            isSender: false,
            color: Colors.white,
            tail: true,
            textStyle: Theme.of(context).textTheme.subtitle1!,
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: TextFormField(
              focusNode: _focusNode,
              controller: _importantTextController,
              maxLines: 4,
              cursorColor: LightAppColors.blackColor,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w700),
              // maxLength: 500,
              decoration: InputDecoration(
                filled: true,
                hintMaxLines: 3,

                fillColor: LightAppColors.cardBackground.withOpacity(0.9),
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
                  return "Enter important text";
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
                  SpeechToTextSingleton.speechToText.listen(
                    listenFor: Duration(seconds: 10),
                    cancelOnError: true,
                    pauseFor: Duration(seconds: 15),
                    onResult: (SpeechRecognitionResult result) {
                      if (result.finalResult) {
                        _importantTextController?.text =
                            (_importantTextController?.text ?? "") +
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
                    onPressed: () {
                      createData["importance_text"] =
                          _importantTextController?.text ?? "";
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PriceToBeScreen(
                            createData: createData,
                            isEditing: widget.isEditing,
                            removeScreenUntil: widget.removeScreenUntil,
                          ),
                          settings: RouteSettings(name: "G"),
                        ),
                      );
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
