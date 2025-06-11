import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:route_mates/functions/fun.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/staged_solid_button.dart';
import 'package:route_mates/utils/access_keys_service.dart';

class KeyInputSection extends StatefulWidget {
  const KeyInputSection({super.key});

  @override
  State<KeyInputSection> createState() => _KeyInputSectionState();
}

class _KeyInputSectionState extends State<KeyInputSection> {
  final _pinController = TextEditingController();
  final _pinFocusNode = FocusNode();
  final _pinFormKey = GlobalKey<FormState>();

  String? _stage;
  String? _errorMessage;

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }

  form() {
    final defaultPinTheme = PinTheme(
      width: 48,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
        color: grey,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: blueLink, width: 2),
      ),
    );

    return Form(
      key: _pinFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              length: 5,
              inputFormatters: [
                UppercaseTextInputFormatter(),
              ],
              keyboardType: TextInputType.visiblePassword,
              textCapitalization: TextCapitalization.characters,
              androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
              controller: _pinController,
              focusNode: _pinFocusNode,
              defaultPinTheme: defaultPinTheme,
              separatorBuilder: (index) => const SizedBox(width: 8),
              validator: keyValidator,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: orange,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: grey),
                ),
              ),
              submittedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  color: darkGrey,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: grey2),
                ),
              ),
              errorPinTheme: defaultPinTheme.copyWith(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: redLight)),
                textStyle: TextStyle(fontSize: 14, color: redLight),
              ),
            ),
          ),
        ],
      ),
    );
  }

  checkKey() async {
    try {
      if (_pinFormKey.currentState!.validate()) {
        setState(() {
          _stage = 'WAITING';
        });

        final key = _pinController.text;
        final result = await AccessKeysService().checkKey(key);

        if (result) {
          if (await AccessKeysService().saveKeyOnPhone(key)) {
            setState(() {
              _stage = 'DONE';
            });
            if (mounted) {
              context.go("/");
            }
            Fluttertoast.showToast(
              msg: "Access granted",
              backgroundColor: grey2,
              textColor: darkGrey,
            );
            return;
          }
        }

        setState(() {
          _errorMessage = 'Access declined';
          _stage = 'ERROR';
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Some problem with confirmation',
        backgroundColor: grey2,
        textColor: darkGrey,
      );
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

  confirmButton() {
    return StageSolidButton(
      borderRadius: 25,
      text: 'Confirm Key',
      buttonColor: orange,
      textColor: blueDark,
      onPressFn: checkKey,
      height: 45,
      stage: _stage,
      textWeight: FontWeight.bold,
      errorMessage: _errorMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        form(),
        const SizedBox(
          height: 24,
        ),
        confirmButton(),
      ],
    );
  }
}
