import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/main.dart';
import 'package:brainfit/provider/home_screen_povider.dart';
import 'package:brainfit/screens/check_in_remindar/screens/check_in_remindar.dart';
import 'package:brainfit/widget/widget.dart';

class ReminderAccordian extends StatefulWidget {
  /// An accordion is used to show (and hide) content. Use [showAccordion] to hide & show the accordion content.
  const ReminderAccordian(
      {Key? key,
      this.title,
      this.collapsedTitleBackgroundColor = Colors.white,
      this.expandedTitleBackgroundColor = const Color(0xFFE0E0E0),
      this.collapsedIcon = const Icon(Icons.keyboard_arrow_down,
          color: LightAppColors.cardBackground),
      this.expandedIcon = const Icon(Icons.keyboard_arrow_up_outlined,
          color: LightAppColors.cardBackground),
      this.textStyle = const TextStyle(color: Colors.black, fontSize: 16),
      this.titlePadding = const EdgeInsets.all(10),
      this.contentBackgroundColor,
      this.contentPadding = const EdgeInsets.all(10),
      this.titleBorder = const Border(),
      this.contentBorder = const Border(),
      this.margin,
      this.showAccordion = false,
      this.onToggleCollapsed,
      this.titleBorderRadius = const BorderRadius.all(Radius.circular(0)),
      this.contentBorderRadius = const BorderRadius.all(Radius.circular(0))})
      : super(key: key);

  /// controls if the accordion should be collapsed or not making it possible to be controlled from outside
  final bool showAccordion;

  /// type of [Color] or [GFColors] which is used to change the background color of the [ReminderAccordian] title when it is collapsed
  final Color collapsedTitleBackgroundColor;

  /// type of [Color] or [GFColors] which is used to change the background color of the [ReminderAccordian] title when it is expanded
  final Color expandedTitleBackgroundColor;

  /// collapsedIcon of type [Widget] which is used to show when the [ReminderAccordian] is collapsed
  final Widget collapsedIcon;

  /// expandedIcon of type[Widget] which is used when the [ReminderAccordian] is expanded
  final Widget expandedIcon;

  /// text of type [String] is alternative to child. text will get priority over titleChild
  final String? title;

  /// textStyle of type [textStyle] will be applicable to text only and not for the child
  final TextStyle textStyle;

  /// titlePadding of type [EdgeInsets] which is used to set the padding of the [ReminderAccordian] title
  final EdgeInsets titlePadding;

  /// descriptionPadding of type [EdgeInsets] which is used to set the padding of the [ReminderAccordian] description
  final EdgeInsets contentPadding;

  /// type of [Color] or [GFColors] which is used to change the background color of the [ReminderAccordian] description
  final Color? contentBackgroundColor;

  /// margin of type [EdgeInsets] which is used to set the margin of the [ReminderAccordian]
  final EdgeInsets? margin;

  /// titleBorderColor of type  [Color] or [GFColors] which is used to change the border color of title
  final Border titleBorder;

  /// contentBorderColor of type  [Color] or [GFColors] which is used to change the border color of content
  final Border contentBorder;

  /// titleBorderRadius of type  [Radius]  which is used to change the border radius of title
  final BorderRadius titleBorderRadius;

  /// contentBorderRadius of type  [Radius]  which is used to change the border radius of content
  final BorderRadius contentBorderRadius;

  /// function called when the content body collapsed
  final Function(bool)? onToggleCollapsed;

  @override
  _ReminderAccordianState createState() => _ReminderAccordianState();
}

