import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/shared/bloc/profile/profile_bloc.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangePassword> {
  TextEditingController _textEditingController = TextEditingController();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _displayAppBar(),
      backgroundColor: Colors.white,
      body: _displayContents(),
    );
  }

  Widget _displayContents() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(30.0),
      height: AppScreenConfig.safeBlockVertical! * 100,
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: _profileBlocListener,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: ((previous, current) =>
              current is ChangePasswordLoadedState ||
              current is ChangePasswordLoader),
          builder: (context, state) {
            if (state is ChangePasswordLoader) {
              return Center(child: AppCircularProgressIndicator());
            }

            return _displayScreenContent();
          },
        ),
      ),
    );
  }

  Widget _displayScreenContent() {
    return ListView(
      children: [
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Change",
              style: Theme.of(context).textTheme.headline4,
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "Password",
              style: Theme.of(context).textTheme.headline4,
            )
          ],
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextFormField(
            obscureText: !showPassword,
            controller: _textEditingController,
            cursorColor: LightAppColors.appBlueColor,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              filled: true,
              fillColor: LightAppColors.greyColor.withOpacity(0.1),
              // prefixIcon: Icon(Icons.mail, color: Colors.grey),
              hintText: "Enter new password",

              hintStyle: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontWeight: FontWeight.w400, color: Colors.grey),
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
                return "Enter new password";
              }
              return null;
            },
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 50,
            width: double.maxFinite,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(LightAppColors.blackColor),
              ),
              onPressed: () => BlocProvider.of<ProfileBloc>(context).add(
                  ChangePasswordEvent(password: _textEditingController.text)),
              child: Text(
                'Change Password',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  AppBar _displayAppBar() {
    return AppBar(
      backgroundColor: LightAppColors.cardBackground,
      elevation: 0.0,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 18,
        ),
      ),
      // title: Text("Edit", style: Theme.of(context).textTheme.headline6),
    );
  }

  void _profileBlocListener(context, state) {
    if (state is ChangePasswordLoadedState) {
      if (state.passwordChanged) {
        Utils.showSuccessToast("Your password is successfully changed");
        Navigator.pop(context);
      } else {
        Utils.showSuccessToast(state.reason);
      }
    }
  }
}
