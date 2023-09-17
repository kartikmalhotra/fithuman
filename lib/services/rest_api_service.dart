import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:brainfit/const/app_constants.dart' as constants;
import 'package:http_parser/http_parser.dart';
import 'package:brainfit/shared/models/user.model.dart';

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) {
        /// Explicitly returning true to avoid handshake exception
        return true;
      });
  }
}

class RestAPIService {
  static RestAPIService? _instance;
  static late String _apiBaseUrl;

  RestAPIService._internal();

  static RestAPIService? getInstance() {
    _instance ??= RestAPIService._internal();

    _apiBaseUrl = "https://api.thegrowthnetwork.com/";

    if (kDebugMode) {
      print(_apiBaseUrl);
    }

    return _instance;
  }

  /// Set the PNM API Base URL
  /// Called when setting syncing mobile app with other server
  set appAPIBaseUrlData(String data) {
    _apiBaseUrl = data;
  }

  String get appAPIBaseUrl => _apiBaseUrl;

  Future<dynamic> requestCall(
      {required String? apiEndPoint,
      required constants.RestAPIRequestMethods method,
      dynamic requestParmas,
      Map<String, dynamic>? addParams,
      bool isFileRequest = false,
      bool givenAPIUrl = false,
      bool addAutherization = false}) async {
    String? _apiEndPoint = apiEndPoint;

    Map<String, String> _httpHeaders = {
      HttpHeaders.contentTypeHeader: "application/json"
    };

    /// Check if [addParams] is not null and [_apiEndPoint] is having [:] then modify the apiEndpoint for [GET] request
    if (addParams != null) {
      _apiEndPoint = _modifyAPIEndPoint(_apiEndPoint, addParams);
    }

    /// Check whether to skip the authorization token in the requested [apiEndpoint]
    if (addAutherization) {
      _httpHeaders[HttpHeaders.authorizationHeader] = "Token ${User.authToken}";
    }

    /// make the complete URL of API
    Uri? _apiUrl;

    if (!givenAPIUrl) {
      /// Make complete API URL
      _apiUrl = Uri.parse('$_apiBaseUrl$_apiEndPoint');
    } else {
      _apiUrl = Uri.parse('$_apiEndPoint');
    }

    /// json encode the request params
    dynamic _requestParmas = json.encode(requestParmas);

    /// check the device OS for appending in request header

    dynamic responseJson;

    switch (method) {
      case constants.RestAPIRequestMethods.get:
        try {
          final response = await http.get(_apiUrl, headers: _httpHeaders);
          responseJson =
              _returnResponse(response, isFileRequest: isFileRequest);
        } on SocketException {
          responseJson = {
            "error":
                'No internet connection found, Please check your internet and try again!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }
        break;
      case constants.RestAPIRequestMethods.post:
        try {
          final response = await http.post(_apiUrl,
              body: _requestParmas, headers: _httpHeaders);

          responseJson = _returnResponse(response);
        } on SocketException {
          responseJson = {
            "error":
                'No internet connection found, Please check your internet and try again!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }

        break;
      case constants.RestAPIRequestMethods.put:
        try {
          final response = await http.put(_apiUrl,
              body: _requestParmas, headers: _httpHeaders);
          responseJson = _returnResponse(response);
        } on SocketException {
          responseJson = {
            "error":
                'No internet connection found, Please check your internet and try again!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Oh No! Unable to process your request. Possible cases may be server is not reachable or if server runs on VPN then VPN should be connected on mobile device!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }
        break;
      case constants.RestAPIRequestMethods.delete:
        try {
          /// normal delete request without body
          if (requestParmas == null) {
            final response = await http.delete(_apiUrl, headers: _httpHeaders);
            responseJson = _returnResponse(response);
          } else {
            /// delete request with body
            final request = http.Request("DELETE", _apiUrl);
            request.headers.addAll(_httpHeaders);
            request.body = json.encode(requestParmas);
            final streamedResponse = await request.send();
            final response = await http.Response.fromStream(streamedResponse);
            responseJson = _returnResponse(response);
          }
        } on SocketException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }
        break;
      case constants.RestAPIRequestMethods.patch:
        try {
          final response = await http.patch(_apiUrl,
              body: _requestParmas, headers: _httpHeaders);
          if (_apiUrl.path.contains("/api/signup") &&
              response.statusCode == 200) {
            return {"code": 200};
          }
          responseJson = _returnResponse(response);
        } on SocketException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on FormatException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } on http.ClientException {
          responseJson = {
            "error":
                'Unable to process your request due to some failure, Please try again later!'
          };
        } catch (exe) {
          if (kDebugMode) {
            print(exe.toString());
          }
        }
        break;
      default:
        break;
    }
    return responseJson;
  }

  /// This function returns the apiEndPoints by modifying the Endpoint i.e by replacing the [:tmp] with actual content required for [GET] request
  static String? _modifyAPIEndPoint(
      String? apiEndPoint, Map<String, dynamic> addParams) {
    String? _modifiedAPIEndPoint = '$apiEndPoint?';
    String _requestParams = '';
    addParams.forEach((key, value) {
      _requestParams += "$key=${value.toString()}&";
    });
    _requestParams = _requestParams.substring(0, _requestParams.length - 1);
    return _modifiedAPIEndPoint + _requestParams;
  }

  //  This function is used k the file (Currently : image) to the server in the form of multipart/form-data
  Future<dynamic> multiPartRequestCall(
      {required String apiEndPoint,
      required String method,
      required String filesPath,
      constants.MediaType mediaType = constants.MediaType.Image,
      bool givenAPIUrl = false,
      Map<String, dynamic>? addParams}) async {
    String? _apiEndPoint = apiEndPoint;

    late String _apiUrl;

    if (!givenAPIUrl) {
      /// Make complete API URL
      _apiUrl = '$_apiBaseUrl$_apiEndPoint';
    } else {
      _apiUrl = apiEndPoint;
    }

    if (mediaType == constants.MediaType.Image) {
      try {
        var request = http.MultipartRequest("PUT", Uri.parse(_apiUrl));
        //create multipart using filepath, string or bytes

        //add multipart to request
        request.files
            .add(await http.MultipartFile.fromPath('profile_pic', filesPath));
        request.headers[HttpHeaders.authorizationHeader] =
            "Token ${User.authToken}";
        request.headers[HttpHeaders.contentTypeHeader] = "multipart/form-data";

        //Get the response from the server
        try {
          http.StreamedResponse response =
              await request.send().whenComplete(() {
            print("Video Download Completed");
          });

          if (response.statusCode == 200 &&
              response.reasonPhrase?.toLowerCase() == "ok") {
            String data =
                await response.stream.bytesToString().catchError((error) {
              print(error);
            });
            Map<String, dynamic> responseData = jsonDecode(data);
            return {"image": responseData["image"]};
          } else {
            return {"error": response.reasonPhrase};
          }
        } catch (exe) {
          if (kDebugMode) {
            print("Exception" + exe.toString());
          }
        }
      } catch (exe) {
        print(exe);
      }
    } else if (mediaType == constants.MediaType.Video) {
      // var request = http.MultipartRequest("POST", Uri.parse(_apiUrl));
      //create multipart using filepath, string or bytes

      //add multipart to request
      // request.files.add(await http.MultipartFile.fromPath('file', filesPath));
      // request.headers[HttpHeaders.authorizationHeader] = User.authToken!;
      // request.headers[HttpHeaders.cookieHeader] = "";

      // //Get the response from the server
      // FormData formData = new FormData.fromMap({
      //   "file": await MultipartFile.fromFile(
      //     filesPath,
      //     contentType: MediaType("video", "mp4"),
      //     filename: filesPath.split("/").last,
      //   ),
      // });

      // var options = Options(
      //   method: "POST",
      //   contentType: "video/mp4",
      //   headers: {
      //     "authorization": User.authToken,
      //     'Accept': "*/*",
      //     'Content-Length': File(filesPath).lengthSync().toString(),
      //     "Content-type": "video/mp4",
      //     'Connection': 'keep-alive',
      //     HttpHeaders.contentTypeHeader: 'application/json'
      //   },
      // );
      // try {
      //   var response = await Dio().post(_apiUrl,
      //       data: formData, options: options, onSendProgress: (v, x) {
      //     print("Progress ${(v / x) * 100}");
      //   }).whenComplete(() {
      //     debugPrint("complete:");
      //   }).catchError((onError) {
      //     debugPrint("error:${onError.toString()}");
      //   });
      //   print(response.statusMessage);
      //   print(response.statusCode);
      // } catch (exe) {
      //   print(exe);
      // }

      // try {
      //   http.StreamedResponse resp;

      //   if (response.statusCode == 200 &&
      //       response.reasonPhrase?.toLowerCase() == "ok") {
      //     String data = await response.stream.bytesToString();
      //     Map<String, dynamic> responseData = jsonDecode(data);
      //     return {"image": responseData["image"]};
      //   } else {
      //     return {"error": response.reasonPhrase};
      //   }
      // } catch (exe) {
      //   if (kDebugMode) {
      //     print("Exception" + exe.toString());
      //   }
      // }

      var headers = {
        'authority': 'app.hellowoofy.com',
        'accept': '*/*',
        'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8',
        'authorization':
            '0197fec0244959791f40ce26c4b22d929f6caebcd2c0de6d5ba07f5fab935032b051ba9add8d8f62c1b5020fe13c93f3a53ab2884a12c2109991bfac394a864ab0654aebedd0e9b6a5df8b83afdf397e8f90eebdc5caf2dbc1a69fa505eba64ab871a0e2e6004de3ee6ed837c0d19c60c17add4f2d04f4721d2c0d921af411c1682f8244a66ac033f9ef068c6a03d8171fc7d87476d506c8fb46be83e63da5fcbcb8779e4a6c5f38e457aa9122b974ab8bb927b8692cedfe442110e36cdd644897e46bccd41c73daddf67747cdff073cbe1dbdd064062b648f33833196ef71bb645860bd3bd24fddef5d7344a1baa7433dd48ab7620b4310665c7a3d915eb391cc63ecc45dd434990a58f54c8581f135fb90e1b462',
        'cookie':
            '_fbp=fb.1.1650481563267.426428942; _ga=GA1.2.502399516.1650481565; _ga=GA1.1.502399516.1650481565; __zlcmid=19akrlS2C6V9lcn; _pin_unauth=dWlkPVlqVm1aVGRoTVRJdE0yUTJNaTAwWTJNNUxUaGxabVF0TWpoaU5EaG1PVFU0WldWbQ; _pin_unauth=dWlkPVlqVm1aVGRoTVRJdE0yUTJNaTAwWTJNNUxUaGxabVF0TWpoaU5EaG1PVFU0WldWbQ; __stripe_mid=6eb2095d-f90b-459b-bfee-12dd0401ce87a2224f; connect.sid=s%3A011pERLkrXRfRSrfeVdvgRfDow-j8KDw.gjQlWSs9K1z89duUfVSfO93vPEqqxUpj1WiCLw3TufQ; _tt_enable_cookie=1; _ttp=e69cf754-ccf9-481c-b90b-c81bf1aaa74c; _gid=GA1.2.142877022.1652455969; pys_landing_page=about:srcdoc; _gid=GA1.1.142877022.1652455969; intercom-session-iyrom9uk=Nks1V2NPUm5Wdi9OUWorUDdPeUVFUVk4eG1VN1FTRnZtVmxPUHRCTHVRQ1lUQ0puOUoyRmU1YnBVS01TVjBxUy0tMzhZWVQ4YnN4dGVHcnlja0pncWI5UT09--e4153e61440b6f3178e8f0eecb3310d44bee0e09',
        'origin': 'https://app.hellowoofy.com',
        'referer': 'https://app.hellowoofy.com/5ec61a27398ccc001e9ca8d8/',
        'sec-ch-ua':
            '" Not A;Brand";v="99", "Chromium";v="101", "Google Chrome";v="101"',
        'sec-ch-ua-mobile': '?0',
        'sec-ch-ua-platform': '"macOS"',
        'sec-fetch-dest': 'empty',
        'sec-fetch-mode': 'cors',
        'sec-fetch-site': 'same-origin',
        'Content-Type': 'video/mp4',
        'user-agent':
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36'
      };
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://app.hellowoofy.com/api/upload-video'),
      );
      request.fields.addAll({'socialNetworksSelected': '[]'});
      request.files.add(await http.MultipartFile.fromPath('file', filesPath,
          contentType: MediaType("video", "mp4")));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return jsonDecode(await response.stream.bytesToString());
      } else {
        return {"error": "Not able to upload Video"};
      }
    }
  }

  static dynamic _returnResponse(http.Response response,
      {bool isFileRequest = false}) {
    switch (response.statusCode) {
      case 200:
      case 201:
        var returnJson = jsonDecode(response.body);
        return returnJson;
      case 204:
        Map<String, bool> _returnMap = {'success': true};
        return _returnMap;
      case 400:
        if (response.body.isNotEmpty) {
          var returnJson = jsonDecode(response.body);
          if (returnJson.containsKey("message")) {
            return {
              'error': returnJson["message"],
              'score': returnJson["score"] ?? null,
              "error_detail": returnJson["errors"]
            };
          }
        }
        return {'error': response.reasonPhrase};
      case 401:
      // return RestAPIUnAuthenticationModel.fromJson(_responseBody['error']);
      case 403:
        if (response.body.isNotEmpty) {
          var returnJson = jsonDecode(response.body);
          if (returnJson.containsKey("message")) {
            return {'error': returnJson["message"]};
          }
        }
        return {'error': response.reasonPhrase};
      case 404:
        if (response.body.isNotEmpty) {
          var returnJson = jsonDecode(response.body);
          if (returnJson.containsKey("message")) {
            return {'error': returnJson["message"]};
          }
        }
        return {'error': response.reasonPhrase};
      default:
        return {'error': response.reasonPhrase};
    }
  }

  Map<String, dynamic> getResponseBody(
      http.Response response, bool isFileRequest) {
    Map<String, dynamic> _responseBody = {};
    if (response.body.isNotEmpty && !isFileRequest) {
      /// decode the response
      var _jsonResponse = json.decode(response.body);

      /// Check if _responseBody is not Map and do not contains key ['data'] and ['error] then add that _responseBody with key 'data'
      /// Required for GIS API Call
      if (_jsonResponse is! Map ||
          (_jsonResponse['data'] == null && _jsonResponse['error'] == null)) {
        _responseBody = {'data': _jsonResponse};
      } else {
        _responseBody = _jsonResponse as Map<String, dynamic>;
      }
    } else if (response.body.isNotEmpty && isFileRequest) {
      String _base64String = base64.encode(response.bodyBytes);
      Uint8List _bytes = base64.decode(_base64String);
      _responseBody['file'] = _bytes;
    } else {
      _responseBody = {
        'error': {'code': 1111, 'message': 'Unexpected error'}
      };
    }
    return _responseBody;
  }
}
