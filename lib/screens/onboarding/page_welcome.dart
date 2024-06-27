import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.indigo,
        child: const Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "Welcome to LiteBook,",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )),
            Text(
              "The best way to sell your books",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 125),
            Image(image: AssetImage("data/icon.png"), width: 200, height: 200),
            SizedBox(height: 125),
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "On the next few screens, you will have to fill out a couple of details. This will only take a few minutes.",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ))
          ],
        )));
  }
}
