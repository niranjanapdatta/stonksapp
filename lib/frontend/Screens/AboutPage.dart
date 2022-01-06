import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: SingleChildScrollView(
              child: Container(
                height: 700,
          color: Colors.black87,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FittedBox(
                  fit: BoxFit.fill,
                                child: Image.network("https://images-platform.99static.com/ZU1PAK19AJVJPEfWIgZXz0cVsyY=/1072x38:1998x964/500x500/top/smart/99designs-contests-attachments/119/119621/attachment_119621398", 
                  height: 400,),
                ),Text(
                  "A Stock market App targetted towards beginners. We provide intricate stock market analysis in the form of easy to understand information such as bar graphs, tables and we also provide a way for you to learn the essentials required in order to invest in the stock market.\n\nDeveloped by: N Dinakara & Niranjana P Datta",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
