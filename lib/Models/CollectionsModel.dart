import 'dart:convert';

List<CollectionsModel> collectionsModelFromJson(String str) => List<CollectionsModel>.from(json.decode(str).map((x) => CollectionsModel.fromJson(x)));

class CollectionsModel { // Represents collection names in MongoDB for all the market standards
    CollectionsModel({
        this.id,

    });

    String id;

    factory CollectionsModel.fromJson(Map<String, dynamic> json) => CollectionsModel(
        id: json["_id"],
    );

}