import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:layout/layout.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../../view_models/cart_view_models/cart_view_model.dart';
import '../../../../view_models/content_view_models/content_view_model.dart';
import '../../../../view_models/product_view_models/product_view_model.dart';
import '../../../../view_models/product_view_models/products_view_model.dart';
import '../../../../view_models/request_view_models/request_list_view_model.dart';
import '../../../../view_models/request_view_models/request_view_model.dart';
import '../../../../view_models/user_view_models/user_view_model.dart';
import '../../common/custom_theme.dart';
import '../../sidebar_widgets/pdp_side/pdp.dart';

class ProductLineItem extends StatefulWidget {
  final ProductViewModel productViewModel;

  const ProductLineItem({super.key, required this.productViewModel});

  @override
  State<ProductLineItem> createState() => _ProductLineItemState();
}

class _ProductLineItemState extends State<ProductLineItem> {
  int selectedSize = 0;
  int productId = 0;

  Widget _requestButton(ProductViewModel product) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    RequestListViewModel requestListViewModel =
        Provider.of<RequestListViewModel>(context);
    return TextButton(
      style: CustomTheme.buttonStyleOutline,
      onPressed: () {
        var newRequestViewModel = RequestViewModel();
        newRequestViewModel.createRequest(
          userViewModel.user,
          product.getProduct
            ..sizes = [
              selectedSize == 0 ? product.getProduct.sizes![0] : selectedSize
            ],
        );
        newRequestViewModel
            .updateMessage('May I receive this product in the dressing room?');

        requestListViewModel.addRequest(newRequestViewModel);

        Timer? timer = Timer(const Duration(milliseconds: 1500), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
              });
              return const AlertDialog(
                title: Text('Product requested!'),
              );
            }).then((value) {
          // dispose the timer in case something else has triggered the dismiss.
          timer?.cancel();
          timer = null;
        });
      },
      child: const Icon(
        Icons.try_sms_star,
        size: 14,
      ),
    );
  }

  Widget _addToCartButton(ProductViewModel productViewModel) {
    return TextButton(
      style: CustomTheme.buttonStyleFill,
      onPressed: () {
        Provider.of<CartViewModel>(
          context,
          listen: false,
        ).addItem(productViewModel.id!, productViewModel.imageUrl!,
            productViewModel.price!, productViewModel.title!);

        Timer? timer = Timer(const Duration(milliseconds: 1500), () {
          Navigator.of(context, rootNavigator: true).pop();
        });
        showDialog(
            context: context,
            builder: (context) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).pop(true);
              });
              return const AlertDialog(
                title: Text('Product added to cart!'),
              );
            }).then((value) {
          // dispose the timer in case something else has triggered the dismiss.
          timer?.cancel();
          timer = null;
        });
      },
      child: const Icon(
        Icons.add_shopping_cart,
        size: 14,
      ),
    );
  }

  Widget _addToFavoriteButton(ProductViewModel product) {
    return Consumer<ProductListViewModel>(
      builder: (context, content, _) => ElevatedButton(
        style: CustomTheme.buttonStyleIcon,
        onHover: (_) {},
        onPressed: () {
          setState(() {
            product.toggleFavoriteStatus();
            content.refreshProduct(product);
          });
        },
        child: product.isFavorite
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = context.read<ContentViewModel>();
    ProductViewModel product = widget.productViewModel;

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      final height = constraints.maxHeight; //width / 0.532544378698225;
      return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width,
              //height: width,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      content.updateProductId(product.id!);
                      if (context.layout.breakpoint < LayoutBreakpoint.md) {
                        content.updateMainContentIndex(Pdp.pageIndex);
                      }
                      content.updateSideBarIndex(Pdp.pageIndex);
                    },
                    child: kIsWeb ||
                            !Platform.environment.containsKey('FLUTTER_TEST')
                        ? Image.network(product.imageUrl!)
                        : Image.asset('assets/images/test.png'),
                  ),
                  Positioned(
                    right: 0.0,
                    top: 0.0,
                    child: _addToFavoriteButton(product),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3.0),
                      child: Column(
                        children: [
                          Text(
                            product.title!,
                            maxLines: 2,
                            style:
                                CustomTheme.headingStyle.copyWith(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EUR ${product.price}',
                          //style: CustomTheme.bodyStyle,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Size: ',
                              //style: CustomTheme.bodyStyle,
                            ),
                            DropdownButton<int>(
                              value: selectedSize == 0
                                  ? product.sizes![0]
                                  : selectedSize,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 1,
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (int? value) {
                                setState(() {
                                  selectedSize = value!;
                                });
                              },
                              items: product.sizes!
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text("$value"),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(child: _requestButton(product)),
                        const SizedBox(width: 8),
                        Expanded(child: _addToCartButton(product)),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 8),
                  // Flexible(
                  //   flex: 2,
                  //   child: Row(
                  //     children: [
                  //       Expanded(child: _addToCartButton(product)),
                  //       //const SizedBox(width: 8),
                  //       //Expanded(child: _addToCartButton(product)),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
