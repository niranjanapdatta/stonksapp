import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:stonksapp/Models/AnalysisModel.dart';
import 'package:stonksapp/Models/SingleAnalysisModel.dart';
import 'package:stonksapp/Models/SymbolModel.dart';
import '../Widgets/AnalysisTable.dart';
import '../SeperateAnalysis.dart';
import '../Widgets/Graph.dart';

class ComparePage extends StatefulWidget {
  final List<AnalysisModel> stocksToCompare;
  final List<SymbolModel> symbolDetails;

  ComparePage(this.stocksToCompare, this.symbolDetails);

  @override
  _ComparePageState createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  List<String> _symbols = [];
  List<SingleAnalysisModel> _sixMonthsAnalyses = [];
  List<SingleAnalysisModel> _oneYearAnalyses = [];
  List<SingleAnalysisModel> _threeYearsAnalyses = [];
  List<SingleAnalysisModel> _fiveYearsAnalyses = [];
  Map<String, List<SingleAnalysisModel>> _analyses = {};
  List<String> _carousel = [
    "Close (₹)",
    "Volatility",
    "Beta",
    "Price up (days)",
    "Avg. Price Up/day (₹)",
    "Price down(days)",
    "Avg. Price Down/day (₹)"
  ];
  List<double> _currentClosePrices = [];

  void initState() {
    for (int i = 0; i < widget.stocksToCompare.length; i++) {
      _currentClosePrices.add(widget.stocksToCompare[i].close);
    }
    for (int i = 0; i < widget.stocksToCompare.length; i++) {
      _symbols.add(widget.stocksToCompare[i].id);
      SeperateAnalysis _getSeperateAnalysis =
          SeperateAnalysis(widget.stocksToCompare[i]);
      _sixMonthsAnalyses.add(_getSeperateAnalysis.getSixMonthsAnalysis());
      _oneYearAnalyses.add(_getSeperateAnalysis.getOneYearAnalysis());
      _threeYearsAnalyses.add(_getSeperateAnalysis.getThreeYearsAnalysis());
      _fiveYearsAnalyses.add(_getSeperateAnalysis.getFiveYearsAnalysis());
    }
    _analyses["Six Months"] = _sixMonthsAnalyses;
    _analyses["One Year"] = _oneYearAnalyses;
    _analyses["Three Years"] = _threeYearsAnalyses;
    _analyses["Five Years"] = _fiveYearsAnalyses;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Compare"),
        ),
        body: widget.stocksToCompare.length < 2 ||
                widget.stocksToCompare.length > 4
            ? Container(
                child: Text("Please select 2-4 Stocks/ Funds to compare"),
              )
            : _analyses == null
                ? Text("Loading...")
                : Column(
                    children: [
                      CarouselSlider.builder(
                        itemCount: _carousel.length,
                        itemBuilder: (context, index, _) {
                          return Column(
                            children: [
                              Graph(_analyses, _carousel[index], _symbols),
                              Text(
                                _carousel[index] + " <-Swipe for more->",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                        options:
                            CarouselOptions(height: 360, viewportFraction: 1.0),
                      ),
                      SingleChildScrollView(
                        child: Container(
                          height: 270,
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _analyses.length,
                              itemBuilder: (context, index) {
                                String key = _analyses.keys.elementAt(index);
                                return ExpansionTile(
                                    title: Text("$key"),
                                    children: [
                                      AnalysisTable(
                                          _symbols,
                                          _analyses[key],
                                          widget.symbolDetails,
                                          _currentClosePrices),
                                    ]);
                              }),
                        ),
                      ),
                    ],
                  ));
  }
}
