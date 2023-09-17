import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/const/app_constants.dart';
import 'package:brainfit/screens/assessment/chart_assessment.dart';

import 'package:brainfit/shared/bloc/auth/auth_bloc.dart';
import 'package:brainfit/screens/authentication/screens/forget.dart';
import 'package:brainfit/screens/authentication/screens/signup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:brainfit/shared/bloc/profile/profile_bloc.dart';
import 'package:brainfit/widget/widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late bool showPassword;

  @override
  void initState() {
    showPassword = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: _listener,
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: ((previous, current) =>
              current is! SignupResultState || current is! SignUpLoader),
          builder: (context, state) {
            return _displayLoginPage(state);
          },
        ),
      ),
    );
  }

  void _listener(context, state) {
    if (state is LogoutState) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => true);
    } else if (state is LoginResultState) {
      if (!state.loggedIn) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(state.errorResult?.toString() ?? "")));
      } else {
        _fetchData(state.takeAssessment);
      }
    }
  }

  Widget _displayLoginPage(state) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Opacity(
            opacity: state is AuthLoader ? 0.3 : 1,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 40),
                  // Center(
                  //     child: Text(
                  //   "Login to your Account",
                  //   style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  //         color: LightAppColors.primary,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  // )),

                  Image.asset("assets/images/logo.jpg",
                      height: 100, width: double.maxFinite),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextFormField(
                      cursorColor: LightAppColors.appBlueColor,
                      controller: _emailController,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontWeight: FontWeight.w700),
                      decoration: InputDecoration(
                        filled: true,
                        prefixIcon:
                            Icon(Icons.mail_outline, color: Colors.grey),
                        fillColor: LightAppColors.greyColor.withOpacity(0.1),
                        // prefixIcon: Icon(Icons.mail, color: Colors.grey),
                        hintText: "Enter your email",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.w700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      validator: (String? text) {
                        if (text?.isEmpty ?? true) {
                          return "Enter your email";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                      cursorColor: LightAppColors.appBlueColor,
                      controller: _passwordController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        fillColor: LightAppColors.greyColor.withOpacity(0.1),
                        filled: true,
                        prefixIcon:
                            Icon(Icons.lock_outline, color: Colors.grey),
                        hintText: "Enter your password",
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontWeight: FontWeight.w700),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        suffixIcon: IconButton(
                          icon: Icon(
                            showPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          },
                        ),
                      ),
                      validator: (String? text) {
                        if (text?.isEmpty ?? true) {
                          return "Enter your password";
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ResetPassword()));
                        },
                        child: Text("Forgot password?",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black)),
                      )
                    ],
                  ),
                  SizedBox(height: AppScreenConfig.safeBlockVertical! * 8),
                  SizedBox(
                    height: 50.0,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5.0),
                          backgroundColor: MaterialStateProperty.all(
                              LightAppColors.secondary)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            BlocProvider.of<AuthBloc>(context).add(LoginEvent(
                                email: _emailController.text,
                                password: _passwordController.text));
                          }
                        }
                      },
                      child: Center(
                        child: Text(
                          'Login',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                        ),
                      ),
                      // child: Text('outline button'),
                    ),
                  ),

                  SizedBox(height: 15.0),
                  SizedBox(
                    height: 50,
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5.0),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      onPressed: () {
                        _emailController.text = _passwordController.text = "";
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign up',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.black87, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  showORDivider(),
                  const SizedBox(height: 20),
                  signWithGoogleFacebookApple()
                ],
              ),
            ),
          ),
        ),
        if (state is AuthLoader ||
            (state is LoginResultState && state.loggedIn)) ...[
          const Center(child: AppCircularProgressIndicator())
        ]
      ],
    );
  }

  Widget signWithGoogleFacebookApple() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () => BlocProvider.of<AuthBloc>(context).add(FacebookLogin()),
          child: Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[100],
              // border: Border.all(width: 0.1)
              // image: DecorationImage(
              //   image: AssetImage(facebookImage),
              // ),
            ),
            child: Image.asset("assets/images/logo/facebook-logo.png"),
          ),
        ),
        InkWell(
          onTap: () => BlocProvider.of<AuthBloc>(context).add(GoogleLogin()),
          child: Container(
            height: 50.0,
            width: 50.0,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
              // border: Border.all(width: 0.1),
            ),
            child: Image.asset(googleImage),
          ),
        ),
        if (Platform.isIOS) ...[
          InkWell(
            onTap: () => BlocProvider.of<AuthBloc>(context).add(AppleLogin()),
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],

                // border: Border.all(width: 0.1),
              ),
              child: appleImage.contains("svg")
                  ? SvgPicture.asset(
                      appleImage,
                      height: 10.0,
                      width: 10.0,
                    )
                  : Image.asset(appleImage),
            ),
          )
        ],
      ],
    );
  }

  Widget showORDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: Divider(color: Colors.grey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "or Sign in with",
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey)),
      ],
    );
  }

  void _fetchData(bool takeAssessment) async {
    String? assessmentQuestion =
        Application.localStorageService?.lastAssessment;
    if (assessmentQuestion != null) {
      var response = await Application.restService!.requestCall(
          apiEndPoint: "api/assessments",
          requestParmas: jsonDecode(assessmentQuestion),
          addAutherization: true,
          method: RestAPIRequestMethods.post);

      if (response['code'] == 200 || response['code'] == "200") {
        Application.localStorageService?.lastAssessment = null;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              settings: RouteSettings(name: "AB"),
              builder: (context) => AssessmentChartScreen(
                  assessmentResult: response["data"],
                  assessmentAfterLogin: true),
            ),
            (route) => false);
      } else if (takeAssessment) {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.assessmentScreen, ((route) => false));
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, ((route) => false));
      }
    }
  }
}
