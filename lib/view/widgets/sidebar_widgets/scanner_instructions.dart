import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';
import '../common/custom_theme.dart';

class ScannerInstructions extends StatelessWidget {
  static const int pageIndex = 10;

  const ScannerInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        key: const Key('barcodeSide'),
        child: Center(
          child: Column(
            children: [
              const Image(image: AssetImage('assets/images/scan.png')),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal:
                        getProportionateScreenWidth(CustomTheme.smallPadding)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Scan a product',
                    style: CustomTheme.headingStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(CustomTheme.smallPadding),
                  vertical: getProportionateScreenHeight(CustomTheme.spacePadding),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Use the QR Code scanner and point it to the item tag to open up the product information!',
                    style: CustomTheme.bodyStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
