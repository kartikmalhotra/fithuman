import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class EventJournelScreen extends StatefulWidget {
  const EventJournelScreen({Key? key}) : super(key: key);

  @override
  State<EventJournelScreen> createState() => EventListingScreenState();
}

class EventListingScreenState extends State<EventJournelScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool toggleOff = true;
  bool showLoader = false;
  List<dynamic> eventJournal = [];
  final ScrollController _scrollController = ScrollController();

  DateTime dateTime = DateTime.now();
  // late DateTime dayStartDateTime;
  // late DateTime dayEndDateTime;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    dateTime = DateTime.now();
    dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
    // dayStartDateTime = dateTime;
    // dayEndDateTime =
    //     dateTime.add(Duration(hours: 23, minutes: 59, seconds: 59));

    super.initState();
    getData();
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  Future<void> getData() async {
    setState(() {
      showLoader = true;
    });

    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.emotionJournel,
          addAutherization: true,
          method: RestAPIRequestMethods.get);

      if (response['code'] == 200 || response['code'] == "200") {
        eventJournal = response["data"] ?? [];
        if (eventJournal.length > 2) {
          eventJournal.sort(((a, b) => DateTime.parse(b["created_at"])
              .compareTo(DateTime.parse(a["created_at"]))));
        }
        setState(() {});
      }
    } catch (exe) {}

    if (mounted) {
      setState(() {
        showLoader = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _displayAppBar(),
      body: Container(
        height: AppScreenConfig.safeBlockVertical! * 100,
        color: Colors.grey.withOpacity(0.005),
        child: Stack(
          children: <Widget>[
            Opacity(
              opacity: showLoader ? 0.01 : 1,
              child: _dailyEventList(),
            ),
            if (showLoader) ...[
              Center(
                child: AppCircularProgressIndicator(),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _dailyEventList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        eventJournal.length != 0
            ? Expanded(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: eventJournal.length,
                    itemBuilder: (context, index) {
                      return _showEventJournal(eventJournal[index]);
                    },
                  ),
                ),
              )
            : Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 100.0),
                    child: Text(
                      "No emotion check-in found",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Widget _showEventJournal(dynamic data) {
    if (data != null) {
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white,
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0)),
          width: double.maxFinite,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("How are you feeling?",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.grey)),
              SizedBox(height: 15.0),
              if (data["internal_conversation"] != null) ...[
                Text(
                  Utils.utf8convert(data["internal_conversation"].toString()),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.black),
                ),
              ],
              if (data["eventual_outcome"] != null) ...[
                SizedBox(height: 20.0),
                Text("What belief do you have ?",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.grey)),
                SizedBox(height: 15.0),
                Text(
                  Utils.utf8convert(data["eventual_outcome"]?.toString() ?? ""),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.black),
                ),
              ],
              SizedBox(height: 20.0),
              Wrap(
                runSpacing: 5.0,
                spacing: 5.0,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.1),
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            data["primary_relationship"]?["name"]?.toString() ??
                                "",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (data["secondary_relationship"] != null) ...[
                    SizedBox(width: 2.0),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.1),
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 3.5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              data["secondary_relationship"]?["name"]
                                      ?.toString() ??
                                  "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 20.0),
              Wrap(
                runSpacing: 5.0,
                spacing: 5.0,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.1),
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            Utils.utf8convert(data["primary_emotion"]?["name"]),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.black),
                          ),
                          SizedBox(width: 5.0),
                          CachedNetworkImage(
                            imageUrl: "https://api.thegrowthnetwork.com" +
                                data["primary_emotion"]["logo"],
                            height: 15.0,
                            width: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 2.0),
                  if (data?["secondary_emotion"]?["logo"] != null) ...[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.1),
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 3.5),
                        child: Wrap(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  data?["secondary_emotion"]?["name"] ?? "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(color: Colors.black),
                                ),
                                SizedBox(width: 5.0),
                                Image.network(
                                  "https://api.thegrowthnetwork.com" +
                                      data?["secondary_emotion"]?["logo"],
                                  height: 15.0,
                                  width: 15.0,
                                  errorBuilder: ((context, error, stackTrace) {
                                    return Container();
                                  }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: 20.0),
              Text(
                  "${DateFormat.yMMMMd('en_US').add_jm().format(DateTime.parse(data["created_at"].toString()))}")
            ],
          ),
        ),
      );
    }
    return Container();
  }

  AppBar _displayAppBar() {
    return AppBar(
      elevation: 1.0,
      backgroundColor: Colors.black.withOpacity(0.8),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "Emotion Journal",
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.white),
      ),
      // actions: [
      //   Row(
      //     children: <Widget>[
      //       Text("Compact",
      //           style: Theme.of(context)
      //               .textTheme
      //               .bodyText1!
      //               .copyWith(color: Colors.black)),
      //       IconButton(
      //         constraints: BoxConstraints(),
      //         padding: EdgeInsets.symmetric(horizontal: 13.0),
      //         onPressed: () {
      //           toggleOff = !toggleOff;
      //           setState(() {});
      //         },
      //         icon: Icon(
      //           toggleOff ? Icons.toggle_off : Icons.toggle_on,
      //           size: 30,
      //           color: Colors.black,
      //         ),
      //       ),
      //       Text("List",
      //           style: Theme.of(context)
      //               .textTheme
      //               .bodyText1!
      //               .copyWith(color: Colors.black)),
      //       SizedBox(width: 10.0)
      //     ],
      //   )
      // ],
    );
  }
}
