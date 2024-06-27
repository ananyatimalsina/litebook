import 'package:hive/hive.dart';
part 'book_data_model.g.dart';

@HiveType(typeId: 1)
class Book {
  @HiveField(0)
  late String title;
  @HiveField(1)
  late String buyer;
  @HiveField(2)
  late String price;
  @HiveField(3)
  late List imageUrl;
  @HiveField(4)
  late String isbn;
  @HiveField(5)
  late String bookCode;

  Book({
    required this.title,
    required this.buyer,
    required this.price,
    required this.imageUrl,
    required this.isbn,
    this.bookCode = "null",
  });

  Book.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        buyer = json['buyer'],
        price = json['price'],
        imageUrl = json['imageUrl'],
        isbn = json['isbn'],
        bookCode = json['bookCode'];

  Book.empty() {
    title = "null";
    buyer = "nobody";
    price = "null";
    imageUrl = ["null", "null"];
    isbn = "null";
    bookCode = "null";
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'buyer': buyer,
        'price': price,
        'imageUrl': imageUrl,
        "isbn": isbn,
        "bookCode": bookCode,
      };
}
