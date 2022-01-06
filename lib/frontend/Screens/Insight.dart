import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:stonksapp/Models/ArticleModel.dart';

class Insight extends StatefulWidget {
  final ArticleModel _insight;

  Insight(this._insight);

  @override
  _InsightState createState() => _InsightState();
}

class _InsightState extends State<Insight> {
  final DateFormat _dateFormat = DateFormat("MMM dd yyyy");

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget._insight.title),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.black87,
            child: Column(
              children: [
                Card(
                  elevation: 3,
                  child: Container(
                    color: Colors.black87,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget._insight.title,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Published on : " +
                          _dateFormat
                              .format(DateTime.parse(widget._insight.timestamp))
                              .toString() + " Topic: ${widget._insight.forSymbol.toUpperCase()}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Card(
                    child: Container(
                      color: Colors.black87,
                      height: 600,
                      width: double.infinity,
                      child: Text(
                        widget._insight.summary,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
