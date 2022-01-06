import 'package:flutter/material.dart';

class TextFieldForForm extends StatelessWidget {
  final String labelForTextField;
  final int maxLinesForTextField;
  final TextEditingController controller;

  TextFieldForForm(this.labelForTextField, this.maxLinesForTextField, this.controller);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
      child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: labelForTextField,
                ),
                maxLines: maxLinesForTextField,
              ),
    );
  }
}