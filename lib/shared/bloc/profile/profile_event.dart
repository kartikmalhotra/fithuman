part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetUserProfile extends ProfileEvent {
  const GetUserProfile();

  @override
  List<Object> get props => [];
}

class ChangePasswordEvent extends ProfileEvent {
  final String password;

  const ChangePasswordEvent({required this.password});

  @override
  List<Object> get props => [password];
}

class ChangeNameEvent extends ProfileEvent {
  final String name;

  const ChangeNameEvent({required this.name});

  @override
  List<Object> get props => [name];
}

class ChangeProfileImage extends ProfileEvent {
  final String imageLocalPath;

  const ChangeProfileImage({required this.imageLocalPath});

  @override
  List<Object> get props => [imageLocalPath];
}

class UploadMediaUrlEvent extends ProfileEvent {
  final String imageLocalPath;
  final DateTime dateTime;

  const UploadMediaUrlEvent({
    required this.imageLocalPath,
    required this.dateTime,
  });

  @override
  List<Object> get props => [imageLocalPath, dateTime];
}

class DeleteMediaEvent extends ProfileEvent {
  const DeleteMediaEvent();

  @override
  List<Object> get props => [];
}
