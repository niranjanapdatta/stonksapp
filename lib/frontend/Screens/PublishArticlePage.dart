import 'package:flutter/material.dart';

import 'package:stonksapp/Models/ArticleModel.dart';
import 'package:stonksapp/Services/Api.dart';
import 'package:stonksapp/frontend/Screens/HomePage.dart';
import 'package:stonksapp/frontend/Widgets/TextFieldForForm.dart';

class PublishArticlePage extends StatefulWidget {
  final bool isAdmin;
  final ArticleModel article;

  PublishArticlePage(this.isAdmin, {this.article});

  @override
  _PublishArticlePage createState() => _PublishArticlePage();
}

class _PublishArticlePage extends State<PublishArticlePage> {
  static const String _defaultForSymbol = "general";
  static const String _defaultImageLink =
      "https://www1.nseindia.com/global/resources/images/NSE_reverse@4x-100.jpg";
  final String _validationErrorText = "Required Field";
  String response;

  bool _validateTitle = true;
  bool _validateSummary = true;
  bool _editMode = false;
  TextEditingController _tilteController,
      _summaryController,
      _forSymbolController,
      _imageLinkController;

  void initState() {
    super.initState();

    _tilteController = TextEditingController();
    _summaryController = TextEditingController();
    _forSymbolController = TextEditingController();
    _imageLinkController = TextEditingController();

    if (widget.article != null) {
      _editMode = true;
      _tilteController.text = widget.article.title;
      _summaryController.text = widget.article.summary;
      _forSymbolController.text = widget.article.forSymbol;
      _imageLinkController.text = widget.article.imageLink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editMode ? "Edit Article" : "Publish Article"),
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
              _editMode ? "Edit News Article" : "Add News Article",
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
            TextFieldForForm("For SYMBOL", 1, _forSymbolController),
            TextFieldForForm("Image Link", 1, _imageLinkController),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 20),
              child: TextField(
                controller: _summaryController,
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Summary",
                  errorText: _validateSummary ? null : _validationErrorText,
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
                  child: Text(_editMode ? "Save Changes" : "Publish Article"),
                  onPressed: () =>
                      _editMode ? _editArticleAction() : _publishArticleAction(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _publishArticleAction() {
    _validateTitle = true;
    _validateSummary = true;
    if (_tilteController.text.isEmpty) {
      setState(() => _validateTitle = false);
    }
    if (_summaryController.text.isEmpty) {
      setState(() => _validateSummary = false);
    } else {
      setState(() {
        _validateTitle = true;
        _validateSummary = true;
      });
      Api.publishArticle(ArticleModel(
              title: _tilteController.text,
              summary: _summaryController.text,
              forSymbol: _forSymbolController.text.isEmpty
                  ? _defaultForSymbol
                  : _forSymbolController.text.toUpperCase(),
              imageLink: _imageLinkController.text.isEmpty
                  ? _defaultImageLink
                  : _imageLinkController.text))
          .then((res) => setState(() {
                response = res;
                if (response != null) {
                  if (response == "success") {
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
                            builder: (BuildContext context) =>
                                HomePage(widget.isAdmin)));
                  }
                }
              }));
    }
  }

  void _editArticleAction() {
    _validateTitle = true;
    _validateSummary = true;
    if (_tilteController.text.isEmpty) {
      setState(() => _validateTitle = false);
    }
    if (_summaryController.text.isEmpty) {
      setState(() => _validateSummary = false);
    } else {
      setState(() {
        _validateTitle = true;
        _validateSummary = true;
      });
      Api.editArticle(ArticleModel(
              title: _tilteController.text,
              summary: _summaryController.text,
              forSymbol: _forSymbolController.text.isEmpty
                  ? _defaultForSymbol
                  : _forSymbolController.text.toUpperCase(),
              imageLink: _imageLinkController.text.isEmpty
                  ? _defaultImageLink
                  : _imageLinkController.text,
              id: widget.article.id))
          .then((res) => setState(() {
                response = res;
                if (response != null) {
                  if (response == "success") {
                    Navigator.pop(
                      context,
                    );
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
}
