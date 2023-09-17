import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';

abstract class AuthRepository {
  Future<dynamic> login(String email, String password);
  Future<dynamic> facebookLogin(String token);
  Future<dynamic> appleLogin(String code);
  Future<dynamic> forgetPassword(String email);
  Future<dynamic> googleLogin(String code);
  Future<dynamic> logout();
  Future<dynamic> signUp(String email, String password, String name);
}

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<dynamic> login(String email, String password) async {
    String? fcm_token;
    await FirebaseMessaging.instance.getToken().then((value) {
      fcm_token = value;
    });
    final response = await Application.restService!.requestCall(
      apiEndPoint: ApiRestEndPoints.login,
      method: RestAPIRequestMethods.post,
      requestParmas: {
        "email": email,
        "password": password,
        "fcm_token": fcm_token
      },
    );
    return response;
  }

  @override
  Future<dynamic> facebookLogin(String token) async {
    String? fcm_token;
    await FirebaseMessaging.instance.getToken().then((value) {
      fcm_token = value;
    });
    final response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.facebookLogin,
        method: RestAPIRequestMethods.post,
        requestParmas: {'code': token, "fcm_token": fcm_token});
    return response;
  }

  @override
  Future<dynamic> googleLogin(String code) async {
    String? fcm_token;
    await FirebaseMessaging.instance.getToken().then((value) {
      fcm_token = value;
    });
    final response = await Application.restService!.requestCall(
        apiEndPoint: ApiRestEndPoints.googleLogin,
        method: RestAPIRequestMethods.post,
        requestParmas: {'code': code, "fcm_token": fcm_token});
    return response;
  }

  @override
  Future<dynamic> forgetPassword(String email) async {
    final response = await Application.restService!.requestCall(
      apiEndPoint: ApiRestEndPoints.forgetPassword,
      method: RestAPIRequestMethods.post,
      requestParmas: {"email": email},
    );
    return response;
  }

  @override
  Future<dynamic> appleLogin(String code) async {
    String? fcm_token;
    await FirebaseMessaging.instance.getToken().then((value) {
      fcm_token = value;
    });
    final response = await Application.restService!.requestCall(
      apiEndPoint: ApiRestEndPoints.appleLogin,
      method: RestAPIRequestMethods.post,
      requestParmas: {"code": code, "fcm_token": fcm_token},
    );
    return response;
  }

  @override
  Future<dynamic> logout() async {
    String _fcmToken = await Application.secureStorageService!.fcmToken;

    if (_fcmToken.isNotEmpty) {
      /// Delete FCM Token
      // final deleteTokenResponse = await Application.restService!.requestCall(
      //     apiEndPoint: ApiRestEndPoints.mobileToken,
      //     addAutherization: true,
      //     requestParmas: {
      //       "mobileToken": _fcmToken,
      //     },
      //     method: RestAPIRequestMethods.delete);
      // print("Delete FCM Token ${deleteTokenResponse.toString()}");
    }

    String? fcm_token;
    await FirebaseMessaging.instance.getToken().then((value) {
      fcm_token = value;
    });

    final response = await Application.restService!.requestCall(
      apiEndPoint: ApiRestEndPoints.logout,
      addAutherization: true,
      requestParmas: {"fcm_token": fcm_token},
      method: RestAPIRequestMethods.post,
    );
    return response;
  }

  @override
  Future<dynamic> signUp(String email, String password, String name) async {
    final response = await Application.restService!.requestCall(
      apiEndPoint: ApiRestEndPoints.signup,
      requestParmas: {
        "email": email,
        "password": password,
        "name": name,
      },
      method: RestAPIRequestMethods.post,
    );
    return response;
  }
}
