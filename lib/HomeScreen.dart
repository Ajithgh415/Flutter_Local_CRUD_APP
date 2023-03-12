import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:local_app_task/DeletedUsers.dart';
import 'package:local_app_task/UpdateUser.dart';
import 'package:local_app_task/getTextformField.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'UserModelClass.dart';
import 'UserProvider.dart';

class HomeScreen extends StatefulWidget {
  final String? mode;
  final String? userId;
  final String? mode2;
  const HomeScreen({super.key, this.userId, this.mode, this.mode2});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? isAdmin1 = "";
  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  _loadInitial() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final isAdmin = prefs.getString('isAdmin');
    setState(() {
      print(isAdmin);
      isAdmin1 = isAdmin;
      if (widget.mode == "" && widget.mode2 == "") {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          final auth = Provider.of<UserProvider>(context, listen: false);
          auth.getUserData(context, userId!, "");
        });
      } else if (widget.mode == "Admin" && widget.mode2 == "") {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          final auth = Provider.of<UserProvider>(context, listen: false);
          auth.getUserList(context);
        });
      }
      // else {
      //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //     final auth = Provider.of<UserProvider>(context, listen: false);
      //     auth.getUserData(context, widget.userId!, "Admin");
      //   });
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, object, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('User Details Page'),
          actions: [
            Visibility(
              visible: object.adminuser || isAdmin1 == "true",
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: const Icon(Icons.personal_injury_rounded),
                  onPressed: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeletedUsers()));
                    });
                  },
                ),
              ),
            ),
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
        body: object.adminuser || isAdmin1 == "true"
            ? Column(
                children: [
                  Material(
                    elevation: 3,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          // width:
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.2,
                              )),
                          child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                              controller: object.searchController,
                              textInputAction: TextInputAction.search,
                              onTap: () {
                                setState(() {
                                  if (object.userlist.isEmpty) {}
                                  if (object.searchController.text == '') {
                                    // object.userlist.clear();
                                    // // userListapi();
                                    // print("searchig675645");
                                    // object.email.text = "Admin";
                                    // object.password.text = "0000";
                                    // object.login(context);
                                  }
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Color.fromARGB(255, 210, 207, 207),
                                ),
                                alignLabelWithHint: false,
                                hintText: "Search",
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 210, 207, 207),
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                ),
                                counterText: "",
                                contentPadding: EdgeInsets.only(
                                    left: 10, top: 15, bottom: 15, right: 4),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value != "") {}
                                  if (object.searchController.text == '') {
                                    object.userlist.clear();
                                    // userListapi();
                                    print("Ajith");
                                    object.email.text = "Admin";
                                    object.password.text = "0000";
                                    object.login(context);
                                  }
                                });
                              },
                              onSubmitted: (String value) {
                                setState(() {
                                  if (value != "") {}
                                  if (object.searchController.text == '') {
                                    object.userlist.clear();
                                    // userListapi();
                                    print("Ajith");
                                    object.email.text = "Admin";
                                    object.password.text = "0000";
                                    object.login(context);
                                  }
                                });

                                // AppData.showInSnackDone(context, value);
                              },
                            ),

                            getImmediateSuggestions: true,
                            suggestionsCallback: (pattern) async {
                              return (pattern != null)
                                  ? await object.fetchSearchAutoComplete(
                                      pattern, object.userlist)
                                  : null;
                            },
                            hideOnLoading: true,
                            itemBuilder: (context, dynamic suggestion) {
                              return Container(
                                padding: EdgeInsets.all(20),
                                child: Text(suggestion.name ?? ""),
                              );
                            },
                            noItemsFoundBuilder: (context) => Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: Center(
                                child: Text(
                                  'No data found.',
                                ),
                              ),
                            ),
                            // hideOnEmpty: true,
                            onSuggestionSelected: (dynamic suggestion) {
                              print(suggestion.toString());
                              object.searchController.text = suggestion.name;
                              setState(() {
                                print("ajith");
                                User user = User();
                                user = suggestion;
                                object.userlist.clear();
                                object.userlist.add(user);
                                print(user);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: object.userlist.isEmpty
                        ? Center(
                            child: Container(
                              child: Text("No Users Available"),
                            ),
                          )
                        : ListView.builder(
                            itemCount: object.userlist.length,
                            itemBuilder: (BuildContext context, int index) {
                              final user = object.userlist[index];

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  title: Text('Name: ${user.name}'),
                                  subtitle: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Email: ${user.email}'),
                                      Text('PhoneNumber: ${user.phone}'),
                                    ],
                                  ),
                                  trailing: SizedBox(
                                    width: 60,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 30,
                                          child: IconButton(
                                            icon: Icon(Icons.edit_square),
                                            onPressed: () {
                                              // Handle edit button tap
                                              setState(() {
                                                print(user.name);
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UpdateUser(
                                                              userId: user.id
                                                                  .toString(),
                                                            )));
                                              });
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 30,
                                          child: IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              // Handle delete button tap
                                              setState(() {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          Text('Remove User?'),
                                                      content: Text(
                                                          'Are you sure you want to remove this user?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                          child: Text('CANCEL'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true),
                                                          child: Text('Remove'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ).then((value) {
                                                  if (value != null && value) {
                                                    // Perform delete operation here
                                                    setState(() {
                                                      user.isDeleted = 1;
                                                      object.removeUser(
                                                          context, user);
                                                    });
                                                  }
                                                });
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Icon(
                                  //   Icons.delete,
                                  //   color: Colors.red,
                                  //   size: 20,
                                  // ),
                                  leading: ClipRRect(
                                      borderRadius:
                                          new BorderRadius.circular(50.0),
                                      child: user.profilePicture != null
                                          ? Image.file(
                                              File(user.profilePicture!),
                                              errorBuilder:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                              fit: BoxFit.contain,
                                              height: 40,
                                              width: 40)
                                          : Image.asset(
                                              'assets/images/demoimg.png',
                                              fit: BoxFit.cover,
                                              height: 90,
                                              width: 90)),
                                  onTap: () {
                                    // Navigate to the user details screen
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              )
            : Center(
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
                                        fit: BoxFit.cover,
                                        height: 90,
                                        width: 90)),
                            Visibility(
                              visible: !object.editable,
                              child: Positioned(
                                bottom: 0,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        object.profileImageModalBottomSheet(
                                            context);
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
                        ElevatedButton(
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
                                    if (widget.mode == "Admin") {
                                      object.updateUser(
                                          context, uModel, "Admin", "User");
                                    } else {
                                      object.updateUser(
                                          context, uModel, "", "");
                                    }
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
                                setState(() {
                                  object.editable = !object.editable;
                                  print(object.editable);
                                });
                              }
                            });
                          },
                          child: Text(
                            object.editable == true ? 'Edit' : 'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          // onPressed: signUp,
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
