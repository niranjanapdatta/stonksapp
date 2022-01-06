import 'dart:convert';

List<TriviaModel> triviaModelFromJson(String str) => List<TriviaModel>.from(json.decode(str).map((x) => TriviaModel.fromJson(x)));

class TriviaModel {
    TriviaModel({
      this.title,
      this.description,
      this.videoUrl,
      this.id,
    });

    String id;
    String title;
    String description;
    String videoUrl;

    factory TriviaModel.fromJson(Map<String, dynamic> json) => TriviaModel(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        videoUrl: json["video_url"],
    );

}