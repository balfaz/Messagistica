import 'dart:core';

String VerificaEmail(String indirizzo) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regexp = RegExp(pattern);
  if (!regexp.hasMatch(indirizzo)) {
    return 'Invalid <Email address>';
  }
  return null;
}

String VerificaPassword(String psw) {
  if (psw.length < 8) {
    return "<Password> must be more or equal of 8 char";
  }
  return null;
}
