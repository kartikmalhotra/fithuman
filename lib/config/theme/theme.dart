import 'package:flutter/material.dart';

final emotionColor = Color(0xFFABF8E7);
final visionColor = Color(0xFFE6F0FF);
final visionColorGradient1 = Color(0xFFE6F0FF);
final visionColorGradient2 = Color(0xFFF1E4F4);
final commitmentColor = Color(0xFF2F80ED);
final commitmentColorGradient1 = Color(0xFF2F80ED);
final commitmentColorGradient2 = Color(0xFFB2FFDA);

final emotionJournalColor = Colors.white;

final lightThemeData = {
  'themeData': ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Helvetica Neue',
    primaryColor: LightAppColors.primary,
    scaffoldBackgroundColor: LightAppColors.stable,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: LightAppColors.primary,
      selectionColor: LightAppColors.textSelectionColor,
      selectionHandleColor: LightAppColors.textSelectionColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(LightAppColors.secondary),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide(color: LightAppColors.secondary),
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        borderSide: BorderSide.none,
      ),
    ),
    snackBarTheme:
        SnackBarThemeData(backgroundColor: LightAppColors.greenColor),
    toggleableActiveColor: LightAppColors.primary,
    cardColor: LightAppColors.cardBackground,
    cardTheme: const CardTheme(
      color: LightAppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(6.0),
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      iconTheme: const IconThemeData(
        color: LightAppColors.cardBackground,
      ),
      backgroundColor: LightAppColors.primary,
      toolbarTextStyle: const TextTheme(
        headline6: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ).bodyText2,
      titleTextStyle: const TextTheme(
        headline6: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ).headline6,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: LightAppColors.cardBackground,
      modalBackgroundColor: LightAppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
      ),
    ),
    textTheme: TextTheme(
      headline1: const TextStyle(
        fontSize: 112,
        fontWeight: FontWeight.w700,
        color: LightAppColors.primaryTextColor,
      ),
      headline2: const TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w400,
        color: LightAppColors.primaryTextColor,
      ),
      headline3: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w500,
        color: LightAppColors.primaryTextColor,
      ),
      headline4: const TextStyle(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: LightAppColors.primaryTextColor,
      ),
      headline5: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: LightAppColors.primaryTextColor,
      ),
      headline6: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        color: LightAppColors.primaryTextColor,
      ),
      subtitle1: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: LightAppColors.primaryTextColor.withOpacity(0.7),
      ),
      subtitle2: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: LightAppColors.primaryTextColor.withOpacity(0.7),
      ),
      bodyText1: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: LightAppColors.primaryTextColor.withOpacity(0.7),
      ),
      bodyText2: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: LightAppColors.primaryTextColor.withOpacity(0.7),
      ),
      button: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: LightAppColors.primaryTextColor.withOpacity(0.7),
      ),
      caption: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: LightAppColors.primaryTextColor.withOpacity(0.5),
      ),
      overline: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: LightAppColors.primary,
      ),
    ),
    buttonTheme: const ButtonThemeData(
      textTheme: ButtonTextTheme.accent,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: LightAppColors.bottomBarButtons,
      foregroundColor: LightAppColors.bottomBarButtons,
    ),
    iconTheme: const IconThemeData(
      color: LightAppColors.primary,
    ),
    primaryIconTheme: const IconThemeData(
      color: LightAppColors.primary,
    ),
    dividerTheme: DividerThemeData(
      color: LightAppColors.primaryTextColor.withOpacity(0.5),
    ),
    sliderTheme: SliderThemeData(
      overlayColor: LightAppColors.primary.withOpacity(0.2),
      valueIndicatorColor: LightAppColors.primary,
      thumbColor: LightAppColors.primary,
      activeTickMarkColor: LightAppColors.primary,
      inactiveTickMarkColor: LightAppColors.inactiveActionColor,
      activeTrackColor: LightAppColors.primary,
      inactiveTrackColor: LightAppColors.inactiveActionColor,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
      valueIndicatorTextStyle: const TextStyle(color: LightAppColors.stable),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: MaterialStateProperty.all(false),
      thumbColor: MaterialStateProperty.all(LightAppColors.sliderColor),
      thickness: MaterialStateProperty.all(6.0),
      radius: const Radius.circular(6.0),
      minThumbLength: 80.0,
    ),
    bannerTheme: const MaterialBannerThemeData(
      backgroundColor: LightAppColors.cardBackground,
    ),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: LightAppColors.primary),
  ),
  'primary': LightAppColors.primary,
  'secondaryColor': LightAppColors.secondary,
  'stableColor': LightAppColors.stable,
  'errorColor': LightAppColors.danger,
  'lightColor': LightAppColors.light,
  'listItemHeaderColor': LightAppColors.light,
  'inactiveActionColor': LightAppColors.inactiveActionColor,
  'borderColor': LightAppColors.borderColor,
  'redColor': LightAppColors.redColor,
  'greenColor': LightAppColors.greenColor,
  'yellowColor': LightAppColors.yellowColor,
  'darkYellowColor': LightAppColors.darkYellowColor,
  'greyColor': LightAppColors.greyColor,
  'blackColor': LightAppColors.blackColor,
  'tableBorderColor': LightAppColors.tableBorderColor,
  'cardTitleBackgroundColor': LightAppColors.cardTitleBackgroundColor,
  'cardBackground': LightAppColors.cardBackground,
  'chartBackgroundColor': LightAppColors.chartBackgroundColor,
  'chartHeadingColor': LightAppColors.chartHeadingColor,
  'chartHeadingBackgroundColor': LightAppColors.chartHeadingBackgroundColor,
  'orangeColor': LightAppColors.orangeColor,
  'lightOrangeColor': LightAppColors.lightOrangeColor,
  'bannerColor': LightAppColors.bannerColorLight,
  'bannerColorAction': LightAppColors.bannerColorDark,
  'warningBackground': LightAppColors.warningBackground,
  'errorBackground': LightAppColors.errorBackground,
  'primaryButtonTextColor': LightAppColors.primaryButtonTextColor,
  'primaryTextColor': LightAppColors.primaryTextColor,
  'inputBoxBorderColor': LightAppColors.primaryTextColor.withOpacity(0.5),
  'placeHolderTextColor': LightAppColors.primaryTextColor.withOpacity(0.4),
  'bottomTabsBackground': LightAppColors.bottomTabsBackground,
  'bottomBarButtons': LightAppColors.bottomBarButtons,
  'bottomSheetDragIndicator': LightAppColors.bottomSheetDragIndicator,
  'bottomSheetBackground': LightAppColors.bottomSheetBackground,
  'bottomSheetItemDivider': LightAppColors.bottomSheetItemDivider,
  'textGreyTitle': LightAppColors.textGreyTitle,
  'textGreySubTitle': LightAppColors.textGreySubTitle,
  'menuItemColor': LightAppColors.menuItemColor,
  'popUpMenuColor': LightAppColors.popUpMenuColor,
  'switchThumbColor': LightAppColors.switchThumbColor,
  'switchTrackActiveColor': LightAppColors.switchTrackActiveColor,
  'switchTrackInActiveColor': LightAppColors.switchTrackInActiveColor,
  'darkPrimary': LightAppColors.primaryGradientColor1,
  'detailScreenScafold': LightAppColors.cardBackground,
  'icfrBackGroundRed': LightAppColors.icfrBackGroundRed,
  'icfrBackGroundYellow': LightAppColors.icfrBackGroundYellow,
  'icfrBackGroundGreen': LightAppColors.icfrBackGroundGreen,
  'lightRedColor': LightAppColors.lightRedColor,
  'lightGreenColor': LightAppColors.lightGreenColor,
  'lightYellowColor': LightAppColors.lightYellowColor,
  'lightGreyColor': LightAppColors.lightGreyColor,
  'lightBlackColor': LightAppColors.lightBlackColor,
  'dullRedColor': LightAppColors.dullRedColor,
  'dullGreenColor': LightAppColors.dullGreenColor,
  'dullYellowColor': LightAppColors.dullYellowColor,
  'dullGreyColor': LightAppColors.dullGreyColor,
  'dullBlackColor': LightAppColors.dullBlackColor,
  'highRedColor': LightAppColors.highRedColor,
  'infoSectionColor': LightAppColors.infoSectionColor,
  'widgetBorderRedColor': LightAppColors.widgetBorderRedColor,
  'widgetBorderBlueColor': LightAppColors.widgetBorderBlueColor,
  'widgetBorderGreenColor': LightAppColors.widgetBorderGreenColor,
  'widgetBackgroundRedColor': LightAppColors.widgetBackgroundRedColor,
  'widgetBackgroundBlueColor': LightAppColors.widgetBackgroundBlueColor,
  'widgetBackgroundGreenColor': LightAppColors.widgetBackgroundGreenColor,
  'appBarGradient': const [
    LightAppColors.primaryGradientColor1,
    LightAppColors.primaryGradientColor2
  ],
  'primaryGradientThemeColors': const [
    LightAppColors.primaryGradientColor1,
    LightAppColors.primaryGradientColor2
  ],
  'secondaryGradientThemeColors': const [
    LightAppColors.secondaryGradientColor1,
    LightAppColors.secondaryGradientColor2
  ]
};

