import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_mates/fire/auth.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/staged_outlined_button.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';

class LoginProviders extends StatefulWidget {
  const LoginProviders({super.key, required this.text});

  final String text;

  @override
  State<LoginProviders> createState() => _LoginProvidersState();
}

class _LoginProvidersState extends State<LoginProviders> {
  String? _stage;
  String? _errorMessage;
  Future<void> signInWithGoogle() async {
    try {
      setState(() {
        _stage = "WAITING";
      });

      await Auth().signInWithGoogle(context);

      setState(() {
        _stage = "DONE";
      });

      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      setState(() {
        _stage = "ERROR";
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

  _textSeparator() {
    line() {
      return Flexible(
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            color: grey2,
          ),
        ),
      );
    }

    return Row(
      children: [
        line(),
        const SizedBox(width: 10),
        CustomText(
          text: widget.text,
          color: grey,
          size: 15,
        ),
        const SizedBox(width: 10),
        line(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _textSeparator(),
        const SizedBox(
          height: 24,
        ),
        StageOutlinedButton(
          borderRadius: 25,
          text: "Google",
          borderColor: grey,
          textColor: grey,
          onPressFn: signInWithGoogle,
          height: 50,
          stage: _stage,
          errorMessage: _errorMessage,
          textWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
