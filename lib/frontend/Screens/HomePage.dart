import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stonksapp/Models/ArticleModel.dart';
import 'package:stonksapp/Models/SymbolModel.dart';

import 'package:stonksapp/Services/Api.dart';
import 'package:stonksapp/Models/AnalysisModel.dart';
import 'package:stonksapp/Models/CollectionsModel.dart';
import 'package:stonksapp/frontend/Screens/AddSymbolPage.dart';
import 'package:stonksapp/frontend/Screens/Insight.dart';
import 'package:stonksapp/frontend/Screens/PublishArticlePage.dart';
import './ComparePage.dart';
import './Stock.dart';
import '../Widgets/Menu.dart';

class HomePage extends StatefulWidget {
  final bool isAdmin;

  HomePage(this.isAdmin);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTabIndex = 0;
  List<CollectionsModel> _collections;
  List<AnalysisModel> _stocks = [];
  List<ArticleModel> _insights = [];
  List<bool> _isChecked = [];
  List<AnalysisModel> _addedToCompare = [];
  List<SymbolModel> _symbolDetails = [];
  List<SymbolModel> _symbolDetailsForComparision = [];
  List<AnalysisModel> _stocksForDisplay = [];
  String response, responseSymbol, responseWatchlist;
  SymbolModel symbolData;

  final DateFormat _dateFormat = DateFormat("MMM dd yyyy");

