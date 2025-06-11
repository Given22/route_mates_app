import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/components/onboarding/forget_pass_modal.dart';
import 'package:route_mates/src/components/onboarding/login_providers.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/staged_solid_button.dart';
import 'package:route_mates/src/widgets/buttons/text_button.dart';
import 'package:route_mates/src/widgets/input_widgets.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginFormKey = GlobalKey<FormState>();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  String? _stage;
  String? _errorMessage;

  Future<void> signInWithEmailAndPassword() async {
    if (loginFormKey.currentState!.validate()) {
      try {
        setState(() {
          _stage = 'WAITING';
        });
        await Auth().signInWithEmailAndPassword(
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
      } on FirebaseAuthException catch (e) {
        String message = 'Authentication failed';
        if (e.code == 'account-exists-with-different-credential') {
          message = 'Account already exists';
        }
        if (e.code == 'user-not-found') {
          message = 'Account not exists';
        }
        setState(() {
          _errorMessage = message;
          _stage = 'ERROR';
        });
      } on PlatformException {
        setState(() {
          _errorMessage = 'Maybe no internet!';
          _stage = 'ERROR';
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'error';
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

  forgetPassword() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const ForgetPassModal();
      },
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "LOGIN",
                        color: grey,
                        weight: FontWeight.bold,
                        size: 20,
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        text: "TO YOUR EXISTING ACCOUNT",
                        color: grey2,
                        size: 18,
                        fontFamily: Fonts().secondary,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Form(
                        key: loginFormKey,
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
                        text: 'Login',
                        buttonColor: orange,
                        textColor: blueDark,
                        onPressFn: signInWithEmailAndPassword,
                        height: 45,
                        stage: _stage,
                        textWeight: FontWeight.bold,
                        errorMessage: _errorMessage,
                      ),
                      TextButtonWid(
                        onPressFn: forgetPassword,
                        text: "Forgot Password?",
                        textColor: grey,
                      ),
                    ],
                  ),
                  const LoginProviders(text: "or login with"),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Don't have an account?",
                          color: grey,
                          size: 15,
                        ),
                        TextButtonWid(
                          onPressFn: () {
                            context.goNamed("REGISTER");
                          },
                          text: "Register",
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
