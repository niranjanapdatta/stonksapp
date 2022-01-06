import 'dart:convert';

List<SymbolModel> symbolModelFromJson(String str) => List<SymbolModel>.from(json.decode(str).map((x) => SymbolModel.fromJson(x)));

class SymbolModel {
    SymbolModel({
        this.symbolName,
        this.name,
        this.isIndex,
        this.marketStandard,
        this.expenseRatio,
        this.dividend,
        this.series,
        this.about
    });

    String symbolName;
    String name;
    bool isIndex;
    String marketStandard;
    double expenseRatio;
    double dividend;
    String series;
    String about;

    factory SymbolModel.fromJson(Map<String, dynamic> json) => SymbolModel(
        symbolName: json["_id"],
        name: json["name"],
        isIndex: json["is_index"],
        marketStandard: json["market_standard"],
        expenseRatio: json["expense_ratio"].toDouble(),
        dividend: json["dividend"].toDouble(),
        series: json["series"],
        about: json["about"],
    );

}