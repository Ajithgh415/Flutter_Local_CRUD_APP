import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_app_task/AppData.dart';
import 'package:local_app_task/LoginScreen.dart';
import 'package:local_app_task/UserProvider.dart';
import 'package:local_app_task/getTextformField.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, object, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Login with Signup'),
        ),
        body: Center(
          child: Form(
            key: object.formKey,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // genLoginSignupHeader('Signup'),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                          borderRadius: new BorderRadius.circular(50.0),
                          child: object.profileImage.isAbsolute
                              ? Image.file(File(object.profileImage!.path),
                                  errorBuilder: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.contain,
                                  height: 90,
                                  width: 90)
                              : Image.asset('assets/images/demoimg.png',
                                  fit: BoxFit.cover, height: 90, width: 90)),
                      Positioned(
                        bottom: 0,
                        child: Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                object.profileImageModalBottomSheet(context);
                              });
                            },
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  getTextFormField(
                      controller: object.name,
                      icon: Icons.person_outline,
                      inputType: TextInputType.name,
                      isName: true,
                      hintName: 'Name'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: object.email,
                      icon: Icons.email,
                      inputType: TextInputType.emailAddress,
                      hintName: 'Email'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                      controller: object.phone,
                      icon: Icons.person_outline,
                      inputType: TextInputType.phone,
                      isPhone: true,
                      hintName: 'Phone Number'),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: object.password,
                    icon: Icons.lock,
                    hintName: 'Password',
                    isObscureText: true,
                  ),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: object.confirmPassword,
                    icon: Icons.lock,
                    hintName: 'Confirm Password',
                    isObscureText: true,
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (object.profileImage.isAbsolute) {
                          object.signUp(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please Select Image'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      });
                    },
                    child: Text(
                      'Signup',
                      style: TextStyle(color: Colors.white),
                    ),
                    // onPressed: signUp,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Does you have account? '),
                        ElevatedButton(
                          // textColor: Colors.blue,
                          child: Text('Sign In'),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LoginScreen()),
                                (Route<dynamic> route) => false);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