  @override
  void initState() {
    super.initState();

    Api.getSymbolDetails().then((details) {
      setState(() {
        for (int j = 0; j < details.length; j++) {
          _symbolDetails.add(details[j]);
        }
      });
    });
    Api.getCollections().then((stocksClose) {
      setState(() {
        _collections = stocksClose;
        if (_collections != null) {
          for (int i = 0; i < _collections.length; i++) {
            Api.getAnalysis(_collections[i].id).then((stocks) {
              setState(() {
                for (int j = 0; j < stocks.length; j++) {
                  _stocks.add(stocks[j]);
                }
              });
              if (_stocks != null) {
                setState(() {
                  _stocksForDisplay = _stocks;
                });
                _isChecked = List<bool>.filled(_stocks.length, false);
              }
            });
          }
        }
      });
    });

    Api.getArticles().then((articles) {
      setState(() {
        _insights = articles;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Menu(widget.isAdmin),
        appBar: AppBar(
          title: Text("Stonks"),
          bottom: TabBar(
            onTap: (index) {
              setState(() => _currentTabIndex = index);
            },
            tabs: [
              Tab(text: "Stocks"),
              Tab(text: "Insights"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _stocksPage(),
            _insightsPage(),
          ],
        ),
        floatingActionButton: _currentTabIndex == 0 && !widget.isAdmin
            ? FloatingActionButton(
                child: Icon(Icons.compare_arrows_rounded),
                onPressed: () {
                  if (_addedToCompare.length <= 4 &&
                      _addedToCompare.length >= 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ComparePage(
                            _addedToCompare, _symbolDetailsForComparision),
                      ),
                    );
                  } else {
                    _showCompareAlert(context);
                  }
                },
              )
            : null,
      ),
    );
  }

  _showCompareAlert(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Cannot Compare"),
      content: Text("Please select 2-4 Stocks/ Funds to compare."),
      actions: [
        ElevatedButton(
          child: Text("OK"),
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

  _showDeleteSymbolAlert(BuildContext context, String id) {
    AlertDialog alert = AlertDialog(
      title: Text("Delete Symbol Warning"),
      content: Text(
          "Are you sure you want to delete the symbol $id?\nNote: Market Standards cannot be deleted."),
      actions: [
        ElevatedButton(
          child: Text("Yes"),
          onPressed: () {
            _deleteSymbolAction(id);
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

  _showDeleteArticleAlert(BuildContext context, String id) {
    AlertDialog alert = AlertDialog(
      title: Text("Delete Article Warning"),
      content: Text("Are you sure you want to delete this article?"),
      actions: [
        ElevatedButton(
          child: Text("Yes"),
          onPressed: () {
            _deleteArticleAction(id);
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

  Widget _stocksPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 3,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search for SYMBOL',
              ),
              onChanged: (search) {
                search = search.toLowerCase();
                setState(() {
                  _stocksForDisplay = _stocks.where((stocks) {
                    var symbol = stocks.id.toLowerCase();
                    return symbol.contains(search);
                  }).toList();
                });
              },
            ),
          ),
          SingleChildScrollView(
            child: Container(
              color: Colors.white,
              height: 560,
              width: double.infinity,
              child: _stocksForDisplay != null && _symbolDetails != null
                  ? ListView.builder(
                      itemCount: _stocksForDisplay.length,
                      itemBuilder: (ctx, index) {
                        return GestureDetector(
                          child: Card(
                            child: Container(
                              color: Colors.black87,
                              // color: _stocksForDisplay[index].isBullish == 0
                              //     ? Colors.red.shade100
                              //     : Colors.green.shade100,
                              child: ListTile(
                                leading: Text(
                                  _stocksForDisplay[index].id,
                                  style: TextStyle(color: Colors.white),
                                ),
                                title: Align(
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _stocksForDisplay[index].isBullish == 0
                                          ? Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.red,
                                            )
                                          : Icon(Icons.arrow_drop_up,
                                              color: Colors.green),
                                      Text(
                                        _stocksForDisplay[index]
                                            .close
                                            .toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    widget.isAdmin
                                        ? ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent)),
                                            child: Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              for (int i = 0;
                                                  i < _symbolDetails.length;
                                                  i++) {
                                                if (_symbolDetails[i]
                                                        .symbolName ==
                                                    _stocksForDisplay[index]
                                                        .id) {
                                                  symbolData =
                                                      _symbolDetails[i];
                                                  break;
                                                }
                                              }
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddSymbolPage(
                                                    widget.isAdmin,
                                                    symbolData: symbolData,
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Container(),
                                    // : ElevatedButton(
                                    //     style: ButtonStyle(
                                    //         backgroundColor:
                                    //             MaterialStateProperty.all(
                                    //                 Colors.transparent)),
                                    //     child: Icon(
                                    //       Icons.remove_red_eye_sharp,
                                    //       color: Colors.black,
                                    //     ),
                                    //     onPressed: null,
                                    //   ),
                                    widget.isAdmin
                                        ? ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent)),
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                            ),
                                            onPressed: () =>
                                                _showDeleteSymbolAlert(
                                                    context,
                                                    _stocksForDisplay[index]
                                                        .id),
                                          )
                                        : Checkbox(
                                          
                                          activeColor: Colors.white,
                                          checkColor: Colors.black87,
                                            onChanged: (val) {
                                              setState(() {
                                                if (val == true) {
                                                  _addedToCompare.add(
                                                      _stocksForDisplay[index]);
                                                  for (int i = 0;
                                                      i < _symbolDetails.length;
                                                      i++) {
                                                    if (_symbolDetails[i]
                                                            .symbolName ==
                                                        _stocksForDisplay[index]
                                                            .id) {
                                                      _symbolDetailsForComparision
                                                          .add(_symbolDetails[
                                                              index]);
                                                      break;
                                                    }
                                                  }
                                                } else {
                                                  _addedToCompare.remove(
                                                      _stocksForDisplay[index]);
                                                  for (int i = 0;
                                                      i < _symbolDetails.length;
                                                      i++) {
                                                    if (_symbolDetails[i]
                                                            .symbolName ==
                                                        _stocksForDisplay[index]
                                                            .id) {
                                                      _symbolDetailsForComparision
                                                          .remove(
                                                              _symbolDetails[
                                                                  index]);
                                                      break;
                                                    }
                                                  }
                                                }
                                                _isChecked[index] = val;
                                              });
                                            },
                                            value: _isChecked[index],
                                          )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            int symbolIndex = index;
                            for (int i = 0; i < _symbolDetails.length; i++) {
                              if (_symbolDetails[i].symbolName ==
                                  _stocksForDisplay[index].id) {
                                symbolIndex = i;
                                break;
                              }
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Stock(
                                    _stocksForDisplay[index],
                                    _symbolDetails[symbolIndex]),
                              ),
                            );
                          },
                        );
                      })
                  : Text("Loading..."),
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightsPage() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: _insights != null
          ? ListView.builder(
              itemCount: _insights.length,
              itemBuilder: (ctx, index) {
                return widget.isAdmin
                    ? GestureDetector(
                        child: Card(
                          color: Colors.black87,
                          child: ListTile(
                            title: Row(children: [
                              Container(
                                height: 30,
                                width: 224,
                                child: Text(
                                  _insights[index].title,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent)),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PublishArticlePage(
                                        widget.isAdmin,
                                        article: _insights[index]),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.transparent)),
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () => _showDeleteArticleAlert(
                                    context, _insights[index].id),
                              ),
                            ]),
                          ),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Insight(_insights[index]),
                          ),
                        ),
                      )
                    : GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Container(
                              child: Card(
                            elevation: 5,
                            child: Column(
                              children: [
                                FittedBox(
                                  fit: BoxFit.fill,
                                  child: Image.network(
                                    _insights[index].imageLink,
                                  ),
                                ),
                                Container(
                                  color: Colors.black87,
                                  height: 50,
                                  width: double.infinity,
                                  child: Text(
                                    _insights[index].title,
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  color: Colors.black87,
                                  height: 25,
                                  width: double.infinity,
                                  child: Text(
                                    _dateFormat
                                        .format(DateTime.parse(
                                            _insights[index].timestamp))
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Insight(_insights[index]),
                          ),
                        ),
                      );
              })
          : Text("Loading..."),
    );
  }

  void _deleteSymbolAction(String id) {
    Api.deleteSymbol(id).then((res) => setState(() {
          responseSymbol = res;
          if (responseSymbol != null) {
            if (responseSymbol == "success") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          HomePage(widget.isAdmin)));
            }
          }
        }));
  }

  void _deleteArticleAction(String id) {
    Api.deleteArticle(id).then((res) => setState(() {
          response = res;
          if (response != null) {
            if (response == "success") {
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
