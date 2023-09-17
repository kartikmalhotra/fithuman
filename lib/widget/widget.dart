import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/utils/utils.dart';

class AppMenuIcon extends StatelessWidget {
  const AppMenuIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 3.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          width: 20,
          height: 3.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5.0),
      ],
    );
  }
}

class AppCircularProgressIndicator extends StatelessWidget {
  final Color color;
  final double strokeWidth;
  final double? value;

  const AppCircularProgressIndicator({
    Key? key,
    this.color = Colors.black,
    this.strokeWidth = 4.0,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: color,
      strokeWidth: strokeWidth,
      value: value,
    );
  }
}

class AppSingleSelectChip extends StatefulWidget {
  final List<String> reportList;
  final String type;
  final Function(String)? onSelectionChanged;
  final Function(List<String>)? onMaxSelected;
  final Color selectedColor;
  final Function()? onPressed;
  final String? selectedValue;
  final int? maxSelection;
  final bool isEditable;
  final List<dynamic>? logoUrl;

  AppSingleSelectChip(
    this.reportList,
    this.type, {
    this.onSelectionChanged,
    this.selectedColor = LightAppColors.secondary,
    this.onMaxSelected,
    this.onPressed,
    this.maxSelection,
    this.selectedValue,
    this.isEditable = true,
    this.logoUrl,
  });

  @override
  _AppSingleSelectChipState createState() => _AppSingleSelectChipState();
}

class _AppSingleSelectChipState extends State<AppSingleSelectChip> {
  // String selectedChoice = "";
  String selectedValue = "";

  _buildChoiceList() {
    List<Widget> choices = [];

    for (int i = 0; i < widget.reportList.length; i++) {
      if (widget.reportList[i].isNotEmpty) {
        choices.add(Container(
          padding: const EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(widget.reportList[i]),
                    if (widget.logoUrl?[i] != null) ...[
                      SizedBox(width: 3.0),
                      Container(
                        height: 20.0,
                        width: 20.0,
                        child: CachedNetworkImage(
                            imageUrl: "https://api.thegrowthnetwork.com" +
                                widget.logoUrl![i]),
                      )
                    ],
                  ],
                ),
                backgroundColor: Colors.grey.withOpacity(0.05),
                selectedColor: Colors.black.withOpacity(0.8),
                labelStyle: TextStyle(
                    color: widget.selectedValue == widget.reportList[i]
                        ? Colors.white
                        : Colors.black),
                selected: widget.selectedValue == widget.reportList[i],
                onSelected: (selected) {
                  if (widget.isEditable) {
                    setState(() {
                      selectedValue = widget.reportList[i];
                      widget.onSelectionChanged?.call(selectedValue);
                    });
                  }
                },
              ),
            ],
          ),
        ));
      }
    }

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ..._buildChoiceList(),
      ],
    );
  }
}

class AppPrimarySecondarySelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(String, String) onSelectionChanged; // +added
  final String primaryValue;
  final String secondaryValue;
  final Color selectedColor;
  final bool isEditable;
  final List<dynamic>? logoUrl;
  final String maxSelectionWarning;

  AppPrimarySecondarySelectChip(
    this.reportList, {
    required this.onSelectionChanged,
    required this.maxSelectionWarning,
    this.selectedColor = LightAppColors.secondary,
    this.primaryValue = "",
    this.secondaryValue = "",
    this.isEditable = true,
    this.logoUrl,
  });
  @override
  _AppPrimarySecondarySelectChipState createState() =>
      _AppPrimarySecondarySelectChipState();
}

class _AppPrimarySecondarySelectChipState
    extends State<AppPrimarySecondarySelectChip> {
  // String selectedChoice = "";

  _buildChoiceList() {
    List<Widget> choices = [];
    for (int i = 0; i < widget.reportList.length; i++) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(widget.reportList[i]),
                  if (widget.reportList[i] == widget.primaryValue) ...[
                    SizedBox(width: 5.0),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(3.5),
                      child: Text(
                        "1",
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ] else if (widget.reportList[i] == widget.secondaryValue) ...[
                    SizedBox(width: 5.0),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: EdgeInsets.all(3.5),
                      child: Text(
                        "2",
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ],
                  // if (widget.logoUrl?[i] != null) ...[
                  //   SizedBox(width: 3.0),
                  //   Container(
                  //     height: 20.0,
                  //     width: 20.0,
                  //     child: CachedNetworkImage(
                  //         imageUrl: "https://api.thegrowthnetwork.com" +
                  //             widget.logoUrl![i]),
                  //   )
                  // ],
                ],
              ),
              selectedColor: widget.selectedColor,
              backgroundColor: Colors.grey.withOpacity(0.05),
              labelStyle: TextStyle(
                  color: widget.reportList[i] == widget.primaryValue ||
                          widget.reportList[i] == widget.secondaryValue
                      ? Colors.white
                      : Colors.black),
              selected: widget.reportList[i] == widget.primaryValue ||
                  widget.reportList[i] == widget.secondaryValue,
              onSelected: (selected) {
                if (widget.isEditable) {
                  if (widget.primaryValue.isEmpty) {
                    widget.onSelectionChanged(
                        widget.reportList[i], widget.secondaryValue);
                  } else if (widget.secondaryValue.isEmpty) {
                    widget.onSelectionChanged(
                        widget.primaryValue, widget.reportList[i]);
                  } else {
                    Utils.showSuccessToast(widget.maxSelectionWarning);
                  }
                }
              },
            ),
          ],
        ),
      ));
    }

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ..._buildChoiceList(),
      ],
    );
  }
}

class AppMultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged; // +added
  final List<String> selectedValue;
  final Color selectedColor;
  final bool isEditable;
  final List<dynamic>? logoUrl;

  AppMultiSelectChip(
    this.reportList, {
    required this.onSelectionChanged,
    this.selectedColor = LightAppColors.secondary,
    required this.selectedValue,
    this.isEditable = true,
    this.logoUrl,
  });
  @override
  _AppMultiSelectChipState createState() => _AppMultiSelectChipState();
}

class _AppMultiSelectChipState extends State<AppMultiSelectChip> {
  // String selectedChoice = "";

  _buildChoiceList() {
    List<Widget> choices = [];
    for (int i = 0; i < widget.reportList.length; i++) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(widget.reportList[i]),
                  if (widget.logoUrl?[i] != null) ...[
                    SizedBox(width: 3.0),
                    Container(
                      height: 20.0,
                      width: 20.0,
                      child: CachedNetworkImage(
                          imageUrl: "https://api.thegrowthnetwork.com" +
                              widget.logoUrl![i]),
                    )
                  ],
                ],
              ),
              selectedColor: widget.selectedColor,
              backgroundColor: Colors.grey.withOpacity(0.05),
              labelStyle: TextStyle(
                  color: widget.selectedValue.contains(widget.reportList[i])
                      ? Colors.white
                      : Colors.black),
              selected: widget.selectedValue.contains(widget.reportList[i]),
              onSelected: (selected) {
                if (widget.isEditable) {
                  setState(() {
                    widget.selectedValue.contains(widget.reportList[i])
                        ? widget.selectedValue.remove(widget.reportList[i])
                        : widget.selectedValue.add(widget.reportList[i]);
                    widget.onSelectionChanged(widget.selectedValue); // +added
                  });
                }
              },
            ),
          ],
        ),
      ));
    }

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ..._buildChoiceList(),
      ],
    );
  }
}

class AppAccordian extends StatefulWidget {
  /// An accordion is used to show (and hide) content. Use [showAccordion] to hide & show the accordion content.
  const AppAccordian(
      {Key? key,
      this.title,
      this.content,
      this.titleChild,
      this.contentChild,
      this.collapsedTitleBackgroundColor = Colors.white,
      this.expandedTitleBackgroundColor = const Color(0xFFE0E0E0),
      this.collapsedIcon = const Icon(Icons.keyboard_arrow_down,
          color: LightAppColors.blackColor),
      this.expandedIcon = const Icon(Icons.keyboard_arrow_up_outlined,
          color: LightAppColors.blackColor),
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

  /// child of  type [Widget]is alternative to title key. title will get priority over titleChild
  final Widget? titleChild;

  /// content of type[String] which shows the messages after the [AppAccordian] is expanded
  final Widget? content;

  /// contentChild of  type [Widget]is alternative to content key. content will get priority over contentChild
  final Widget? contentChild;

  /// type of [Color] or [GFColors] which is used to change the background color of the [AppAccordian] title when it is collapsed
  final Color collapsedTitleBackgroundColor;

  /// type of [Color] or [GFColors] which is used to change the background color of the [AppAccordian] title when it is expanded
  final Color expandedTitleBackgroundColor;

  /// collapsedIcon of type [Widget] which is used to show when the [AppAccordian] is collapsed
  final Widget collapsedIcon;

  /// expandedIcon of type[Widget] which is used when the [AppAccordian] is expanded
  final Widget expandedIcon;

  /// text of type [String] is alternative to child. text will get priority over titleChild
  final String? title;

  /// textStyle of type [textStyle] will be applicable to text only and not for the child
  final TextStyle textStyle;

  /// titlePadding of type [EdgeInsets] which is used to set the padding of the [AppAccordian] title
  final EdgeInsets titlePadding;

  /// descriptionPadding of type [EdgeInsets] which is used to set the padding of the [AppAccordian] description
  final EdgeInsets contentPadding;

  /// type of [Color] or [GFColors] which is used to change the background color of the [AppAccordian] description
  final Color? contentBackgroundColor;

  /// margin of type [EdgeInsets] which is used to set the margin of the [AppAccordian]
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
  _AppAccordianState createState() => _AppAccordianState();
}

class _AppAccordianState extends State<AppAccordian>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController controller;
  late Animation<Offset> offset;
  late bool showAccordion;

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
  Widget build(BuildContext context) => Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: _toggleCollapsed,
              borderRadius: widget.titleBorderRadius,
              child: Container(
                padding: widget.titlePadding,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: widget.title != null
                          ? Text(widget.title!, style: widget.textStyle)
                          : (widget.titleChild ?? Container()),
                    ),
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
                      child: widget.content != null
                          ? widget.content!
                          : (widget.contentChild ?? Container()),
                    ),
                  )
                : Container()
          ],
        ),
      );

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
