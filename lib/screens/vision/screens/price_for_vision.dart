import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/vision/screens/get_to_be.dart';
import 'package:brainfit/screens/vision/screens/vision_days_screen.dart';
import 'package:brainfit/services/database_helper.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class PriceToBeScreen extends StatefulWidget {
  final Map<String, dynamic> createData;
  final bool isEditing;
  final String removeScreenUntil;

  const PriceToBeScreen(
      {Key? key,
      required this.createData,
      required this.removeScreenUntil,
      this.isEditing = false})
      : super(key: key);

  @override
  State<PriceToBeScreen> createState() => _PriceToBeScreenState();
}

class _PriceToBeScreenState extends State<PriceToBeScreen> {
  bool showLoader = false;
  List<dynamic> data = [];
  bool editRelationship = false;
  TextEditingController _addRelationshipController = TextEditingController();
  Map<String, dynamic> createData = {};
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    createData = widget.createData;
    if (createData["price"] != null) {
      createData["price"] = createData["price"];
    }
    super.initState();
    _fetchRelationships();
  }

  void _fetchRelationships() async {
    showLoader = true;
    setState(() {});
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.price,
        addAutherization: true,
        method: RestAPIRequestMethods.get);
    if (response?["code"] == "200" || response["code"] == 200) {
      data = response["data"];
      if (_addRelationshipController.text.isNotEmpty) {
        createData["price"] = _addRelationshipController.text;
        _addRelationshipController.text = "";
      }
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
          currentStep: 6,
          size: 5.5,
          selectedColor: Colors.white,
          unselectedColor: Colors.grey,
          roundedEdges: Radius.circular(10),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        BubbleNormal(
          text:
              'What price am I willing to pay to move this relationship forward?',
          isSender: false,
          color: Colors.white,
          tail: true,
          textStyle: Theme.of(context).textTheme.subtitle1!,
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        if (data.isNotEmpty) ...[
          AppSingleSelectChip(
            data.map((e) => e["name"]).toList().cast<String>(),
            "Price",
            selectedValue: createData["price"] ?? "",
            selectedColor: Colors.black87,
            onSelectionChanged: (value) {
              createData["price"] = value;
              setState(() {});
            },
          ),
        ] else ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Text(
              "You have no price present for a vision, please create a price",
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
            ),
          )
        ],
        if (!editRelationship) ...[
          SizedBox(height: 20.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    editRelationship = !editRelationship;
                  });
                },
                child: Container(
                  height: 30.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: LightAppColors.blackColor.withOpacity(0.2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: Text(
                        "Add",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 20.0),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    createData["price"] = null;
                  });
                },
                child: Text("Clear All",
                    style: Theme.of(context).textTheme.bodyText1),
              )
            ],
          ),
        ] else ...[
          Row(
            children: <Widget>[
              InkWell(
                onTap: () {
                  setState(() {
                    editRelationship = !editRelationship;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.cancel, color: Colors.grey),
                ),
              ),
              Expanded(
                child: Container(
                  height: 40.0,
                  child: FocusScope(
                    child: Focus(
                      onFocusChange: (focus) async {
                        if (focus) {
                          await Future.delayed(Duration(milliseconds: 50));
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 50),
                            curve: Curves.fastOutSlowIn,
                          );
                        }
                      },
                      child: TextFormField(
                        controller: _addRelationshipController,
                        cursorColor: LightAppColors.appBlueColor,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.w700),
                        decoration: InputDecoration(
                          filled: true,
                          contentPadding: EdgeInsets.all(10),
                          fillColor: LightAppColors.greyColor.withOpacity(0.1),
                          // prefixIcon: Icon(Icons.mail, color: Colors.grey),
                          hintText: "Enter a price ",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                          labelStyle: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.w700),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        validator: (String? text) {
                          if (text?.isEmpty ?? true) {
                            return "Enter your price";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => _createAPrice(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.check, color: Colors.grey),
                ),
              )
            ],
          )
        ],
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 3),
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
                    if (createData["price"] != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisionDaysScreen(
                            createData: createData,
                            isEditing: widget.isEditing,
                            removeScreenUntil: widget.removeScreenUntil,
                          ),
                          settings: RouteSettings(name: "G"),
                        ),
                      );
                    } else {
                      Utils.showSuccessToast(
                          "Please enter a price for your vision");
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

  void _createAPrice() async {
    var response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.price,
        addAutherization: true,
        requestParmas: {"name": _addRelationshipController.text},
        method: RestAPIRequestMethods.post);
    if ((response["code"] == 401 || response["code"] == 403)) {
      await DatabaseHelper().deleteUsers();
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    }
    if (response["code"] == 200) {
      editRelationship = false;
      _fetchRelationships();
    } else {
      Utils.showSuccessToast(response["error"]);
    }
  }
}
