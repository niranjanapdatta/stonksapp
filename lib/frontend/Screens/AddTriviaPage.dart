import 'package:flutter/material.dart';

import 'package:stonksapp/Models/TriviaModel.dart';
import 'package:stonksapp/Services/Api.dart';
import 'package:stonksapp/frontend/Screens/HomePage.dart';
import 'package:stonksapp/frontend/Screens/TriviaPage.dart';
import 'package:stonksapp/frontend/Widgets/TextFieldForForm.dart';

class AddTriviaPage extends StatefulWidget {
  final bool isAdmin;
  final TriviaModel trivia;

  AddTriviaPage(this.isAdmin, {this.trivia});

  @override
  _AddTriviaPage createState() => _AddTriviaPage();
}

class _AddTriviaPage extends State<AddTriviaPage> {
  static const _defaultVideoUrlText = "none";
  final String _validationErrorText = "Required Field";
  String response;

  bool _validateTitle = true;
  bool _validateDescription = true;
  TextEditingController _tilteController,
      _descriptionController,
      _videoUrlController;
  bool _editMode = false;

  void initState() {
    super.initState();

    _tilteController = TextEditingController();
    _descriptionController = TextEditingController();
    _videoUrlController = TextEditingController();

    if (widget.trivia != null) {
      _editMode = true;
      _tilteController.text = widget.trivia.title;
      _descriptionController.text = widget.trivia.description;
      _videoUrlController.text = widget.trivia.videoUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editMode ? "Edit Trivia" : "Add Trivia"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Text(
              _editMode ? "Edit Trivia" : "Add Trivia",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 20),
              child: TextField(
                controller: _tilteController,
                autofocus: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Title",
                  errorText: _validateTitle ? null : _validationErrorText,
                ),
              ),
            ),
            TextFieldForForm("YouTube Video URL", 1, _videoUrlController),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 20),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Description",
                  errorText: _validateDescription ? null : _validationErrorText,
                ),
                maxLines: 10,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text(_editMode ? "Save Trivia" : "Add Trivia"),
                  onPressed: () =>
                      _editMode ? _editTriviaAction() : _addTriviaAction(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addTriviaAction() {
    // Improve methods in AddTriviaPage, PublishArticlePage, AddSymbolPage, LoginPage, RegistrationPage and DeleteAccountPage.
    _validateTitle = true;
    _validateDescription = true;
    if (_tilteController.text.isEmpty) {
      setState(() => _validateTitle = false);
    }
    if (_descriptionController.text.isEmpty) {
      setState(() => _validateDescription = false);
    } else {
      setState(() {
        _validateTitle = true;
        _validateDescription = true;
      });
      Api.addTrivia(TriviaModel(
              title: _tilteController.text,
              description: _descriptionController.text,
              videoUrl: _videoUrlController.text.isEmpty
                  ? _defaultVideoUrlText
                  : _videoUrlController.text))
          .then((res) => setState(() {
                response = res;
                if (response != null) {
                  if (response == "success") {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HomePage(widget.isAdmin)));
                  }
                }
              }));
    }
  }

  void _editTriviaAction() {
    _validateTitle = true;
    _validateDescription = true;
    if (_tilteController.text.isEmpty) {
      setState(() => _validateTitle = false);
    }
    if (_descriptionController.text.isEmpty) {
      setState(() => _validateDescription = false);
    } else {
      setState(() {
        _validateTitle = true;
        _validateDescription = true;
      });
      Api.editTrivia(TriviaModel(
              title: _tilteController.text,
              description: _descriptionController.text,
              videoUrl: _videoUrlController.text.isEmpty
                  ? _defaultVideoUrlText
                  : _videoUrlController.text,
              id: widget.trivia.id))
          .then((res) => setState(() {
                response = res;
                if (response != null) {
                  if (response == "success") {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TriviaPage(widget.isAdmin)));
                  }
                }
              }));
    }
  }
}
