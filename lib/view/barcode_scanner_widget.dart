import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/material.dart';

class BarcodeScannerWidget extends StatefulWidget {
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
    super.dispose();

    _scannerController
      ..stopCameraPreview()
      ..stopCamera();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformAiBarcodeScannerWidget(
          platformScannerController: _scannerController,
        );
  }
}
