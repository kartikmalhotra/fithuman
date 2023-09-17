import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/vision/screens/imortance_text_vision.dart';
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class CommitmentScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final String removeScreenUntil;
  final bool isEditing;

  const CommitmentScreen(
      {Key? key,
      required this.createData,
      required this.removeScreenUntil,
      this.isEditing = false})
      : super(key: key);

  @override
  State<CommitmentScreen> createState() => _VisionRelationshipState();
}

class _VisionRelationshipState extends State<CommitmentScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  bool editRelationship = false;
  Map<String, dynamic> createData = {};
  TextEditingController _addRelationshipController = TextEditingController();

  @override
  void initState() {
    createData = widget.createData;
    if (createData["commitment"] != null) {
      createData["commitment"] = createData["commitment"];
    }

    super.initState();
    _fetchRelationships();
  }

  void _fetchRelationships() async {
    showLoader = true;
    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.commitments,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response["code"] == "200" || response["code"] == 200) {
      data = response["data"];
    }

    if (kDebugMode) {
      print(response);
    }

    setState(() {
      showLoader = false;
    });
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
                color: visionColor.withOpacity(0.9),
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
          currentStep: 4,
          size: 5.5,
          selectedColor: Colors.white,
          unselectedColor: Colors.grey,
          roundedEdges: Radius.circular(10),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        BubbleNormal(
          text: 'You are committed to building a relationship of',
          isSender: false,
          color: Colors.white,
          tail: true,
          textStyle: Theme.of(context).textTheme.subtitle1!,
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        if (data.isNotEmpty) ...[
          AppSingleSelectChip(
            data.map((e) => e["name"]).toList().cast<String>(),
            "commitments",
            selectedValue: createData["commitment"] ?? "",
            selectedColor: Colors.black87,
            onSelectionChanged: (value) {
              createData["commitment"] = value;
              setState(() {});
            },
          ),
        ] else ...[
          Text(
            "Hey looks like no commitments are present",
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
          )
        ],
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 8),
        Row(
          children: <Widget>[
            OutlinedButton(
              onPressed: () {
                setState(() {
                  createData["commitment"] = null;
                });
              },
              child: Text("Clear All",
                  style: Theme.of(context).textTheme.bodyText1),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
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
              child: Container(
                height: 50.0,
                child: OutlinedButton(
                  onPressed: () {
                    if (createData["commitment"] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImportanceTextScreen(
                              removeScreenUntil: widget.removeScreenUntil,
                              createData: createData,
                              isEditing: widget.isEditing),
                          settings: RouteSettings(name: "F"),
                        ),
                      );
                    } else {
                      Utils.showSuccessToast("Please select a commitment");
                    }
                  },
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
