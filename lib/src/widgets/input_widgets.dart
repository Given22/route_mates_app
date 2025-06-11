import 'package:flutter/material.dart';
import 'package:route_mates/functions/regex.dart';
import 'package:route_mates/src/const.dart';
import 'package:route_mates/src/widgets/text_widgets.dart';
import 'package:route_mates/src/widgets/widgets.dart';

class TextInputWid extends StatefulWidget {
  final bool? isPassoword;
  final String label;
  final TextEditingController controller;
  final Color color;
  final Color secondaryColor;
  final FocusNode? focusNode;
  final void Function(String)? onChange;
  final Color? fillColor;
  final Color? borderColor;
  final int? maxChars;
  final bool? counter;
  final bool? expands;
  final bool? border;
  final String? Function(String?)? validator;
  final TextInputType? keyboard;
  final FloatingLabelBehavior? labelBehavior;
  final double? height;
  final double? fontSize;

  const TextInputWid({
    super.key,
    this.isPassoword,
    this.focusNode,
    this.onChange,
    this.maxChars,
    this.expands,
    this.border,
    this.borderColor,
    this.fillColor,
    this.validator,
    this.keyboard,
    this.counter,
    this.labelBehavior,
    this.height,
    this.fontSize,
    required this.label,
    required this.controller,
    required this.color,
    required this.secondaryColor,
  });

  @override
  State<TextInputWid> createState() => _TextInputState();
}

class _TextInputState extends State<TextInputWid> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboard,
      maxLength: widget.maxChars,
      expands: widget.expands ?? false,
      maxLines: widget.expands != null
          ? widget.expands == true
              ? null
              : 1
          : 1,
      style: TextStyle(color: widget.color, fontSize: widget.fontSize ?? 16),
      onChanged: widget.onChange,
      focusNode: widget.focusNode,
      validator: widget.validator ?? emptyInputValidator,
      controller: widget.controller,
      obscureText: widget.isPassoword == true ? !isPasswordVisible : false,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16),
        labelText: widget.label,
        iconColor: widget.secondaryColor,
        floatingLabelBehavior:
            widget.labelBehavior ?? FloatingLabelBehavior.never,
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
          borderSide: BorderSide(
              color: widget.border != null && widget.border!
                  ? widget.secondaryColor
                  : Colors.transparent,
              width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: widget.border != null && widget.border!
                  ? widget.borderColor ?? widget.color
                  : Colors.transparent,
              width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: widget.border != null && widget.border!
                  ? widget.secondaryColor
                  : Colors.transparent,
              width: 2),
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelStyle: TextStyle(
          color: widget.color.withOpacity(0.7),
          fontFamily: Fonts().secondary,
        ),
        counterStyle: TextStyle(color: widget.color),
        counter: widget.counter != null && !widget.counter!
            ? const SizedBox()
            : null,
        filled: widget.fillColor != null,
        fillColor: widget.fillColor,
        suffixIcon: widget.isPassoword == true
            ? IconButton(
                splashRadius: 24,
                icon: isPasswordVisible
                    ? Icon(
                        Icons.visibility,
                        color: grey2,
                        size: 20,
                      )
                    : Icon(
                        Icons.visibility_off,
                        color: grey2,
                        size: 20,
                      ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }
}

class TextInputBox extends StatefulWidget {
  const TextInputBox({
    super.key,
    this.validator,
    this.onCHange,
    this.keyboardType,
    this.labelBehavior,
    this.buttonIcon,
    required this.onSubmit,
    required this.label,
  });

  final String? Function(String?)? validator;
  final Function(String)? onCHange;
  final Function(String) onSubmit;
  final String label;
  final TextInputType? keyboardType;
  final FloatingLabelBehavior? labelBehavior;
  final IconData? buttonIcon;

  @override
  State<TextInputBox> createState() => _TextInputBoxState();
}

class _TextInputBoxState extends State<TextInputBox> {
  final TextEditingController _controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  _submit() {
    if (formKey.currentState!.validate()) {
      widget.onSubmit(_controller.text);
    }
  }

