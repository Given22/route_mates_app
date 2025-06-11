import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/wide_solid_button.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class ForgetPassModal extends StatefulWidget {
  const ForgetPassModal({super.key});

  @override
  State<ForgetPassModal> createState() => _ForgetPassModalState();
}

class _ForgetPassModalState extends State<ForgetPassModal> {
  final TextEditingController _controllerForgottenEmail =
      TextEditingController();
  final forgotPasswordKey = GlobalKey<FormState>();

  Future<void> resetPassword() async {
    try {
      if (forgotPasswordKey.currentState!.validate()) {
        await FirebaseAuth.instance.sendPasswordResetEmail(
            email: _controllerForgottenEmail.text.trim());

        if (mounted) {
          context.pop();
        }

        Fluttertoast.showToast(
            msg: 'Reset your password using the link on your email.',
            toastLength: Toast.LENGTH_SHORT);
      }
    } on FirebaseAuthException {
      Fluttertoast.showToast(
          msg: 'We had some problem, try again later.',
          toastLength: Toast.LENGTH_SHORT);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
            color: darkGrey,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(34), topRight: Radius.circular(34))),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              CustomText(
                text: 'Enter the email to the account',
                color: grey,
                size: 18,
                weight: FontWeight.bold,
              ),
              const SizedBox(
                height: 40,
                width: double.infinity,
              ),
              Form(
                key: forgotPasswordKey,
                child: TextInputWid(
                  isPassoword: false,
                  label: 'Email',
                  controller: _controllerForgottenEmail,
                  color: grey,
                  secondaryColor: orange,
                  validator: emailValidator,
                  fillColor: darkGrey3,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 30,
                width: double.infinity,
              ),
              BigSolidButton(
                borderRadius: 25,
                text: 'Reset password',
                buttonColor: orange,
                textColor: darkBg,
                onPressFn: resetPassword,
                height: 50,
                textWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 40,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
