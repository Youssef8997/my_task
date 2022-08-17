import 'package:flutter/material.dart';


Widget myTextForm({auto=false, controller,required String hint,label,prefix,suffix,keyboardType,obscureText=false,validator,onTap,enabled,onChanged,focusNode,onSubmitted,inputFormatters}) {
  return TextFormField(
    inputFormatters: inputFormatters,
    autofocus: auto,
    onFieldSubmitted: onSubmitted,
    obscuringCharacter: "*",
    focusNode: focusNode,
    enabled: enabled,
    onTap: onTap,
    onChanged: onChanged,
    style: const TextStyle(color: Colors.black),
    controller: controller,
    keyboardType: keyboardType,
    decoration: InputDecoration(
        contentPadding: const EdgeInsetsDirectional.fromSTEB(20, 0, 0,0),
        hintText: hint,
        hintStyle:const TextStyle(color: Colors.black),
        label: label!=null?Text("$label"):null,

        labelStyle: const TextStyle(color: Colors.black),
        prefixIcon: prefix,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.black,),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.red,),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.black,),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.black,),)
    ),
    obscureText: obscureText,
    validator: validator,

  );
}
