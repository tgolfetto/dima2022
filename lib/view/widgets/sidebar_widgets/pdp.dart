import 'package:dima2022/utils/size_config.dart';
import 'package:dima2022/view_models/cart_view_models/cart_view_model.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../view_models/content_view_models/content_view_model.dart';
import '../../../view_models/product_view_models/product_view_model.dart';
import '../../../view_models/product_view_models/products_view_model.dart';
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
      style: CustomTheme.buttonStyleIcon,
      onPressed: () {
        if (context.layout.breakpoint < LayoutBreakpoint.md) {
          content.updateMainContentIndex(Plp.pageIndex);
        } else {
          content.updateSideBarIndex(Filter.pageIndex);
        }
      },
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.close),
            Text('Close', style: CustomTheme.bodyStyle)
          ]),
    );
  }

  Widget _requestButton(productId) {
    return ElevatedButton(
      style: CustomTheme.buttonStyleOutline,
      onPressed: () => {
        ///TODO: request this productId
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        const Icon(Icons.try_sms_star),
        Padding(
          padding: EdgeInsets.only(left: CustomTheme.smallPadding),
          child: Text('Request', style: CustomTheme.bodyStyle),
        )
      ]),
    );
  }

  Widget _addToCartButton(productId) {
    return ElevatedButton(
      style: CustomTheme.buttonStyleFill,
      onPressed: () => {
        Provider.of<CartViewModel>(
          context,
          listen: false,
        ).addSingleItem(productId)
      },
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        const Icon(Icons.add_shopping_cart),
        Padding(
          padding: EdgeInsets.only(left: CustomTheme.smallPadding),
          child: Text('Add to cart', style: CustomTheme.bodySecondStyle),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = context.read<ContentViewModel>();
    ProductViewModel loadedProduct = Provider.of<ProductListViewModel>(
      context,
      listen: false,
    ).findById(content.productId);
    return Scaffold(
        body: Column(
      children: [
        Container(alignment: Alignment.centerLeft, child: _backButton(content)),
        Expanded(
          child: SingleChildScrollView(
            child: Expanded(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(CustomTheme.smallPadding),
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Image.network(loadedProduct.imageUrl!),
                      )),
                  Text(
                    'ID: ${loadedProduct.id}',
                    style: CustomTheme.bodyStyle,
                  ),
                  Padding(
                      padding:
                          EdgeInsets.only(bottom: CustomTheme.spacePadding),
                      child: Text(
                        loadedProduct.title!,
                        style: CustomTheme.headingStyle,
                      )),
                  Text(loadedProduct.description!,
                      style: CustomTheme.bodyStyle),
                  Text('EUR ${loadedProduct.price}',
                      style: CustomTheme.bodyStyle),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('Size: ', style: CustomTheme.bodyStyle),
                    DropdownButton<int>(
                      value: dropdownValue == 0
                          ? loadedProduct.sizes![0] //productModel.sizes[0]
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
                      items: loadedProduct.sizes! //productModel.sizes
                          .map<DropdownMenuItem<int>>((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text("$value", style: CustomTheme.bodyStyle),
                        );
                      }).toList(),
                    ),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Margin(
                        margin:
                            EdgeInsets.only(right: CustomTheme.spacePadding),
                        child: _requestButton(loadedProduct.id),
                      ),
                      _addToCartButton(loadedProduct.id)
                    ],
                  ),
                  const SizedBox(
                    height: 120,
                  )
                ],
              ),
            )),
          ),
        ),
      ],
    ));
  }
}
