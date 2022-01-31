import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget Mytextfield({required Controlr,required String hint,Prefix,suffix,keybordtype,isobsr=false,validator}) {
  return Container(
    height: 50,
    clipBehavior: Clip.antiAliasWithSaveLayer,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(25.0),
    ),
    child: TextFormField(
      controller: Controlr,
      keyboardType: keybordtype,
      decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Prefix,
          suffixIcon: suffix,
        border: InputBorder.none
      ),
      obscureText: isobsr,
      validator: validator,

    ),
  );
}
