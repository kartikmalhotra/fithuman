import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:brainfit/config/routes/routes.dart';
import 'package:brainfit/services/local_storage.dart';
import 'package:brainfit/services/native_service.dart';
import 'package:brainfit/services/rest_api_service.dart';
import 'package:brainfit/services/secure_storage.dart';
import 'package:brainfit/services/timezone_service.dart';
import 'package:brainfit/shared/models/profile_model.dart';

class Application {
  static String? preferedLanguage;
  static String? preferedTheme;
  static UserDetails? userDetails;
  static Brightness? hostSystemBrightness;
  static LocalStorageService? localStorageService;
  static SecureStorageService? secureStorageService;
  static FirebaseMessaging? firebaseMessaging;
  static TimezoneService? timezoneService;
  static NativeAPIService? nativeAPIService;
  static AppRouteSetting? routeSetting;
  static RestAPIService? restService;
  static TargetPlatform platform =
      Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android;
}
