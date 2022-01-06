import 'package:flutter/material.dart';
import 'package:stonksapp/Models/TriviaModel.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class Trivia extends StatelessWidget {
  final TriviaModel _trivia;

  Trivia(this._trivia);

  @override
  Widget build(BuildContext context) {
    var _orientation = MediaQuery.of(context).orientation;
    final _topPadding = MediaQuery.of(context).padding.top;
    final _appBar = AppBar(
      title: Text(_trivia.title),
    );
    return Scaffold(
      appBar: _appBar,
      body: _trivia.videoUrl != "none" ? Column(children: [
        Container(
          height: _orientation == Orientation.portrait
              ? (MediaQuery.of(context).size.height -
                      _appBar.preferredSize.height -
                      _topPadding) *
                  0.4
              : (MediaQuery.of(context).size.height -
                      _appBar.preferredSize.height -
                      _topPadding) *
                  1,
          width: (MediaQuery.of(context).size.width),
          child: YoutubePlayerIFrame(
            controller: YoutubePlayerController(
              initialVideoId: _trivia.videoUrl.split("https://www.youtube.com/watch?v=")[1],
              params: YoutubePlayerParams(
                autoPlay: false,
                showControls: true,
                showFullscreenButton: true,
              ),
            ),
            aspectRatio: 16 / 9,
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.black87,
          height: _orientation == Orientation.portrait
              ? (MediaQuery.of(context).size.height -
                      _appBar.preferredSize.height -
                      _topPadding) *
                  0.6
              : 0,
          child: Container(
            margin: EdgeInsets.only(right: 5, left: 5),
            child: Container(
              child: Scrollbar(
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    "Description:\n ${_trivia.description}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]) : Container(
        color: Colors.black87,
        width: double.infinity,
        height: 700,
            child: Container(
              child: Scrollbar(
                isAlwaysShown: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(
                    "Description:\n ${_trivia.description}",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
