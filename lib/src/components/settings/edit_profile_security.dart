import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/staged_solid_button.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/utils/profile/profile.dart';

class EditProfileSecutityBox extends StatefulWidget {
  const EditProfileSecutityBox({super.key});

  @override
  State<EditProfileSecutityBox> createState() => _EditProfileDataBoxState();
}

class _EditProfileDataBoxState extends State<EditProfileSecutityBox> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  String? stage;
  String? _errorMessage;

  _updateProfileSecurityButton() {
    Future<void> updateProfileSecurity() async {
      final password = _controllerPassword.text.trim();

      if (!formKey.currentState!.validate()) return;
      if (Auth().currentUser == null) return;
      if (password.isEmpty) return;

      try {
        setState(() {
          stage = 'WAITING';
        });

        await Profile().setNewPassword(password, context);

        setState(() {
          stage = 'DONE';
        });

        _controllerEmail.clear();
        _controllerPassword.clear();
      } on FirebaseAuthException catch (e) {
        if (e.code == "user-mismatch" || e.code == "operation-not-allowed") {
          setState(() {
            _errorMessage = "Invalid email or password";
          });
        }
        setState(() {
          stage = 'ERROR';
        });
      } finally {
        _emailFocusNode.unfocus();
        _passwordFocusNode.unfocus();
        Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              stage = null;
            });
          }
        });
      }
    }

    return StageSolidButton(
      borderRadius: 20,
      text: 'Update',
      buttonColor: orange,
      textColor: darkBg,
      onPressFn: updateProfileSecurity,
      height: 40,
      textWeight: FontWeight.w600,
      stage: stage,
      errorMessage: _errorMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<AsyncSnapshot<UserStore?>>(context, listen: false);

    if (!user.hasData) {
      return const Center(
        child: CustomText(text: "We cannot connect to the server"),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: formKey,
          child: TextInputWid(
            label: 'New Password',
            controller: _controllerPassword,
            color: grey,
            secondaryColor: blueLink,
            validator: emptyPasswordValidator,
            focusNode: _passwordFocusNode,
            isPassoword: true,
            keyboard: TextInputType.visiblePassword,
            fillColor: darkGrey,
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        _updateProfileSecurityButton()
      ],
    );
  }
}
