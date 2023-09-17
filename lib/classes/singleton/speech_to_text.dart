//InternetAddress utility
//For StreamController/Stream
import 'dart:async';

import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechToTextSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final SpeechToTextSingleton _singleton =
      new SpeechToTextSingleton._internal();
  static final SpeechToText speechToText = SpeechToText();
  static final StreamController<String> controller =
      StreamController<String>.broadcast();

  SpeechToTextSingleton._internal() {
    initialize();
  }

  //This is what's used to retrieve the instance through the app
  static SpeechToTextSingleton getInstance() => _singleton;

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  static void initialize() async {
    await speechToText.initialize(
      finalTimeout: Duration(seconds: 10),
      onError: (errorNotification) =>
          {controller.add(errorNotification.errorMsg)},
      onStatus: (status) => controller.add(status),
    );
  }

  /// Each time to start a speech recognition session
  // static Future<String> startListening() async {
  //   String listenResult = "";
  //   await SpeechToTextSingleton.speechToText.listen(
  //       onResult: (SpeechRecognitionResult result) {
  //     listenResult = (result.recognizedWords);
  //     print("Listened word  $listenResult");
  //   });
  //   return listenResult;
  // }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  static String onSpeechResult(SpeechRecognitionResult result) {
    return result.recognizedWords;
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  static stopListening() async {
    await SpeechToTextSingleton.speechToText.stop();
  }
}
