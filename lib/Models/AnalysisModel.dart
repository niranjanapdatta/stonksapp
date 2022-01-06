import 'dart:convert';

List<AnalysisModel> analysisModelFromJson(String str) => List<AnalysisModel>.from(json.decode(str).map((x) => AnalysisModel.fromJson(x)));

class AnalysisModel {
    AnalysisModel({
        this.id,
        this.close,
        this.date,
        this.isBullish,
        this.smClose,
        this.smDate,
        this.smVolatility,
        this.smBeta,
        this.smPriceUp,
        this.smAvgPriceUp,
        this.smPriceDown,
        this.smAvgPriceDown,
        this.oyClose,
        this.oyDate,
        this.oyVolatility,
        this.oyBeta,
        this.oyPriceUp,
        this.oyAvgPriceUp,
        this.oyPriceDown,
        this.oyAvgPriceDown,
        this.tyClose,
        this.tyDate,
        this.tyVolatility,
        this.tyBeta,
        this.tyPriceUp,
        this.tyAvgPriceUp,
        this.tyPriceDown,
        this.tyAvgPriceDown,
        this.fyClose,
        this.fyDate,
        this.fyVolatility,
        this.fyBeta,
        this.fyPriceUp,
        this.fyAvgPriceUp,
        this.fyPriceDown,
        this.fyAvgPriceDown,
    });

    String id;
    double close;
    DateTime date;
    int isBullish;
    double smClose;
    DateTime smDate;
    double smVolatility;
    double smBeta;
    int smPriceUp;
    double smAvgPriceUp;
    int smPriceDown;
    double smAvgPriceDown;
    double oyClose;
    DateTime oyDate;
    double oyVolatility;
    double oyBeta;
    int oyPriceUp;
    double oyAvgPriceUp;
    int oyPriceDown;
    double oyAvgPriceDown;
    double tyClose;
    DateTime tyDate;
    double tyVolatility;
    double tyBeta;
    int tyPriceUp;
    double tyAvgPriceUp;
    int tyPriceDown;
    double tyAvgPriceDown;
    double fyClose;
    DateTime fyDate;
    double fyVolatility;
    double fyBeta;
    int fyPriceUp;
    double fyAvgPriceUp;
    int fyPriceDown;
    double fyAvgPriceDown;

    factory AnalysisModel.fromJson(Map<String, dynamic> json) => AnalysisModel(
        id: json["_id"],
        close: json["close"].toDouble(),
        date: DateTime.parse(json["date"]),
        isBullish: json["is_bullish"],
        smClose: json["sm_close"].toDouble(),
        smDate: DateTime.parse(json["sm_date"]),
        smVolatility: json["sm_volatility"].toDouble(),
        smBeta: json["sm_beta"].toDouble(),
        smPriceUp: json["sm_price_up"],
        smAvgPriceUp: json["sm_avg_price_up"].toDouble(),
        smPriceDown: json["sm_price_down"],
        smAvgPriceDown: json["sm_avg_price_down"].toDouble(),
        oyClose: json["oy_close"].toDouble(),
        oyDate: DateTime.parse(json["oy_date"]),
        oyVolatility: json["oy_volatility"].toDouble(),
        oyBeta: json["oy_beta"].toDouble(),
        oyPriceUp: json["oy_price_up"],
        oyAvgPriceUp: json["oy_avg_price_up"].toDouble(),
        oyPriceDown: json["oy_price_down"],
        oyAvgPriceDown: json["oy_avg_price_down"].toDouble(),
        tyClose: json["ty_close"].toDouble(),
        tyDate: DateTime.parse(json["ty_date"]),
        tyVolatility: json["ty_volatility"].toDouble(),
        tyBeta: json["ty_beta"].toDouble(),
        tyPriceUp: json["ty_price_up"],
        tyAvgPriceUp: json["ty_avg_price_up"].toDouble(),
        tyPriceDown: json["ty_price_down"],
        tyAvgPriceDown: json["ty_avg_price_down"].toDouble(),
        fyClose: json["fy_close"].toDouble(),
        fyDate: DateTime.parse(json["fy_date"]),
        fyVolatility: json["fy_volatility"].toDouble(),
        fyBeta: json["fy_beta"].toDouble(),
        fyPriceUp: json["fy_price_up"],
        fyAvgPriceUp: json["fy_avg_price_up"].toDouble(),
        fyPriceDown: json["fy_price_down"],
        fyAvgPriceDown: json["fy_avg_price_down"].toDouble(),
    );

}