import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

import 'UpdateUser.dart';
import 'UserModelClass.dart';
import 'UserProvider.dart';

class DeletedUsers extends StatefulWidget {
  const DeletedUsers({super.key});

  @override
  State<DeletedUsers> createState() => _DeletedUsersState();
}

class _DeletedUsersState extends State<DeletedUsers> {
  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  _loadInitial() async {
    setState(() {
      // Get the DeletedUser List function calling
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        final auth = Provider.of<UserProvider>(context, listen: false);
        auth.getDeletedUserList(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, object, child) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Deleted User List Page'),
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
                            title: const Text('Logout User?'),
                            content: const Text('Are you sure you want to logout?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('CANCEL'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('OK'),
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
          body: Column(
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
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          controller: object.searchController,
                          textInputAction: TextInputAction.search,
                          onTap: () {
                            setState(() {
                              if (object.removeduserlist.isEmpty) {}
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
                          decoration: const InputDecoration(
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
                                object.removeduserlist.clear();
                                // userListapi();
                                object.getDeletedUserList(context);
                              }
                            });
                          },
                          onSubmitted: (String value) {
                            setState(() {
                              if (value != "") {}
                              if (object.searchController.text == '') {
                                object.removeduserlist.clear();
                                // userListapi();
                                object.getDeletedUserList(context);
                              }
                            });

                            // AppData.showInSnackDone(context, value);
                          },
                        ),

                        getImmediateSuggestions: true,
                        suggestionsCallback: (pattern) async {
                          return (pattern != null)
                              ? await object.fetchSearchAutoComplete(
                                  pattern, object.removeduserlist)
                              : null;
                        },
                        hideOnLoading: true,
                        itemBuilder: (context, dynamic suggestion) {
                          return Container(
                            padding: const EdgeInsets.all(20),
                            child: Text(suggestion.name ?? ""),
                          );
                        },
                        noItemsFoundBuilder: (context) => Container(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: const Center(
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
                            object.removeduserlist.clear();
                            object.removeduserlist.add(user);
                            print(user);
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: object.removeduserlist.isEmpty
                    ? Center(
                        child: Container(
                          child: const Text("No Users1 Available"),
                        ),
                      )
                    : ListView.builder(
                        itemCount: object.removeduserlist.length,
                        itemBuilder: (BuildContext context, int index) {
                          final user = object.removeduserlist[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text('Name: ${user.name}'),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Email: ${user.email}'),
                                  Text('PhoneNumber: ${user.phone}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_red_eye_rounded),
                                onPressed: () {
                                  // Handle edit button tap
                                  setState(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => UpdateUser(
                                                  userId: user.id.toString(),
                                                  viewMode: "1",
                                                )));
                                  });
                                },
                              ),
                              leading: ClipRRect(
                                  borderRadius: new BorderRadius.circular(50.0),
                                  child: user.profilePicture != null
                                      ? Image.file(File(user.profilePicture!),
                                          errorBuilder: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.contain,
                                          height: 40,
                                          width: 40)
                                      : Image.asset('assets/images/demoimg.png',
                                          fit: BoxFit.cover,
                                          height: 90,
                                          width: 90)),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ));
    });
  }
}
