import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/data/exception.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/functions/fun.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/staged_solid_button.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final formKey = GlobalKey<FormState>();
  File? _file;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerLocation = TextEditingController();

  bool _public = false;

  String? stage;
  String? errorMessage;

  _createNewGroup() async {
    if (!formKey.currentState!.validate()) return;
    try {
      setState(() {
        stage = "WAITING";
      });

      if (await Store()
          .groupNameAlreadyExists(controllerName.value.text.trim())) {
        throw MyException("Group name already exists");
      }
      var groupUid = await FBFunctions().createNewGroup.call({
        'name': controllerName.value.text.trim(),
        'location': controllerLocation.value.text.trim(),
        'public': _public,
      });
      if (_file != null) {
        await DB().uploadPhoto(
            file: _file!, folder: DB().groupFolder, uid: groupUid.data);
      }

      if (mounted) {
        setState(() {
          stage = "DONE";
        });
        context.go("/main", extra: 0);
      }
    } on MyException catch (e) {
      setState(() {
        errorMessage = e.message;
        stage = "ERROR";
      });
    } catch (e) {
      setState(() {
        stage = "ERROR";
      });
    } finally {
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            stage = null;
          });
        }
      });
    }
  }

  _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'New group',
              color: grey,
              size: 18,
              weight: FontWeight.bold,
            ),
            CustomText(
              text: 'Create place for your route mates',
              color: grey2,
              size: 16,
              fontFamily: Fonts().secondary,
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            context.go('/main', extra: 0);
          },
          iconSize: 32,
          splashRadius: 24,
          icon: Icon(
            Icons.arrow_back_rounded,
            color: grey,
          ),
        ),
      ],
    );
  }

  _photoBox() {
    return Container(
      height: 130,
      width: 130,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
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
            });
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            color: darkGrey,
            image: _file != null
                ? DecorationImage(
                    image: FileImage(_file!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_camera_outlined,
                  color: grey2,
                  size: 28,
                  shadows: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0, 0),
                      blurRadius: 20,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _form() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextInputWid(
            keyboard: TextInputType.emailAddress,
            isPassoword: false,
            label: "Group name*",
            controller: controllerName,
            color: grey,
            secondaryColor: blueLight2,
            validator: usernameValidator,
            fillColor: darkGrey,
            fontSize: 18,
          ),
          const SizedBox(
            height: 16,
          ),
          TextInputWid(
            keyboard: TextInputType.visiblePassword,
            label: "Location${_public ? "*" : ""}",
            isPassoword: false,
            controller: controllerLocation,
            color: grey,
            secondaryColor: blueLight2,
            validator: _public ? inputValidator : emptyInputValidator,
            fillColor: darkGrey,
            fontSize: 18,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(
              text: "required*",
              color: blueLink,
              fontFamily: Fonts().secondary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  showDuration: const Duration(seconds: 5),
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.all(8),
                  textStyle: TextStyle(
                    fontFamily: Fonts().secondary,
                    color: grey2,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  decoration: BoxDecoration(
                      color: blueLink, borderRadius: BorderRadius.circular(8)),
                  message: PUBLIC_GROUP_TOOLTIP_MESSAGE,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_rounded,
                        color: grey2,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      CustomText(
                        text: "Visibility: ${_public ? "Public" : "Private"}",
                        size: 16,
                        color: grey,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                ),
                Switch(
                  inactiveTrackColor: blueLink,
                  inactiveThumbColor: grey,
                  activeColor: orange,
                  value: _public,
                  onChanged: (public) {
                    setState(() {
                      _public = public;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          StageSolidButton(
            borderRadius: 25,
            text: 'Create new group',
            buttonColor: orange,
            textColor: blueDark,
            onPressFn: _createNewGroup,
            textWeight: FontWeight.bold,
            height: 45,
            stage: stage,
            errorMessage: errorMessage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      body: SafeArea(
        child: GestureDetector(
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
            padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
            child: Column(
              children: [
                _header(),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        _photoBox(),
                        const SizedBox(
                          height: 48,
                        ),
                        _form(),
                        const SizedBox(
                          height: 48,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
