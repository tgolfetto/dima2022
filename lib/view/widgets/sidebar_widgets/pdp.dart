import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../view_models/content_view_model.dart';
import '../../custom_theme.dart';
import '../homepage_widgets/plp.dart';
import 'filter.dart';

class Pdp extends StatefulWidget {
  static const int pageIndex = 5;

  const Pdp({super.key});

  @override
  State<Pdp> createState() => _PdpState();
}

class _PdpState extends State<Pdp> {
  int dropdownValue = 0;

  ElevatedButton _backButton(ContentViewModel content) {
    return ElevatedButton(
      style: CustomTheme.buttonStyleOutline,
      onPressed: (){
        if(context.layout.breakpoint < LayoutBreakpoint.md){
          content.updateMainContentIndex(Plp.pageIndex);
        }else{
          content.updateSideBarIndex(Filter.pageIndex);
        }
      },
      child: const Icon(Icons.close),
    );
  }

  Widget get _addToCartButton {
    return ElevatedButton(
      style: CustomTheme.buttonStyleFill,
      onPressed: () => {
        //Cart.addToCart(widget.model, dropdownValue)
      } ,
      child: const Icon(Icons.add_shopping_cart),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = context.read<ContentViewModel>();
    return Scaffold(
        body: Column(
      children: [
        Container(child: _backButton(content)),
        Expanded(
          child: SingleChildScrollView(
            child: Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: double.maxFinite,
                    child: Image.asset('assets/images/example.jpg'),
                  ),
                  Text(content.productId),
                  const Text('Product name: T-shirt black'),
                  const Text('19.99 €'),
                  DropdownButton<int>(
                    value: dropdownValue == 0
                        ? 44 //productModel.sizes[0]
                        : dropdownValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (int? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    items: [44, 46, 48] //productModel.sizes
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text("$value"),
                      );
                    }).toList(),
                  ),
                  _addToCartButton,
                ],
              ),
            )),
          ),
        ),
      ],
    ));
  }
}