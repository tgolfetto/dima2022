import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../view/widgets/homepage_widgets/barcode_scanner.dart';
import '../view/widgets/homepage_widgets/plp.dart';

class HomepageContentRoute {
  String _barcodeScanned = '';

  Widget mainContent(int currentIndex) {
    switch (currentIndex) {
      case 1:
        {
          return BarcodeScannerWidget((String code) {
            _barcodeScanned = code;
            if (kDebugMode) {
              print(_barcodeScanned);
            }

            /// @TODO: show the product of the related barcode
          });
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
