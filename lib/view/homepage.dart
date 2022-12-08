import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './menu.dart';
import './custom_theme.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'barcode_scanner_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;
  String _barcodeScanned = '';

  ElevatedButton get _cartButton {
    return ElevatedButton(
      style: buttonStyle,
      onPressed: () => Modular.to.navigate('/barcode'),
      child: const Icon(Icons.shopping_cart),
    );
  }

  Widget get _mainContent {
    switch (_currentIndex) {
      case 1:
        {
          return Expanded(
              flex:1,
              child: BarcodeScannerWidget((String code) {
                _barcodeScanned = code;
                if (kDebugMode) {
                  print(_barcodeScanned);
                }
              }));
        }
      default:
        {
          return const Text('Home');
        }
    }
  }

  Menu get _bottomMenu {
    return Menu(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      items: [
        /// Home
        BottomBarItem(
          icon: const Icon(Icons.home),
          title: const Text("Home"),
          selectedColor: Colors.purple,
        ),

        /// Scan
        BottomBarItem(
          icon: const Icon(Icons.qr_code_scanner),
          title: const Text("Scan"),
          selectedColor: Colors.pink,
        ),

        /// Dressing room
        BottomBarItem(
          icon: const Icon(Icons.switch_access_shortcut),
          title: const Text("Dressing Room"),
          selectedColor: Colors.orange,
        ),

        /// Profile
        BottomBarItem(
          icon: const Icon(Icons.person),
          title: const Text("Profile"),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_cartButton, _mainContent, _bottomMenu],
      )),
    );
  }
}
