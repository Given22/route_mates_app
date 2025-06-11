import 'dart:async';
import 'package:flutter/material.dart';
import 'package:route_mates/data/exception.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/staged_solid_button.dart';
import 'package:route_mates/src/widgets/buttons/text_button.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/functions/fun.dart';
import 'package:route_mates/utils/profile/profile.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({super.key});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final TextEditingController _controllerName = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? _file;

  String? _stage;
  String? _errorMessage;

  Future<void> createProfile() async {
    if (formKey.currentState!.validate()) {
      try {
        setState(() {
          _stage = 'WAITING';
        });

        await Profile().setNewName(_controllerName.text.trim());
        if (_file != null) {
          await Profile().setPhoto(_file!);
        }

        setState(() {
          _stage = 'DONE';
        });

        if (mounted) {
          context.go('/first_vehicle');
        }
      } on MyException catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = e.message;
            _stage = 'ERROR';
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _stage = 'ERROR';
          });
        }
      } finally {
        Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _errorMessage = null;
              _stage = null;
            });
          }
        });
      }
    }
  }

  _imageContainer() {
    return GestureDetector(
      onTap: () async {
        var file = await getPhotoFromGallery(1, 1);
        if (file != null) {
          setState(() {
            _file = file;
          });
        }
      },
      child: Container(
        height: 128,
        width: 128,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          color: darkGrey3,
          boxShadow: [
            BoxShadow(
              color: Colors.black38.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: _file == null
              ? Icon(
                  Icons.photo_camera_rounded,
                  size: 40,
                  color: grey2,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.file(
                    _file!,
                    width: 128,
                    fit: BoxFit.fill,
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  darkBg2,
                  darkBg,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "CREATE YOUR PROFILE",
                    color: grey,
                    weight: FontWeight.bold,
                    size: 20,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _imageContainer(),
                        TextButtonWid(
                          onPressFn: () async {
                            var file = await getPhotoFromGallery(1, 1);
                            if (file != null) {
                              setState(() {
                                _file = file;
                              });
                            }
                          },
                          text: 'Choose your profile picture',
                          textColor: grey,
                          textWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 32),
                        Form(
                          key: formKey,
                          child: TextInputWid(
                            isPassoword: false,
                            label: "Name",
                            controller: _controllerName,
                            color: grey,
                            secondaryColor: orange,
                            validator: usernameValidator,
                            fillColor: darkGrey,
                          ),
                        ),
                        const SizedBox(height: 64),
                        StageSolidButton(
                          borderRadius: 25,
                          text: 'Create',
                          buttonColor: orange,
                          textColor: blueDark,
                          onPressFn: createProfile,
                          height: 45,
                          stage: _stage,
                          errorMessage: _errorMessage,
                          textWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
