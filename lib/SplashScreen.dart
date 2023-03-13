import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomeScreen.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getString('IsLoggedIn');
    final isAdmin = prefs.getString('isAdmin');
    setState(() {
      print(isLoggedIn);
      print(isAdmin);
      
      // If user already login to the app the user will gets to the home screen
      if (isLoggedIn == "true") {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (_) => HomeScreen(
                    mode: isAdmin == "true" ? "Admin" : "",
                    mode2: "",
                  )),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Local Storage Details'),
      ),
    );
  }
}
