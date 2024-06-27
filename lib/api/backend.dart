import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:litebook/api/book_data_model.dart';
import 'package:litebook/api/momox_backend.dart';
import 'package:litebook/api/rebuy_backend.dart';
import 'package:palette_generator/palette_generator.dart';

class Backend {
  final dio = Dio();
  late Box box;

  late Momox momox;
  late Rebuy rebuy;

  Backend({
    required this.box,
    required this.momox,
    required this.rebuy,
  }) {
    _prepareDio();
  }

  void _prepareDio() {
    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      logPrint: print,
      retries: 3,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 3),
        Duration(seconds: 5),
      ],
    ));
  }

  Future<List> getData(String isbn) async {
    final futures = <Future>[
      checkMomox(isbn),
      checkRebuy(isbn),
    ];

    final results = await Future.wait<dynamic>(futures);

    final m = results[0];
    final r = results[1];

    final imageUrl = ["null", "null"];
    var title = "null";
    var bookCode = "null";
    var buyer = "nobody";

    final highest = [
      decToInt(m[1]),
      decToInt(r[1]),
    ].reduce(max);

    if (highest == 0) {
      imageUrl[0] = m[2][1];
      imageUrl[1] = r[2][1][1];
      title = m[2][0];
      buyer = "nobody";
    } else if (highest == decToInt(m[1])) {
      imageUrl[0] = m[2][1];
      imageUrl[1] = r[2][1][1];
      title = m[2][0];
      buyer = "momox";
    } else if (highest == decToInt(r[1])) {
      imageUrl[1] = r[2][1][1];
      title = r[2][0];
      buyer = "rebuy";
      bookCode = r[3];
    }

    final book = Book(
      isbn: isbn,
      title: title,
      imageUrl: imageUrl,
      price: intToDec(highest.toString()),
      buyer: buyer,
      bookCode: bookCode,
    );

    PaletteGenerator? paletteGenerator;
    if (book.imageUrl[1] != "null") {
      try {
        paletteGenerator = await PaletteGenerator.fromImageProvider(
          CachedNetworkImageProvider(book.imageUrl[1]),
        );
      } catch (_) {
        paletteGenerator = null;
      }
    }

    var front = "Item found!";
    var button = "Add to cart";
    var message =
        "This is getting bought by ${book.buyer.toString().replaceAll("Buyer.", "")} for ${book.price}€";
    var color = Colors.black;

    if (book.buyer == "nobody") {
      message = "This is not getting bought";
      button = "Scan Again";
    }

    if (book.title == "null" && book.imageUrl[1] == "null") {
      front = "Item Not Found!";
      button = "Scan Again";
    }

    book.imageUrl[1] ??=
        "https://icon-library.com/images/question-mark-icon/question-mark-icon-20.jpg";
    try {
      color = paletteGenerator?.darkVibrantColor?.color ??
          paletteGenerator?.darkMutedColor?.color ??
          paletteGenerator?.dominantColor?.color ??
          Colors.black;
    } catch (_) {
      color = Colors.black;
    }

    return [book, front, button, message, color];
  }

  Future<List<Book>> getCart() async {
    final r = await rebuy.getRebuy();
    final m = await momox.getMomox();
    return [...r, ...m];
  }

  Future<bool> addBook(Book book) async {
    if (book.buyer == "rebuy") {
      return (await rebuy.addRebuy(book.bookCode, book.bookCode, book.price));
    } else if (book.buyer == "momox") {
      return (await momox.addMomox(book.isbn));
    } else {
      return false;
    }
  }

  Future<bool> removeBook(Book book) async {
    if (book.buyer == "rebuy") {
      return (await rebuy.removeRebuy(book.bookCode));
    } else if (book.buyer == "momox") {
      return (await momox.removeMomox(book.isbn));
    } else {
      return false;
    }
  }
}

int decToInt(String input) {
  String output = "0";
  List inL = input.split("");

  if (inL[0] == "0") {
    inL.removeRange(0, 2);
    output = inL.join("");
  } else {
    output = input.replaceAll(".", "");
  }

  return int.parse(output);
}

String intToDec(String input) {
  List ins = input.split("");
  String output = "0.0";

  if (ins.length == 2 || ins.length == 1) {
    output = "0.$input";
  } else {
    ins.insert(ins.length - 2, ".");
    output = ins.join("");
  }
  return output;
}
