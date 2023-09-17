import 'package:flutter/material.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/screens/event_schedular/screens/event_title.dart';

class EventCreateScreen extends StatelessWidget {
  final String visionId;

  const EventCreateScreen({Key? key, required this.visionId}) : super(key: key);

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
        Card(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('Create your commitment ',
                style: Theme.of(context).textTheme.headline6),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 50,
            width: double.maxFinite,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(LightAppColors.secondary),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventTitleScreen(
                    createData: {"vision_id": visionId},
                  ),
                ),
              ),
              child: Text(
                'Create',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        )
      ],
    );
  }
}
