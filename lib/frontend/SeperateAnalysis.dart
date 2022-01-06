import '../Models/AnalysisModel.dart';

import '../Models/SingleAnalysisModel.dart';

class SeperateAnalysis{
  final AnalysisModel analysis;

  SeperateAnalysis(this.analysis);

  SingleAnalysisModel getSixMonthsAnalysis(){
    SingleAnalysisModel _smAnalysis = SingleAnalysisModel(
        analysis.smClose,
        analysis.smDate,
        analysis.smVolatility,
        analysis.smBeta,
        analysis.smPriceUp,
        analysis.smAvgPriceUp,
        analysis.smPriceDown,
        analysis.smAvgPriceDown,
        );

    return _smAnalysis;
  }

  SingleAnalysisModel getOneYearAnalysis(){
    SingleAnalysisModel _oyAnalysis = SingleAnalysisModel(
        analysis.oyClose,
        analysis.oyDate,
        analysis.oyVolatility,
        analysis.oyBeta,
        analysis.oyPriceUp,
        analysis.oyAvgPriceUp,
        analysis.oyPriceDown,
        analysis.oyAvgPriceDown,
        );

    return _oyAnalysis;
  }

  SingleAnalysisModel getThreeYearsAnalysis(){
    SingleAnalysisModel _tyAnalysis = SingleAnalysisModel(
        analysis.tyClose,
        analysis.tyDate,
        analysis.tyVolatility,
        analysis.tyBeta,
        analysis.tyPriceUp,
        analysis.tyAvgPriceUp,
        analysis.tyPriceDown,
        analysis.tyAvgPriceDown,
        );

    return _tyAnalysis;
  }

  SingleAnalysisModel getFiveYearsAnalysis(){
    SingleAnalysisModel _fyAnalysis = SingleAnalysisModel(
        analysis.fyClose,
        analysis.fyDate,
        analysis.fyVolatility,
        analysis.fyBeta,
        analysis.fyPriceUp,
        analysis.fyAvgPriceUp,
        analysis.fyPriceDown,
        analysis.fyAvgPriceDown,
        );

    return _fyAnalysis;
  }

}