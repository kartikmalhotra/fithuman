import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:brainfit/config/routes/routes_const.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/screens/change_name.dart';
import 'package:brainfit/screens/change_password.dart';
import 'package:brainfit/screens/profile/edit_profile_pic.dart';
import 'package:brainfit/shared/bloc/auth/auth_bloc.dart';
import 'package:brainfit/shared/bloc/profile/profile_bloc.dart';
import 'package:brainfit/widget/widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userInfo = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<AuthBloc, AuthState>(
          listener: _authBlocListener,
          child: _displayProfileScreenContent(),
        ),
      ),
    );
  }

  Widget _displayProfileScreenContent() {
    return Container(
      color: Colors.white,
      height: AppScreenConfig.safeBlockVertical! * 100,
      width: AppScreenConfig.safeBlockHorizontal! * 100,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthLoader) {
            return const Center(child: AppCircularProgressIndicator());
          }
          return _displayProfileScreen();
        },
      ),
    );
  }

  Widget _displayProfileScreen() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: ((previous, current) =>
          current is ProfileLoadedState || current is ProfileLoader),
      builder: (context, state) {
        if (state is ProfileLoader) {
          return Center(child: AppCircularProgressIndicator());
        }
        if (state is ProfileLoadedState) {
          userInfo = state.data ?? {};
          return Container(
            height: AppScreenConfig.safeBlockVertical! * 100,
            child: Stack(
              children: <Widget>[
                _displayScreenContent(state),
                _displayLogoutButton(),
                _displayChangePasswordButton(context),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget _displayLogoutButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: LightAppColors.greyColor.withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        height: 140,
        width: double.maxFinite,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
              },
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Logout",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayChangePasswordButton(context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: LightAppColors.blackColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePassword(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Change Password",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _displayScreenContent(ProfileState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _displayAppBar(context),
          SizedBox(height: 30.0),
          _displayProfilePic(context),
          _displayUserInfo(context),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }

  Widget _displayProfilePic(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => EditProfilePic())),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: ((previous, current) =>
                current is UploadingMediaLoaderState ||
                current is MediaUploadedState),
            builder: (context, state) {
              return ClipOval(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  height: 150,
                  width: 150.0,
                  child: state is! UploadingMediaLoaderState &&
                          userInfo["profile"]?["profile_pic"] != null
                      ? CachedNetworkImage(
                          imageUrl: userInfo["profile"]["profile_pic"],
                          placeholder: (context, url) =>
                              Center(child: new CircularProgressIndicator()),
                          fit: BoxFit.fill,
                          errorWidget: (context, url, error) {
                            return Container();
                          },
                        )
                      : Center(
                          child: Container(
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _displayAppBar(context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        constraints: BoxConstraints(),
        onPressed: () => Navigator.pop(context),
        icon: Icon(
          Icons.arrow_back_ios,
          size: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _displayUserInfo(context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          if (userInfo.isEmpty || userInfo["profile"]["name"] != null) ...[
            Wrap(
              children: <Widget>[
                Text(
                  userInfo["profile"]?["name"] ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.black87),
                ),
                SizedBox(width: 5.0),
                IconButton(
                  constraints: BoxConstraints(),
                  padding: EdgeInsets.all(0.0),
                  icon: Icon(Icons.edit,
                      size: 18, color: LightAppColors.greyColor),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeName(),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10.0),
          ],
          if (userInfo.isEmpty || userInfo["profile"]["email"] != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  userInfo["profile"]?["email"] ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(color: Colors.grey),
                )
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ],
      ),
    );
  }

  void _authBlocListener(context, state) {
    if (state is LogoutState && state.isLogout) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.login, (route) => false);
    }
  }
}
