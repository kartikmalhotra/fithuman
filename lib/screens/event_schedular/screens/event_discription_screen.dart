import 'package:flutter/material.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';

import 'package:brainfit/screens/event_schedular/screens/event_recurring.dart';
import 'package:brainfit/utils/utils.dart';

import 'package:brainfit/widget/widget.dart';

class EventDiscriptionScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String? route;

  const EventDiscriptionScreen({
    Key? key,
    required this.createData,
    required this.isEditing,
    this.route,
  }) : super(key: key);

  @override
  State<EventDiscriptionScreen> createState() => _EventDiscriptionScreenState();
}

class _EventDiscriptionScreenState extends State<EventDiscriptionScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  double _value = 5;
  Map<String, dynamic> createData = {};
  final TextEditingController _importantTextController =
      TextEditingController();

  @override
  void initState() {
    createData = widget.createData;
    if (createData["description"] != null) {
      _importantTextController.text =
          Utils.utf8convert(createData["description"]);
    }
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
                color: commitmentColor.withOpacity(0.7),
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
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Card(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Any additional details?',
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextFormField(
            controller: _importantTextController,
            maxLines: 4,
            cursorColor: LightAppColors.appBlueColor,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w700),
            maxLength: 500,
            decoration: InputDecoration(
              filled: true,
              hintMaxLines: 3,

              fillColor: LightAppColors.cardBackground,
              // prefixIcon: Icon(Icons.mail, color: Colors.grey),

              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
              labelStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w700),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),

              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
            validator: (String? text) {
              if (text?.isEmpty ?? true) {
                return "Enter commitment description";
              }
              return null;
            },
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                height: 50.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        LightAppColors.cardBackground),
                  ),
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
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        LightAppColors.cardBackground),
                  ),
                  onPressed: () {
                    createData["description"] = _importantTextController.text;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: RouteSettings(name: "EC"),
                        builder: (context) => EventRecurringScreen(
                            createData: createData,
                            route: widget.route,
                            isEditing: widget.isEditing),
                      ),
                    );
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
        )
      ],
    );
  }
}
