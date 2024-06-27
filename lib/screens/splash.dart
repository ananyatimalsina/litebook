import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:litebook/api/backend.dart';
import 'package:litebook/api/momox_backend.dart';
import 'package:litebook/api/rebuy_backend.dart';
import 'package:litebook/main.dart';

class Splash extends StatefulWidget {
  final VoidCallback onInitializationComplete;
  const Splash({Key? key, required this.onInitializationComplete})
      : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    controller.repeat();
    init();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color(0xFF1A237E),
        child: Center(
          child: RotationTransition(
              turns:
                  CurvedAnimation(parent: controller, curve: Curves.decelerate),
              child: const Image(
                  image: AssetImage("data/icon.png"), width: 200, height: 200)),
        ));
  }

  Future<void> init() async {
    final Momox momox = Momox(
        username: box.get('momoxU', defaultValue: ''),
        password: box.get('momoxP', defaultValue: ''));

    final Rebuy rebuy = Rebuy(
        username: box.get('rebuyU', defaultValue: ''),
        password: box.get('rebuyP', defaultValue: ''));

    try {
      await rebuy.login();
      await rebuy.getUuid();
      await momox.login();
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        debugPrint(response.data);
        debugPrint(response.headers.toString());
        debugPrint(response.requestOptions.toString());
      } else {
        debugPrint(e.requestOptions.toString());
        debugPrint(e.message);
      }
    }

    backend = Backend(box: bookBox, momox: momox, rebuy: rebuy);
    box.put("showHome", true);

    if (controller.isAnimating) {
      controller.stop();
    }
    widget.onInitializationComplete();
  }
}