  searchInput() {
    return TextFormField(
      onChanged: (value) {
        if (widget.onCHange != null) {
          widget.onCHange!(value);
        }
      },
      onFieldSubmitted: (_) => _submit(),
      keyboardType: widget.keyboardType ?? TextInputType.name,
      controller: _controller,
      textAlignVertical: TextAlignVertical.center,
      validator: widget.validator ?? emptyInputValidator,
      style: TextStyle(
        color: grey,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.only(left: 16, top: 14, bottom: 14, right: 4),
        isDense: true,
        labelText: widget.label,
        floatingLabelBehavior:
            widget.labelBehavior ?? FloatingLabelBehavior.never,
        errorStyle: TextStyle(
          color: redLight,
          fontFamily: Fonts().primary,
          fontSize: 10,
          height: 1,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: red),
          borderRadius: BorderRadius.circular(16.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelStyle: TextStyle(color: grey2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Box(
      padding: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Form(
              key: formKey,
              child: searchInput(),
            ),
          ),
          IconButton(
            splashRadius: 4,
            padding: const EdgeInsets.only(left: 18, right: 18),
            onPressed: _submit,
            icon: Icon(
              widget.buttonIcon ?? Icons.search_rounded,
              color: grey,
            ),
          )
        ],
      ),
    );
  }
}

class UnderLineTextInputWid extends StatefulWidget {
  final bool? isPassoword;
  final String label;
  final TextEditingController controller;
  final Color color;
  final Color secondaryColor;
  final FocusNode? focusNode;
  final void Function(String)? onChange;
  final int? maxChars;
  final bool? counter;
  final bool? expands;
  final String? Function(String?)? validator;
  final TextInputType? keyboard;
  final FloatingLabelBehavior? labelBehavior;
  final double? height;
  final double? fontSize;
  final TextAlign? alignment;

  const UnderLineTextInputWid({
    super.key,
    this.isPassoword,
    this.focusNode,
    this.onChange,
    this.maxChars,
    this.expands,
    this.validator,
    this.keyboard,
    this.counter,
    this.labelBehavior,
    this.height,
    this.fontSize,
    this.alignment,
    required this.label,
    required this.controller,
    required this.color,
    required this.secondaryColor,
  });

  @override
  State<UnderLineTextInputWid> createState() => _UnderLineTextInputState();
}

class _UnderLineTextInputState extends State<UnderLineTextInputWid> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.keyboard,
      maxLength: widget.maxChars,
      expands: widget.expands ?? false,
      textAlign: widget.alignment ?? TextAlign.start,
      maxLines: widget.expands != null
          ? widget.expands == true
              ? null
              : 1
          : 1,
      style: TextStyle(
          color: widget.color,
          fontSize: widget.fontSize ?? 16,
          fontFamily: Fonts().primary,
          fontWeight: FontWeight.bold),
      onChanged: widget.onChange,
      focusNode: widget.focusNode,
      validator: widget.validator ?? emptyInputValidator,
      controller: widget.controller,
      obscureText: widget.isPassoword == true ? !isPasswordVisible : false,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(bottom: 12, right: 16, left: 16),
        iconColor: widget.secondaryColor,
        label: CustomText(
          text: widget.label,
          color: widget.color,
          height: 2,
        ),
        floatingLabelBehavior:
            widget.labelBehavior ?? FloatingLabelBehavior.never,
        errorStyle: TextStyle(
          color: redLight,
          fontFamily: Fonts().primary,
          fontSize: 12,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: red),
          borderRadius: BorderRadius.circular(0.0),
        ),
        focusedErrorBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: red, width: 2)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: grey2, width: 2),
            borderRadius: BorderRadius.circular(0.0)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: grey2, width: 2),
          borderRadius: BorderRadius.circular(0.0),
        ),
        labelStyle: TextStyle(
          color: widget.color.withOpacity(0.8),
          fontSize: widget.fontSize ?? 15,
        ),
        counterStyle: TextStyle(color: widget.color),
        counter: widget.counter != null && !widget.counter!
            ? const SizedBox()
            : null,
        suffixIcon: widget.isPassoword == true
            ? IconButton(
                splashRadius: 24,
                icon: isPasswordVisible
                    ? Icon(
                        Icons.visibility,
                        color: grey2,
                        size: 20,
                      )
                    : Icon(
                        Icons.visibility_off,
                        color: grey2,
                        size: 20,
                      ),
                onPressed: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }
}
