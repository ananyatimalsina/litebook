import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'backend.dart';
import 'book_data_model.dart';

class Rebuy {
  final dio = Dio();
  late String username;
  late String password;

  late List loginData;
  late String uuid;

  Rebuy({
    required this.username,
    required this.password,
  }) {
    _prepareDio();
  }

  void _prepareDio() {
    dio.options.baseUrl = 'https://mobile.rebuy.com';

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

  Future<bool> login() async {
    Map<String, String> headers = {
      'authorization': '02ac1424-f7cc-47ce-a9fc-7de2378e1461',
    };

    Map<String, String> data = {
      'username': username,
      'password': password,
    };

    try {
      Response r = await dio.post(
        '/customers/oauth/token',
        data: data,
        options: Options(
          headers: headers,
        ),
      );

      String accessToken = r.data["access_token"];
      headers = {
        'authorization': accessToken,
      };
      r = await dio.get(
        "/customers/?filter.oauth2Token=$accessToken",
        options: Options(headers: headers),
      );
      String id = r.data["elements"][0]["id"];
      loginData = [true, accessToken, id];
      return true;
    } catch (e) {
      debugPrint("$e rebuy_backend.dart, loginRebuy");
      loginData = [false, "null", "null"];
      return false;
    }
  }

  Future<bool> getUuid() async {
    Map<String, String> headers = {
      'authorization': loginData[1],
    };
    Response r =
        await dio.get("/v2/green/carts", options: Options(headers: headers));

    if (r.statusCode != 200) {
      uuid = "null";
      return false;
    } else {
      uuid = r.data["uuid"];
      return true;
    }
  }

  Future<bool> addRebuy(String bookCode, String uuid, String price) async {
    Map<String, String> headers = {
      'authorization': loginData[1],
    };
    Map<String, Map<String, Object>> data = {
      "product": {"id": bookCode},
    };
    Response r = await dio.post("/v2/green/carts/$uuid/products",
        data: data, options: Options(headers: headers));

    if (r.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> removeRebuy(String bookCode) async {
    Map<String, String> headers = {
      'authorization': loginData[1],
    };
    Response r = await dio.delete("/v2/green/carts/$uuid/products/$bookCode",
        options: Options(headers: headers));

    if (r.statusCode != 200) {
      return false;
    } else {
      return true;
    }
  }

  Future<List<Book>> getRebuy() async {
    Map<String, String> headers = {
      'authorization': loginData[1],
    };
    Response r =
        await dio.get("/v2/green/carts", options: Options(headers: headers));

    if (r.statusCode != 200) {
      return [Book.empty()];
    } else {
      var rj = r.data;
      List<Book> books = [];
      for (var i in rj["orderProducts"]) {
        var product = i["product"];
        var isbn = "null";
        try {
          isbn = product["identifiers"][1];
        } catch (e) {
          debugPrint("$e rebuy_backend.dart, getRebuy");
          isbn = product["identifiers"][0];
        }
        books.add(Book(
            title: product["name"],
            buyer: "rebuy",
            price: intToDec(i["price"]["amount"].toString()),
            imageUrl: [product["thumbsCoverUrls"]["200x200"]],
            isbn: isbn,
            bookCode: i["id"].toString()));
      }
      return books;
    }
  }
}

Future<List> checkRebuy(String isbn) async {
  var headers = {
    'authorization': '02ac1424-f7cc-47ce-a9fc-7de2378e1461',
  };

  List productInfo = [
    "null",
    ["null", "null"]
  ];
  bool check = false;
  String price = "0.0";
  String bookCode = "null";

  try {
    Response r =
        await Dio(BaseOptions(baseUrl: "https://mobile.rebuy.com")).get(
      '/v2/green/search/?q=$isbn',
      options: Options(headers: headers),
    );
    var rj = r.data;
    if (rj["products"]["docs"][0]["is_purchaseable"]) {
      check = true;
      var p = rj["products"]["docs"][0]["price_purchase"];
      price = intToDec(p.toString());

      bookCode = rj["products"]["docs"][0]["id"].toString();
    }

    productInfo[0] = rj["products"]["docs"][0]["name"];
    productInfo[1] = [
      rj["products"]["docs"][0]["thumbs_cover_urls"]["100x100"],
      rj["products"]["docs"][0]["thumbs_cover_urls"]["200x200"]
    ];
  } catch (e) {
    debugPrint("$e rebuy_backend.dart, checkRebuy");
  }

  return [check, price, productInfo, bookCode];
}
