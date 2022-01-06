import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:stonksapp/Models/AnalysisModel.dart';
import 'package:stonksapp/Models/ArticleModel.dart';
import 'package:stonksapp/Models/SingleAnalysisModel.dart';
import 'package:stonksapp/Models/SymbolModel.dart';
import 'package:stonksapp/Services/Api.dart';
import 'package:stonksapp/frontend/Widgets/AboutStock.dart';
import 'package:stonksapp/frontend/Widgets/SingleStockNews.dart';
import '../Widgets/AnalysisTable.dart';
import '../Widgets/Graph.dart';
import '../SeperateAnalysis.dart';

class Stock extends StatefulWidget {
  final AnalysisModel _stock;
  final SymbolModel _symbol;

  Stock(this._stock, this._symbol);

  @override
  _StockState createState() => _StockState();
}

class _StockState extends State<Stock> {
  Map<String, List<SingleAnalysisModel>> _analysis = {};
  List<String> _carousel = [
    "Close (₹)",
    "Volatility",
    "Beta",
    "Price up (days)",
    "Avg. Price Up/day (₹)",
    "Price down(days)",
    "Avg. Price Down/day (₹)"
  ];
  double currentClose = 0;
  List<ArticleModel> _insightsForStock;

  void initState() {
    currentClose = widget._stock.close;
    SeperateAnalysis _getSeperateAnalysis = SeperateAnalysis(widget._stock);
    _analysis["Six Months"] = [_getSeperateAnalysis.getSixMonthsAnalysis()];
    _analysis["One Year"] = [_getSeperateAnalysis.getOneYearAnalysis()];
    _analysis["Three Years"] = [_getSeperateAnalysis.getThreeYearsAnalysis()];
    _analysis["Five Years"] = [_getSeperateAnalysis.getFiveYearsAnalysis()];
    _analysis["About Page"] = null;
    _analysis["News"] = null;
    Api.getArticlesForSymbol(widget._symbol.symbolName)
        .then((articles) => setState(() {
              _insightsForStock = articles;
            }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._stock.id),
      ),
      body: _analysis != null
          ? Column(
              children: [
                CarouselSlider.builder(
                  itemCount: _carousel.length,
                  itemBuilder: (context, index, _) {
                    return Column(
                      children: [
                        Graph(_analysis, _carousel[index], [widget._stock.id]),
                        Text(
                          _carousel[index] + " <-Swipe for more->",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    );
                  },
                  options: CarouselOptions(height: 360, viewportFraction: 1.0),
                ),
                SingleChildScrollView(
                  child: Container(
                    height: 270,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _analysis.length,
                        itemBuilder: (ctx, index) {
                          String key = _analysis.keys.elementAt(index);
                          return ExpansionTile(title: Text("$key"), children: [
                            key == "About Page" || key == "News"
                                ? key == "News"
                                    ? _insightsForStock != null
                                        ? SingleStockNews(_insightsForStock)
                                        : Container()
                                    : AboutStock(widget._symbol)
                                // Converting stock symbol to list by wrapping it with [ ]
                                : AnalysisTable(
                                    [widget._stock.id],
                                    _analysis[key],
                                    [widget._symbol],
                                    [currentClose]),
                          ]);
                        }),
                  ),
                )
              ],
            )
          : Text("Loading..."),
    );
  }
}
