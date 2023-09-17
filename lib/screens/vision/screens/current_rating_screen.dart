import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/screens/vision/screens/commitment_vision_screen.dart';
import 'package:brainfit/widget/widget.dart';

class CurrentRating extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String removeScreenUntil;

  const CurrentRating({
    Key? key,
    required this.createData,
    required this.removeScreenUntil,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<CurrentRating> createState() => _CurrentRatingState();
}

class _CurrentRatingState extends State<CurrentRating> {
  bool showLoader = false;
  List<dynamic> data = [];
  double _value = 5;
  Map<String, dynamic> createData = {};

  @override
  void initState() {
    createData = widget.createData;
    _value = createData["current_rating"]?.toDouble() ?? 5.0;
    createData["current_rating"] = _value.toInt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Opacity(
              opacity: showLoader ? 0.1 : 1,
              child: Container(
                padding: EdgeInsets.all(30.0),
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
                ),
                child: _displayContents(context),
              ),
            ),
            if (showLoader) ...[
              Center(child: AppCircularProgressIndicator()),
            ]
          ],
        ),
      ),
    );
  }

  Widget _displayContents(context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        StepProgressIndicator(
          totalSteps: 8,
          currentStep: 3,
          size: 5.5,
          selectedColor: Colors.white,
          unselectedColor: Colors.grey,
          roundedEdges: Radius.circular(10),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        BubbleNormal(
          text:
              'Where do you see this relationship right now on a scale of 1 to 10',
          isSender: false,
          color: Colors.white,
          tail: true,
          textStyle: Theme.of(context).textTheme.subtitle1!,
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      10,
                      (index) => Text(
                        "${index + 1}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Slider(
                        min: 1.0,
                        max: 10.0,
                        activeColor: LightAppColors.cardBackground,
                        thumbColor: visionColorGradient1,
                        inactiveColor:
                            LightAppColors.greyColor.withOpacity(0.2),
                        divisions: 10,
                        value: _value,
                        label: '${_value.round()}',
                        onChanged: (value) {
                          _value = value;
                          createData["current_rating"] = value.toInt();
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: 50.0,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Back',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(width: 30.0),
            Expanded(
              child: SizedBox(
                height: 50.0,
                child: OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommitmentScreen(
                        createData: createData,
                        isEditing: widget.isEditing,
                        removeScreenUntil: widget.removeScreenUntil,
                      ),
                      settings: RouteSettings(name: "E"),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
