import 'dart:io';
import 'dart:typed_data';

// import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image/image.dart';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:http/http.dart' as http;

class NativeAPIService {
  static NativeAPIService? _nativeAPIService;
  static ImagePicker? _imagePicker;

  NativeAPIService._internal();

  static NativeAPIService? getInstance() {
    _nativeAPIService ??= NativeAPIService._internal();
    _imagePicker = ImagePicker();
    return _nativeAPIService;
  }

  Future<File> pickVideoFromGallery() async {
    XFile? pickedFile =
        await _imagePicker!.pickVideo(source: ImageSource.gallery);
    File video = File(pickedFile!.path);
    return video;
  }

  // Future<String> genThumbnailFile(String path) async {
  //   if (kDebugMode) {
  //     print(path);
  //   }
  //   final fileName = await VideoThumbnail.thumbnailFile(
  //     video: path,
  //     thumbnailPath: '/data/user/0/com.woofy.hellowoofy/cache/',
  //     imageFormat: ImageFormat.PNG,
  //     maxHeight:
  //         100, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
  //     quality: 75,
  //   );
  //   File file = File(fileName!);
  //   return file.path;
  // }

  /// ******************************************************
  ///
  ///         Image Upload Related Feature
  ///
  /// ******************************************************

  /// This function is used to pick image from the source provided [Camera] or [Gallery]
  Future<Map<String, dynamic>> pickImage(ImageSource source) async {
    try {
      XFile? _pickedFile = await _imagePicker!.pickImage(source: source);
      Map<String, dynamic> _imageFile;
      if (_pickedFile?.path.isNotEmpty ?? false) {
        _imageFile = {'image': _pickedFile?.path as String};
        return _imageFile;
        // _imageFile = await cropImage(_imageFile["image"].path, "Crop image");
      } else {
        _imageFile = {'error': 'error_no_image_selected'};

        return _imageFile;
      }
    } catch (e) {
      Map<String, dynamic> _error = {'error': e.toString()};
      return _error;
    }
  }

  /// Android system -- although very rarely -- sometimes kills the MainActivity after the image_picker finishes. This result in loss of data
  /// This is used to retrieve the lost data (image) by using the [image_picker] plugin
  // Future<Map<String, dynamic>> retrieveLostImage(dynamic e) async {
  //   Map<String, dynamic> _lostImage;
  // final LostDataResponse response = await _imagePicker!.retrieveLostData();

  // if (response.isEmpty) {
  //   _lostImage = {'error': e};
  // }

  // /// Check if lost file is present and is only of type image
  // if (response.file != null) {
  //   if (response.type == RetrieveType.image) {
  //     _lostImage = {'image': File(response.file!.path)};
  //   } else {
  //     _lostImage = {'error': e};
  //   }
  // } else {
  //   _lostImage = {
  //     'error': response.exception != null ? response.exception!.code : e
  //   };
  // }

  //   return _lostImage;
  // }

  /// This function is used to compress the image size using plugin
  /// [flutter_image_compress] which is used to compress the image
  // Future<Map<String, dynamic>> compressImage(File file) async {
  //   Map<String, dynamic> _compressedImage;
  //   final String _filePath = file.absolute.path;
  //   final int _lastIndex = _filePath.lastIndexOf('.');
  //   final Directory _tempDirectory = await getTemporaryDirectory();
  //   final String _targetPath =
  //       "${_tempDirectory.path}/compress_${DateTime.now()}${_filePath.substring(_lastIndex)}";

  //   final CompressFormat _compressFormat =
  //       _getCompressFormat(_filePath.substring(_lastIndex));

  //   /// Compress and Get file
  //   try {
  //     File? _compressedFile = await FlutterImageCompress.compressAndGetFile(
  //       _filePath,
  //       _targetPath,
  //       format: _compressFormat,
  //       quality: 15,
  //       minWidth: 1200,
  //       minHeight: 900,
  //     );

  //     _compressedImage = {'image': _compressedFile};

  //     return _compressedImage;
  //   } catch (e) {
  //     _compressedImage = {'error': e.toString()};
  //     return _compressedImage;
  //   }
  // }

  // CompressFormat _getCompressFormat(String? format) {
  //   if (format == null) {
  //     return CompressFormat.jpeg;
  //   }

  //   if (format.endsWith('.jpg') || format.endsWith('.jpeg')) {
  //     return CompressFormat.jpeg;
  //   } else if (format.endsWith('.png')) {
  //     return CompressFormat.png;
  //   } else if (format.endsWith('.heic')) {
  //     return CompressFormat.heic;
  //   }

