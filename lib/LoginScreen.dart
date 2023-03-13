import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:local_app_task/SignupScreen.dart';
import 'package:local_app_task/UserProvider.dart';
import 'package:local_app_task/getTextformField.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, object, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Login with Signup'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      children: [
                        const SizedBox(height: 50.0),
                        const Text(
                          "Login",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 40.0),
                        ),
                        const SizedBox(height: 10.0),
                        Image.asset(
                          "assets/images/logo.png",
                          height: 150.0,
                          width: 150.0,
                        ),
                        const SizedBox(height: 10.0),
                      ],
                    ),
                  ),
                  getTextFormField(
                      controller: object.email,
                      icon: Icons.person,
                      hintName: 'Email Id or Phone Number'),
                  const SizedBox(height: 10.0),
                  getTextFormField(
                    controller: object.password,
                    icon: Icons.lock,
                    hintName: 'Password',
                    isObscureText: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      setState(() {
                        object.login(context);
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Does not have account? '),
                        ElevatedButton(
                          // textColor: Colors.blue,
                          child: const Text('Signup'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SignupScreen()));
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
