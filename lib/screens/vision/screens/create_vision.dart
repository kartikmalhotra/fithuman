// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:brainfit/config/application.dart';
// import 'package:brainfit/config/routes/routes_const.dart';
// import 'package:brainfit/config/theme/theme.dart';
// import 'package:brainfit/config/theme/theme_config.dart';
// import 'package:brainfit/const/api_path.dart';
// import 'package:brainfit/const/app_constants.dart';
// import 'package:brainfit/services/database_helper.dart';
// import 'package:brainfit/utils/utils.dart';
// import 'package:brainfit/widget/widget.dart';

// class CreateVisionScreen extends StatefulWidget {
//   CreateVisionScreen({Key? key}) : super(key: key);

//   @override
//   State<CreateVisionScreen> createState() => _CreateVisionScreenState();
// }

// class _CreateVisionScreenState extends State<CreateVisionScreen> {
//   bool showLoader = false;

//   final TextEditingController _conversationController = TextEditingController();
//   final TextEditingController _emotionController = TextEditingController();
//   final TextEditingController _addRelationshipController =
//       TextEditingController();

//   final FocusNode focusNode = FocusNode();
//   final _formKey = GlobalKey<FormState>();

//   List<dynamic> visions = [];
//   List<dynamic> relationships = [];
//   List<dynamic> emotions = [];
//   List<dynamic> commitments = [];
//   List<dynamic> price = [];
//   List<dynamic> getToBe = [];

//   bool editRelationship = false;
//   bool editEmotions = false;

//   double _value = 10;

//   Map<String, dynamic> visionParams = {};

//   @override
//   void initState() {
//     showLoader = true;
//     super.initState();
//     getData();
//   }

//   Future<void> getData() async {
//     try {
//       showLoader = true;
//       setState(() {});
//       var response = [
//         await Application.restService!.requestCall(
//             apiEndPoint: ApiRestEndPoints.visionPlanner,
//             addAutherization: true,
//             method: RestAPIRequestMethods.get),
//         await Application.restService!.requestCall(
//             apiEndPoint: ApiRestEndPoints.relationships,
//             addAutherization: true,
//             method: RestAPIRequestMethods.get),
//         await Application.restService!.requestCall(
//             apiEndPoint: ApiRestEndPoints.emotions,
//             addAutherization: true,
//             method: RestAPIRequestMethods.get),
//         await Application.restService!.requestCall(
//             apiEndPoint: ApiRestEndPoints.commitments,
//             addAutherization: true,
//             method: RestAPIRequestMethods.get),
//         await Application.restService!.requestCall(
//             apiEndPoint: ApiRestEndPoints.price,
//             addAutherization: true,
//             method: RestAPIRequestMethods.get),
//         await Application.restService!.requestCall(
//             apiEndPoint: ApiRestEndPoints.getToBe,
//             addAutherization: true,
//             method: RestAPIRequestMethods.get),
//       ];
//       showLoader = false;
//       setState(() {});
//       if (response[0]['code'] == 200 || response[0]['code'] == "200") {
//         visions = response[0]["data"];
//       }

//       if (response[1]['code'] == 200 || response[1]['code'] == "200") {
//         relationships = response[1]["data"];
//       }

//       if (response[2]['code'] == 200 || response[2]['code'] == "200") {
//         emotions = response[2]["data"];
//       }

//       if (response[3]['code'] == 200 || response[3]['code'] == "200") {
//         commitments = response[3]["data"];
//       }

