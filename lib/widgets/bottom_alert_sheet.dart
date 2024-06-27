import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:litebook/api/backend.dart';

class BottomAlertSheet extends StatelessWidget {
  const BottomAlertSheet({
    Key? key,
    required this.data,
    required this.backend,
  }) : super(key: key);

  final List data;
  final Backend backend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 15.0, left: 10.0, right: 10.0, bottom: 10.0),
      child: Column(children: [
        Stack(children: [
          Container(
            alignment: Alignment.topCenter,
            child: Text(
              data[1],
              style: const TextStyle(fontSize: 28, fontFamily: "IndieFlower"),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            top: -6,
            right: 8,
            child: IconButton(
              iconSize: 30,
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          )
        ]),
        const Divider(),
        Stack(
          children: [
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  data[0].title,
                  style: const TextStyle(fontSize: 18),
                  maxLines: 1,
                )),
          ],
        ),
        Stack(
          children: [
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  data[0].isbn,
                  style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey),
                )),
          ],
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Image(image: CachedNetworkImageProvider(data[0].imageUrl[1])),
        )),
        Stack(
          children: [
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  data[3],
                  style: const TextStyle(fontSize: 18),
                )),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: data[4],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              onPressed: () {
                backend.addBook(data[0]);
                Navigator.pop(context);
              },
              child: Text(
                data[2],
                style: const TextStyle(color: Colors.white),
              )),
        ),
      ]),
    );
  }
}
