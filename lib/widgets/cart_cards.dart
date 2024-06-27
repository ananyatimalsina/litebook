import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:litebook/api/backend.dart';
import 'package:litebook/api/book_data_model.dart';
import 'package:litebook/widgets/utils.dart';
import 'package:shimmer/shimmer.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.book,
    required this.backend,
  }) : super(key: key);

  final Book book;
  final Backend backend;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(book.isbn),
        direction: DismissDirection.endToStart,
        onDismissed: (dir) async {
          await backend.removeBook(book);
        },
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.indigo,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Row(children: [Spacer(), Icon(Icons.delete)]),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                width: 88,
                child: AspectRatio(
                  aspectRatio: 0.9,
                  child: Container(
                    padding:
                        EdgeInsets.all(getProportionateScreenWidth(8, context)),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image(
                        image: CachedNetworkImageProvider(book.imageUrl[0])),
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${book.title.characters.take(getCharLength(context))}...",
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "€${book.price} ",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.indigo),
                    children: [
                      TextSpan(
                          text: book.buyer[0].toUpperCase() +
                              book.buyer.substring(1),
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

class LoadingCard extends StatelessWidget {
  const LoadingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.indigo,
        highlightColor: Colors.white,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 88,
                child: AspectRatio(
                  aspectRatio: 0.9,
                  child: Container(
                      padding: EdgeInsets.all(
                          getProportionateScreenWidth(8, context)),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15.0)))),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20,
                  width: 280,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 20,
                  width: 140,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(15))),
                ),
              ],
            ),
          ],
        ));
  }
}
