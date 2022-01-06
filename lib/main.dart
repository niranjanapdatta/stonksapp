import 'package:flutter/material.dart';

import 'frontend/Screens/LoginPage.dart';

void main() => runApp(Stonks());

class Stonks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Stonks",
        home: LoginPage(),
        theme: ThemeData(checkboxTheme:
            CheckboxThemeData(fillColor: MaterialStateColor.resolveWith(
          (states) {
            if (states.contains(MaterialState.selected)) {
              return Colors.purple; // the color when checkbox is selected;
            }
            return Colors.white; //the color when checkbox is unselected;
          },
        ))));
  }
}
