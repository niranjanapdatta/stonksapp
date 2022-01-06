import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stonksapp/Models/SingleAnalysisModel.dart';
import 'package:stonksapp/Models/SymbolModel.dart';


class AnalysisTable extends StatelessWidget {
  final List<String> symbols;
  final List<SingleAnalysisModel> analysis;
  final List<SymbolModel> symbolDetails;
  final List<double> currentClose;
  
  AnalysisTable(this.symbols, this.analysis, this.symbolDetails, this.currentClose);

  final DateFormat _dateFormat = DateFormat("MMM dd yyyy");
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Table( // TO DO: Reorganize reusable components
            border: TableBorder.all(
                color: Colors.white, style: BorderStyle.solid, width: 2),
            children: [
              TableRow(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Analysis", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ]),
                for (var item in symbols) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                ),
              ]),
              TableRow(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Date", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ]),
                for (var item in analysis) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_dateFormat.format(item.date).toString(), style: TextStyle(color: Colors.white),),
                ),
              ]),
              TableRow(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Close (₹)",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ]),
                for (var item in analysis) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.close.toString(), style: TextStyle(color: Colors.white),),
                ),
              ]),
              TableRow(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Potential Returns (₹)",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ]),
                for (int i= 0; i < analysis.length; i++) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_calculateReturns(currentClose[i], analysis[i].date.year, analysis[i].close, symbolDetails[i].expenseRatio, 
                  symbolDetails[i].dividend).toString(), style: TextStyle(color: Colors.white),),
                ),
              ]),
              TableRow(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Volatility",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ]),
                for (var item in analysis) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.volatility.toString(), style: TextStyle(color: Colors.white),),
                ),
              ]),
              TableRow(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Beta", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ]),
                for (var item in analysis) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.beta == -100 ? "-" : item.beta.toString(), style: TextStyle(color: Colors.white),),
                ),
              ]),
              TableRow(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Price up(days)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ]),
                for (var item in analysis) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.priceUp.toString(), style: TextStyle(color: Colors.white),),
                ),
              ]),
              TableRow(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Avg. Price up/day (₹)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ]),
                for (var item in analysis) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.avgPriceUp.toString(), style: TextStyle(color: Colors.white),),
                ),
              ]),
              TableRow(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Price down(days)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ]),
                for (var item in analysis) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.priceDown.toString(), style: TextStyle(color: Colors.white),),
                ),
              ]),
              TableRow(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Avg.Price down/day (₹)", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ]),
                for (var item in analysis) Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(item.avgPriceDown.toString(), style: TextStyle(color: Colors.white),),
                ),
              ]),
            ],
          ),
    );
  }

  int _calculateReturns(double currentClose, int year, double closePrice, double expenseRatio, double dividend){
    int duration = DateTime.now().year - year;
    double expenses = (currentClose * expenseRatio) * duration;
    double dividendEarned = (currentClose * dividend) * duration;
    double grossReturns = currentClose - closePrice;
    double potentialReturnsForTimePeriod = (grossReturns + dividendEarned) - expenses; // potential net returns
    return potentialReturnsForTimePeriod.round();
  }
}