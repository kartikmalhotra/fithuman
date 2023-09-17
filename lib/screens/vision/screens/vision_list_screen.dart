import 'package:flutter/material.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/widget/widget.dart';

class VisionListScreen extends StatefulWidget {
  VisionListScreen({Key? key}) : super(key: key);

  @override
  State<VisionListScreen> createState() => _VisionListScreenState();
}

class _VisionListScreenState extends State<VisionListScreen> {
  bool showLoader = false;
  List<dynamic> visions = [];

  @override
  void initState() {
    showLoader = true;
    super.initState();
    getVisions();
  }

  Future<void> getVisions() async {
    try {
      showLoader = true;
      setState(() {});
      var response = await Application.restService!.requestCall(
          apiEndPoint: ApiRestEndPoints.visionPlanner,
          addAutherization: true,
          method: RestAPIRequestMethods.get);
      showLoader = false;
      setState(() {});
      if (response['code'] == 200 || response['code'] == "200") {
        visions = response["data"];
      }
    } catch (exe) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.0),
          width: AppScreenConfig.safeBlockHorizontal! * 100,
          height: AppScreenConfig.safeBlockVertical! * 100,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Opacity(
                opacity: showLoader ? 0.01 : 1,
                child: ListView(
                  children: [
                    Row(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Text(
                      "Visions",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(height: 30.0),
                    if (visions.length != 0) ...[
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: visions.length,
                        itemBuilder: (context, index) {
                          return _displayVisionCard(visions[index]);
                        },
                      ),
                    ] else ...[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: AppScreenConfig.safeBlockVertical! * 20,
                            ),
                            Text(
                              "No vision found create a vision",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                            SizedBox(height: 20.0),
                            Center(
                              child: SizedBox(
                                height: 50,
                                width:
                                    AppScreenConfig.safeBlockHorizontal! * 70,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: ((context) =>
                                    //         QuestionScreen()),
                                    //   ),
                                    // );
                                  },
                                  child: Text(
                                    'Create Vision',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]
                  ],
                ),
              ),
              if (showLoader) ...[
                Center(
                  child: AppCircularProgressIndicator(),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _displayVisionCard(dynamic vision) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(10.0),
        width: double.maxFinite,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text("Relationship",
                  style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text(
                vision["relationship"]["name"].toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.grey),
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text("Current Rating",
                  style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text(
                vision["current_rating"].toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.grey),
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text("Conversation",
                  style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text(
                vision["conversation_with_self"].toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.grey),
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text("Importance", style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text(
                vision["importance"].toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.grey),
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text("Price", style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text(
                vision["price"]["name"].toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.grey),
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text("Get to be", style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text(
                vision["get_to_be"]["name"].toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.grey),
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text("Emotions", style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text(
                vision["emotions"].toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.grey),
              ),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text("Commitment", style: Theme.of(context).textTheme.subtitle1),
              SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
              Text(
                vision["commitment"]["name"].toString(),
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
