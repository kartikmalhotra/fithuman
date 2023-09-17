import 'package:flutter/foundation.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool showLoader = true;
  bool deleteRemindarLoader = false;
  bool deleteEventLoader = false;

  List<dynamic> assessment = [];
  List<dynamic> visions = [];
  List<dynamic> events = [];
  List<dynamic> emotions = [];
  List<dynamic> emotionCheckIn = [];
  List<dynamic> lastTenEmotionCheckIn = [];
  List<dynamic> remindarList = [];
  Map<String, dynamic> chartData = {};

  Future<void> getData() async {
    showLoader = true;
    await getEmotionCheckIn();
    await getRemindarList();
    await getEvents();
    await getVisions();
    await getAssessments();
    await getEmotions();
    showLoader = false;
    notifyListeners();
  }

  Future<void> reloadEmotionCheckIn() async {
    showLoader = true;
    notifyListeners();
    await getEmotionCheckIn();
    showLoader = false;
    notifyListeners();
  }

  Future<void> reloadEmotionJournal() async {
    showLoader = true;
    notifyListeners();
    await getEmotionCheckIn();
    showLoader = false;
    notifyListeners();
  }

  Future<void> reloadEvents() async {
    showLoader = true;
    notifyListeners();
    await getEvents();
    showLoader = false;
    notifyListeners();
  }

  Future<void> reloadVisions() async {
    showLoader = true;
    notifyListeners();
    await getVisions();
    showLoader = false;
    notifyListeners();
  }

  Future<void> reloadVisionsAndEvents() async {
    showLoader = true;
    notifyListeners();
    await getVisions();
    await getEvents();
    showLoader = false;
    notifyListeners();
  }

  Future<void> reloadAssessmnets() async {
    showLoader = true;
    notifyListeners();
    await getAssessments();
    showLoader = false;
    notifyListeners();
  }

  Future<void> getEmotions() async {
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.emotions,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      emotions = response["data"];
    }

    if (kDebugMode) {
      print(response);
    }
  }

  Future<dynamic> getEmotionCheckIn() async {
    try {
      DateTime dateTime = DateTime.now();
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
      DateTime dayStartDateTime = dateTime;
      // DateTime weekStartDateTime = getDate(dayStartDateTime
      //     .subtract(Duration(days: dayStartDateTime.weekday - 1)));
      // DateTime weekEndDateTime = getDate(dayStartDateTime
      //     .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday)));
      chartData = {};
      var response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.emotionJournel,
          addAutherization: true,
          method: RestAPIRequestMethods.get);
      if (response['code'] == 200 || response['code'] == "200") {
        emotionCheckIn = (response["data"] as List);
        if (emotionCheckIn.length > 100) {
          emotionCheckIn = emotionCheckIn.sublist(0, 100);
        }

        lastTenEmotionCheckIn = emotionCheckIn;
        if (lastTenEmotionCheckIn.length > 10) {
          lastTenEmotionCheckIn = emotionCheckIn.sublist(0, 10);
        }

        emotionCheckIn.forEach((e) {
          if (chartData.containsKey(e["primary_emotion"]["name"])) {
            chartData[e["primary_emotion"]["name"]]++;
          } else {
            chartData[e["primary_emotion"]["name"]] = 1;
          }
          if (chartData.containsKey(e["secondary_emotion"]["name"])) {
            chartData[e["secondary_emotion"]["name"]]++;
          } else {
            chartData[e["secondary_emotion"]["name"]] = 1;
          }
        });
      }
    } catch (exe) {}
  }

  Future<dynamic> getEvents() async {
    try {
      DateTime dateTime = DateTime.now();
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
      DateTime dayStartDateTime = dateTime;
      DateTime weekStartDateTime = getDate(dayStartDateTime
          .subtract(Duration(days: dayStartDateTime.weekday - 1)));
      DateTime weekEndDateTime = getDate(dayStartDateTime
          .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday)));

      var response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.schedulers +
              "?start_datetime=${weekStartDateTime.toUtc().toIso8601String()}&end_datetime=${(weekEndDateTime.toUtc().toIso8601String())}",
          addAutherization: true,
          method: RestAPIRequestMethods.get);

      if (response['code'] == 200 || response['code'] == "200") {
        events = response["data"]?["listed_events"] ?? [];
      }
    } catch (exe) {}

    notifyListeners();
  }

  Future<dynamic> getVisions() async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.visionPlanner,
          addAutherization: true,
          method: RestAPIRequestMethods.get);
      if (response['code'] == 200 || response['code'] == "200") {
        visions = response["data"];
      }
    } catch (exe) {}
  }

  Future<dynamic> getAssessments() async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "api/assessments",
          addAutherization: true,
          method: RestAPIRequestMethods.get);
      if (response['code'] == 200 || response['code'] == "200") {
        assessment = response["data"];
        // if (assessment.length == 0) {
        //   Navigator.pushNamedAndRemoveUntil(
        //       context, AppRoutes.assessmentScreen, (route) => false);
        // }
      }
    } catch (exe) {
      if (kDebugMode) {
        print("Firebase Exeception $exe");
      }
    }
  }

  Future<dynamic> deleteEvent(String eventId) async {
    deleteEventLoader = true;
    notifyListeners();
    // / If image is picked from galley
    final response = await Application.restService?.requestCall(
        apiEndPoint: ApiRestEndPoints.schedulers,
        method: RestAPIRequestMethods.delete,
        requestParmas: {"event_id": eventId},
        addAutherization: true);

    deleteEventLoader = false;
    notifyListeners();
    if (kDebugMode) {
      print(response);
      await getEvents();
    }
  }

  Future<void> getRemindarList() async {
    final response = await Application.restService!.requestCall(
      apiEndPoint: ApiRestEndPoints.remindarNotification,
      method: RestAPIRequestMethods.get,
      addAutherization: true,
    );
    if (response["code"] == 200) {
      remindarList = response["data"] ?? [];
    }

    notifyListeners();
    return response;
  }

  Future<void> deleteReminder(String id) async {
    deleteRemindarLoader = true;
    notifyListeners();
    final response = await Application.restService!.requestCall(
      apiEndPoint: ApiRestEndPoints.remindarNotification,
      requestParmas: {'reminder_id': id},
      method: RestAPIRequestMethods.delete,
      addAutherization: true,
    );

    await getRemindarList();
    deleteRemindarLoader = false;
    notifyListeners();
    return response;
  }
}

DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
