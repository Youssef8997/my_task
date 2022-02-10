import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_task/module/MoneyOrganiz/MoneyOrganiz.dart';

Widget Mytextfield(
    {Controlr,
    required String hint,
    Prefix,
    suffix,
    keybordtype,
    isobsr = false,
    validator,
    func,
    bool? Enabled}) {
  return Container(
    height: 50,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black,
      width: 2),
      borderRadius: BorderRadius.circular(25.0),
    ),
    child: TextFormField(
      enabled: Enabled,
      onTap: func,
      controller: Controlr,
      keyboardType: keybordtype,
      decoration: InputDecoration(
          hintText: "    $hint",
          hintStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              ),
          prefixIcon: Prefix,
          suffixIcon: suffix,
          border: InputBorder.none),
      obscureText: isobsr,
      validator: validator,
    ),
  );
}
