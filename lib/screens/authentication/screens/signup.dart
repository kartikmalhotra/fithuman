import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/shared/bloc/auth/auth_bloc.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.navigate_before,
            size: 24,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: _listener,
        child: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: ((previous, current) =>
              current is! SignupResultState || current is! SignUpLoader),
          builder: (context, state) {
            return _displaySignupContents(state);
          },
        ),
      ),
    );
  }

  void _listener(context, state) {
    if (state is SignupResultState &&
        state.signedIn &&
        state.errorResult == null) {
      Utils.showSuccessToast("Your Account is created");
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => true);
    } else if (state is SignupResultState &&
        (state.errorResult?.isNotEmpty ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(state.errorResult.toString())));
    }
  }

  Widget _displaySignupContents(state) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Center(
                //     child: Text(
                //   "Login to your Account",
                //   style: Theme.of(context).textTheme.bodyText1!.copyWith(
                //         color: LightAppColors.primary,
                //         fontWeight: FontWeight.bold,
                //       ),
                // )),
                Image.asset(
                  "assets/images/logo.jpg",
                  width: double.maxFinite,
                  height: 120,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    cursorColor: LightAppColors.blackColor,
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),

                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                      fillColor: Colors.grey.withOpacity(0.07),
                      prefixIcon:
                          Icon(Icons.person_outline, color: Colors.grey),
                      helperStyle: const TextStyle(color: Colors.black),

                      // border: OutlineInputBorder(
                      //   borderRadius: BorderRadius.circular(5),
                      //   borderSide: BorderSide(width: 1),
                      // ),
                      labelText: 'Name',
                    ),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return "Enter a name";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    cursorColor: LightAppColors.appBlueColor,
                    controller: _emailController,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.w700),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: LightAppColors.greyColor.withOpacity(0.08),
                      prefixIcon: Icon(Icons.mail_outline, color: Colors.grey),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                              fontWeight: FontWeight.w700, color: Colors.grey),
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                              fontWeight: FontWeight.w700, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Email',
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
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    cursorColor: LightAppColors.appBlueColor,
                    controller: _passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      fillColor: LightAppColors.greyColor.withOpacity(0.08),
                      filled: true,
                      prefixIcon:
                          Icon(Icons.lock_outline_rounded, color: Colors.grey),
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                              fontWeight: FontWeight.w700, color: Colors.grey),
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                              fontWeight: FontWeight.w700, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: 'Password',
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: TextFormField(
                    obscureText: !showConfirmPassword,
                    cursorColor: LightAppColors.blackColor,
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      hintStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                      labelStyle: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                      fillColor: Colors.grey.withOpacity(0.08),
                      prefixIcon:
                          Icon(Icons.lock_outline_rounded, color: Colors.grey),
                      helperStyle: const TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          showConfirmPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            showConfirmPassword = !showConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (String? text) {
                      if (text?.isEmpty ?? true) {
                        return "Enter your password";
                      }
                      if (_confirmPasswordController.text !=
                          _passwordController.text) {
                        return "Password and Confirm Password should be same";
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: SizedBox(
                    height: 50,
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(5.0),
                          backgroundColor: MaterialStateProperty.all(
                              LightAppColors.secondary)),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (_nameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty &&
                              _confirmPasswordController.text.isNotEmpty) {
                            BlocProvider.of<AuthBloc>(context).add(
                              SignUpEvent(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  name: _nameController.text),
                            );
                          }
                        }
                      },
                      child: Text(
                        'Signup',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (state is SignUpLoader) ...[
          const Center(child: AppCircularProgressIndicator())
        ]
      ],
    );
  }
}
