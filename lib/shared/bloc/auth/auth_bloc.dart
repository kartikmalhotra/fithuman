import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/services/database_helper.dart';
import 'package:brainfit/shared/models/user.model.dart';
import 'package:brainfit/shared/repository/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl repository;

  AuthBloc({required this.repository}) : super(const AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoginEvent) {
      yield* _mapLoginEventToState(event);
    } else if (event is ForgetPasswordEvent) {
      yield* _mapForgetPasswordEventToState(event);
    } else if (event is LogoutEvent) {
      yield* _mapLogoutEventToState();
    } else if (event is SignUpEvent) {
      yield* _mapSignUpEventToState(event);
    } else if (event is FacebookLogin) {
      yield* _mapFacebookLoginEventToState(event);
    } else if (event is GoogleLogin) {
      yield* _mapGoogleLoginEventToState(event);
    } else if (event is AppleLogin) {
      yield* _mapAppleLoginEventToState(event);
    }
  }

  Stream<AuthState> _mapLoginEventToState(LoginEvent event) async* {
    yield const AuthLoader();

    final response = await repository.login(event.email, event.password);
    if (response['code'] == 200 || response['code'] == "200") {
      User.setUserParams(response);
      await DatabaseHelper().saveUser();

      _saveSecureStorage(response, event.email, event.password);

      List<dynamic> getAssessment = await getAssessments();
      yield LoginResultState(
          loggedIn: true, takeAssessment: (getAssessment.length == 0));
    } else {
      yield LoginResultState(
          loggedIn: false,
          errorResult: response['reason'] ?? response["error"]);
    }
  }

  Stream<AuthState> _mapForgetPasswordEventToState(
      ForgetPasswordEvent event) async* {
    yield const ForgetPasswordLoader();
    final response = await repository.forgetPassword(event.email);
    if (response['code'] == 200 || response['code'] == "200") {
      yield ForgetPasswordState(message: response['reason']);
    } else {
      yield ForgetPasswordState(
          errorResult: response['reason'] ?? response["error"]);
    }
  }

  Stream<AuthState> _mapSignUpEventToState(SignUpEvent event) async* {
    yield const SignUpLoader();
    final response =
        await repository.signUp(event.email, event.password, event.name);
    if (response['code'] == 200 || response['code'] == "200") {
      yield const SignupResultState(signedIn: true);
    } else {
      if (response["response"] != null) {
        yield SignupResultState(
            signedIn: false, errorResult: response["response"]);
        return;
      }
      yield SignupResultState(
          errorResult: response["reason"] ?? response["error"]);
    }
  }

  Stream<AuthState> _mapFacebookLoginEventToState(FacebookLogin event) async* {
    yield const AuthLoader();

    final LoginResult result = await FacebookAuth.instance
        .login(); // by the fault we request the email and the public profile
    if (result.status == LoginStatus.success) {
      final AccessToken? code = result.accessToken;
      if (code?.token != null) {
        var oauthResp = await repository.facebookLogin(code!.token);
        if (oauthResp.containsKey('reason') &&
            oauthResp['code'] != 200 &&
            oauthResp['code'] != '200') {
          yield LoginResultState(
              loggedIn: false, errorResult: oauthResp["reason"]);
        } else {
          if (oauthResp != null && oauthResp["error"] == null) {
            User.setUserParams(oauthResp);
            await DatabaseHelper().saveUser();
          }

          dynamic getAssessment = await getAssessments();

          yield LoginResultState(
              loggedIn: true,
              errorResult: oauthResp["reason"],
              takeAssessment: (getAssessment.length == 0));
        }
      } else {
        yield LoginResultState(
            loggedIn: false, errorResult: 'Unable to login with facebook');
      }
    } else if (result.status == LoginStatus.cancelled) {
      yield LoginResultState(loggedIn: false, errorResult: "Login canceled");
    } else {
      yield LoginResultState(
          loggedIn: false, errorResult: 'Unable to login with facebook');
    }
  }

  Stream<AuthState> _mapGoogleLoginEventToState(GoogleLogin event) async* {
    yield const AuthLoader();

    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email'],
      clientId: Platform.isAndroid
          ? "391749015417-61mcelfvkhke5sg5dgad1cbl4fv26102.apps.googleusercontent.com"
          : "391749015417-ua7hd25v9c7e6khnkn3p1rq33c3bk0ou.apps.googleusercontent.com",
    );

    GoogleSignInAccount? user;
    try {
      user = await _googleSignIn.signIn();
    } catch (exe) {
      print(exe);
    }

    if (user != null) {
      GoogleSignInAuthentication? googleSignInAuthentication =
          await user.authentication;
      if (googleSignInAuthentication.accessToken != null) {
        var response =
            await repository.googleLogin(googleSignInAuthentication.idToken!);
        if (response['code'] == 200 || response['code'] == "200") {
          User.setUserParams(response);
          await DatabaseHelper().saveUser();
          List<dynamic> getAssessment = await getAssessments();
          yield LoginResultState(
              loggedIn: true, takeAssessment: getAssessment.length == 0);
        } else {
          yield LoginResultState(
              loggedIn: false,
              errorResult: response['reason'] ?? response["error"]);
        }
      }
    } else {
      yield LoginResultState(
          loggedIn: false,
          errorResult: "Unable to Login, Something went wrong");
    }
  }

  Stream<AuthState> _mapAppleLoginEventToState(AppleLogin event) async* {
    yield const AuthLoader();
    dynamic credential;
    try {
      credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
    } catch (exe) {}

    if (credential != null) {
      var response = await repository.appleLogin(credential.authorizationCode);
      if (response['code'] == 200 || response['code'] == "200") {
        User.setUserParams(response);
        _saveSecureStorage(response, response["data"]["user"]["email"], '');
        List<dynamic> getAssessment = await getAssessments();
        yield LoginResultState(
            loggedIn: true, takeAssessment: getAssessment.length == 0);
      } else {
        yield LoginResultState(
            loggedIn: false, errorResult: response["reason"]);
      }
    } else {
      yield LoginResultState(
          loggedIn: false, errorResult: "Something went wrong");
    }
  }

  Stream<AuthState> _mapLogoutEventToState() async* {
    yield const AuthLoader();

    final response = await repository.logout();
    if (response != null &&
        response['error'] == null &&
        (response['code'] == 200 || response['code'] == "200")) {
      logoutUser();
      yield const LogoutState(isLogout: true);
    } else {
      yield LogoutState(
          isLogout: false, error: response['reason'] ?? response["error"]);
    }
  }

  void _saveSecureStorage(response, email, password) {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((token) {
      print("FCM Token is " + (token ?? ""));
    });

    if (kDebugMode) {
      print(User.authToken);
    }
  }

  void logoutUser() async {
    User.deleteUser();
    await DatabaseHelper().deleteUsers();
  }

  Future<dynamic> getAssessments() async {
    try {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "api/assessments",
          addAutherization: true,
          method: RestAPIRequestMethods.get);
      if (response['code'] == 200 || response['code'] == "200") {
        return response["data"];
      }
    } catch (exe) {
      return [];
    }
  }
}
