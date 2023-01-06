import 'package:dima2022/utils/size_config.dart';
import 'package:dima2022/view_models/content_view_model.dart';
import 'package:dima2022/view_models/product_view_models/product_view_model.dart';
import 'package:dima2022/view_models/product_view_models/products_view_model.dart';
import 'package:dima2022/view_models/request_view_models/request_list_view_model.dart';
import 'package:dima2022/view_models/user_view_models/user_view_model.dart';
import 'package:layout/layout.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../models/request/request.dart';
import '../../models/request/request_status.dart';
import '../../models/user/user.dart';
import '../../view_models/cart_view_models/cart_view_model.dart';
import '../../view_models/request_view_models/request_view_model.dart';
import '../custom_theme.dart';
import 'sidebar_widgets/pdp.dart';

class LineItem extends StatefulWidget {
  ProductViewModel productViewModel;

  LineItem({super.key, required this.productViewModel});

  @override
  State<LineItem> createState() => _LineItemState();
}

class _LineItemState extends State<LineItem> {
  int dropdownValue = 0;
  int productId = 0;

  Widget _requestButton(ProductViewModel product) {
    return ElevatedButton(
      style: CustomTheme.buttonStyleOutline,
      onPressed: () {
        List<RequestViewModel> rqList = Provider.of<RequestListViewModel>(
          context,
          listen: false,
        ).requests;

        ProductViewModel product = widget.productViewModel;
        // Provider.of<ProductListViewModel>(
        //   context,
        //   listen: false,
        // ).findById(productId);

        String email = Provider.of<UserViewModel>(
          context,
          listen: false,
        ).email;

        Request rq = Request(
            id: '${rqList.length}',
            user: User(email: email),
            clerk: null,
            products: [product.getProduct],
            message: 'May i have this product',
            status: RequestStatus.pending);

        Provider.of<RequestViewModel>(
          context,
          listen: false,
        ).createRequest(rq);

        Provider.of<RequestListViewModel>(
          context,
          listen: false,
        ).addRequest(Provider.of<RequestViewModel>(
          context,
          listen: false,
        ));

        ///TODO: ?????
      },
      child: const Icon(
        Icons.try_sms_star,
        size: 14,
      ),
      //  Row(
      //   mainAxisAlignment: MainAxisAlignment.start,
      //   children: [
      //     const Icon(Icons.try_sms_star),
      //     Padding(
      //       padding: EdgeInsets.only(left: CustomTheme.smallPadding),
      //       child: Text('Request', style: CustomTheme.bodyStyle),
      //     )
      //   ],
      // ),
    );
  }

  Widget _addToCartButton(ProductViewModel productViewModel) {
    return ElevatedButton(
      style: CustomTheme.buttonStyleFill,

      onPressed: () => {
        Provider.of<CartViewModel>(
          context,
          listen: false,
        ).addItem(productViewModel.id!, productViewModel.imageUrl!,
            productViewModel.price!, productViewModel.title!)
      },
      child: const Icon(
        Icons.add_shopping_cart,
        size: 14,
      ),

      // Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   crossAxisAlignment: CrossAxisAlignment.center,
      //   children: [
      //     const Icon(Icons.add_shopping_cart),
      //     Text(
      //       'Add to cart',
      //       overflow: TextOverflow.ellipsis,
      //     ),
      //   ],
      // ),
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
                });
              },
              child: product.isFavorite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
            ));
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
        padding: EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              //height: width,
              child: Stack(children: [
                GestureDetector(
                  onTap: () {
                    content.updateProductId(product.id!);
                    if (context.layout.breakpoint < LayoutBreakpoint.lg) {
                      content.updateMainContentIndex(Pdp.pageIndex);
                    } else {
                      content.updateSideBarIndex(Pdp.pageIndex);
                    }
                  },
                  child: Image.network(product.imageUrl!),
                ),
                Positioned(
                  right: 0.0,
                  top: 0.0,
                  child: _addToFavoriteButton(product),
                )
              ]),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
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
                    flex: 3,
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
                              value: dropdownValue == 0
                                  ? product.sizes![0]
                                  : dropdownValue,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 1,
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (int? value) {
                                setState(() {
                                  dropdownValue = value!;
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
