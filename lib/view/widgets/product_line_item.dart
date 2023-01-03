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

  Widget _requestButton(productId) {
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
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        const Icon(Icons.try_sms_star),
        Text('Request', style: CustomTheme.bodyStyle)
      ]),
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
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        const Icon(Icons.add_shopping_cart),
        Text('Add to cart', style: CustomTheme.bodyStyle)
      ]),
    );
  }

  ElevatedButton _addToFavoriteButton(productId) {
    return ElevatedButton(
      style: CustomTheme.buttonStyleIcon,
      onPressed: () {
        setState(() {
          widget.productViewModel.toggleFavoriteStatus();
        });
      },
      child: widget.productViewModel.isFavorite
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_border),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = context.read<ContentViewModel>();
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(children: [
            GestureDetector(
              onTap: () {
                content.updateProductId(widget.productViewModel.id!);
                if (context.layout.breakpoint < LayoutBreakpoint.lg) {
                  content.updateMainContentIndex(Pdp.pageIndex);
                } else {
                  content.updateSideBarIndex(Pdp.pageIndex);
                }
              },
              child: Image.network(widget.productViewModel.imageUrl!),
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              child: _addToFavoriteButton(widget.productViewModel.id),
            )
          ]),
          Text(
            widget.productViewModel.title!,
            style: CustomTheme.headingStyle,
          ),
          Text('EUR ${widget.productViewModel.price}',
              style: CustomTheme.bodyStyle),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Size: ', style: CustomTheme.bodyStyle),
              DropdownButton<int>(
                value: dropdownValue == 0
                    ? widget.productViewModel.sizes![0]
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
                items: widget.productViewModel.sizes!
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("$value"),
                  );
                }).toList(),
              ),
            ],
          ),
          Margin(
              margin: EdgeInsets.symmetric(vertical: CustomTheme.spacePadding),
              child: _requestButton(widget.productViewModel.id)),
          _addToCartButton(widget.productViewModel),
        ],
      ),
    );
  }
}
