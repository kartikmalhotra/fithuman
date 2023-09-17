import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:brainfit/config/application.dart';
import 'package:brainfit/config/theme/theme.dart';
import 'package:brainfit/config/theme/theme_config.dart';
import 'package:brainfit/shared/bloc/profile/profile_bloc.dart';
import 'package:brainfit/utils/utils.dart';
import 'package:brainfit/widget/widget.dart';

class EditProfilePic extends StatelessWidget {
  EditProfilePic({Key? key}) : super(key: key);

  Map<String, dynamic> userInfo = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: ((context, state) {
            if (state is ProfileLoadedState) {
              userInfo = state.data ?? {};
            }
          }),
          child: BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: ((previous, current) =>
                current is ProfileLoadedState || current is ProfileLoader),
            builder: (context, state) {
              if (state is ProfileLoader) {
                return Center(child: AppCircularProgressIndicator());
              }
              if (state is ProfileLoadedState) {
                userInfo = state.data ?? {};

                return Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _displayProfilePic(context),
                      _changeImage(context),
                      _deleteImage(context),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _changeImage(BuildContext context) {
    return ListTile(
      title: Text("Change Image"),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: Text("Select Image from"),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(.0),
                      child: TextButton(
                        child: Text("Gallery"),
                        onPressed: () =>
                            _pickProfilePic(context, ImageSource.gallery),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(.0),
                      child: TextButton(
                        child: Text("Camera"),
                        onPressed: () =>
                            _pickProfilePic(context, ImageSource.camera),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
              ],
            );
          },
        );
      },
    );
  }

  Widget _deleteImage(context) {
    return ListTile(
      title: Text("Delete Image", style: Theme.of(context).textTheme.subtitle1),
      onTap: () => BlocProvider.of<ProfileBloc>(context).add(
        DeleteMediaEvent(),
      ),
    );
  }

  Widget _displayProfilePic(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: LightAppColors.greyColor.withOpacity(0.2),
      height: AppScreenConfig.safeBlockVertical! * 50,
      child: Stack(
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          Center(
            child: InkWell(
              onTap: () {},
              child: BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: ((previous, current) =>
                    current is UploadingMediaLoaderState ||
                    current is MediaUploadedState),
                builder: (context, state) {
                  return ClipOval(
                    child: Container(
                      color: Colors.white,
                      height: 150,
                      width: 150.0,
                      child: state is! UploadingMediaLoaderState
                          ? (userInfo["profile"]?["profile_pic"] != null)
                              ? CachedNetworkImage(
                                  imageUrl: userInfo["profile"]["profile_pic"],
                                  fit: BoxFit.fill,
                                  placeholder: (_, __) {
                                    return Center(
                                      child: AppCircularProgressIndicator(),
                                    );
                                  },
                                  errorWidget: (_, __, ___) {
                                    return Center(
                                      child: AppCircularProgressIndicator(),
                                    );
                                  },
                                )
                              : Center(
                                  child: Container(
                                    child: Icon(Icons.person,
                                        size: 60, color: Colors.grey),
                                  ),
                                )
                          : Center(
                              child: AppCircularProgressIndicator(),
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickProfilePic(context, ImageSource imageSource) async {
    Map<String, dynamic> image =
        await Application.nativeAPIService!.pickImage(imageSource);
    if (image["image"] != null) {
      BlocProvider.of<ProfileBloc>(context).add(
        UploadMediaUrlEvent(
          dateTime: DateTime.now(),
          imageLocalPath: image['image'],
        ),
      );
    } else {
      if (image["error"] != null && image["error"].isNotEmpty) {
        Utils.showFailureToast(image["error"]);
      }
    }
  }
}
