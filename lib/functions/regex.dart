import 'package:regexpattern/regexpattern.dart';

final RegExp _upperAndNumberRegExp = RegExp(r'^[A-Z0-9]{5}$');
final RegExp _inputRegExp = RegExp(r'^[a-zA-Z0-9_.]{1,30}$');
final RegExp _emptyInputRegExp = RegExp(r'^[a-zA-Z0-9_.]{0,30}$');

String? simpleErrorNameValidator(String? text) {
  if (text == null) return null;
  if (!text.isUsernameInstagram()) {
    return "Incorrect name";
  }
  return null;
}

String? usernameValidator(String? text) {
  if (text == null) return null;
  if (!text.isUsernameInstagram()) {
    return "Min len: 3, Max len: 30,\nspecial characters: period ( . ), underscore( _ )\ncan't start and end with period\ncan't have consecutive period";
  }
  return null;
}

String? emailValidator(String? text) {
  if (text == null) return null;
  if (!text.toLowerCase().isEmail()) {
    return "Incorrect email";
  }
  return null;
}

String? emptyEmailValidator(String? text) {
  if (text == null) return null;
  if (text.isEmpty) return null;
  if (!text.toLowerCase().isEmail()) {
    return "Incorrect email";
  }
  return null;
}

String? passwordValidator(String? text) {
  if (text == null) return null;
  if (!text.isPasswordEasy()) {
    return "No whitespace allowed\nMinimum characters: 8";
  }
  return null;
}

String? emptyPasswordValidator(String? text) {
  if (text == null) return null;
  if (text.isEmpty) return null;
  if (!text.isPasswordHard()) {
    return "No whitespace allowed\nMinimum characters: 8";
  }
  return null;
}

String? keyValidator(String? text) {
  if (text == null) return null;
  if (!_upperAndNumberRegExp.hasMatch(text)) {
    return "Incorrect key";
  }
  return null;
}

String? inputValidator(String? text) {
  if (text == null) return null;
  if (!_inputRegExp.hasMatch(text)) {
    return "Incorrect input";
  }
  return null;
}

String? emptyInputValidator(String? text) {
  if (text == null) return null;
  if (!_emptyInputRegExp.hasMatch(text)) {
    return "Incorrect input";
  }
  return null;
}