abstract class LightAppColors {
  static const primary = Color(0xFF00F5FF);
  static const secondary = Color(0xFF3D3DF2);
  static const tertiary = Color(0xFFEF0014);
  static const danger = Color(0xfff9304d);
  static const pink = Color(0xFFFEC1FF);
  static const stable = Color(0xfffafafa);
  static const light = Color(0xfff6f6f6);
  static const inactiveActionColor = Color(0xffcddcec);
  static const borderColor = Color(0xfff2f2f2);
  static const tableBorderColor = Color(0xffeaeaea);
  static const greenColor = Color(0xff41ad49);
  static const redColor = Color(0xffd50000);
  static const yellowColor = Color(0xffffff00);
  static const darkYellowColor = Color(0xffd4c72d);
  static const greyColor = Color(0xff9e9e9e);
  static const blackColor = Color(0xff000000);
  static const cardTitleBackgroundColor = Color(0xfff5f5f5);
  static const chartBackgroundColor = Color(0xfff8f8f8);
  static const chartHeadingColor = Color(0xff752262);
  static const chartHeadingBackgroundColor = Color(0xfff8f8f8);
  static const orangeColor = Color(0xfff07238);
  static const lightOrangeColor = Color(0xfff28e5f);
  static const sliderColor = Color(0xff9e9e9e);
  static const appBlueColor = Color(0xff39d1f8);

