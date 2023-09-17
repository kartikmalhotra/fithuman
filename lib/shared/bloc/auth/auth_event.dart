part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class ForgetPasswordEvent extends AuthEvent {
  final String email;

  const ForgetPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}

class LogoutEvent extends AuthEvent {
  const LogoutEvent();

  @override
  List<Object> get props => [];
}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  const SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, password];
}

class SendFirebaseTokenToServer extends AuthEvent {
  final String firebaseToken;

  const SendFirebaseTokenToServer({required this.firebaseToken});
}

class GoogleLogin extends AuthEvent {
  const GoogleLogin();

  @override
  List<Object> get props => [];
}

class FacebookLogin extends AuthEvent {
  const FacebookLogin();

  @override
  List<Object> get props => [];
}

class AppleLogin extends AuthEvent {
  const AppleLogin();

  @override
  List<Object> get props => [];
}
