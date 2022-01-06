import 'package:flutter/material.dart';
import 'package:stonksapp/Models/ArticleModel.dart';
import 'package:stonksapp/frontend/Screens/Insight.dart';

class SingleStockNews extends StatelessWidget {
  final List<ArticleModel> _articles;

  SingleStockNews(this._articles);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 200,
        child: ListView.builder(
          itemCount: _articles.length,
          itemBuilder: (ctx, index) {
            return GestureDetector(
              child: Card(
                child: Container(
                  color: Colors.black87,
                  child: ListTile(
                    title: Text(
                      _articles[index].title,
                      style: TextStyle(color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Insight(_articles[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
