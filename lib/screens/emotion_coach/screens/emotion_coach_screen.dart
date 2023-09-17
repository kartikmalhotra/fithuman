import 'package:flutter/material.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/home/screens/home_screen.dart';
import 'package:brainfit/screens/vision/screens/conversation_text.dart';
import 'package:brainfit/utils/utils.dart';

class EmotionCoachScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  EmotionCoachScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<EmotionCoachScreen> createState() => _EmotionCoachScreenState();
}

class _EmotionCoachScreenState extends State<EmotionCoachScreen> {
  List<dynamic> visions = [];
  bool showLoader = false;

  @override
  void initState() {
    super.initState();
    getAllVisionsForRelationship();
  }

  Future<void> getAllVisionsForRelationship() async {
    try {
      setState(() {
        showLoader = true;
      });
      var response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.visionPlanner +
              "?relationship_id=${widget.data["relationship_id"]}",
          addAutherization: true,
          method: RestAPIRequestMethods.get);
      if (response['code'] == 200 || response['code'] == "200") {
        visions = response["data"];
      }
      setState(() {
        showLoader = false;
      });
    } catch (exe) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: AppScreenConfig.safeBlockHorizontal! * 100,
        height: AppScreenConfig.safeBlockVertical! * 100,
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                    onPressed: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                      await getAllVisionsForRelationship();
                    },
                    icon: Icon(Icons.cancel_outlined, color: Colors.black))
              ],
            ),
            SizedBox(height: AppScreenConfig.safeBlockVertical! * 2),
            Text(
                "Hey looks like you have following visions with the same relationship",
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemCount: visions.length,
              itemBuilder: (context, index) {
                return _showVisionDetail(visions[index]);
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _showVisionDetail(dynamic vision) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () async {
                      Map<String, dynamic> createData = {
                        "vision_id": vision["id"],
                        "relationship": vision["relationship"]["name"],
                        "current_rating": vision["current_rating"],
                        "conversation_with_self":
                            vision["conversation_with_self"],
                        "importance_text": vision["importance"],
                        "price": vision["price"]["name"],
                        "get_to_be": vision["get_to_be"]["name"],
                        "emotions": vision["emotions"]
                            .map((e) => e["name"])
                            .toList()
                            .cast<String>(),
                        "commitment": vision["commitment"]["name"]
                      };

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: RouteSettings(name: "A"),
                          builder: (context) => ConversationText(
                              removeScreenUntil: 'EC',
                              createData: createData,
                              isEditing: true),
                        ),
                      );
                      // await getData();
                    },
                    child: Icon(Icons.edit, color: LightAppColors.blackColor)),
              ],
            ),
            SizedBox(height: AppScreenConfig.safeBlockVertical! * 6),
            Wrap(
              children: [
                Text(
                  Utils.utf8convert(vision["relationship"]["name"].toString()),
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
                SizedBox(width: 10.0),
                Text(
                  "( ${vision["current_rating"].toString()}/10 )",
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: LightAppColors.blackColor,
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
            SizedBox(height: 30.0),
            Text(
              "How are you feeling?",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.grey[400], fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10.0),
            Text(
              Utils.utf8convert(vision["conversation_with_self"].toString()),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30.0),
            Text(
              "Why is this relationship important to you",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.grey[400], fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10.0),
            Text(
              Utils.utf8convert(vision["importance"].toString()),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30.0),
            Text(
              "What price am I willing to pay to move this relationship forward?",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.grey[400], fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10.0),
            Text(
              Utils.utf8convert(vision["price"]["name"].toString()),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30.0),
            Text(
              "Enter a Get to be be",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.grey[500], fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10.0),
            Text(
              Utils.utf8convert(vision["get_to_be"]["name"].toString()),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30.0),
            Text(
              "Select Emotion for your vision",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.grey[500], fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10.0),
            Wrap(
              runSpacing: 5.0,
              spacing: 5.0,
              children: [
                for (int i = 0; i < (vision["emotions"]?.length ?? 0); i++) ...[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Colors.orangeAccent,
                    ),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.5),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            Utils.utf8convert(vision["emotions"][i]["name"]),
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.white),
                          ),
                          SizedBox(width: 5.0),
                          Image.network(
                            "https://api.thegrowthnetwork.com" +
                                vision["emotions"][i]["logo"],
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
            SizedBox(height: 30.0),
            Text(
              "You are committed to building a relationship of",
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.grey[500], fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10.0),
            Text(
              Utils.utf8convert(vision["commitment"]["name"].toString()),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
