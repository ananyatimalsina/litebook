import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:litebook/api/book_data_model.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class Momox {
  final dio = Dio();
  late String username;
  late String password;

  Momox({
    required this.username,
    required this.password,
  }) {
    _prepareDio();
  }

  Future<void> _prepareDio() async {
    dio.options.baseUrl = 'https://api.momox.de/api';
    dio.options.headers = {
      'x-api-token': '2231443b8fb511c7b6a0eb25a62577320bac69b6',
      'x-marketplace-id': 'momox_de',
    };

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
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final jar = PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("$appDocPath/.cookies/"),
    );
    dio.interceptors.add(CookieManager(jar));
  }

  Future<bool> login() async {
    Map<String, String> data = {
      'email': username,
      'password': password,
    };

    var r = await dio.put('/v4/user/login/', data: data);

    if (r.toString().contains("E_5000")) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> addMomox(String isbn) async {
    Map<String, String> data = {
      'ean': isbn,
    };

    var r = await dio.post('/v3/cart/items/', data: data);

    if (r.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> removeMomox(String isbn) async {
    var r = await dio.delete(
      '/v3/cart/items/$isbn/',
    );

    if (r.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Book>> getMomox() async {
    try {
      var r = await dio.get(
        '/v3/cart/',
      );
      List<Book> books = [];
      for (var i in r.data["items"]) {
        books.add(Book(
            title: i["product"]["title"],
            buyer: "momox",
            price: i["price"],
            imageUrl: [i["product"]["image_url"]],
            isbn: i["product_pk"]));
      }
      return books;
    } on Exception catch (e) {
      debugPrint("$e momox_backend.dart getMomox");
      return [];
    }
  }
}

Future<List> checkMomox(String isbn) async {
  Map<String, String> headers = {
    'x-api-token': '2231443b8fb511c7b6a0eb25a62577320bac69b6',
    'x-marketplace-id': 'momox_de',
  };

  List productInfo = ["null", "null"];
  bool check = false;
  String price = "0.0";

  try {
    var r = await Dio(BaseOptions(baseUrl: "https://api.momox.de/api")).get(
      '/v4/media/offer/?ean=$isbn',
      options: Options(headers: headers),
    );

    var rj = r.data;
    if (rj["status"] == "offer") {
      check = true;
      price = rj["price"];
    }
    productInfo[0] = rj["product"]["title"];
    productInfo[1] = rj["product"]["image_url"];
  } catch (e) {
    debugPrint("$e momox_backend.dart checkMomox");
  }

  return [check, price, productInfo];
}
