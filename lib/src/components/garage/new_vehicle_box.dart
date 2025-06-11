import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:route_mates/fire/db.dart';
import 'package:route_mates/fire/firestore.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/functions/fun.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/staged_solid_button.dart';
import 'package:route_mates/utils/confirm_action_service.dart';
import 'package:uuid/uuid.dart';

class NewVehicleBox extends StatefulWidget {
  const NewVehicleBox({super.key, required this.afterFunction});

  final Function() afterFunction;

  @override
  State<NewVehicleBox> createState() => _NewVehicleBoxState();
}

class _NewVehicleBoxState extends State<NewVehicleBox> {
  final formKey = GlobalKey<FormState>();
  File? file;
  final TextEditingController controllerName = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();

  String? stage;

  Future<void> addNewVehicle() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    try {
      setState(() {
        stage = 'WAITING';
      });

      final vehicleUid = const Uuid().v4();

      await FBFunctions().addNewVehicle({
        'name': controllerName.text.trim(),
        'description': controllerDescription.text.trim(),
        'uid': vehicleUid,
      });

      if (file != null) {
        await DB().uploadPhoto(
          file: file!,
          folder: DB().vehicleFolder,
          uid: vehicleUid,
        );
      }

      setState(() {
        stage = 'DONE';
      });

      if (mounted) {
        await ConfirmAction().certify(
          () async {
            await Store().updateActiveVehicle(vehicleId: vehicleUid);
          },
          context,
          title: "Use as a active vehicle?",
        );
      }

      widget.afterFunction();
    } catch (e) {
      setState(() {
        stage = "ERROR";
      });

      Fluttertoast.showToast(
        msg:
            "We had a problem with uploading your vehicle, please try again later.",
        toastLength: Toast.LENGTH_SHORT,
      );
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

  _photoBox() {
    return Container(
      height: 180,
      width: 270,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: darkGrey,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            color: darkGrey,
            image: file != null
                ? DecorationImage(
                    image: FileImage(file!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: Center(
            child: Icon(
              Icons.photo_camera_outlined,
              color: grey2,
              size: 32,
              shadows: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 0),
                  blurRadius: 20,
                )
              ],
            ),
          ),
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
          letterSpacing: -0.5,
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
          labelStyle: TextStyle(color: grey, fontSize: 14),
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
          labelStyle: TextStyle(color: grey, fontSize: 14),
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
            text: 'Add vehicle',
            buttonColor: orange,
            textColor: darkBg,
            onPressFn: () {
              addNewVehicle();
            },
            textWeight: FontWeight.bold,
            height: 40,
            stage: stage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
        ],
      ),
    );
  }
}
