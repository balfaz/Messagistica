import 'package:flutter/material.dart';

class InputButton extends StatefulWidget {
  InputButton(
      {Key key,
      @required this.label,
      this.hiddenChar = false,
      this.validator,
      this.inputType = TextInputType.text})
      : super(key: key);

  final String label;
  final bool hiddenChar;
  final Function(String) validator;
  final TextInputType inputType;

  @override
  _InputButtonState createState() => _InputButtonState();
}

class _InputButtonState extends State<InputButton> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.inputType,
      validator: widget.validator,
      obscureText: widget.hiddenChar,
      decoration: InputDecoration(
          labelText: widget.label,
          contentPadding: EdgeInsets.symmetric(vertical: 10)),
    );
  }
}
