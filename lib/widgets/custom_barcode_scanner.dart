import 'package:flutter/material.dart';
import 'package:native_barcode_scanner/barcode_scanner.dart';

class CustomBarcodeScanner extends StatefulWidget {
  final bool stopScanOnBarcodeDetected;
  final ScannerType scannerType;
  final Function(Barcode) onBarcodeDetected;
  final Function(dynamic) onError;

  const CustomBarcodeScanner({
    super.key,
    required this.stopScanOnBarcodeDetected,
    required this.scannerType,
    required this.onBarcodeDetected,
    required this.onError,
  });

  @override
  State<CustomBarcodeScanner> createState() => _CustomBarcodeScannerState();
}

class _CustomBarcodeScannerState extends State<CustomBarcodeScanner> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BarcodeScannerWidget(
          stopScanOnBarcodeDetected: widget.stopScanOnBarcodeDetected,
          scannerType: widget.scannerType,
          onBarcodeDetected: widget.onBarcodeDetected,
          onError: widget.onError,
        ),
        Center(
          child: Stack(
            children: [
              Container(
                width: 380, // adjust as needed
                height: 150, // adjust as needed
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Center(
                  child: Container(
                    width: 350,
                    height: 1,
                    color: Colors.red,
                  ),
                ),
              ),
              // Top left corner
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 2),
                      left: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
              // Top right corner
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.white, width: 2),
                      right: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
              // Bottom left corner
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white, width: 2),
                      left: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
              // Bottom right corner
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white, width: 2),
                      right: BorderSide(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
