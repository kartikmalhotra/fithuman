part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  @override
  List<Object> get props => [];
}

class ProfileLoader extends ProfileState {
  const ProfileLoader();

  @override
  List<Object> get props => [];
}

class ChangePasswordLoader extends ProfileState {
  const ChangePasswordLoader();

  @override
  List<Object> get props => [];
}

class ChangeNameLoader extends ProfileState {
  const ChangeNameLoader();

  @override
  List<Object> get props => [];
}

class ChangeProfileImageLoader extends ProfileState {
  const ChangeProfileImageLoader();

  @override
  List<Object> get props => [];
}

class ProfileLoadedState extends ProfileState {
  final Map<String, dynamic>? data;
  final String? error;

  const ProfileLoadedState({this.data, this.error});

  @override
  List<Object?> get props => [data, error];
}

class ChangeNameLoadedState extends ProfileState {
  final bool nameChanged;
  final String? reason;

  const ChangeNameLoadedState({required this.nameChanged, this.reason});

  @override
  List<Object?> get props => [nameChanged, reason];
}

class ChangePasswordLoadedState extends ProfileState {
  final bool passwordChanged;
  final String? reason;

  const ChangePasswordLoadedState({required this.passwordChanged, this.reason});

  @override
  List<Object?> get props => [passwordChanged, reason];
}

class UploadingMediaLoaderState extends ProfileState {
  final DateTime dateTime;

  const UploadingMediaLoaderState({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class MediaUploadedState extends ProfileState {
  final bool isUploaded;
  final String? error;

  const MediaUploadedState({
    this.isUploaded = false,
    this.error,
  });

  @override
  List<Object?> get props => [isUploaded, error];
}
