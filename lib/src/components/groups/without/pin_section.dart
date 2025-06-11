import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:route_mates/fire/config.dart';
import 'package:route_mates/fire/functions.dart';
import 'package:route_mates/functions/fun.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/buttons/staged_solid_button.dart';

class PinInputSection extends StatefulWidget {
  const PinInputSection({super.key});

  @override
  State<PinInputSection> createState() => _PinInputSectionState();
}

class _PinInputSectionState extends State<PinInputSection> {
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
        border: Border.all(color: blueLink),
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

  joinViaKey() async {
    try {
      if (_pinFormKey.currentState!.validate()) {
        setState(() {
          _stage = 'WAITING';
        });
        final result =
            await FBFunctions().joinViaKey.call({'key': _pinController.text});
        if (mounted) {
          if (result.data.toString() == "success") {
            setState(() {
              _stage = 'DONE';
            });
            return;
          }
          setState(() {
            _errorMessage = "Invalid key";
            _stage = 'ERROR';
          });
        }
      }
    } on FirebaseFunctionsException catch (e) {
      if (e.code == 'not-found') {
        Fluttertoast.showToast(msg: e.message.toString());
      }
      if (mounted) {
        setState(() {
          _stage = 'ERROR';
        });
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Some problem with joining');
      if (mounted) {
        setState(() {
          _stage = 'ERROR';
        });
      }
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

  joinButton() {
    return StageSolidButton(
      borderRadius: 16,
      text: Config().getString("WITHOUT_GROUP_PIN_BUTTON"),
      buttonColor: orange,
      textColor: blueDark,
      onPressFn: joinViaKey,
      height: 40,
      stage: _stage,
      textWeight: FontWeight.bold,
      errorMessage: _errorMessage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 275,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          form(),
          const SizedBox(
            height: 24,
          ),
          joinButton(),
        ],
      ),
    );
  }
}