  //   return CompressFormat.jpeg;
  // }

  /// This is used to crop the image using plugin [image_cropper]
  Future<Map<String, dynamic>> cropImage(
      String imageSourcePath, String? toolBarTitle,
      {Color? toolBarColor}) async {
    Map<String, dynamic> _croppedImage;

    CroppedFile? _croppedFile = await ImageCropper().cropImage(
      sourcePath: imageSourcePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio3x2,
      ],
    );

    if (_croppedFile != null) {
      _croppedImage = {'image': _croppedFile};
    } else {
      _croppedImage = {'error': "error_no_image_selected"};
    }

    return _croppedImage;
  }

  /// ******************************************************
  ///
  ///         Geolocation Related Feature
  ///
  /// ******************************************************

  /// This function is used to return the bool value if location permission is given to the application
  Future<bool> getGeolocationPermissionStatus() async {
    try {
      return await requestPermission(Permission.location);
    } catch (_) {
      return false;
    }
  }

  /// This function is used to check whether the GPS is enabled on device or not
  // Future<bool> checkGPSEnabled() async {
  //   try {
  //     bool _gpsEnabled = await _location!.serviceEnabled();

  //     /// Check if GPS is not enabled then allow the user to enable the GPS/ Location service
  //     if (!_gpsEnabled) {
  //       _gpsEnabled = await _location!.requestService();
  //     }

  //     return _gpsEnabled;
  //   } catch (_) {
  //     return false;
  //   }
  // }

  /// This function is used to fetch the user current location provided with default [desiredAccuracy = LocationAccuracy.best]
  // Future<Map<String, dynamic>> getCurrentLocation(
  //     {LocationAccuracy desiredAccuracy = LocationAccuracy.high}) async {
  //   /// Fetch the Current Location
  //   try {
  //     /// Change the location setting to [desiredAccuracy]
  //     await _location!.changeSettings(accuracy: desiredAccuracy);

  //     LocationData _currentLocation = await _location!.getLocation().timeout(
  //       const Duration(seconds: 10),
  //       onTimeout: () async {
  //         if (desiredAccuracy == LocationAccuracy.high) {
  //           /// Change the location setting to [LocationAccuracy.balanced]
  //           await _location!
  //               .changeSettings(accuracy: LocationAccuracy.balanced);

  //           /// Fetch the current location
  //           LocationData _currentLocation =
  //               await _location!.getLocation().timeout(
  //                     const Duration(seconds: 20),
  //                     onTimeout: (() => throw const FormatException()),
  //                   );

  //           return _currentLocation;
  //         } else {
  //           throw const FormatException();
  //         }
  //       },
  //     );
  //     return {'success': _currentLocation};
  //   } on PlatformException {
  //     return {'error': 'error_no_location_permission'};
  //   } on FormatException {
  //     return {'error': 'error_invalid_location_mode'};
  //   } catch (e) {
  //     if (desiredAccuracy == LocationAccuracy.high) {
  //       return await getCurrentLocation(
  //           desiredAccuracy: LocationAccuracy.balanced);
  //     } else {
  //       return {'error': 'error_location_not_found'};
  //     }
  //   }
  // }

  /// ******************************************************
  ///
  ///         Storage Permission Related Feature
  ///
  /// ******************************************************

  /// This function request for the storage permissions
  Future<bool> requestStoragePermission() async {
    return await requestPermission(Permission.storage);
  }

  /// ******************************************************
  ///
  ///         Permission handler Related Feature
  ///
  /// ******************************************************

  /// This function request for the permission related to native features.
  /// Request param: [PermissionGroup]
  Future<bool> requestPermission(Permission permission) async {
    return await permission.request().isGranted;
  }

  // Future<List<String>> downloadMedia(dynamic post, MediaType mediaType,
  //     {bool isStory = true}) async {
  //   List<String> mediaUrls = [];

  //   /// If MediaType is Image
  //   if (mediaType == MediaType.Image) {
  //     for (int i = 0; i < (post.images?.length ?? 0); i++) {
  //       if ((post.images?.length ?? 0) > 0) {
  //         GallerySaver.saveImage(post.images![i]).then((bool? success) {});
  //       }
  //       var response = await http.get(Uri.parse(post.images![i]));
  //       var documentDirectory = await getApplicationDocumentsDirectory();
  //       if (await Permission.storage.request().isGranted) {
  //         if (kDebugMode) {
  //           print("MANAGE_EXTERNAL_STORAGE Granted");
  //         }
  //       } else {
  //         if (kDebugMode) {
  //           print("MANAGE_EXTERNAL_STORAGE Not Granted");
  //         }
  //       }
  //       var firstPath = documentDirectory.path + "/images";
  //       String fileName = post.images![i].split('/').last;
  //       var filePathAndName = documentDirectory.path + '/images/$fileName';
  //       await Directory(firstPath).create(recursive: true);
  //       File file2 = File(filePathAndName);
  //       file2.writeAsBytesSync(response.bodyBytes);
  //       mediaUrls.add(fileName);
  //     }
  //   }

  //   /// If MediaType is Video or GIF
  //   else if (mediaType == MediaType.Video || mediaType == MediaType.Gif) {
  //     String url =
  //         MediaType.Video == mediaType ? post.video!.url! : post.images!.first;
  //     String? path = await downloadVideoGIFFile(url, mediaType);
  //     if (path != null) {
  //       mediaUrls.add(path);
  //     }
  //   }
  //   return mediaUrls;
  // }

  MediaType? checkMediaType(post) {
    MediaType? _mediaType;
    if (post.images?.isEmpty ?? false) {
      if (post.video?.url?.isEmpty ?? false) {
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

  // Future<String?> downloadVideoGIFFile(
  //     String mediaUrl, MediaType? mediaType) async {
  //   String extension = mediaUrl.substring(mediaUrl.length - 3);

  //   Dio dio = Dio();
  //   try {
  //     var dir = await getApplicationDocumentsDirectory();
  //     // var dir = await DownloadsPathProvider.downloadsDirectory;
  //     await dio.download(mediaUrl, "${dir.path}/videos/media.$extension",
  //         onReceiveProgress: (rec, total) {});
  //     if (kDebugMode) {
  //       print("Download completed");
  //     }
  //     return "${dir.path}/videos/media.$extension";
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e);
  //     }
  //     return null;
  //   }
  // }

  Future<List<String>> convertMediaToBytes(
      List<String> imagePath, MediaType mediaType) async {
    List<String> byteImagePaths = [];
    final tempDir = await getTemporaryDirectory();

    /// Media Type is Video
    if (mediaType == MediaType.Video) {
      File file = File(imagePath[0]);
      Uint8List bytes = await File(imagePath[0]).readAsBytes();
      var stickerData = bytes.buffer.asUint8List();
      String stickerAssetName =
          'video.${imagePath[0].substring(imagePath[0].length - 3)}';
      final Uint8List stickerAssetAsList = stickerData;
      final stickerAssetPath = '${tempDir.path}/$stickerAssetName';
      file = await File(stickerAssetPath).create();
      byteImagePaths.add(stickerAssetName);
      file.writeAsBytesSync(stickerAssetAsList);
    }

    /// Media Type is Gif
    else if (mediaType == MediaType.Gif) {
      final String outputFile = imagePath[0]; //path to export the mp4 file.
      File file = File(outputFile);
      Uint8List bytes = await file.readAsBytes();
      var stickerData = bytes.buffer.asUint8List();
      String stickerAssetName =
          'video.${outputFile.substring(outputFile.length - 3)}';
      final Uint8List stickerAssetAsList = stickerData;
      final stickerAssetPath = '${tempDir.path}/$stickerAssetName';
      file = await File(stickerAssetPath).create();
      byteImagePaths.add(stickerAssetName);
      file.writeAsBytesSync(stickerAssetAsList);
    }

    /// Media Type is Image
    else {
      for (int i = 0; i < imagePath.length; i++) {
        /// Get image from URI
        var response = await http.get(Uri.parse(imagePath[i]));
        var documentDirectory = await getApplicationDocumentsDirectory();
        if (await Permission.storage.request().isGranted) {
          if (kDebugMode) {
            print("MANAGE_EXTERNAL_STORAGE Granted");
          }
        } else {
          if (kDebugMode) {
            print("MANAGE_EXTERNAL_STORAGE Not Granted");
          }
        }
        var firstPath = documentDirectory.path + "/images";
        String fileName = imagePath[i].split('/').last;

        var filePathAndName = documentDirectory.path + '/images/$fileName';
        await Directory(firstPath).create(recursive: true);
        File file2 = File(filePathAndName);
        byteImagePaths.add(filePathAndName);
        file2.writeAsBytesSync(response.bodyBytes);
      }
    }

    return byteImagePaths;
  }
}
