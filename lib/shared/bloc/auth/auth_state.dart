part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();

  @override
  List<Object?> get props => [];
}

class AuthLoader extends AuthState {
  const AuthLoader();

  @override
  List<Object?> get props => [];
}

class ForgetPasswordLoader extends AuthState {
  const ForgetPasswordLoader();

  @override
  List<Object?> get props => [];
}

class SignUpLoader extends AuthState {
  const SignUpLoader();

  @override
  List<Object?> get props => [];
}

class SignupResultState extends AuthState {
  final bool signedIn;
  final String? errorResult;

  const SignupResultState({
    this.signedIn = false,
    this.errorResult,
  });

  @override
  List<Object?> get props => [signedIn, errorResult];
}

class LoginResultState extends AuthState {
  final bool loggedIn;
  final String? errorResult;
  final bool takeAssessment;

  const LoginResultState({
    required this.loggedIn,
    this.errorResult,
    this.takeAssessment = false,
  });

  @override
  List<Object?> get props => [loggedIn, errorResult, takeAssessment];
}

class ForgetPasswordState extends AuthState {
  final String? message;
  final String? errorResult;

  const ForgetPasswordState({
    this.message,
    this.errorResult,
  });

  @override
  List<Object?> get props => [message, errorResult];
}

class LogoutState extends AuthState {
  final bool isLogout;
  final String? error;

  const LogoutState({required this.isLogout, this.error});

  @override
  List<Object?> get props => [isLogout, error];
}
