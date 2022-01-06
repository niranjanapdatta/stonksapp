import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:stonksapp/Models/UserModel.dart';
import 'package:stonksapp/Services/Api.dart';
import 'package:stonksapp/frontend/Screens/LoginPage.dart';

class DeleteAccountPage extends StatefulWidget {

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
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

  _showDeleteAccountAlert(BuildContext context) {
    AlertDialog alert = AlertDialog(  
    title: Text("Delete Account Warning"),  
    content: Text("Are you sure you want to delete your Stonks account?"),  
    actions: [  
      ElevatedButton(
      child: Text("Yes"),
      onPressed: () {
        _deleteAccountAction();
      },
    ),  
    ElevatedButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ), 
    ],  
  );  
  showDialog(  
    context: context,  
    builder: (BuildContext context) {  
      return alert;  
    },  
  );  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Account"),
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
              "Delete Account",
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
            ElevatedButton(
              child: Text("Delete Account"),
              onPressed: () => _showDeleteAccountAlert(context),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteAccountAction() {
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

      Api.deleteUser(UserModel(
              username: _usernameController.text, password: digest.toString()))
          .then((res) {
        setState(() {
          response = res;
          if (response != null) {
            if (response == "username") {
              _validateUsername = false;
              _usernameValidationErrorText =
                  "User by that username does not exist";
            } else if(response == "admin"){
              _validateUsername = false;
              _usernameValidationErrorText = "Cannot delete a user that has admin privileges";
            }
            else if (response == "incorrect") {
              _validatePassword = false;
              _passwordValidationErrorText = "Incorrect Password";
            } else if (response == "success") {
              Navigator.pop(
                context,
              );
              Navigator.pop(
                context,
              );
              Navigator.pop(
                context,
              );
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()));
            }
          }
        });
      });
    }
  }
}
