import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/shared/bloc/profile/profile_bloc.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class ChangeName extends StatefulWidget {
  ChangeName({Key? key}) : super(key: key);

  @override
  State<ChangeName> createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  TextEditingController _textEditingController = TextEditingController();

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
              current is ChangeNameLoadedState || current is ChangeNameLoader),
          builder: (context, state) {
            if (state is ChangeNameLoader) {
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
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 7),
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
              "Name",
              style: Theme.of(context).textTheme.headline4,
            )
          ],
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 5),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: TextFormField(
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
              hintText: "Enter your name",
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
            ),
            validator: (String? text) {
              if (text?.isEmpty ?? true) {
                return "Enter your name";
              }
              return null;
            },
          ),
        ),
        SizedBox(height: AppScreenConfig.safeBlockVertical! * 10),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(LightAppColors.blackColor),
            ),
            onPressed: () => BlocProvider.of<ProfileBloc>(context)
                .add(ChangeNameEvent(name: _textEditingController.text)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Text(
                'Change Name',
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
    if (state is ChangeNameLoadedState) {
      if (state.nameChanged) {
        Utils.showSuccessToast("Your name is successfully changed");
        Navigator.pop(context);
      } else {
        Utils.showSuccessToast(state.reason);
      }
    }
  }
}
