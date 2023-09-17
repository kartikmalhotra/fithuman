import 'package:brainfit/shared/models/profile_model.dart';

abstract class UserRepository {
  UserDetails? get userDetails => null;

  set userDetailsData(UserDetails data);

  Future<dynamic> fetchUserDetails();
}

class UserRepositoryImpl extends UserRepository {
  UserDetails? _userDetails;

  @override
  UserDetails? get puserDetails => _userDetails;

  @override
  set userDetailsData(UserDetails data) {
    _userDetails = data;
  }

  @override
  Future<dynamic> fetchUserDetails() async {
    // final response = await Application.restService!.requestCall(
    //   apiEndPoint: ApiRestEndPoints.user,
    //   method: RestAPIRequestMethods.get,
    // );
    // return response;
  }
}
