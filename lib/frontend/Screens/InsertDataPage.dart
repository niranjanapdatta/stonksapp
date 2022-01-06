import 'package:flutter/material.dart';
import 'package:stonksapp/frontend/Screens/AddSymbolPage.dart';
import 'package:stonksapp/frontend/Screens/AddTriviaPage.dart';
import 'package:stonksapp/frontend/Screens/PublishArticlePage.dart';

class InsertDataPage extends StatelessWidget {
  final bool isAdmin;

  InsertDataPage(this.isAdmin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insert Data"),
      ),
      body: ListView(children: [
        SizedBox(height: 250),
        Card(
          elevation: 5,
          child: ElevatedButton(
            child: Text("Add SYMBOL"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddSymbolPage(isAdmin),
              ),
            ),
          ),
        ),
        Card(
          elevation: 5,
          child: ElevatedButton(
            child: Text("Add News Article"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PublishArticlePage(isAdmin),
              ),
            ),
          ),
        ),
        Card(
          elevation: 5,
          child: ElevatedButton(
            child: Text("Add Stock Market Trivia"),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTriviaPage(isAdmin),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
