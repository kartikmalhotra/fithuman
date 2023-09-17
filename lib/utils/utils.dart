import 'dart:convert';
import 'dart:io';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:brainfit/const/app_constants.dart';
// import 'package:social_share_plugin/social_share_plugin.dart';

class Utils {
  static showFailureToast(message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
    );
  }

  static showSuccessToast(message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
    );
  }

  static String utf8convert(String text) {
    try {
      List<int> bytes = text.toString().codeUnits;
      return utf8.decode(bytes);
    } catch (exe) {
      return text;
    }
  }

  static Future<String?> screenShotAndSaveToLocal(
      BuildContext context, ScreenshotController controller) async {
    try {
      double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final imageByte = await controller.capture(
        pixelRatio: pixelRatio,
      );
      if (imageByte != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = File('${directory.path}/screenshot.png');
        if (!(await imagePath.exists())) {
          await imagePath.create();
        }
        // write to temporary directory
        await imagePath.writeAsBytes(imageByte);

        final saveImage =
            await GallerySaver.saveImage(imagePath.path, albumName: "My Image");

        if (saveImage == true) {
          return imagePath.path;
        }
      }
    } catch (e) {
      debugPrint("Exception while taking screenshot:" + e.toString());
    }
    return null;
  }

  static showSnackBar(String message, context) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'X',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static MediaType? checkMediaType(post) {
    MediaType? _mediaType;
    if (post.images?.isEmpty) {
      if (post.video?.url?.isNotEmpty ?? false) {
        _mediaType = MediaType.Video;
        return _mediaType;
      }
    } else {
      if (post.images != null &&
          post.images!.length <= 1 &&
          post.images![0].endsWith('gif')) {
        _mediaType = MediaType.Gif;
        return _mediaType;
      } else {
        _mediaType = MediaType.Image;
        return _mediaType;
      }
    }
    return MediaType.Image;
  }

  static Future<String?> downloadVideoGIFFile(
      String mediaUrl, MediaType? mediaType) async {
    try {
      if (mediaType == MediaType.Video) {
        await GallerySaver.saveVideo(mediaUrl).then((value) => print(value));
        return mediaUrl.split('/').last;
      } else if (mediaType == MediaType.Gif) {
        await GallerySaver.saveImage(mediaUrl).then((bool? success) {});
        return mediaUrl.split('/').last;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return '';
    }
    return null;
  }

  static Frequency calculateFrequency(String frequency) {
    if (frequency == "daily") {
      return Frequency.daily;
    } else if (frequency == "monthly") {
      return Frequency.monthly;
    } else if (frequency == "weekly") {
      return Frequency.weekly;
    } else if (frequency == "annually") {
      return Frequency.yearly;
    }
    return Frequency.daily;
  }

  // static Future<String?>? downloadVideoFile(String videoUrl) async {
  //   try {
  //     // if (await Permission.storage.request().isGranted) {
  //     //   if (kDebugMode) {
  //     //     print("MANAGE_EXTERNAL_STORAGE Granted");
  //     //   }
  //     // } else {
  //     //   if (kDebugMode) {
  //     //     print("MANAGE_EXTERNAL_STORAGE Not Granted");
  //     //   }
  //     // }
  //     var documentDirectory = await getTemporaryDirectory();
  //     String fileName = videoUrl.split('/').last;
  //     var filePathAndName = documentDirectory.path + '/' + fileName;

  //     await Dio().download(videoUrl, filePathAndName,
  //         onReceiveProgress: (received, total) {
  //       // if (total != -1) {
  //       print((received / total * 100).toStringAsFixed(0) + "%");
  //       // }
  //     });

  //     return filePathAndName;
  //   } on DioError catch (e) {
  //     print(e.message);
  //   }
  //   return null;
  // }

  // static Future<String?>? convertGIFToVideoFile(String videoUrl) async {
  //   try {
  //     if (await Permission.storage.request().isGranted) {
  //       if (kDebugMode) {
  //         print("MANAGE_EXTERNAL_STORAGE Granted");
  //       }
  //     } else {
  //       if (kDebugMode) {
  //         print("MANAGE_EXTERNAL_STORAGE Not Granted");
  //       }
  //     }
  //     final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  //     final String inputFile = videoUrl; //path of the gif file.
  //     // final String outputFile = videoUrl.replaceRange(videoUrl.length - 3,
  //     //     videoUrl.length, "mp4"); //path to export the mp4 file.

  //     var documentDirectory = await getTemporaryDirectory();
  //     String fileName = videoUrl.split('/').last;
  //     String newName = DateTime.now().microsecondsSinceEpoch.toString();
  //     var filePathAndName = documentDirectory.path + '/' + newName + ".mp4";

  //     await _flutterFFmpeg.execute("-f gif -i $inputFile $filePathAndName");
  //     return filePathAndName;
  //   } on DioError catch (e) {
  //     print(e.message);
  //   }
  //   return null;
  // }

  // static Future<String?>? downloadImageFile(String imageUrl) async {
  //   try {
  //     // if (await Permission.storage.request().isGranted) {
  //     //   if (kDebugMode) {
  //     //     print("MANAGE_EXTERNAL_STORAGE Granted");
  //     //   }
  //     // } else {
  //     //   if (kDebugMode) {
  //     //     print("MANAGE_EXTERNAL_STORAGE Not Granted");
  //     //   }
  //     // }
  //     var documentDirectory = await getTemporaryDirectory();
  //     String fileName = imageUrl.split('/').last;
  //     var filePathAndName = documentDirectory.path + '/' + fileName;

  //     await Dio().download(imageUrl, filePathAndName,
  //         onReceiveProgress: (received, total) {
  //       // if (total != -1) {
  //       //   print((received / total * 100).toStringAsFixed(0) + "%");
  //       // }
  //     });

  //     return filePathAndName;
  //   } on DioError catch (e) {
  //     print(e.message);
  //   }
  //   return null;
  // }

  static List<String?> extractHashtags(String text) {
    Iterable<Match> matches = RegExp(r"\B(\#[a-zA-Z]+\b)").allMatches(text);
    return matches.map((m) => m[0]).toList();
  }

  // static MediaType? getMediaType(String imagePath) {
  //   if (imagePath.isNotEmpty && imagePath.length > 4) {
  //     String extension =
  //         imagePath.substring(imagePath.length - 4, imagePath.length);
  //     if (extension.contains("jpeg") ||
  //         extension.contains("jpg") ||
  //         extension.contains("png")) {
  //       return MediaType.Image;
  //     } else if (extension.contains("gif")) {
  //       return MediaType.Gif;
  //     } else if (extension.contains("webp") || extension.contains("mp4")) {
  //       return MediaType.Video;
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  // static SocialMedia? getSocialMedia(String imagePath) {
  //   if (imagePath.isNotEmpty && imagePath.length > 4) {
  //     String extension =
  //         imagePath.substring(imagePath.length - 4, imagePath.length);
  //     if (extension.contains("jpeg") ||
  //         extension.contains("jpg") ||
  //         extension.contains("png")) {
  //       return MediaType.Image;
  //     } else if (extension.contains("gif")) {
  //       return MediaType.Gif;
  //     } else if (extension.contains("webp") || extension.contains("mp4")) {
  //       return MediaType.Video;
  //     } else {
  //       return null;
  //     }
  //   }
  // }

  static bool? checkExtension(String imagePath) {
    String extension = imagePath.split('.').last;
    if (extension == "jpeg" ||
        extension == "jpg" ||
        extension == "png" ||
        extension == "gif" ||
        extension == "webp" ||
        extension == "mp4") {
      return true;
    } else {
      return null;
    }
  }
}

