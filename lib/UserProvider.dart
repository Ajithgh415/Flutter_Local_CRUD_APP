import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_app_task/Databasehelper.dart';
import 'package:local_app_task/HomeScreen.dart';
import 'package:local_app_task/LoginScreen.dart';
import 'package:local_app_task/UserModelClass.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

enum AuthMode { Signup, Login }

class UserProvider extends ChangeNotifier {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  final TextEditingController _email = TextEditingController();

  TextEditingController get email => _email;

  final TextEditingController _searchController = TextEditingController();

  TextEditingController get searchController => _searchController;

  final TextEditingController _password = TextEditingController();

  TextEditingController get password => _password;

  final TextEditingController _confirmPassword = TextEditingController();

  TextEditingController get confirmPassword => _confirmPassword;

  final TextEditingController _phone = TextEditingController();

  TextEditingController get phone => _phone;

  final TextEditingController _name = TextEditingController();

  TextEditingController get name => _name;

  String _profileImageUrl = "";

  String get profileImageUrl => _profileImageUrl;

  File get profileImage => _profileImage;

  File _profileImage = File("");

  final _picker = ImagePicker();

  final formKey = new GlobalKey<FormState>();

  bool editable = false;

  bool get _editable => editable;

  bool adminuser = false;

  bool get _adminuser => adminuser;

  List<User> userlist = [];
  List<User> get _userList => userlist;

  List<User> removeduserlist = [];
  List<User> get _removeduserlist => removeduserlist;

  String userid = "";

  String get _userid => userid;

