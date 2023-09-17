import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/provider/home_screen_povider.dart';

import 'package:brainfit/screens/emotion_journal/emotion_checkin_screen.dart';
import 'package:brainfit/screens/emotion_journal/emotion_journal_conversation.dart';
import 'package:brainfit/screens/event_schedular/screens/event_summary_screen.dart';
import 'package:brainfit/screens/home/screens/emotion_checkin_chart_report.dart';
import 'package:brainfit/screens/home/screens/reminder_accordian.dart';
import 'package:brainfit/screens/home/screens/pie_chart_home.dart';

import 'package:brainfit/screens/vision/screens/vision_create.dart';
import 'package:brainfit/shared/bloc/profile/profile_bloc.dart';
import 'package:brainfit/utils/greetings.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? fcmToken;

  final ScrollController _visionScrollController = ScrollController();
  final ScrollController _calendarScrollController = ScrollController();

  int _currentPage = 0;
  int _eventCurrentPage = 0;

  bool _showAccordian = false;

  final PageController _pageController = PageController();
  final PageController _eventPageController = PageController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context).add(GetUserProfile());
    _currentPage = 0;
    _eventCurrentPage = 0;

    super.initState();

    _firebaseMessagingFunction();
    getData();
  }

  Future<void> getData() async {
    await context.read<HomeScreenProvider>().getData();
  }

  @override
  Widget build(BuildContext context) {
    AppScreenConfig.init(context);
    return Scaffold(
      body: Container(
        color: Colors.grey.withOpacity(0.01),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Consumer(
          builder: (_, HomeScreenProvider cameraScreenProvider, __) {
            return Stack(
              children: <Widget>[
                if (!context.read<HomeScreenProvider>().showLoader) ...[
                  Opacity(
                    opacity: context.read<HomeScreenProvider>().showLoader
                        ? 0.01
                        : 1,
                    child: _displayContents(),
                  ),
                ],
                if (context.read<HomeScreenProvider>().showLoader) ...[
                  Center(child: AppCircularProgressIndicator()),
                ]
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _displayContents() {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: () async {
        await getData();
      },
      child: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          _displayAppBar(),
          SizedBox(height: 20.0),
          Wrap(
            children: <Widget>[
              Text(greeting() + ", ",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.black87)),
              BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: ((previous, current) =>
                    current is ProfileLoadedState || current is ProfileLoader),
                builder: (context, state) {
                  if (state is ProfileLoadedState &&
                      state.data?["profile"]["name"] != null) {
                    return Text(state.data?["profile"]["name"] + " 👋",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Colors.black87));
                  }
                  return Container();
                },
              ),
            ],
          ),
          SizedBox(height: 20.0),
          if (context.read<HomeScreenProvider>().emotionCheckIn.isEmpty) ...[
            _createEmotionJournal(),
          ] else ...[
            _displayEmotionJournal(),
          ],
          if (context.read<HomeScreenProvider>().events.isNotEmpty) ...[
            SizedBox(height: 20.0),
            _displayListOfEvents(),
          ] else ...[
            // _createEventCard(),
          ],
          SizedBox(height: 20.0),
          if (context.read<HomeScreenProvider>().visions.isEmpty) ...[
            _createVisionCard(),
          ] else ...[
            _displayListOfVisions()
          ],
          SizedBox(height: 20.0),
          ReminderAccordian(
            showAccordion: _showAccordian,
            onToggleCollapsed: (toggle) {
              setState(() {
                _showAccordian = toggle;
              });
            },
          ),
          SizedBox(height: 20.0),
          if (context.read<HomeScreenProvider>().assessment.isNotEmpty) ...[
            _showAssessmentCard(
                context.read<HomeScreenProvider>().assessment.first)
          ],
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _createEventCard() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Container(),
          ),
        );
      },
      child: Container(
        height: AppScreenConfig.safeBlockVertical! * 30,
        decoration: BoxDecoration(
          color: emotionColor,
          // gradient: const LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   stops: [0.0, 1.0],
          //   colors: [
          //     Color(0xFF8E2DEE),
          //     LightAppColors.secondary,
          //   ],
          // ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(40.0),
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Create a ",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black)),
            Text("Event",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black))
          ],
        ),
      ),
    );
  }

  Widget _createVisionCard() {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VisionCreateScreen(),
          ),
        );
        await context.read<HomeScreenProvider>().reloadVisions();
      },
      child: Container(
        height: AppScreenConfig.safeBlockVertical! * 30,
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
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(40.0),
        width: double.maxFinite,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Create a ",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black)),
            Text("Vision",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.black))
          ],
        ),
      ),
    );
  }

  Widget _createEmotionJournal() {
    return InkWell(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EmotionJournalConversationText(createData: {}),
          ),
        );
        await context.read<HomeScreenProvider>().reloadEmotionJournal();
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        color: Colors.white,
        child: Container(
          height: AppScreenConfig.safeBlockVertical! * 40,
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Emotion",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.black)),
              Text("Check-in",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayEmotionJournal() {
    return Container(
      height: AppScreenConfig.safeBlockVertical! * 40,
      width: double.maxFinite,
      child: EmotionCheckInChartReport(
        chartData: context.read<HomeScreenProvider>().chartData,
        lastTenEmotionsData:
            context.read<HomeScreenProvider>().lastTenEmotionCheckIn,
      ),
    );
  }

  Widget _displayListOfVisions() {
    return Container(
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
        borderRadius: BorderRadius.circular(30.0),
      ),
      width: double.maxFinite,
      height: AppScreenConfig.safeBlockVertical! * 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            child: Row(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Visions ",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VisionCreateScreen()),
                    );
                  },
                  child: Text(
                    "Create",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .copyWith(color: Colors.grey[900]),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: context.read<HomeScreenProvider>().visions.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    await Navigator.pushNamed(
                        context, AppRoutes.visionDetailScreen, arguments: {
                      "vision_id": context
                          .read<HomeScreenProvider>()
                          .visions[index]["id"]
                    });
                    if (mounted) {
                      await context
                          .read<HomeScreenProvider>()
                          .reloadVisionsAndEvents();
                    }
                  },
                  child: _visionCardInfo(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _visionChangeArrow(DateTime dateTime) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              _currentPage--;
              if (_currentPage <= 0) {
                _pageController.animateToPage(_currentPage,
                    duration: Duration(milliseconds: 500), curve: Curves.ease);
              }
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: 15,
              color: Colors.black,
            ),
          ),
          Spacer(),
          Text("${DateFormat.yMMMMd('en_US').add_jm().format(dateTime)}",
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.black)),
          Spacer(),
          InkWell(
            onTap: () {
              _currentPage++;
              _pageController.animateToPage(_currentPage,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayListOfEvents() {
    return Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: emotionColor,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.5, 1.0],
          colors: [
            commitmentColorGradient1,
            commitmentColorGradient2,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Commitments ",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Spacer(),
              OutlinedButton(
                onPressed: () async {
                  await Navigator.pushNamed(
                      context, AppRoutes.eventsListScreen);
                  await context.read<HomeScreenProvider>().getEvents();
                },
                child: Text(
                  "Show All",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Colors.grey[900]),
                ),
              )
            ],
          ),
          SizedBox(height: 10.0),
          Container(
            height: AppScreenConfig.safeBlockVertical! * 40,
            child: context.read<HomeScreenProvider>().deleteEventLoader
                ? Center(
                    child: AppCircularProgressIndicator(color: Colors.white))
                : PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _eventPageController,
                    itemCount: context.read<HomeScreenProvider>().events.length,
                    itemBuilder: (context, index) {
                      return _eventCardInfo(index);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _eventChangeArrow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: () {
            _eventCurrentPage--;
            if (_eventCurrentPage != -1) {
              _eventPageController.animateToPage(_eventCurrentPage,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios,
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _eventCurrentPage++;
            _eventPageController.animateToPage(_eventCurrentPage,
                duration: Duration(milliseconds: 500), curve: Curves.ease);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _visionCardInfo(int index) {
    List<dynamic> visions = context.read<HomeScreenProvider>().visions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: constraints.maxHeight,
                  child: Scrollbar(
                    controller: _visionScrollController,
                    child: ListView(
                      controller: _visionScrollController,
                      children: [
                        Wrap(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 0.5),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 3.5),
                                child: Text(
                                  "${Utils.utf8convert(visions[index]?["primary_relationship"]?["name"] ?? "")}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ),
                            if (visions[index]?["secondary_relationship"] !=
                                null) ...[
                              SizedBox(width: 10.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(width: 0.5),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 3.5),
                                    child: Text(
                                      "${Utils.utf8convert(visions[index]?["secondary_relationship"]?["name"] ?? "")}",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1!
                                          .copyWith(color: Colors.black),
                                    )),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          "Current rating is ${visions[index]["current_rating"].toString()}/10",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 15.0),
                        Wrap(
                          runSpacing: 5.0,
                          spacing: 5.0,
                          children: [
                            for (int i = 0;
                                i < (visions[index]["emotions"]?.length ?? 0);
                                i++) ...[
                              Container(
                                decoration: BoxDecoration(
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
                                        Utils.utf8convert(visions[index]
                                            ["emotions"][i]["name"]),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(color: Colors.black),
                                      ),
                                      SizedBox(width: 5.0),
                                      CachedNetworkImage(
                                        imageUrl:
                                            "https://api.thegrowthnetwork.com" +
                                                visions[index]["emotions"][i]
                                                    ["logo"],
                                        height: 15.0,
                                        width: 15.0,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ]
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 8.0),
          _visionChangeArrow(DateTime.parse(visions[index]["created_at"])),
        ],
      ),
    );
  }

  Widget _eventCardInfo(int index) {
    List<dynamic> events = context.read<HomeScreenProvider>().events;
    RouteSettings? route = ModalRoute.of(context)?.settings;

    DateTime _startDate =
        DateTime.parse(events[index]["start_datetime"]).toLocal();
    DateTime _endDate = DateTime.parse(events[index]["end_datetime"]).toLocal();

    return InkWell(
      onTap: () async {
        await Navigator.pushNamed(context, AppRoutes.eventDetailScreen,
            arguments: {"event_id": events[index]["id"]});
        await context.read<HomeScreenProvider>().reloadEvents();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              OutlinedButton(
                onPressed: () {
                  final Event event = Event(
                    title: events[index]["title"],
                    description: events[index]["description"],
                    location: events[index]["location"],
                    recurrence: Recurrence(
                        frequency: Utils.calculateFrequency(
                            events[index]["frequency"]),
                        endDate: DateTime.parse(events[index]["end_datetime"])
                            .toLocal()),
                    startDate: DateTime.parse(events[index]["start_datetime"])
                        .toLocal(),
                    endDate: DateTime.parse(events[index]["start_datetime"])
                        .toLocal()
                        .add(Duration(
                            seconds: double.parse(
                                    events[index]["duration"].toString())
                                .toInt())),
                    iosParams: IOSParams(
                      reminder: Duration(
                          seconds:
                              double.parse(events[index]["duration"].toString())
                                  .toInt()),
                    ),
                    androidParams: AndroidParams(
                      emailInvites: [], // on Android, you can add invite emails to your event.
                    ),
                  );

                  Add2Calendar.addEvent2Cal(event);
                },
                child: Text(
                  "Add to Calendar",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.black),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () async {
                  Map<String, dynamic> createData = {
                    "event_id": events[index]["id"],
                    "created_at": events[index]["created_at"],
                    "title": events[index]["title"],
                    "description": events[index]["description"],
                    "location": events[index]["location"],
                    "start_datetime": events[index]["start_datetime"],
                    "end_datetime": events[index]["end_datetime"],
                    "duration": events[index]["duration"],
                    "recurring": events[index]["recurring"],
                    "frequency": events[index]["frequency"],
                    "vision_id": events[index]["vision_id"],
                  };

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      settings: RouteSettings(name: "EA"),
                      builder: (context) => EventSummaryScreen(
                          route: AppRoutes.home,
                          createData: createData,
                          isEditing: true),
                    ),
                  );
                  await getData();
                },
                child: Icon(Icons.edit, color: Colors.white),
              ),
              SizedBox(width: 20.0),
              InkWell(
                onTap: () => context
                    .read<HomeScreenProvider>()
                    .deleteEvent(events[index]["id"]),
                child: Icon(Icons.delete_outline, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
          Text(
            Utils.utf8convert(events[index]["title"].toString()),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            Utils.utf8convert(events[index]["description"].toString()),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.start,
            alignment: WrapAlignment.start,
            children: <Widget>[
              Text(
                "📍",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
              SizedBox(width: 5.0),
              Text(
                Utils.utf8convert(events[index]["location"].toString()),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w400),
              ),
            ],
          ),
          SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: <Widget>[
              Text(
                "📅",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
              SizedBox(width: 5.0),
              Text(
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white, fontSize: 12),
                  "${DateFormat.yMMMd().format(_startDate).toString()} (${_startDate.getMonthString().toString()})"),
              if (events[index]["recurring"] ?? false) ...[
                Text(
                  "- ${DateFormat.yMMMd().format(_endDate).toString()} (${_endDate.getMonthString().toString()})",
                  style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white, fontSize: 12),
                ),
              ],
              SizedBox(width: 5.0),
              if (events[index]["recurring"] ?? false) ...[
                Image.asset(
                  "assets/images/refresh.png",
                  width: 15.0,
                  height: 15.0,
                  color: Colors.white,
                ),
              ],
            ],
          ),
          SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            children: <Widget>[
              Text(
                "🕑",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
              SizedBox(width: 5.0),
              Text(
                "${DateFormat.jm().format(_startDate).toString()}" +
                    "-" +
                    "${DateFormat.jm().format(DateTime.parse(events[index]["start_datetime"]).toLocal().add(Duration(seconds: double.parse(events[index]["duration"].toString()).toInt()))).toString()}",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
          Spacer(),
          _eventChangeArrow(),
        ],
      ),
    );
  }

  Widget _showAssessmentCard(Map<String, dynamic> data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      color: Colors.white,
      child: Container(
        height: AppScreenConfig.safeBlockVertical! * 55,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Assessment",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      await Navigator.pushNamed(
                          context, AppRoutes.assessmentListScreen);
                      await context
                          .read<HomeScreenProvider>()
                          .reloadAssessmnets();
                    },
                    child: Text("Show All",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(color: Colors.grey[800])),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                height: double.maxFinite,
                // height: AppScreenConfig.safeBlockVertical! * 55,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: HomePieChartCard(assessmentResult: data),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayAppBar() {
    return Padding(
      padding: EdgeInsets.only(top: 60.0, bottom: 10.0),
      child: Align(
        alignment: Alignment.topRight,
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.profileScreen);
          },
          child: Text(
            "Profile",
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  void _firebaseMessagingFunction() {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token is " + (token ?? ""));
      fcmToken = token;
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Firebase onMessage: $message");
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmotionCheckinScreen(),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print(message);
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmotionCheckinScreen(),
          ),
        );
      }
    });
  }
}
