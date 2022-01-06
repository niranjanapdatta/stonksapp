import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'package:stonksapp/Models/SingleAnalysisModel.dart';

class Graph extends StatelessWidget {
  final Map<String, List<SingleAnalysisModel>> analysis;
  final String graphFor;
  final List<String> symbols;

  Graph(this.analysis, this.graphFor, this.symbols);

  @override
  Widget build(BuildContext context) {
    List<List<StockGraph>> _data = [];
    List<charts.Series<StockGraph, String>> _graphData = [];

    for (int i = 0; i < analysis["Six Months"].length; i++) {
      List<StockGraph> _tempData = [];
      for (var key in analysis.keys) {
        if (key == "About Page" || key == "News") {
          continue;
        }
        if (graphFor == "Close (₹)") {
          _tempData.add(StockGraph(key, analysis[key][i].close));
        } else if (graphFor == "Volatility") {
          _tempData.add(StockGraph(key, analysis[key][i].volatility));
        } else if (graphFor == "Beta") {
          _tempData.add(StockGraph(key, analysis[key][i].beta ==  -100 ? 0 : analysis[key][i].beta));
        } else if (graphFor == "Price up (days)") {
          _tempData.add(StockGraph(key, analysis[key][i].priceUp.toDouble()));
        } else if (graphFor == "Avg. Price Up/day (₹)") {
          _tempData.add(StockGraph(key, analysis[key][i].avgPriceUp));
        } else if (graphFor == "Price down(days)") {
          _tempData.add(StockGraph(key, analysis[key][i].priceDown.toDouble()));
        } else if (graphFor == "Avg. Price Down/day (₹)") {
          _tempData.add(StockGraph(key, analysis[key][i].avgPriceDown));
        }
      }
      _data.add(_tempData);
    }

    _graphData.add(
      charts.Series(
        id: "Analysis",
        data: _data[0],
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (StockGraph graph, _) => graph.date,
        measureFn: (StockGraph graph, _) => graph.analysisData,
      ),
    );

    if (_data.length >= 2) {
      _graphData.add(
        charts.Series(
          id: "Analysis",
          data: _data[1],
          colorFn: (_, __) => charts.MaterialPalette.yellow.shadeDefault,
          domainFn: (StockGraph graph, _) => graph.date,
          measureFn: (StockGraph graph, _) => graph.analysisData,
        ),
      );
    }

    if (_data.length >= 3) {
      _graphData.add(
        charts.Series(
          id: "Analysis",
          data: _data[2],
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (StockGraph graph, _) => graph.date,
          measureFn: (StockGraph graph, _) => graph.analysisData,
        ),
      );
    }

    if (_data.length == 4) {
      _graphData.add(
        charts.Series(
          id: "Analysis",
          data: _data[3],
          colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
          domainFn: (StockGraph graph, _) => graph.date,
          measureFn: (StockGraph graph, _) => graph.analysisData,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 300,
            child: charts.BarChart(
              _graphData,
              animate: true,
              animationDuration: Duration(seconds: 1),
            )),
        SizedBox(height: 15),
        Container(
          height: 20,
          width: 390,
          child: FittedBox(
            fit: BoxFit.contain,
                      child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                symbols.length >= 2
                    ? Icon(Icons.circle, color: Colors.blue)
                    : Text(""),
                symbols.length >= 2 ? Text(symbols[0]) : Text(""),
                SizedBox(width: 5),
                symbols.length >= 2
                    ? Icon(Icons.circle, color: Colors.yellow)
                    : Text(""),
                symbols.length >= 2 ? Text(symbols[1]) : Text(""),
                SizedBox(width: 5),
                symbols.length >= 3
                    ? Icon(Icons.circle, color: Colors.green)
                    : Text(""),
                symbols.length >= 3 ? Text(symbols[2]) : Text(""),
                SizedBox(width: 5),
                symbols.length == 4
                    ? Icon(Icons.circle, color: Colors.red)
                    : Text(""),
                symbols.length == 4 ? Text(symbols[3]) : Text(""),
                SizedBox(width: 5),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StockGraph {
  final String date;
  final double analysisData;

  StockGraph(this.date, this.analysisData);
}
