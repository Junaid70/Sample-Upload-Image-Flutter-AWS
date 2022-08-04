import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

rectangularCustomColorBoxDecorationWithRadius(
    double topLeft,
    double bottomLeft,
    double bottomRight,
    double topRight,
    Color color,
    ) =>
    BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft),
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight),
            topRight: Radius.circular(topRight)),
        color: color);

rectangularLighterGreyBoxDecorationWithRadius(double radius) => BoxDecoration(
    shape: BoxShape.rectangle,
    borderRadius: BorderRadius.circular(radius),
    color: Colors.grey[200]);