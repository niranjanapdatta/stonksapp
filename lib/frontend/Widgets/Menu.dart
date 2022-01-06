import 'package:flutter/material.dart';
import 'package:stonksapp/frontend/Screens/DeleteAccountPage.dart';
import 'package:stonksapp/frontend/Screens/InsertDataPage.dart';
import 'package:stonksapp/frontend/Screens/LoginPage.dart';

import '../Screens/Watchlist.dart';
import '../Screens/TriviaPage.dart';
import '../Screens/AboutPage.dart';

class Menu extends StatelessWidget {
  final bool isAdmin;

  Menu(this.isAdmin);

  @override
  Widget build(BuildContext context) {
    return Drawer( // TO DO: Watchlist
      child: ListView(
        children: [
          Container(
            color: Colors.blue,
            height: 120,
          ),
          isAdmin
              ? ListTile(
                  title: GestureDetector(
                    child: Row(
                      children: [
                        Icon(Icons.upload_sharp),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Insert Data"),
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InsertDataPage(isAdmin),
                      ),
                    ),
                  ),
                ) : Container(),
              // : ListTile(
              //     title: GestureDetector(
              //       child: Row(
              //         children: [
              //           Icon(Icons.remove_red_eye_sharp),
              //           SizedBox(
              //             width: 10,
              //           ),
              //           Text("Watchlist"),
              //         ],
              //       ),
              //       onTap: () => Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => Watchlist(),
              //         ),
              //       ),
              //     ),
              //   ),
          ListTile(
            title: GestureDetector(
              child: Row(
                children: [
                  Icon(Icons.library_books_sharp),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Stock Market Trivia"),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TriviaPage(isAdmin),
                ),
              ),
            ),
          ),
          ListTile(
            title: GestureDetector(
              child: Row(
                children: [
                  Icon(Icons.info_outline),
                  SizedBox(
                    width: 10,
                  ),
                  Text("About"),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutPage(),
                ),
              ),
            ),
          ),
          isAdmin ? Container() : ListTile(
            title: GestureDetector(
              child: Row(
                children: [
                  Icon(Icons.delete_forever),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Delete Account"),
                ],
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DeleteAccountPage(),
                ),
              ),
            ),
          ),
          ListTile(
            title: GestureDetector(
              child: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(
                    width: 10,
                  ),
                  Text("Sign Out"),
                ],
              ),
              onTap: () {
                Navigator.pop(context); // Pops Menu
                Navigator.pop(context); // Pops HomePage
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
