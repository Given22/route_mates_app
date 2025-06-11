import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/functions/fun.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/staged_solid_button.dart';
import 'package:route_mates/src/widgets/buttons/text_button.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/utils/confirm_action_service.dart';
import 'package:shimmer/shimmer.dart';

class EditVehicleScreen extends StatefulWidget {
  const EditVehicleScreen({
    super.key,
    required this.uid,
    required this.name,
    required this.description,
  });

  final String uid;
  final String name;
  final String? description;

  @override
  State<EditVehicleScreen> createState() => _NewVehicleScreenState();
}

class _NewVehicleScreenState extends State<EditVehicleScreen> {
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  File? file;

  String? stage;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controllerName.text = widget.name;
    if (widget.description != null) {
      controllerDescription.text = widget.description!;
    }
    super.initState();
  }

  Future<void> editVehicle() async {
    try {
      setState(() {
        stage = 'WAITING';
      });

      if (formKey.currentState!.validate()) {
        await FBFunctions().editVehicle({
          'name': controllerName.text.trim(),
          'description': controllerDescription.text.trim(),
          'uid': widget.uid,
        });

        if (file != null) {
          await DB().uploadPhoto(
              file: file!, folder: DB().vehicleFolder, uid: widget.uid);
        }

        setState(() {
          stage = 'DONE';
        });

        if (mounted) {
          context.pop();
        }
      } else {
        setState(() {
          stage = null;
        });
      }
    } catch (e) {
      setState(() {
        stage = 'ERROR';
      });

      Fluttertoast.showToast(
          msg: "We can't update the vehicle, please try again later.",
          toastLength: Toast.LENGTH_SHORT);
    }
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          stage = null;
        });
      }
    });
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
              text: 'Update',
              color: grey,
              size: 20,
              weight: FontWeight.w600,
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 30,
          splashRadius: 24,
          icon: Icon(
            Icons.arrow_downward_outlined,
            color: grey,
          ),
        ),
      ],
    );
  }

  _photoBox() {
    return Container(
      height: 180,
      width: 270,
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
          var newfile = await getPhotoFromGallery(3, 2);
          if (newfile != null) {
            setState(() {
              file = newfile;
            });
          }
        },
        child: FutureBuilder(
          future: DB().getPhotoUrl(
            folder: DB().vehicleFolder,
            uid: widget.uid,
          ),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                baseColor: darkGrey,
                highlightColor: grey2,
                child: Container(
                  height: 180,
                  width: 270,
                  color: darkGrey,
                ),
              );
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                color: darkGrey,
                image: file != null
                    ? DecorationImage(
                        opacity: 0.6,
                        image: FileImage(file!),
                        fit: BoxFit.cover,
                      )
                    : snapshot.data! != ''
                        ? DecorationImage(
                            opacity: 0.6,
                            image: CachedNetworkImageProvider(
                              snapshot.data!,
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
              ),
              child: Center(
                child: file == null && snapshot.data! == ''
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            color: file == null ? grey2 : grey,
                            size: 28,
                          ),
                          CustomText(
                            text: "Add photo",
                            color: grey2,
                            weight: FontWeight.w300,
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            color: grey2,
                            size: 28,
                          ),
                          CustomText(
                            text: "Change photo",
                            color: grey2,
                            weight: FontWeight.w600,
                          )
                        ],
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  _form() {
    nameInput() {
      return TextFormField(
        controller: controllerName,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 32,
        validator: (value) {
          if (value.toString().trim().isEmpty) {
            return 'Your vehicle need a name';
          }
          return null;
        },
        style: TextStyle(
          color: grey,
        ),
        decoration: InputDecoration(
          labelText: 'Name',
          isDense: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          alignLabelWithHint: true,
          errorStyle: TextStyle(
            color: redLight,
            fontFamily: Fonts().primary,
            fontSize: 12,
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: red),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelStyle: TextStyle(color: grey),
          counterStyle: TextStyle(color: grey),
          filled: true,
          fillColor: darkGrey,
        ),
      );
    }

    descriptionInput() {
      return TextFormField(
        controller: controllerDescription,
        inputFormatters: [
          TextInputFormatter.withFunction((oldValue, newValue) {
            int newLines = newValue.text.split('\n').length;
            if (newLines > 5) {
              return oldValue;
            } else {
              return newValue;
            }
          }),
        ],
        maxLines: 5,
        maxLength: 255,
        textAlignVertical: TextAlignVertical.top,
        style: TextStyle(
          color: grey,
        ),
        decoration: InputDecoration(
          labelText: 'Descripton',
          floatingLabelBehavior: FloatingLabelBehavior.never,
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 2),
            borderRadius: BorderRadius.circular(10.0),
          ),
          labelStyle: TextStyle(color: grey),
          counterStyle: TextStyle(color: grey),
          filled: true,
          fillColor: darkGrey,
        ),
      );
    }

    return Form(
      key: formKey,
      child: Column(
        children: [
          nameInput(),
          const SizedBox(
            height: 16,
          ),
          descriptionInput(),
          const SizedBox(
            height: 24,
          ),
          StageSolidButton(
            borderRadius: 25,
            text: 'Update',
            buttonColor: orange,
            textColor: darkBg,
            onPressFn: () {
              editVehicle();
            },
            textWeight: FontWeight.bold,
            height: 45,
            stage: stage,
          ),
        ],
      ),
    );
  }

  _remove() {
    return Center(
      child: TextButtonWid(
        onPressFn: () async {
          await ConfirmAction().certify(() async {
            await FBFunctions().removeVehicle({'uid': widget.uid});
            if (mounted) {
              context.pop();
            }
          }, context, message: "Your vehicle will be erased permanently.");
        },
        text: 'Remove vehicle from the garage',
        textColor: blueLink,
        textWeight: FontWeight.bold,
        textSize: 16,
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _header(),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      top: 48,
                    ),
                    child: Column(
                      children: [
                        _photoBox(),
                        const SizedBox(
                          height: 48,
                        ),
                        _form(),
                        const SizedBox(
                          height: 8,
                        ),
                        _remove(),
                        const SizedBox(
                          height: 48,
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
