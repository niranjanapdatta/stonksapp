import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:stonksapp/Models/UserModel.dart';
import 'package:stonksapp/Services/Api.dart';
import 'package:stonksapp/frontend/Screens/HomePage.dart';
import './RegistrationPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _validateUsername = true;
  bool _validatePassword = true;
  String response;

  String _usernameValidationErrorText, _passwordValidationErrorText;
  TextEditingController _usernameController, _passwordController;

  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
          child: Scaffold(
        appBar: AppBar(
          title: Text("Login Page"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                "LOGIN",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 20),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                    errorText:
                        _validateUsername ? null : _usernameValidationErrorText,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, left: 10, right: 10, bottom: 20),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    errorText:
                        _validatePassword ? null : _passwordValidationErrorText,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text("Change Password"),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage(changePassword: true))),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    child: Text("Login"),
                    onPressed: () => _loginAction(),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    child: Text("Sign Up"),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage())),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginAction(){
    _validateUsername = true;
    _validatePassword = true;
    if (_usernameController.text.isEmpty) {
      setState(() {
        _validateUsername = false;
        _usernameValidationErrorText = "Username is required";
      });
    }
    if (_passwordController.text.isEmpty) {
      setState(() {
        _validatePassword = false;
        _passwordValidationErrorText = "Password is required";
      });
    } else {
      setState(() {
        _validateUsername = true;
        _validatePassword = true;
      });

      var bytes = utf8.encode(_passwordController.text);
      var digest = sha256.convert(bytes);

      Api.authenticateUser(UserModel(
              username: _usernameController.text, password: digest.toString()))
          .then((res) {
        setState(() {
          response = res;
          if (response != null) {
            if(response == "username"){
              _validateUsername = false;
              _usernameValidationErrorText = "User by that username does not exist";
            }
            else if(response == "incorrect"){
              _validatePassword = false;
              _passwordValidationErrorText = "Incorrect Password";
            }
            else if(response == "admin" || response == "user"){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => response == "admin"
                        ? HomePage(true)
                        : HomePage(false)));
          }
          }
        });
      });
    }
  }
}
