///
///                       NimbleThis, Inc. Proprietary
///
/// This source code is the sole property of  NimbleThis, Inc.. Any form of utilization of this source code in whole or in part is  prohibited without written consent from
///  NimbleThis, Inc.
///
///  File Name	              : theme_config.dart
///  Principal Author         : NimbleThis
///  Module Name              : Themes
///  Date of First Release	  :
///  Author				            : NimbleThis
///  Description              : This file contains the code for theme configuartion like App spacing, device screen information etc
///  Change History Version   : 6.0.0
///  Date(DD/MM/YYYY) 	      : 18-02-20
///  Modified by			        : NimbleThis
///  Description of change    : N/A
///

import 'dart:io' show Platform;
import 'package:flutter/material.dart';

enum AppTheme { light, dark, system }
enum Device { mobile, tablet, iPhone, iPad }

abstract class SetAppScreenConfiguration {
  static late BuildContext context;

  static void init(BuildContext ctx) {
    context = ctx;
    AppScreenConfig.init(context);
    AppDevice.init(AppScreenConfig.getScreenWidth()!);
  }
}

abstract class AppDevice {
  static Device? type;

  static void init(double deviceWidth) {
    if (deviceWidth > 600 && Platform.isAndroid) {
      type = Device.tablet;
    } else if (deviceWidth > 600) {
      type = Device.iPad;
    } else if (Platform.isAndroid) {
      type = Device.mobile;
    } else {
      type = Device.iPhone;
    }
  }
}

abstract class AppScreenConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double statusbarHeight;
  static late double systemNavbarHeight;

  static late double safeAreaHorizontal;
  static late double safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    statusbarHeight = _mediaQueryData.padding.top;
    systemNavbarHeight = _mediaQueryData.padding.bottom;

    safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - safeAreaVertical) / 100;
  }

  static double? getScreenWidth() => screenWidth;
  static double? getScreenHeight() => screenHeight;
  static double? getStatusBarHeight() => statusbarHeight;
  static double? getSystemNavBarHeight() => systemNavbarHeight;
}

abstract class AppSpacing {
  static const xsss = 2.0;
  static const xss = 4.0;
  static const xs = 8.0;
  static const ms = 10.0;
  static const s = 12.0;
  static const m = 16.0;
  static const l = 20.0;
  static const xl = 24.0;
  static const xxl = 28.0;
  static const xxxl = 32.0;
  static const xxxxl = 36.0;

  static const cardHeight = 150.0;
  static const miniCardWidth = 200.0;
  static const borderRadius = 6.0;
  static const iconSize = 24.0;
  static const photoSize = 36.0;
  static const dashboardModuleIconSize = 30.0;
  static const listItemHeight = 64.0;
  static const walkThroughAppBarHeight = 85.0;
  static const topAppBarHeight = 50.0;
  static const bottomNavBarHeight = 60.0;
  static const bannerCardHeight = 50.0;
  static const legendsIconSizeBig = 30.0;
  static const legendsIconSizeSmall = 24.0;
  static const legendsIconSizeExtraSmall = 16.0;
}

abstract class AppAnimationDuration {
  static const xxxxshort = 10;
  static const xxxshort = 100;
  static const xxshort = 200;
  static const xshort = 500;
  static const short = 800;
  static const medium = 1000;
  static const xmedium = 1300;
  static const long = 1500;
  static const xlong = 2000;
}
