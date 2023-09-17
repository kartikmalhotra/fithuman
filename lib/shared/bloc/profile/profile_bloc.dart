import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:brainfit/shared/repository/profile_repository.dart';
import 'package:brainfit/utils/utils.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepositoryImpl repository;

  ProfileBloc({required this.repository}) : super(ProfileInitial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is GetUserProfile) {
      yield* _mapGetUserProfileEventToState(event);
    } else if (event is ChangePasswordEvent) {
      yield* _mapChangePasswordEventToState(event);
    } else if (event is ChangeNameEvent) {
      yield* _mapChangeNameEventToState(event);
    } else if (event is ChangeProfileImage) {
      yield* _mapChangeProfileImageEventToState(event);
    } else if (event is UploadMediaUrlEvent) {
      yield* _mapUploadMediaUrlEventToState(event);
    } else if (event is DeleteMediaEvent) {
      yield* _mapDeleteMediaEventEventToState(event);
    }
  }

  Stream<ProfileState> _mapGetUserProfileEventToState(event) async* {
    yield const ProfileLoader();
    var response = await repository.fetchUserProfile();
    if (response != null &&
        (response['code'] == 200 || response['code'] == "200")) {
      // UserDetails? _userList = UserDetails.fromJson(response);
      // Application.userDetails = _userList;
      yield ProfileLoadedState(data: response["data"]);
    } else {
      yield ProfileLoadedState(error: response?['error']);
    }
  }

  Stream<ProfileState> _mapUploadMediaUrlEventToState(
      UploadMediaUrlEvent event) async* {
    yield UploadingMediaLoaderState(dateTime: event.dateTime);

    var response = await repository.uploadMedia(event.imageLocalPath);
    if (response != null) {
      yield MediaUploadedState(isUploaded: true);
      add(GetUserProfile());
    } else {
      Utils.showFailureToast("Unable to upload a Media file");
      yield MediaUploadedState(isUploaded: false);
    }

    // } else if (event.mediaType == MediaType.Video) {
    //   var response = await repository.uploadMedia(event.url, event.mediaType);
    //   if (response != null && response["image"] != null) {
    //     repository.addImageUrlData = response["image"];
    //     yield UploadMediaUrlState(
    //         url: response["image"],
    //         mediaType: event.mediaType,
    //         dateTime: event.dateTime);
    //     add(GetHashtagFromImages(url: response["image"]));
    //   }
    // }
  }

  Stream<ProfileState> _mapDeleteMediaEventEventToState(
      DeleteMediaEvent event) async* {
    yield UploadingMediaLoaderState(dateTime: DateTime.now());

    var response = await repository.deleteMedia();
    if (response != null) {
      yield MediaUploadedState(isUploaded: true);
      add(GetUserProfile());
    } else {
      Utils.showFailureToast("Unable to upload a Media file");
      yield MediaUploadedState(isUploaded: false);
    }

    // } else if (event.mediaType == MediaType.Video) {
    //   var response = await repository.uploadMedia(event.url, event.mediaType);
    //   if (response != null && response["image"] != null) {
    //     repository.addImageUrlData = response["image"];
    //     yield UploadMediaUrlState(
    //         url: response["image"],
    //         mediaType: event.mediaType,
    //         dateTime: event.dateTime);
    //     add(GetHashtagFromImages(url: response["image"]));
    //   }
    // }
  }

  Stream<ProfileState> _mapChangePasswordEventToState(
      ChangePasswordEvent event) async* {
    yield const ChangePasswordLoader();
    var response = await repository.changePassword(event.password);
    if (response['code'] == 200 || response['code'] == '200') {
      add(GetUserProfile());
      yield ChangePasswordLoadedState(
          passwordChanged: true, reason: response["reason"]);
    } else {
      yield ChangePasswordLoadedState(
          passwordChanged: false, reason: response["reason"]);
    }
  }

  Stream<ProfileState> _mapChangeNameEventToState(
      ChangeNameEvent event) async* {
    yield const ChangeNameLoader();
    var response = await repository.changeName(event.name);
    if (response['code'] == 200 || response['code'] == '200') {
      yield ChangeNameLoadedState(
          nameChanged: true, reason: response["reason"]);
      add(GetUserProfile());
    } else {
      yield ChangeNameLoadedState(
          nameChanged: false, reason: response["reason"]);
    }
  }

  Stream<ProfileState> _mapChangeProfileImageEventToState(
      ChangeProfileImage event) async* {
    yield const ChangeProfileImageLoader();
    var response = await repository.changeProfileImage(event.imageLocalPath);
    if (response['code'] == 200 && response['code'] == '200') {
      yield ChangePasswordLoadedState(
          passwordChanged: true, reason: response["reason"]);
      add(GetUserProfile());
    } else {
      yield ChangePasswordLoadedState(
          passwordChanged: false, reason: response["reason"]);
    }
  }
}
