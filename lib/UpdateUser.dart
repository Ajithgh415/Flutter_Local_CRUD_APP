import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UserModelClass.dart';
import 'UserProvider.dart';
import 'getTextformField.dart';

class UpdateUser extends StatefulWidget {
  final String? viewMode;
  final String? userId;
  const UpdateUser({super.key, this.userId, this.viewMode});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  _loadInitial() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    // final isAdmin = prefs.getString('isAdmin');
    setState(() {
      if (widget.viewMode == '1') {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          final auth = Provider.of<UserProvider>(context, listen: false);
          auth.getDeletedUserData(context, widget.userId!,);
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          final auth = Provider.of<UserProvider>(context, listen: false);
          auth.getUserData(context, widget.userId!, "Admin");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, object, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Details Page'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  setState(() {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Logout User?'),
                          content: Text('Are you sure you want to logout?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    ).then((value) {
                      if (value != null && value) {
                        // Perform delete operation here
                        object.logout(context);
                      }
                    });
                  });
                },
              ),
            )
          ],
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
                          child: object.profileImage.isAbsolute ||
                                  object.profileImageUrl != ""
                              ? Image.file(
                                  File(object.profileImage.isAbsolute
                                      ? object.profileImage!.path
                                      : object.profileImageUrl),
                                  errorBuilder: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.contain,
                                  height: 90,
                                  width: 90)
                              : Image.asset('assets/images/demoimg.png',
                                  fit: BoxFit.cover, height: 90, width: 90)),
                      Visibility(
                        visible: !object.editable,
                        child: Positioned(
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
                    hintName: 'Name',
                    isEnable: !object.editable,
                    isName: true,
                  ),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: object.email,
                    icon: Icons.email,
                    inputType: TextInputType.emailAddress,
                    hintName: 'Email',
                    isEnable: !object.editable,
                  ),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: object.phone,
                    icon: Icons.person_outline,
                    inputType: TextInputType.phone,
                    hintName: 'Phone Number',
                    isEnable: !object.editable,
                    isPhone: true,
                  ),
                  SizedBox(height: 10.0),
                  getTextFormField(
                    controller: object.password,
                    icon: Icons.lock,
                    hintName: 'Password',
                    isObscureText: true,
                    isEnable: !object.editable,
                  ),
                  SizedBox(height: 10.0),
                  Visibility(
                    visible: widget.viewMode=="",
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (object.editable == false) {
                            if (object.formKey.currentState!.validate()) {
                              if (object.profileImage.isAbsolute ||
                                  object.profileImageUrl != "") {
                                User uModel = User(
                                    id: object.userid,
                                    name: object.name.text,
                                    email: object.email.text,
                                    phone: object.phone.text,
                                    password: object.password.text,
                                    profilePicture: object.profileImageUrl,
                                    isDeleted: 0);
                                // if (widget.mode == "Admin") {
                                object.updateUser(
                                    context, uModel, "Admin", "User");
                                // } else {
                                //   object.updateUser(context, uModel, "", "");
                                // }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Image Should not empty'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          } else {
                            object.editable = !object.editable;
                          }
                        });
                      },
                      child: Text(
                        object.editable == true ? 'Edit' : 'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                      // onPressed: signUp,
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
