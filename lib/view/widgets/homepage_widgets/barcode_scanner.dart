import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

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
    super.dispose();

    _scannerController
      ..stopCameraPreview()
      ..stopCamera();
  }

  @override
  Widget build(BuildContext context) {
    return context.layout.breakpoint < LayoutBreakpoint.md
        ? PlatformAiBarcodeScannerWidget(
            platformScannerController: _scannerController,
          )
        : FractionallySizedBox(
            widthFactor: 0.95,
            heightFactor: 0.95,
            child: Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: PlatformAiBarcodeScannerWidget(
                platformScannerController: _scannerController,
              ),
            ));
  }
}
