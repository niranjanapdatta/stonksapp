import 'package:http/http.dart' as http;
import 'package:stonksapp/Models/UserModel.dart';

import '../Models/TriviaModel.dart';
import '../Models/ArticleModel.dart';
import '../Models/SymbolModel.dart';
import '../Models/AnalysisModel.dart';
import '../Models/CollectionsModel.dart';

class Api {

  static Future<List<CollectionsModel>> getCollections() async{
    try{
      final response = await http.get(Uri.parse("http://192.168.0.111:5000/api/stonks/MARKETSTANDARDS"));
      if (response.statusCode == 200){
        final List<CollectionsModel> collections = collectionsModelFromJson(response.body);
        return collections;
      }
      else {
        return null;
      }
    } catch(e){
      print(e);
      print("CM");
      return null;
    }
  }

  static Future<List<AnalysisModel>> getAnalysis(String collection) async{
    try{
      final response = await http.get(Uri.parse("http://192.168.0.111:5000/api/stonks/"+collection));
      if (response.statusCode == 200){
        final List<AnalysisModel> analysis = analysisModelFromJson(response.body);
        return analysis;
      }
      else {
        return null;
      }
    } catch(e){
      print(e);
      
      print("AM");
      return null;
    }
  }

  static Future<List<SymbolModel>> getSymbolDetails() async{
    try{
      final response = await http.get(Uri.parse("http://192.168.0.111:5000/api/stonks/SYMBOLS"));
      if (response.statusCode == 200){
        final List<SymbolModel> symbolDetails = symbolModelFromJson(response.body);
        return symbolDetails;
      }
      else {
        return null;
      }
    } catch(e){
      print(e);
      print("GS");
      return null;
    }
  }

  static Future<List<ArticleModel>> getArticles() async{
    try{
      final response = await http.get(Uri.parse("http://192.168.0.111:5000/api/stonks/ARTICLES"));
      if (response.statusCode == 200){
        final List<ArticleModel> articles = articleModelFromJson(response.body);
        return articles;
      }
      else {
        return null;
      }
    } catch(e){
      print(e);
      print("GA");
      return null;
    }
  }

  static Future<List<ArticleModel>> getArticlesForSymbol(String id) async{
    try{
      final response = await http.get(Uri.parse("http://192.168.0.111:5000/api/stonks/articles_for/"+id));
      if (response.statusCode == 200){
        final List<ArticleModel> articles = articleModelFromJson(response.body);
        return articles;
      }
      else {
        return null;
      }
    } catch(e){
      print(e);
      print("GA");
      return null;
    }
  }


  static Future<List<TriviaModel>> getTrivia() async{
    try{
      final response = await http.get(Uri.parse("http://192.168.0.111:5000/api/stonks/TRIVIA"));
      if (response.statusCode == 200){
        final List<TriviaModel> trivia = triviaModelFromJson(response.body);
        return trivia;
      }
      else {
        return null;
      }
    } catch(e){
      print(e);
      print("GT");
      return null;
    }
  }

