import 'package:flutter/material.dart';
import 'package:stonksapp/Models/TriviaModel.dart';
import 'package:stonksapp/Services/Api.dart';
import 'package:stonksapp/frontend/Screens/AddTriviaPage.dart';
import 'package:stonksapp/frontend/Screens/Trivia.dart';

class TriviaPage extends StatefulWidget {
  final bool isAdmin;

  TriviaPage(this.isAdmin);

  @override
  _TriviaPageState createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage> {
  List<TriviaModel> _triviaList;
  String response;

  void initState() {
    super.initState();

    Api.getTrivia().then((trivia) {
      setState(() {
        _triviaList = trivia;
      });
    });
  }

  _showDeleteTriviaAlert(BuildContext context, id) {
    AlertDialog alert = AlertDialog(  
    title: Text("Delete Trivia Warning"),  
    content: Text("Are you sure you want to delete this trivia?"),  
    actions: [  
      ElevatedButton(
      child: Text("Yes"),
      onPressed: () {
        _deleteTriviaAction(id);
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
        title: Text("Trivia"),
      ),
      body: Container(
        color: Colors.white54,
        width: double.infinity,
        child: _triviaList != null
            ? GridView.builder(
                itemCount: _triviaList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Container(
                          child: Card(
                        elevation: 10,
                        child: Container(
                            color: Colors.black87,
                            height: 50,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                                                      child: Text(
                                      _triviaList[index].title,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                widget.isAdmin
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent)),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddTriviaPage(widget.isAdmin, trivia: _triviaList[index]),
                              ),
                            ),
                                          ),
                                          ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent)),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            onPressed: () =>
                                                _showDeleteTriviaAlert(context, 
                                                    _triviaList[index].id),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            )),
                      )),
                    ),
                    onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Trivia(_triviaList[index]),
                              ),
                            ),
                  );
                })
            : Text("Loading..."),
      ),
    );
  }

  void _deleteTriviaAction(String id) {
    Api.deleteTrivia(id).then((res) => setState(() {
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