//       if (response[4]['code'] == 200 || response[4]['code'] == "200") {
//         price = response[4]["data"];
//       }
//       if (response[5]['code'] == 200 || response[5]['code'] == "200") {
//         getToBe = response[5]["data"];
//       }
//     } catch (exe) {}
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           padding: EdgeInsets.all(20.0),
//           width: AppScreenConfig.safeBlockHorizontal! * 100,
//           height: AppScreenConfig.safeBlockVertical! * 100,
//           color: Colors.white,
//           child: Stack(
//             children: <Widget>[
//               Opacity(
//                 opacity: showLoader ? 0.01 : 1,
//                 child: ListView(
//                   children: [
//                     _backArrow(context),
//                     SizedBox(height: 20.0),
//                     Text(
//                       "Create a Vision",
//                       style: Theme.of(context).textTheme.headline5,
//                     ),
//                     SizedBox(height: 50.0),
//                     _selectRelationship(),
//                     SizedBox(height: 20.0),
//                     _selectCurrentRating(),
//                     SizedBox(height: 20.0),
//                     _conversationText(),
//                     SizedBox(height: 20.0),
//                     _emotionList(),
//                     SizedBox(height: 20.0),
//                     _importanceText(),
//                     SizedBox(height: 20.0),
//                     _priceWidget(),
//                     SizedBox(height: 20.0),
//                     _getToBe(),
//                     SizedBox(height: 20.0),
//                     Align(
//                       alignment: Alignment.center,
//                       child: SizedBox(
//                         height: 50,
//                         width: double.maxFinite,
//                         child: ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all(
//                                 LightAppColors.secondary),
//                           ),
//                           onPressed: () => createVision(),
//                           child: Text(
//                             'Create',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyText1!
//                                 .copyWith(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (showLoader) ...[
//                 Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               ]
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _backArrow(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _selectRelationship() {
//     return Card(
//       child: Padding(
//         padding: EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: <Widget>[
//                 Text("Relationship",
//                     style: Theme.of(context).textTheme.subtitle1),
//                 Spacer(),
//                 InkWell(
//                   onTap: () {
//                     editRelationship = true;
//                     setState(() {});
//                   },
//                   child: Icon(
//                     Icons.edit,
//                     color: Colors.black,
//                     size: 20,
//                   ),
//                 )
//               ],
//             ),
//             SizedBox(height: 20.0),
//             if (relationships.isNotEmpty) ...[
//               AppMultiSelectChip(
//                 relationships.map((e) => e["name"]).toList().cast<String>(),
//                 "Relationship",
//                 onPressed: () {},
//               ),
//             ] else ...[
//               Text(
//                 "You have no relationships create a relationships",
//                 style: Theme.of(context).textTheme.bodyText1!.copyWith(
//                     color: Colors.grey, fontWeight: FontWeight.normal),
//               )
//             ],
//             if (editRelationship) ...[
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text("Add a Relationship",
//                         style: Theme.of(context).textTheme.bodyText1),
//                     SizedBox(height: 20.0),
//                     TextFormField(
//                       controller: _addRelationshipController,
//                       cursorColor: LightAppColors.appBlueColor,
//                       style: Theme.of(context)
//                           .textTheme
//                           .bodyText1!
//                           .copyWith(fontWeight: FontWeight.w700),
//                       decoration: InputDecoration(
//                         filled: true,
//                         fillColor: LightAppColors.greyColor.withOpacity(0.1),
//                         // prefixIcon: Icon(Icons.mail, color: Colors.grey),
//                         hintText: "Enter a relationship",
//                         hintStyle: Theme.of(context)
//                             .textTheme
//                             .bodyText1!
//                             .copyWith(
//                                 fontWeight: FontWeight.w400,
//                                 color: Colors.grey),
//                         labelStyle: Theme.of(context)
//                             .textTheme
//                             .bodyText1!
//                             .copyWith(fontWeight: FontWeight.w700),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                           borderSide: BorderSide.none,
//                         ),
//                         floatingLabelBehavior: FloatingLabelBehavior.never,
//                       ),
//                       validator: (String? text) {
//                         if (text?.isEmpty ?? true) {
//                           return "Enter your email";
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20.0),
//                     Align(
//                       alignment: Alignment.center,
//                       child: SizedBox(
//                         height: 40,
//                         width: double.maxFinite,
//                         child: ElevatedButton(
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all(
//                                 LightAppColors.secondary),
//                           ),
//                           onPressed: () => _createRelationship(),
//                           child: Text(
//                             'Create Relationship',
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyText1!
//                                 .copyWith(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _selectCurrentRating() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: <Widget>[
//             Text("Current rating", style: Theme.of(context).textTheme.subtitle1)
//           ],
//         ),
//         SizedBox(height: 20.0),
//         Row(
//           children: <Widget>[
//             Text("0",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1!
//                     .copyWith(color: Colors.grey)),
//             Expanded(
//               child: Slider(
//                 min: 0.0,
//                 max: 10.0,
//                 activeColor: LightAppColors.primary,
//                 thumbColor: LightAppColors.primary,
//                 divisions: 10,
//                 value: _value,
//                 label: '${_value.round()}',
//                 onChanged: (value) {
//                   _value = value;
//                   setState(() {});
//                 },
//               ),
//             ),
//             Text("10",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1!
//                     .copyWith(color: Colors.grey))
//           ],
//         )
//       ],
//     );
//   }

//   Widget _conversationText() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: <Widget>[
//             Text("Conversation", style: Theme.of(context).textTheme.subtitle1)
//           ],
//         ),
//         SizedBox(height: 20.0),
//         TextFormField(
//           maxLines: 3,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: LightAppColors.greyColor.withOpacity(0.1),
//             // prefixIcon: Icon(Icons.mail, color: Colors.grey),
//             hintText: "Enter something",
//             hintStyle: Theme.of(context)
//                 .textTheme
//                 .bodyText1!
//                 .copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
//             labelStyle: Theme.of(context)
//                 .textTheme
//                 .bodyText1!
//                 .copyWith(fontWeight: FontWeight.w700),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//             floatingLabelBehavior: FloatingLabelBehavior.never,
//           ),
//         )
//       ],
//     );
//   }

//   Widget _importanceText() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: <Widget>[
//             Text("Importance Text",
//                 style: Theme.of(context).textTheme.subtitle1)
//           ],
//         ),
//         SizedBox(height: 20.0),
//         TextFormField(
//           maxLines: 3,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: LightAppColors.greyColor.withOpacity(0.1),
//             // prefixIcon: Icon(Icons.mail, color: Colors.grey),
//             hintText: "Enter something",
//             hintStyle: Theme.of(context)
//                 .textTheme
//                 .bodyText1!
//                 .copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
//             labelStyle: Theme.of(context)
//                 .textTheme
//                 .bodyText1!
//                 .copyWith(fontWeight: FontWeight.w700),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//             floatingLabelBehavior: FloatingLabelBehavior.never,
//           ),
//         )
//       ],
//     );
//   }

//   Widget _emotionList() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: <Widget>[
//             Text("Emotion", style: Theme.of(context).textTheme.subtitle1)
//           ],
//         ),
//         SizedBox(height: 20.0),
//         if (emotions.isNotEmpty) ...[] else ...[]
//       ],
//     );
//   }

//   Widget _priceWidget() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: <Widget>[
//             Text("Price", style: Theme.of(context).textTheme.subtitle1)
//           ],
//         ),
//         SizedBox(height: 20.0),
//         TextFormField(
//           maxLines: 3,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: LightAppColors.greyColor.withOpacity(0.1),
//             // prefixIcon: Icon(Icons.mail, color: Colors.grey),
//             hintText: "Enter something",
//             hintStyle: Theme.of(context)
//                 .textTheme
//                 .bodyText1!
//                 .copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
//             labelStyle: Theme.of(context)
//                 .textTheme
//                 .bodyText1!
//                 .copyWith(fontWeight: FontWeight.w700),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//             floatingLabelBehavior: FloatingLabelBehavior.never,
//           ),
//         )
//       ],
//     );
//   }

//   Widget _getToBe() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: <Widget>[
//             Text("Get to be", style: Theme.of(context).textTheme.subtitle1)
//           ],
//         ),
//         SizedBox(height: 20.0),
//         TextFormField(
//           maxLines: 3,
//           decoration: InputDecoration(
//             filled: true,
//             fillColor: LightAppColors.greyColor.withOpacity(0.1),
//             // prefixIcon: Icon(Icons.mail, color: Colors.grey),
//             hintText: "Enter something",
//             hintStyle: Theme.of(context)
//                 .textTheme
//                 .bodyText1!
//                 .copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
//             labelStyle: Theme.of(context)
//                 .textTheme
//                 .bodyText1!
//                 .copyWith(fontWeight: FontWeight.w700),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//             floatingLabelBehavior: FloatingLabelBehavior.never,
//           ),
//         )
//       ],
//     );
//   }

//   void _createRelationship() async {
//     var response = await Application.restService!.requestCall(
//         apiEndPoint: ApiRestEndPoints.relationships,
//         addAutherization: true,
//         requestParmas: {"name": _addRelationshipController.text},
//         method: RestAPIRequestMethods.post);
//     if ((response["code"] == 401 || response["code"] == 403)) {
//       await DatabaseHelper().deleteUsers();
//       Navigator.of(context)
//           .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
//     }
//     if (response["code"] == 200) {
//       await getData();
//     } else {
//       Utils.showSuccessToast(response["error"]);
//     }
//   }

//   void createVision() async {
//     var response = await Application.restService!.requestCall(
//         apiEndPoint: ApiRestEndPoints.visionPlanner,
//         addAutherization: true,
//         addParams: {
//           "relationship": "",
//           "current_rating": _value,
//           "conversation": "",
//         },
//         method: RestAPIRequestMethods.put);

//     if (kDebugMode) {
//       print(response);
//     }
//   }
// }