/// a custom controller based on [TextEditingController] used to activly style input text based on regex patterns and word matching
/// with some custom features.
/// {@tool snippet}
///
/// ```dart
/// class _ExampleState extends State<Example> {
///
///   late RichTextController _controller;
///
/// _controller = RichTextController(
///       deleteOnBack: true,
///       patternMatchMap: {
///         //Returns every Hashtag with red color
///         RegExp(r"\B#[a-zA-Z0-9]+\b"):
///             const TextStyle(color: Colors.red, fontSize: 22.0),
///         //Returns every Mention with blue color and bold style.
///         RegExp(r"\B@[a-zA-Z0-9]+\b"): const TextStyle(
///           fontWeight: FontWeight.w800,
///           color: Colors.blue,
///         ),
///
///  TextFormField(
///  controller: _controller,
///  ...
/// )
///
/// ```
/// {@end-tool}
class RichTextController extends TextEditingController {
  final Map<RegExp, TextStyle>? patternMatchMap;
  final Map<String, TextStyle>? stringMatchMap;
  final Function(List<String> match) onMatch;
  final bool? deleteOnBack;
  String _lastValue = "";

  bool isBack(String current, String last) {
    return current.length < last.length;
  }

  RichTextController({
    String? text,
    this.patternMatchMap,
    this.stringMatchMap,
    required this.onMatch,
    this.deleteOnBack = false,
  })  : assert((patternMatchMap != null && stringMatchMap == null) ||
            (patternMatchMap == null && stringMatchMap != null)),
        super(text: text);

  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {
    List<TextSpan> children = [];
    List<String> matches = [];

    // Validating with REGEX
    RegExp? allRegex;
    allRegex = patternMatchMap != null
        ? RegExp(patternMatchMap?.keys.map((e) => e.pattern).join('|') ?? "")
        : null;
    // Validating with Strings
    RegExp? stringRegex;
    stringRegex = stringMatchMap != null
        ? RegExp(r'\b' + stringMatchMap!.keys.join('|').toString() + r'+\b')
        : null;
    ////
    text.splitMapJoin(
      stringMatchMap == null ? allRegex! : stringRegex!,
      onNonMatch: (String span) {
        children.add(TextSpan(text: span, style: style));
        return span.toString();
      },
      onMatch: (Match m) {
        if (!matches.contains(m[0])) matches.add(m[0]!);
        final RegExp? k = patternMatchMap?.entries.firstWhere((element) {
          return element.key.allMatches(m[0]!).isNotEmpty;
        }).key;
        final String? ks = stringMatchMap?.entries.firstWhere((element) {
          return element.key.allMatches(m[0]!).isNotEmpty;
        }).key;
        if (deleteOnBack!) {
          if ((isBack(text, _lastValue) && m.end == selection.baseOffset)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              children.removeWhere((element) => element.text! == text);
              text = text.replaceRange(m.start, m.end, "");
              selection = selection.copyWith(
                baseOffset: m.end - (m.end - m.start),
                extentOffset: m.end - (m.end - m.start),
              );
            });
          } else {
            children.add(
              TextSpan(
                text: m[0],
                style: stringMatchMap == null
                    ? patternMatchMap![k]
                    : stringMatchMap![ks],
              ),
            );
          }
        } else {
          children.add(
            TextSpan(
              text: m[0],
              style: stringMatchMap == null
                  ? patternMatchMap![k]
                  : stringMatchMap![ks],
            ),
          );
        }

        return (onMatch(matches) ?? '');
      },
    );

    _lastValue = text;
    return TextSpan(style: style, children: children);
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

extension DateTimeExtension on DateTime {
  String getMonthString() {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Err';
    }
  }
}
