import 'package:litebook/widgets/custom_barcode_scanner.dart';
import 'package:native_barcode_scanner/barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:future_loading_dialog/future_loading_dialog.dart';
import 'package:litebook/screens/cart.dart';
import 'package:litebook/screens/onboarding/onboarding.dart';
import 'package:litebook/screens/splash.dart';
import 'package:litebook/api/backend.dart';
import 'package:litebook/main.dart';
import 'package:litebook/widgets/bottom_alert_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.backend,
  }) : super(key: key);

  final Backend backend;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
      appBar: AppBar(
        elevation: 0,
        title: const Text("LiteBook"),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.shopping_basket),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Cart(
                              backend: widget.backend,
                            )));
              })
        ],
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            box.put("showHome", false);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Onboarding(
                        onOnboardingComplete: () => {
                              runApp(Splash(
                                  onInitializationComplete: () =>
                                      {runApp(const LiteBook())}))
                            })));
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: Stack(children: [
        CustomBarcodeScanner(
          scannerType: ScannerType.barcode,
          stopScanOnBarcodeDetected: false,
          onBarcodeDetected: (barcode) async {
            List data = [];

            await showFutureLoadingDialog(
              context: context,
              future: () async {
                data = await widget.backend.getData(barcode.value);
              },
            );

            await showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                )),
                // ignore: use_build_context_synchronously
                context: context,
                isDismissible: true,
                builder: (context) {
                  return BottomAlertSheet(
                    data: data,
                    backend: widget.backend,
                  );
                });
          },
          onError: (error) {},
        ),
      ]),
    );
  }
}
