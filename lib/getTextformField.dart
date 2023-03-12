import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_app_task/AppData.dart';

class getTextFormField extends StatelessWidget {
  TextEditingController? controller;
  String? hintName;
  IconData? icon;
  bool isObscureText;
  TextInputType inputType;
  bool isEnable;
  bool isPhone;
  bool isName;

  getTextFormField(
      {this.controller,
      this.hintName,
      this.icon,
      this.isObscureText = false,
      this.inputType = TextInputType.text,
      this.isEnable = true,
      this.isPhone = false,
      this.isName = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: controller,
        obscureText: isObscureText,
        enabled: isEnable,
        keyboardType: inputType,
        maxLength: isPhone ? 10 : null,
        inputFormatters: [
          isPhone
              ? FilteringTextInputFormatter.digitsOnly
              : isName
                  ? FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                  : FilteringTextInputFormatter.allow(RegExp(
                      '[a-zA-Z0-9!@#\$%^&*(),.?":{}|<>_+=\\-\\[\\]\\/\\\\]+')),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintName';
          }
          if (hintName == "Email" && !AppData.validateEmail(value)) {
            return 'Please Enter Valid Email';
          }
          return null;
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Colors.blue),
          ),
          prefixIcon: Icon(icon),
          hintText: hintName,
          labelText: hintName,
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),
    );
  }
}
