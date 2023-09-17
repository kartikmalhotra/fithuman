import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/shared/bloc/auth/auth_bloc.dart';
import 'package:brainfit/widget/widget.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: _listener,
          child: BlocBuilder<AuthBloc, AuthState>(
            buildWhen: ((previous, current) =>
                current is ForgetPasswordLoader ||
                current is ForgetPasswordState),
            builder: (context, state) {
              return _displayResetPasswordContents(state);
            },
          ),
        ),
      ),
    );
  }

  Widget _displayResetPasswordContents(state) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.all(0.0),
                    icon: Icon(Icons.arrow_back_ios),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 80),
              Text("Forgot", style: Theme.of(context).textTheme.headline4),
              SizedBox(height: 10.0),
              Text("Password", style: Theme.of(context).textTheme.headline4),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  controller: _emailController,
                  cursorColor: LightAppColors.appBlueColor,
                  validator: (String? text) {
                    if (text?.isEmpty ?? true) {
                      return "Enter your email";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: Colors.grey.withOpacity(0.1),
                    prefixIcon: Icon(Icons.mail_outline, color: Colors.grey),
                    hintStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.w400, color: Colors.grey),
                    labelStyle: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Email",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: SizedBox(
                  height: 50,
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(5.0),
                        backgroundColor: MaterialStateProperty.all(
                            LightAppColors.secondary)),
                    onPressed: () {
                      if (_emailController.text.isNotEmpty) {
                        BlocProvider.of<AuthBloc>(context).add(
                            ForgetPasswordEvent(email: _emailController.text));
                      }
                    },
                    child: Text(
                      'Confirm',
                      style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: LightAppColors.cardBackground,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (state is ForgetPasswordLoader) ...[
          Center(
            child: AppCircularProgressIndicator(),
          )
        ]
      ],
    );
  }
}

void _listener(context, state) {
  if (state is ForgetPasswordState) {
    if (state.message?.isNotEmpty ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: visionColor,
          content: Text(state.message.toString(),
              style: Theme.of(context).textTheme.bodyText1)));
    } else if (state.errorResult?.isNotEmpty ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(state.errorResult.toString())));
    }
  }
}
