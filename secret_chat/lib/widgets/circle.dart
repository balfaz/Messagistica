import 'package:flutter/material.dart';

class Circle extends StatelessWidget {
  const Circle(
      {Key key,
      @required this.radius,
      @required this.colors,
      @required this.alignmentStart,
      @required this.alignmentEnd})
      : super(key: key);

  final double radius;
  final List<Color> colors;
  final Alignment alignmentStart;
  final Alignment alignmentEnd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(this.radius),
          gradient: LinearGradient(
              colors: this.colors, begin: alignmentStart, end: alignmentEnd)),
    );
  }
}
