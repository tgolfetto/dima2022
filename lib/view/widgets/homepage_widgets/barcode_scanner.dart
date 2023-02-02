import 'package:ai_barcode/ai_barcode.dart';
import 'package:dima2022/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

import '../common/custom_theme.dart';

class BarcodeScannerWidget extends StatefulWidget {
  static const pageIndex = 1;
  const BarcodeScannerWidget(this.resultCallback, {super.key});

  final void Function(String result) resultCallback;

  @override
  State<StatefulWidget> createState() {
    return _AppBarcodeScannerWidgetState();
  }
}

class _AppBarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  late ScannerController _scannerController;

  @override
  void initState() {
    super.initState();

    _scannerController = ScannerController(scannerResult: (result) {
      widget.resultCallback(result);
    }, scannerViewCreated: () {
      final TargetPlatform platform = Theme.of(context).platform;
      if (TargetPlatform.iOS == platform) {
        Future.delayed(const Duration(seconds: 2), () {
          _scannerController
            ..startCamera()
            ..startCameraPreview();
        });
      } else {
        _scannerController
          ..startCamera()
          ..startCameraPreview();
      }
    });
  }

  @override
  void dispose() {
    _scannerController
      ..stopCameraPreview()
      ..stopCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      key: const Key('barcodeScan'),
      color: CustomTheme.secondaryBackgroundColor,
      child: Margin(
          margin: const EdgeInsets.all(20),
          child: context.layout.breakpoint < LayoutBreakpoint.md
              ? PlatformAiBarcodeScannerWidget(
                  platformScannerController: _scannerController,
                )
              : Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: getProportionateScreenWidth(300),
                    height: getProportionateScreenHeight(300),
                    child: PlatformAiBarcodeScannerWidget(
                      platformScannerController: _scannerController,
                    ),
                  ))),
    ));
  }
}
