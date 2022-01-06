import 'dart:convert';

List<ArticleModel> articleModelFromJson(String str) => List<ArticleModel>.from(json.decode(str).map((x) => ArticleModel.fromJson(x)));

class ArticleModel {
    ArticleModel({
      this.title,
      this.summary,
      this.forSymbol,
      this.imageLink,
      this.timestamp,
      this.id,
    });

    String id;
    String title;
    String summary;
    String forSymbol;
    String imageLink;
    String timestamp;


    factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
        id: json["_id"],
        title: json["title"],
        summary: json["summary"],
        forSymbol: json["for_symbol"],
        imageLink: json["image_link"],
        timestamp: json["timestamp"],
    );

}