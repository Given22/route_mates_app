import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/exception.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/functions/fun.dart';
import 'package:route_mates/src/widgets/buttons/staged_solid_button.dart';
import 'package:route_mates/src/widgets/buttons/text_button.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/utils/profile/profile.dart';
import 'package:shimmer/shimmer.dart';

class EditProfileDataBox extends StatefulWidget {
  const EditProfileDataBox({super.key});

  @override
  State<EditProfileDataBox> createState() => _EditProfileDataBoxState();
}

class _EditProfileDataBoxState extends State<EditProfileDataBox> {
  final TextEditingController _controllerName = TextEditingController();
  final FocusNode _usernameFocusNode = FocusNode();

  File? _file;

  bool _removePhoto = false;

  String? stage;
  String? errorMessage;

  final formKey = GlobalKey<FormState>();

  _photoBox(uid) {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: darkGrey,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 5),
            blurRadius: 10,
          )
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          var newfile = await getPhotoFromGallery(1, 1);
          if (newfile != null) {
            setState(() {
              _file = newfile;
              _removePhoto = false;
            });
          }
        },
        child: FutureBuilder(
          future: DB().getPhotoUrl(folder: DB().profileFolder, uid: uid),
          builder: (BuildContext context, AsyncSnapshot<String> future) {
            if (future.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: darkGrey,
                highlightColor: grey2,
                child: Container(
                  width: 110,
                  height: 110,
                  color: darkGrey,
                ),
              );
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: darkBg2,
                image: _file != null
                    ? DecorationImage(
                        image: FileImage(_file!),
                        fit: BoxFit.cover,
                      )
                    : _removePhoto
                        ? DecorationImage(
                            image: AssetImage(DB().profileAsset),
                            fit: BoxFit.cover,
                          )
                        : future.data! != ''
                            ? DecorationImage(
                                image: CachedNetworkImageProvider(future.data!),
                                fit: BoxFit.cover,
                              )
                            : DecorationImage(
                                image: AssetImage(DB().profileAsset),
                                fit: BoxFit.cover,
                              ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_camera_outlined,
                      color: grey,
                      size: 28,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _updateProfileButton() {
    Future<void> updateProfile() async {
      final profileUid = Auth().currentUser?.uid;
      if (profileUid == null) return;

      try {
        setState(() {
          stage = 'WAITING';
          errorMessage = null;
        });

        if (formKey.currentState!.validate()) {
          await Profile().setName(_controllerName.text.trim());
        } else {
          throw "";
        }

        if (_removePhoto == true) {
          await Profile().removePhoto();
        } else if (_file != null) {
          await Profile().setPhoto(_file!);
        }

        setState(() {
          stage = 'DONE';
          _file = null;
        });
      } on MyException catch (e) {
        setState(() {
          stage = 'ERROR';
          errorMessage = e.message;
        });
      } catch (e) {
        setState(() {
          stage = 'ERROR';
        });
      } finally {
        _usernameFocusNode.unfocus();
        Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              errorMessage = null;
              stage = null;
            });
          }
        });
      }
    }

    return StageSolidButton(
      borderRadius: 16,
      text: 'Update profile',
      buttonColor: orange,
      textColor: darkBg,
      onPressFn: updateProfile,
      height: 45,
      textHeight: 18,
      textWeight: FontWeight.bold,
      stage: stage,
      errorMessage: errorMessage,
    );
  }

  @override
  void initState() {
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context, listen: false);

    if (user.hasData) {
      _controllerName.text = user.data?.displayName ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context);

    if (!user.hasData) {
      return const Center(
        child: CustomText(text: "We cannot connect to the server"),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: darkGrey3,
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Column(
                  children: [
                    _photoBox(user.data!.uid),
                    TextButtonWid(
                      onPressFn: () {
                        if (!_removePhoto) {
                          setState(() {
                            _file = null;
                          });
                        }
                        setState(() {
                          _removePhoto = !_removePhoto;
                        });
                      },
                      text: 'Remove',
                      textColor: blueLink,
                      textWeight: FontWeight.bold,
                      textSize: 16,
                    ),
                  ],
                ),
                Form(
                  key: formKey,
                  child: TextFormField(
                    keyboardType: TextInputType.name,
                    maxLength: 30,
                    expands: false,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: grey,
                        fontSize: 18,
                        fontFamily: Fonts().primary,
                        fontWeight: FontWeight.bold),
                    validator: usernameValidator,
                    controller: _controllerName,
                    obscureText: false,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 16),
                      labelText: "Username",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      errorStyle: TextStyle(
                        color: redLight,
                        fontFamily: Fonts().primary,
                        fontSize: 12,
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: red),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: red, width: 2)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: grey2, width: 2),
                          borderRadius: BorderRadius.circular(0.0)),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: grey2, width: 2),
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      labelStyle: TextStyle(
                        color: grey.withOpacity(0.7),
                        fontFamily: Fonts().secondary,
                      ),
                      counter: const SizedBox(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          _updateProfileButton()
        ],
      ),
    );
  }
}
