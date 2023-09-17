// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:brainfit/shared/models/user.model.dart';
// import 'package:brainfit/widget/widget.dart';

// class WebViewScreen extends StatefulWidget {
//   final String? htmlURL;
//   final String? url;

//   const WebViewScreen({
//     Key? key,
//     this.htmlURL,
//     this.url,
//   }) : super(key: key);

//   @override
//   _WebViewScreenState createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   final GlobalKey webViewKey = GlobalKey();
//   String? data;

//   InAppWebViewController? webViewController;
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//     crossPlatform: InAppWebViewOptions(
//       useShouldOverrideUrlLoading: true,
//       mediaPlaybackRequiresUserGesture: false,
//     ),
//     android: AndroidInAppWebViewOptions(
//       useHybridComposition: true,
//     ),
//     ios: IOSInAppWebViewOptions(
//       allowsInlineMediaPlayback: true,
//     ),
//   );

//   late PullToRefreshController pullToRefreshController;
//   String url = "";
//   double progress = 0;
//   final urlController = TextEditingController();
//   late bool _showSpinner;

//   @override
//   void initState() {
//     _showSpinner = false;
//     super.initState();

//     pullToRefreshController = PullToRefreshController(
//       options: PullToRefreshOptions(
//         color: Colors.blue,
//       ),
//       onRefresh: () async {
//         pullToRefreshController.endRefreshing();
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.black),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),
//         body: Stack(
//           children: <Widget>[
//             if (_showSpinner) ...[
//               Container(
//                 color: Colors.white,
//                 child: const Center(
//                   child: AppCircularProgressIndicator(),
//                 ),
//               )
//             ],
//             if (!_showSpinner) ...[
//               Opacity(
//                 opacity: _showSpinner ? 0.3 : 1,
//                 child: Container(
//                   color: Colors.white,
//                   child: InAppWebView(
//                     key: webViewKey,
//                     initialOptions: options,
//                     initialUrlRequest: widget.url != null
//                         ? URLRequest(
//                             url: Uri.parse(widget.url!),
//                             headers: {"authorization": User.authToken},
//                           )
//                         : null,
//                     pullToRefreshController: pullToRefreshController,
//                     onLoadStop: (controller, url) async {
//                       pullToRefreshController.endRefreshing();
//                       setState(() {
//                         this.url = url.toString();
//                         urlController.text = this.url;
//                       });
//                     },
//                     onLoadError: (controller, url, code, message) {
//                       pullToRefreshController.endRefreshing();
//                     },
//                     onLoadStart: (controller, url) {
//                       setState(() {
//                         this.url = url.toString();
//                         urlController.text = this.url;
//                       });
//                     },
//                     onWebViewCreated: (controller) {
//                       webViewController = controller;
//                       if (widget.htmlURL != null) {
//                         _loadHtmlFromAssets();
//                       }
//                     },
//                     androidOnPermissionRequest:
//                         (controller, origin, resources) async {
//                       return PermissionRequestResponse(
//                         resources: resources,
//                         action: PermissionRequestResponseAction.GRANT,
//                       );
//                     },
//                     onProgressChanged: (controller, progress) {
//                       if (progress == 100) {
//                         pullToRefreshController.endRefreshing();
//                       }
//                       setState(() {
//                         this.progress = progress / 100;
//                         urlController.text = url;
//                       });
//                     },
//                     onUpdateVisitedHistory: (controller, url, androidIsReload) {
//                       setState(() {
//                         this.url = url.toString();
//                         urlController.text = this.url;
//                       });
//                     },
//                     onConsoleMessage: (controller, consoleMessage) {},
//                   ),
//                 ),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }

//   _loadHtmlFromAssets() async {
//     String fileText = await rootBundle.loadString('${widget.htmlURL}');
//     webViewController!.loadUrl(
//       urlRequest: URLRequest(
//         url: Uri.dataFromString(
//           fileText,
//           mimeType: 'text/html',
//           encoding: Encoding.getByName('utf-8'),
//         ),
//       ),
//     );
//   }
// }