  static Future<String> addSymbol(SymbolModel symbol) async {
    Map _symbolData = {
      '_id': symbol.symbolName,
      'name': symbol.name,
      'is_index': symbol.isIndex.toString(),
      'market_standard': symbol.marketStandard,
      'expense_ratio': symbol.expenseRatio.toString(),
      'dividend': symbol.dividend.toString(),
      'series': symbol.series,
      'about': symbol.about,
    };
    try{
    final response = await http.post(Uri.parse("http://192.168.0.111:5000/api/stonks/add_symbol"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _symbolData,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return null;
    }
    } catch(e){
      print(e);
      print("SM");
      return null;
    }
  } 

  // static Future<CollectionsModel> addMarketIndex(CollectionsModel collection) async {
  //   Map _marketIndexData = {
  //     '_id': collection.id,
  //   };
  //   try{
  //   final response = await http.post(Uri.parse("http://192.168.0.111:5000/api/stonks/add_index"),
  //   headers: {"Content-Type": "application/x-www-form-urlencoded"},
  //   body: _marketIndexData,
  //   );
  //   if(response.statusCode == 201){
  //     return collectionsModelFromJson(response.body)[0];
  //   }
  //   else{
  //     print(response.body);
  //     return null;
  //   }
  //   } catch(e){
  //     print(e);
  //     print("SM MI");
  //     return null;
  //   }
  // } 
  
  static Future<String> publishArticle(ArticleModel article) async {
    Map _articleData = {
      'title': article.title,
      'summary': article.summary,
      'for_symbol': article.forSymbol,
      'image_link': article.imageLink,
    };
    try{
    final response = await http.post(Uri.parse("http://192.168.0.111:5000/api/stonks/publish_article"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _articleData,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return null;
    }
    } catch(e){
      print(e);
      print("PA");
      return null;
    }
  } 

  static Future<String> editArticle(ArticleModel article) async {
    Map _articleData = {
      'id': article.id,
      'title': article.title,
      'summary': article.summary,
      'for_symbol': article.forSymbol,
      'image_link': article.imageLink,
    };
    try{
    final response = await http.put(Uri.parse("http://192.168.0.111:5000/api/stonks/edit_article"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _articleData,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return null;
    }
    } catch(e){
      print(e);
      print("PA");
      return null;
    }
  } 

  static Future<String> addTrivia(TriviaModel trivia) async {
    Map _triviaData = {
      'title': trivia.title,
      'description': trivia.description,
      'video_url': trivia.videoUrl,
    };
    try{
    final response = await http.post(Uri.parse("http://192.168.0.111:5000/api/stonks/add_trivia"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _triviaData,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return null;
    }
    } catch(e){
      print(e);
      print("AA");
      return null;
    }
  } 

  static Future<String> editTrivia(TriviaModel trivia) async {
    Map _triviaData = {
      'id': trivia.id,
      'title': trivia.title,
      'description': trivia.description,
      'video_url': trivia.videoUrl,
    };
    try{
    final response = await http.put(Uri.parse("http://192.168.0.111:5000/api/stonks/edit_trivia"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _triviaData,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return null;
    }
    } catch(e){
      print(e);
      print("PA");
      return null;
    }
  }

  static Future<String> editSymbol(SymbolModel symbol) async {
    Map _symbolData = {
      'id': symbol.symbolName,
      'name': symbol.name,
      'market_standard': symbol.marketStandard,
      'expense_ratio': symbol.expenseRatio.toString(),
      'dividend': symbol.dividend.toString(),
      'series': symbol.series,
      'about': symbol.about,
    };
    try{
    final response = await http.put(Uri.parse("http://192.168.0.111:5000/api/stonks/edit_symbol"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _symbolData,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return null;
    }
    } catch(e){
      print(e);
      print("PA");
      return null;
    }
  }

  static Future<String> authenticateUser(UserModel user) async {
    Map _userAccountData = {
      'username': user.username,
      'password': user.password,
    };
    try{
    final response = await http.post(Uri.parse("http://192.168.0.111:5000/api/stonks/authenticate"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _userAccountData,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return null;
    }
    } catch(e){
      print(e);
      print("AU");
      return null;
    }
  } 

  static Future<String> registerUser(UserModel user) async {
    Map _userAccountData = {
      'username': user.username,
      'password': user.password,
      'is_admin': user.isAdmin.toString(),
    };
    try{
    final response = await http.post(Uri.parse("http://192.168.0.111:5000/api/stonks/register"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _userAccountData,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return response.body;
    }
    } catch(e){
      print(e);
      print("RU");
      return "Error";
    }
  } 


  static Future<String> changePassword(String oldPassword, UserModel user) async {
    Map _userAccountData = {
      'username': user.username,
      'old_password': oldPassword,
      'password': user.password,
      'is_admin': user.isAdmin.toString(),
    };
    try{
    final response = await http.put(Uri.parse("http://192.168.0.111:5000/api/stonks/change_password"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _userAccountData,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return response.body;
    }
    } catch(e){
      print(e);
      print("CP");
      return "Error";
    }
  } 

  static Future<String> deleteTrivia(String id) async {
    Map _triviaId = {
      'id': id,
    };
    try{
    final response = await http.delete(Uri.parse("http://192.168.0.111:5000/api/stonks/delete_trivia"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _triviaId,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return response.body;
    }
    } catch(e){
      print(e);
      print("DT");
      return "Error";
    }
  } 

  static Future<String> deleteUser(UserModel user) async {
    Map _userDetails = {
      'username': user.username,
      'password': user.password,
    };
    try{
    final response = await http.delete(Uri.parse("http://192.168.0.111:5000/api/stonks/delete_user"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _userDetails,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return response.body;
    }
    } catch(e){
      print(e);
      print("DU");
      return "Error";
    }
  } 

  static Future<String> deleteArticle(String id) async {
    Map _articleId = {
      'id': id,
    };
    try{
    final response = await http.delete(Uri.parse("http://192.168.0.111:5000/api/stonks/delete_article"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _articleId,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return response.body;
    }
    } catch(e){
      print(e);
      print("DA");
      return "Error";
    }
  } 


  static Future<String> deleteSymbol(String id) async {
    Map _symbolId = {
      'id': id,
    };
    try{
    final response = await http.delete(Uri.parse("http://192.168.0.111:5000/api/stonks/delete_symbol"),
    headers: {"Content-Type": "application/x-www-form-urlencoded"},
    body: _symbolId,
    );
    if(response.statusCode == 201){
      return response.body;
    }
    else{
      return response.body;
    }
    } catch(e){
      print(e);
      print("DA");
      return "Error";
    }
  } 
}