import 'package:flutter/foundation.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/const/api_path.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/shared/models/profile_model.dart';

abstract class ProfileRepository {
  UserDetails? get userDetails => null;
  set userDetailsData(UserDetails data);

  Future<dynamic> fetchUserProfile();

  Future<dynamic> changePassword(String password);

  Future<dynamic> changeName(String name);

  Future<dynamic> changeProfileImage(String imagePath);

  Future<dynamic> uploadMedia(String mediaLocalPath);

  Future<dynamic> deleteMedia();
}

class ProfileRepositoryImpl extends ProfileRepository {
  UserDetails? _userDetails;

  @override
  UserDetails? get userDetails => _userDetails;

  @override
  set userDetailsData(UserDetails data) {
    _userDetails = data;
  }

  @override
  Future<dynamic> fetchUserProfile() async {
    final response = await Application.restService?.requestCall(
        apiEndPoint: ApiRestEndPoints.profile,
        method: RestAPIRequestMethods.get,
        addAutherization: true);
    return response;
  }

  @override
  Future<dynamic> changePassword(String password) async {
    final response = await Application.restService?.requestCall(
        apiEndPoint: ApiRestEndPoints.changePassword,
        method: RestAPIRequestMethods.post,
        requestParmas: {"new_password": password},
        addAutherization: true);
    return response;
  }

  @override
  Future<dynamic> changeName(String name) async {
    final response = await Application.restService?.requestCall(
        apiEndPoint: ApiRestEndPoints.profile,
        method: RestAPIRequestMethods.put,
        requestParmas: {"name": name},
        addAutherization: true);
    return response;
  }

  @override
  Future<dynamic> changeProfileImage(String imagePath) async {
    // final response = await Application.restService?.requestCall(
    //     apiEndPoint: ApiRestEndPoints.profile,
    //     method: RestAPIRequestMethods.post,
    //     addParams: {"new_password": },
    //     addAutherization: true);
    // return response;
  }

  @override
  Future<dynamic> uploadMedia(String mediaLocalPath) async {
    // / If image is picked from galley
    var response = await Application.restService!.multiPartRequestCall(
        apiEndPoint: ApiRestEndPoints.profile,
        method: 'POST',
        filesPath: mediaLocalPath,
        addParams: {});

    if (kDebugMode) {
      print(response);
    }
    if (response != null) {
      return response;
    }

    // else if(mediaType == Meid)
  }

  @override
  Future<dynamic> deleteMedia() async {
    // / If image is picked from galley
    final response = await Application.restService?.requestCall(
        apiEndPoint: ApiRestEndPoints.profile,
        method: RestAPIRequestMethods.delete,
        addAutherization: true);

    if (kDebugMode) {
      print(response);
    }
    if (response != null) {
      return response;
    }
  }
}
