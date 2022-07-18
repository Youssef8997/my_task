import 'package:flutter/material.dart';

Future Nevigator({page, context, bool = false}) {
  return Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => page), (Route route) => bool);
}

