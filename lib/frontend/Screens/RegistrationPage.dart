import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:stonksapp/Models/UserModel.dart';
import 'package:stonksapp/Services/Api.dart';
import 'package:stonksapp/frontend/Screens/LoginPage.dart';


class RegistrationPage extends StatefulWidget {
  final bool changePassword;

  RegistrationPage({this.changePassword});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool _validateUsername = true;
  bool _validatePassword = true;
  bool _validateRetypePassword = true;
  bool _validateOldPassword = true;
  static const bool _isAdmin = false;
  String response;

  String _validationErrorUsername, _validationErrorPassword, _validationErrorOldPassword, _validateErrorRetypePassword = "Does not match the password";
  TextEditingController _usernameController, _passwordController, _retypePasswordController, _oldPasswordController;

  void initState(){
    super.initState();

    _usernameController = TextEditingController();
    _oldPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _retypePasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.changePassword != null ? "Change Password" : "Sign Up"),
        ),
        body: SingleChildScrollView(
                  child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                Text(widget.changePassword != null ? "Change Password" : "SIGN UP", style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
                  child: TextField(
                    controller: _usernameController,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Username",
                      errorText: _validateUsername ? null : _validationErrorUsername,
                    ),
                  ),
                ),
                widget.changePassword != null ? SizedBox(height: 20,) : Container(),
                widget.changePassword != null ? Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
                  child: TextField(
                    controller: _oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Old Password",
                      errorText: _validateOldPassword ? null : _validationErrorOldPassword,
                    ),
                  ),
                ) : Container(),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: widget.changePassword != null ? "New Password" : "Password",
                      errorText: _validatePassword ? null : _validationErrorPassword,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
                  child: TextField(
                    controller: _retypePasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: widget.changePassword != null ? "Retype New Password" : "Retype Password",
                      errorText: _validateRetypePassword ? null : _validateErrorRetypePassword,
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                    ElevatedButton(
                  child: Text(widget.changePassword != null ? "Change Password" : "Register"),
                  onPressed: () => widget.changePassword != null ? _changePasswordAction() : 
                      _registerAction(),
                ),
                  ],
                ),
        ),
          );
  }

  void _changePasswordAction(){
    _validateUsername = true;
    _validateOldPassword = true;
    _validatePassword = true;
    _validateRetypePassword = true;
        if(_usernameController.text.isEmpty){
      setState(() {
        _validateUsername = false;
        _validationErrorUsername = "Username is required";
      });
    }
    if(_passwordController.text.isEmpty){
      setState(() {
        _validatePassword = false;
        _validationErrorPassword = "Please type in a new password";
      });
    }
    if(_oldPasswordController.text.isEmpty){
      setState(() {
        _validateOldPassword = false;
        _validationErrorOldPassword = "Please type your old password";
      });
    }
    if(_retypePasswordController.text.isEmpty){
      setState(() {
        _validateRetypePassword = false;
        _validateErrorRetypePassword = "Please retype your new password";
      });
    }
    else if(_retypePasswordController.text != _passwordController.text){
      setState(() {
        _validateRetypePassword = false;
        _validateErrorRetypePassword = "Retyped password should match password";
      });
    }
    else{
      setState(() {
        _validateUsername = true;
        _validatePassword = true;
        _validateRetypePassword = true;
        _validateOldPassword = true;
      });

      var bytesOld = utf8.encode(_oldPasswordController.text);
      var digestOld = sha256.convert(bytesOld);

      var bytes = utf8.encode(_passwordController.text);
      var digest = sha256.convert(bytes);

      Api.changePassword(digestOld.toString(), UserModel(username: _usernameController.text, password: digest.toString(), isAdmin: _isAdmin)).then((res) => setState((){
        response = res;
        if(response != null){
          if(response == "success"){
            Navigator.pop(context);
            Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          LoginPage()));
          }
          else if(response == "username"){
            _validateUsername = false;
            _validationErrorUsername = "User by that username does not exist";
          }
          else if(response == "incorrect"){
            _validateOldPassword = false;
            _validationErrorOldPassword = "Incorrect old password";
          }
          else{
            _validateUsername = false;
            _validationErrorUsername = "An unknown error occured! Please try again";
          }
        }
      }));
    }
  }


  void _registerAction(){
    _validateUsername = true;
    _validatePassword = true;
    _validateRetypePassword = true;
    if(_usernameController.text.isEmpty){
      setState(() {
        _validateUsername = false;
        _validationErrorUsername = "Username is required";
      });
    }
    if(_passwordController.text.isEmpty){
      setState(() {
        _validatePassword = false;
        _validationErrorPassword = "Password is required";
      });
    }
    if(_retypePasswordController.text.isEmpty){
      setState(() {
        _validateRetypePassword = false;
        _validateErrorRetypePassword = "Please retype your password";
      });
    }
    else if(_retypePasswordController.text != _passwordController.text){
      setState(() {
        _validateRetypePassword = false;
        _validateErrorRetypePassword = "Retyped password should match password";
      });
    }
    else{
      setState(() {
        _validateUsername = true;
        _validatePassword = true;
        _validateRetypePassword = true;
      });

      var bytes = utf8.encode(_passwordController.text);
      var digest = sha256.convert(bytes);

      Api.registerUser(UserModel(username: _usernameController.text, password: digest.toString(), isAdmin: _isAdmin)).then((res) => setState((){
        response = res;
        if(response != null){
          if(response == "success"){
            Navigator.pop(context);
            Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          LoginPage()));
          }
          else if(response == "exists"){
            _validateUsername = false;
            _validationErrorUsername = "A user by that username already exists";
          }
          else{
            _validateUsername = false;
            _validationErrorUsername = "An unknown error occured! Please try again";
          }
        }
      }));
    }
  }

}
