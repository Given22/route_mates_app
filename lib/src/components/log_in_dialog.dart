import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/data/user.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/wide_solid_button.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class LogInDialogContent extends StatefulWidget {
  const LogInDialogContent({super.key});

  @override
  State<LogInDialogContent> createState() => _LogInDialogContentState();
}

class _LogInDialogContentState extends State<LogInDialogContent> {
  final TextEditingController controllerEmail = TextEditingController();
  final TextEditingController controllerPassword = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0, -1.5),
          end: Alignment.bottomCenter,
          colors: [
            darkGrey3,
            darkGrey,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 8,
            ),
            CustomText(
              text: "Reauthenticate to continue",
              color: grey,
              weight: FontWeight.bold,
              size: 18,
            ),
            const SizedBox(
              height: 24,
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextInputWid(
                    label: 'Email',
                    controller: controllerEmail,
                    color: grey,
                    secondaryColor: blueLink,
                    validator: emailValidator,
                    focusNode: emailFocusNode,
                    keyboard: TextInputType.emailAddress,
                    fillColor: darkGrey3,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextInputWid(
                    label: 'Password',
                    controller: controllerPassword,
                    color: grey,
                    secondaryColor: blueLink,
                    validator: passwordValidator,
                    focusNode: passwordFocusNode,
                    isPassoword: true,
                    keyboard: TextInputType.visiblePassword,
                    fillColor: darkGrey3,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            BigSolidButton(
              borderRadius: 8,
              text: "Reauthorize",
              buttonColor: orange,
              textWeight: FontWeight.bold,
              textColor: darkBg,
              onPressFn: () {
                if (formKey.currentState!.validate()) {
                  context.pop(
                    UserSecurity(
                      email: controllerEmail.text.trim(),
                      password: controllerPassword.text.trim(),
                    ),
                  );
                }
              },
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
