import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/components/onboarding/login_providers.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/staged_solid_button.dart';
import 'package:route_mates/src/widgets/buttons/text_button.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final registerFormKey = GlobalKey<FormState>();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  String? _stage;
  String? _errorMessage;

  Future<void> _register() async {
    if (registerFormKey.currentState!.validate()) {
      try {
        setState(() {
          _stage = 'WAITING';
        });

        await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text.trim(),
          password: _controllerPassword.text.trim(),
          context: context,
        );

        setState(() {
          _stage = 'DONE';
        });

        if (mounted) {
          context.go('/');
        }
      } on FirebaseAuthException {
        setState(() {
          _errorMessage = 'Server error';
          _stage = 'ERROR';
        });
      } on PlatformException {
        setState(() {
          _errorMessage = 'Maybe no internet!';
          _stage = 'ERROR';
        });
      }
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

  Future<void> signInWithGoogle() async {
    await Auth().signInWithGoogle(context);
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "SIGN UP",
                        color: grey,
                        weight: FontWeight.bold,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        text: "TO CREATE YOUR ACCOUNT",
                        color: grey2,
                        size: 18,
                        fontFamily: Fonts().secondary,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Form(
                        key: registerFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextInputWid(
                              keyboard: TextInputType.emailAddress,
                              isPassoword: false,
                              label: "Email",
                              controller: _controllerEmail,
                              color: grey,
                              secondaryColor: blueLight2,
                              validator: emailValidator,
                              fillColor: darkGrey,
                              fontSize: 18,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            TextInputWid(
                              keyboard: TextInputType.visiblePassword,
                              label: "Password",
                              isPassoword: true,
                              controller: _controllerPassword,
                              color: grey,
                              secondaryColor: blueLight2,
                              validator: passwordValidator,
                              fillColor: darkGrey,
                              fontSize: 18,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      StageSolidButton(
                        borderRadius: 25,
                        text: 'Sign up',
                        buttonColor: orange,
                        textColor: blueDark,
                        onPressFn: _register,
                        height: 45,
                        stage: _stage,
                        textWeight: FontWeight.bold,
                        errorMessage: _errorMessage,
                      ),
                    ],
                  ),
                  const LoginProviders(text: "or sign up with"),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'Have an account?',
                          color: grey,
                          size: 15,
                        ),
                        TextButtonWid(
                          onPressFn: () {
                            context.goNamed("LOGIN");
                          },
                          text: "Log in",
                          textColor: orange,
                          textSize: 15,
                          textWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
