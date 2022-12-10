import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../view/barcode_scanner_widget.dart';
import '../view/plp.dart';

class HomepageContentRoute{
  String _barcodeScanned = '';

  Widget mainContent(int currentIndex) {
    switch (currentIndex) {
      case 1:
        {
          return Expanded(
              flex:1,
              child: BarcodeScannerWidget((String code) {
                _barcodeScanned = code;
                if (kDebugMode) {
                  print(_barcodeScanned);
                }
                /// @TODO: show the product of the related barcode
              }));
        }
      case 2:
        {
          return const Text('Dressing room');
          /// @TODO: show dressing room widget
        }
      case 3:
        {
          return const Text('Profile');
          /// @TODO: show profile widget
        }
      default:
        {
          return const Plp();
          /// @TODO: show list of products
        }
    }
  }

}