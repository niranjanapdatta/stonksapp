import 'package:flutter/material.dart';
import 'package:stonksapp/Models/SymbolModel.dart';

class AboutStock extends StatelessWidget {
  final SymbolModel symbolData;

  AboutStock(this.symbolData);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
              child: ListTile(
                  tileColor: Colors.black87,
                  title: Text(
                    "Series: ${symbolData.series}",
                    style: TextStyle(color: Colors.white),
                  ))),
          Card(
              child: ListTile(
                  tileColor: Colors.black87,
                  title: Text(
                    "Market Standard: ${symbolData.marketStandard}",
                    style: TextStyle(color: Colors.white),
                  ))),
          symbolData.expenseRatio != 0
              ? Card(
                  child: ListTile(
                      tileColor: Colors.black87,
                      title: Text(
                        "Expense Ratio: ${symbolData.expenseRatio.toString()}",
                        style: TextStyle(color: Colors.white),
                      )))
              : Container(),
          symbolData.dividend != 0
              ? Card(
                  child: ListTile(
                      tileColor: Colors.black87,
                      title: Text(
                        "Dividend: ${symbolData.dividend.toString()}",
                        style: TextStyle(color: Colors.white),
                      )))
              : Container(),
          Card(
              child: ListTile(
                  tileColor: Colors.black87,
                  title: Text(
                    "Description: ${symbolData.about}",
                    style: TextStyle(color: Colors.white),
                  ))),
        ],
      ),
    );
  }
}
