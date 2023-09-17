import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/screens/event_schedular/screens/event_title.dart';

class EventCreateScreen extends StatelessWidget {
  final String? route;
  final Map<String, dynamic> createData;

  const EventCreateScreen({
    Key? key,
    required this.createData,
    this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.0),
        color: Colors.white,
        child: _displayContents(context),
      ),
    );
  }

  Widget _displayContents(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        BubbleNormal(
          text: 'We will ask you some questions to create an commitment',
          isSender: false,
          color: commitmentColor,
          tail: true,
          textStyle: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.white),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(commitmentColor)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EventTitleScreen(createData: createData, route: route),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: Text(
                  'Create',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