  static const primaryGradientColor1 = Color(0xff000046);
  static const primaryGradientColor2 = Color(0xff1cb5e0);

  static const secondaryGradientColor1 = Color(0xfff6f6f6);
  static const secondaryGradientColor2 = Color(0xffffffff);

  static const cardBackground = Color(0xffffffff);
  static const bannerColorLight = Color(0xff0063a2);
  static const bannerColorDark = Color(0xff00568c);
  static const warningBackground = Color(0xfff9f8e7);
  static const errorBackground = Color(0xffffdddd);

  static const primaryButtonTextColor = Color(0xffffffff);
  static const primaryTextColor = Color(0xff000000);

  static const bottomTabsBackground = Color(0xff1D63a2);
  static const bottomBarButtons = Color(0xffffffff);

  static const bottomSheetDragIndicator = Color(0xffdbdbe0);
  static const bottomSheetBackground = Color(0xfff9f9f9);
  static const bottomSheetItemDivider = Color(0xffffffff);

  static const icfrBackGroundRed = Color(0xffffdddd);
  static const icfrBackGroundYellow = Color(0xfff9fdd4);
  static const icfrBackGroundGreen = Color(0xffe0ffe6);

  static const textGreyTitle = Color(0xff757575);
  static const textGreySubTitle = Color(0xffbec2c5);
  static const menuItemColor = Color(0xff828a8e);
  static const popUpMenuColor = Color(0xffffffff);

  static const switchThumbColor = Color(0xffffffff);
  static const switchTrackActiveColor = Color(0xff1D63a2);
  static const switchTrackInActiveColor = Color(0xffbec2c5);

  static const lightRedColor = Color(0xfff5b1b0);
  static const lightGreenColor = Color(0xff90dc9e);
  static const lightYellowColor = Color(0xffe5de31);
  static const lightGreyColor = Color(0xffc9c9ce);
  static const lightBlackColor = Color(0xff3a3a3a);

  static const dullRedColor = Color(0xfffad7d7);
  static const dullGreenColor = Color(0xffc7edce);
  static const dullYellowColor = Color(0xfff2ee98);
  static const dullGreyColor = Color(0xffe4e4e6);
  static const dullBlackColor = Color(0xff616161);

  static const highRedColor = Color(0xfff15a28);

  static const infoSectionColor = Color(0xfff7f9ff);

  static const widgetBorderRedColor = Color(0xfffd2a2a);
  static const widgetBorderBlueColor = Color(0xff00c4ff);
  static const widgetBorderGreenColor = Color(0xff4bc35f);
  static const widgetBackgroundRedColor = Color(0xffffdfe0);
  static const widgetBackgroundBlueColor = Color(0xffe2f8ff);
  static const widgetBackgroundGreenColor = Color(0xffdef9e5);

  static const textSelectionColor = Color(0xff1cb5e0);
}