class _ReminderAccordianState extends State<ReminderAccordian>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController controller;
  late Animation<Offset> offset;
  late bool showAccordion;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    showAccordion = widget.showAccordion;
    animationController =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    offset = Tween(
      begin: const Offset(0, -0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: LightAppColors.secondary.withOpacity(0.6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: _toggleCollapsed,
            borderRadius: widget.titleBorderRadius,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Check-in Reminders',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.white)),
                  showAccordion ? widget.expandedIcon : widget.collapsedIcon
                ],
              ),
            ),
          ),
          showAccordion
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: widget.contentBorderRadius,
                    border: widget.contentBorder,
                    color: widget.contentBackgroundColor ?? Colors.white70,
                  ),
                  width: MediaQuery.of(context).size.width,
                  padding: widget.contentPadding,
                  child: SlideTransition(
                    position: offset,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      height: AppScreenConfig.safeBlockVertical! * 30,
                      child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: LayoutBuilder(
                                  builder: ((context, constraints) {
                                    if (App.globalContext
                                        .read<HomeScreenProvider>()
                                        .deleteRemindarLoader) {
                                      return Center(
                                        child: AppCircularProgressIndicator(
                                          color: LightAppColors.blackColor,
                                        ),
                                      );
                                    }
                                    return Container(
                                      height: constraints.maxHeight,
                                      child:
                                          App.globalContext
                                                  .read<HomeScreenProvider>()
                                                  .remindarList
                                                  .isEmpty
                                              ? Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Text(
                                                        "You have no check-in reminders",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1!
                                                            .copyWith(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          OutlinedButton(
                                                            onPressed:
                                                                () async {
                                                              await Navigator
                                                                  .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            CheckInRemindarScreen()),
                                                              );
                                                              await context
                                                                  .read<
                                                                      HomeScreenProvider>()
                                                                  .getRemindarList();
                                                            },
                                                            child: Text(
                                                              "Create Reminder",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .black87),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : Scrollbar(
                                                  controller: _scrollController,
                                                  child: Column(
                                                    children: <Widget>[
                                                      if (context
                                                              .read<
                                                                  HomeScreenProvider>()
                                                              .remindarList
                                                              .length ==
                                                          0) ...[
                                                        InkWell(
                                                            onTap: () async {
                                                              await Navigator
                                                                  .push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          CheckInRemindarScreen(),
                                                                ),
                                                              );
                                                              await App
                                                                  .globalContext
                                                                  .read<
                                                                      HomeScreenProvider>()
                                                                  .getRemindarList();
                                                            },
                                                            child: Card(
                                                              child: Container(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10.0,
                                                                      vertical:
                                                                          10.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          "Create",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText1!
                                                                              .copyWith(color: LightAppColors.secondary.withOpacity(0.6)))
                                                                    ],
                                                                  )),
                                                            )),
                                                      ],
                                                      Expanded(
                                                        child: ListView.builder(
                                                          controller:
                                                              _scrollController,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  0.0),
                                                          itemCount: context
                                                              .read<
                                                                  HomeScreenProvider>()
                                                              .remindarList
                                                              .length,
                                                          itemBuilder:
                                                              ((context,
                                                                  index) {
                                                            return Column(
                                                              children: <Widget>[
                                                                if (index ==
                                                                    0) ...[
                                                                  InkWell(
                                                                    onTap:
                                                                        () async {
                                                                      await Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              CheckInRemindarScreen(),
                                                                        ),
                                                                      );
                                                                      await App
                                                                          .globalContext
                                                                          .read<
                                                                              HomeScreenProvider>()
                                                                          .getRemindarList();
                                                                    },
                                                                    child: Card(
                                                                      child:
                                                                          Container(
                                                                        padding: EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                10.0,
                                                                            vertical:
                                                                                10.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              "Create",
                                                                              style: Theme.of(context).textTheme.bodyText1!.copyWith(color: LightAppColors.secondary.withOpacity(0.6)),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                                Card(
                                                                  child:
                                                                      Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            10.0,
                                                                        vertical:
                                                                            10.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Text(
                                                                            DateFormat.jm().format(DateFormat("hh:mm:ss").parse(context.read<HomeScreenProvider>().remindarList[index][
                                                                                "time"])),
                                                                            style:
                                                                                Theme.of(context).textTheme.caption!),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            context.read<HomeScreenProvider>().deleteReminder(context.read<HomeScreenProvider>().remindarList[index]["id"]);
                                                                          },
                                                                          child: Icon(
                                                                              Icons.delete_outline_rounded,
                                                                              color: LightAppColors.greyColor),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                    );
                                  }),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void _toggleCollapsed() {
    setState(() {
      switch (controller.status) {
        case AnimationStatus.completed:
          controller.forward(from: 0);
          break;
        case AnimationStatus.dismissed:
          controller.forward();
          break;
        default:
      }
      showAccordion = !showAccordion;
      if (widget.onToggleCollapsed != null) {
        widget.onToggleCollapsed!(showAccordion);
      }
    });
  }
}