  void profileImageModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                    onTap: () =>
                        {Navigator.pop(context), profileCameraImage("C")}),
                ListTile(
                  leading: Icon(Icons.image),
                  title: const Text('Gallery'),
                  onTap: () => {Navigator.pop(context), profileCameraImage("")},
                ),
              ],
            ),
          );
        });
  }

  User? _authenticatedUser;

  User? get authenticatedUser {
    return _authenticatedUser;
  }

  void getDeletedUserData(BuildContext context, String userId) async {
    final user2 = await DatabaseHelper.instance.queryUserDetails(userId, 1);
    if (user2 != null) {
      print(user2.toMap().toString());
      userid = user2.id.toString();
      email.text = user2.email.toString();
      phone.text = user2.phone.toString();
      name.text = user2.name.toString();
      password.text = user2.password.toString();
      _profileImageUrl = user2.profilePicture.toString();
      editable = true;
      notifyListeners();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SucessFully Fetched UserDetails'),
        backgroundColor: Colors.green,
      ),
    );
    notifyListeners();
  }

  void getUserData(BuildContext context, String userId, String mode) async {
    final user2 = await DatabaseHelper.instance.queryUserDetails(userId, 0);
    if (user2 != null) {
      print(user2.toMap().toString());
      userid = user2.id.toString();
      email.text = user2.email.toString();
      phone.text = user2.phone.toString();
      name.text = user2.name.toString();
      password.text = user2.password.toString();
      _profileImageUrl = user2.profilePicture.toString();
      editable = true;
      if (mode == "") {
        setSP(user2);
      } else if (mode == "Admin" && userId != "") {
        adminuser = true;
      }
      notifyListeners();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SucessFully Fetched UserDetails'),
        backgroundColor: Colors.green,
      ),
    );
    notifyListeners();
  }

  fetchSearchAutoComplete(String pattern, List<User> userListt) {
    return userListt
        .where((element) =>
            element.name
                .toString()
                .toLowerCase()
                .contains(pattern.toLowerCase()) ||
            element.email
                .toString()
                .toLowerCase()
                .contains(pattern.toLowerCase()) ||
            element.phone
                .toString()
                .toLowerCase()
                .contains(pattern.toLowerCase()))
        .toList();
  }

  Future<void> authenticate(
      BuildContext context,
      String emailOrPhoneNumber,
      String passwordString,
      AuthMode authMode,
      String nameString,
      String profilePicString,
      String emailString) async {
    try {
      if (authMode == AuthMode.Login) {
        // Login
        if (emailOrPhoneNumber == "Admin" && passwordString == "0000") {
          final user1 = await DatabaseHelper.instance.getAllUsers(0);
          final SharedPreferences sp = await _pref;
          sp.setString("isAdmin", "true");
          sp.setString("IsLoggedIn", "true");
          adminuser = true;
          userlist = user1;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        mode: "Admin",
                        mode2: "",
                      )),
              (route) => false);
        } else {
          final user = await DatabaseHelper.instance
              .queryUser(emailOrPhoneNumber, passwordString);
          notifyListeners();
          if (user != null) {
            print(user.toMap().toString());
            _authenticatedUser = user;
            editable = true;
            userid = user.id.toString();
            email.text = user.email.toString();
            name.text = user.name.toString();
            phone.text = user.phone.toString();
            _profileImageUrl = user.profilePicture.toString();
            password.text = user.password.toString();
            setSP(user);
            adminuser = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Sucessfull Login'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          userId: userid,
                          mode: "",
                          mode2: "",
                        )),
                (route) => false);
            notifyListeners();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid email/phone number or password'),
                backgroundColor: Colors.red,
              ),
            );
            notifyListeners();
          }
        }
      } else {
        // Sign up
        final existingUser = await DatabaseHelper.instance
            .queryUser(emailOrPhoneNumber, passwordString);
        if (existingUser != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "An account with this email/phone number already exists"),
              backgroundColor: Colors.red,
            ),
          );
          notifyListeners();
          // throw "An account with this email/phone number already exists";
        } else {
          final now = DateTime.now().millisecondsSinceEpoch;
          // Generate a random string of length 4
          final random = Random();
          final randString = String.fromCharCodes(
              List.generate(4, (_) => random.nextInt(26) + 65));
          final String userId = 'USER$now$randString';
          final String id = userId;
          final user = User(
              id: id,
              name: nameString,
              email: emailString,
              phone: emailOrPhoneNumber,
              password: passwordString,
              profilePicture: profilePicString,
              isDeleted: 0);
          await DatabaseHelper.instance.insert(user);
          _authenticatedUser = user;
          _profileImage = File("");
          name.text = "";
          phone.text = '';
          confirmPassword.text = '';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("User Sucessfull Registered "),
              backgroundColor: Colors.green,
            ),
          );
          notifyListeners();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false);
          notifyListeners();
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
      // throw error;
    }
  }

  void updateUser(
      BuildContext context, User user, String mode, String mode2) async {
    if (formKey.currentState!.validate()) {
      await DatabaseHelper.instance.updateUser(user);
      final user2 = await DatabaseHelper.instance.queryUserDetails(user.id!, 0);
      if (mode == "") {
        if (user2 != null) {
          print(user2.toMap().toString());
          userid = user2.id.toString();
          email.text = user2.email.toString();
          phone.text = user2.phone.toString();
          name.text = user2.name.toString();
          password.text = user2.password.toString();
          _profileImageUrl = user2.profilePicture.toString();
          editable = true;
          setSP(user2);
          notifyListeners();
        }
      } else {
        adminuser = true;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      mode: "Admin",
                      mode2: "",
                    )));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('SucessFully Updated'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void removeUser(BuildContext context, User user) async {
    await DatabaseHelper.instance.updateUser(user);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('SucessFully Removed'),
        backgroundColor: Colors.green,
      ),
    );
    // getDeletedUserList(context);
    getUserList(context);
    // login(context);
    notifyListeners();
  }

  void getUserList(BuildContext context) async {
    final user1 = await DatabaseHelper.instance.getAllUsers(0);
    final SharedPreferences sp = await _pref;
    sp.setString("isAdmin", "true");
    sp.setString("IsLoggedIn", "true");
    adminuser = true;
    userlist = user1;
    notifyListeners();
  }

  void getDeletedUserList(BuildContext context) async {
    final user1 = await DatabaseHelper.instance.getAllUsers(1);
    final SharedPreferences sp = await _pref;
    sp.setString("isAdmin", "true");
    sp.setString("IsLoggedIn", "true");
    // adminuser = true;
    removeduserlist = user1;
    notifyListeners();
  }

  void clearData() async {
    name.text = "";
    email.text = "";
    password.text = "";
    confirmPassword.text = "";
    phone.text = "";
    _profileImageUrl = "";
    _profileImage = File("");
    userid = "";
    userlist.clear();
    final SharedPreferences sp = await _pref;
    sp.clear();
    sp.setString("user_id", "");
    sp.setString("name", "");
    sp.setString("email", "");
    sp.setString("password", "");
    sp.setString("profilePic", "");
    sp.setString("phoneNumber", "");
    sp.setString("IsLoggedIn", "false");
    sp.setString("isAdmin", "false");
    notifyListeners();
  }

  void logout(BuildContext context) {
    _authenticatedUser = null;
    clearData();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
    notifyListeners();
  }

  signUp(BuildContext context) async {
    String uname = _name.text.trim();
    String email = _email.text.trim();
    String passwd = _password.text.trim();
    String cpasswd = _confirmPassword.text.trim();
    String phone = _phone.text.trim();
    notifyListeners();

    if (formKey.currentState!.validate()) {
      if (passwd != cpasswd) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password Mismatch'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // formKey.currentState!.save();
        authenticate(context, phone, passwd, AuthMode.Signup, uname,
            profileImageUrl, email);
        // await DatabaseHel,per.saveData(uModel).then((userData) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Sucessfully Save'),
        //       backgroundColor: Colors.green,
        //     ),
        //   );

        // Navigator.push(
        //     context, MaterialPageRoute(builder: (_) => LoginScreen()));
        // }).catchError((error) {
        //   print(error);
        //   SnackBar(
        //     content: Text("Error: Data Save Fail"),
        //     backgroundColor: Colors.red,
        //   );
        // });
      }
    }
  }

  login(BuildContext context) async {
    print(_email.text.toString());
    String email = _email.text.trim();
    String passwd = _password.text.trim();
    notifyListeners();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the email or phonenumber'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (passwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter the password'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      authenticate(context, email, passwd, AuthMode.Login, "", "", "");

      notifyListeners();
      // await dbHelper.getLoginUser(uid, passwd).then((userData) {
      //   if (userData != null) {
      //     setSP(userData).whenComplete(() {
      //       Navigator.pushAndRemoveUntil(
      //           context,
      //           MaterialPageRoute(builder: (_) => HomeForm()),
      //           (Route<dynamic> route) => false);
      //     });
      //   } else {
      //     alertDialog(context, "Error: User Not Found");
      //   }
      // }).catchError((error) {
      //   print(error);
      // });
    }
  }

  Future setSP(User user) async {
    final SharedPreferences sp = await _pref;
    print('Velue Setting');
    sp.setString("user_id", user.id!);
    sp.setString("name", user.name!);
    sp.setString("email", user.email!);
    sp.setString("password", user.password!);
    sp.setString("profilePic", user.profilePicture!);
    sp.setString("phoneNumber", user.phone!);
    sp.setString("IsLoggedIn", "true");
    notifyListeners();
  }

  Future profileCameraImage(mode) async {
    final pickedfile = await _picker.pickImage(
        source: mode == "C" ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 25);
    if (pickedfile != null) {
      _profileImage = File(pickedfile.path);
      _profileImage = File(pickedfile.path.toString());
      var fileSize = _profileImage.lengthSync();
      final directory = await getApplicationDocumentsDirectory();
      final now = DateTime.now().millisecondsSinceEpoch;
      // Generate a random string of length 4
      final random = Random();
      final randString = String.fromCharCodes(
          List.generate(4, (_) => random.nextInt(26) + 65));
      String d = "profile_pic$now$randString.jpg";
      final imagePath = '${directory.path}/$d';
      print(imagePath);
      final savedImage = await _profileImage.copy(imagePath);
      _profileImageUrl = savedImage.path.toString();
      print('File Size' + profileImage!.lengthSync().toString());
      if (fileSize < 10000000) {
      } else {
        // profilepicSelected = false;
        _profileImage = File("");
      }
      notifyListeners();
    } else {
      print('No image');
    }
  }
}
