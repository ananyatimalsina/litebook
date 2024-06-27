import 'package:flutter/material.dart';
import 'package:litebook/api/backend.dart';
import 'package:litebook/widgets/cart_cards.dart';

class Cart extends StatefulWidget {
  const Cart({
    Key? key,
    required this.backend,
  }) : super(key: key);
  final Backend backend;

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Cart"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: Center(
          child: FutureBuilder(
              future: widget.backend.getCart(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ListView.builder(
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return const LoadingCard();
                    },
                  );
                }
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  List data = snapshot.data as List;
                  if (data.isEmpty) {
                    return const Text("Nothing in cart!");
                  } else {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return CartCard(
                          book: data[index],
                          backend: widget.backend,
                        );
                      },
                    );
                  }
                }
              })),
    );
  }
}
