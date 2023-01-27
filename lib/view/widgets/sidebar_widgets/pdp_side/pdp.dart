import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../../utils/size_config.dart';
import '../../../../view_models/cart_view_models/cart_view_model.dart';
import '../../../../view_models/content_view_models/content_view_model.dart';
import '../../../../view_models/product_view_models/product_view_model.dart';
import '../../../../view_models/product_view_models/products_view_model.dart';

import '../../../../view_models/request_view_models/request_list_view_model.dart';
import '../../../../view_models/request_view_models/request_view_model.dart';
import '../../../../view_models/user_view_models/user_view_model.dart';
import '../../common/conditional_row_column.dart';
import '../../common/custom_theme.dart';
import '../../common/close_button.dart';
import '../../common/custom_button.dart';
import '../../homepage_widgets/plp/plp.dart';
import '../../homepage_widgets/screen_builder.dart';
import '../../ui_widgets/glass_rounded_container.dart';
import '../filter.dart';
import 'category_tag.dart';

class Pdp extends StatefulWidget {
  static const int pageIndex = 5;

  const Pdp({super.key});

  @override
  State<Pdp> createState() => _PdpState();
}

class _PdpState extends State<Pdp> {
  int selectedSize = 0;

  Widget _addFavoriteButton(
      bool isFavorite, double sizeWidth, double sideHeight) {
    SizeConfig().init(context);
    var marginWidth = getProportionateScreenWidth(10, parentWidth: sizeWidth);
    var marginHeight =
        getProportionateScreenHeight(20, parentHeight: sideHeight);
    return GlassRoundedContainer(
        margin: EdgeInsets.symmetric(
            vertical: marginHeight,
            horizontal: marginWidth / marginHeight * marginHeight),
        itemPadding: EdgeInsets.symmetric(
            vertical: marginWidth / marginHeight * marginHeight,
            horizontal: marginWidth / marginHeight * marginHeight),
        radius: BorderRadius.circular(20.0),
        opacity: 0.45,
        enableShadow: true,
        enableBorder: false,
        child: isFavorite
            ? const Icon(Icons.favorite)
            : const Icon(Icons.favorite_border));
  }

  Widget _requestButton(ProductViewModel product, bool hideDetails) {
    return CustomButton(
      onPressed: () {
        UserViewModel userViewModel = Provider.of<UserViewModel>(
          context,
          listen: false,
        );

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

        Provider.of<RequestListViewModel>(
          context,
          listen: false,
        ).addRequest(newRequestViewModel);
      },
      transparent: false,
      outline: true,
      fontSize: 12,
      text: !hideDetails ? 'Request' : null,
      icon: Icons.try_sms_star,
    );
  }

  Widget _addToCartButton(ProductViewModel productViewModel, bool hideDetails) {
    return CustomButton(
      onPressed: () {
        Provider.of<CartViewModel>(
          context,
          listen: false,
        ).addItem(productViewModel.id!, productViewModel.imageUrl!,
            productViewModel.price!, productViewModel.title!);
      },
      transparent: false,
      outline: false,
      fontSize: 12,
      text: !hideDetails ? 'Add to cart' : null,
      icon: Icons.add_shopping_cart,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = context.read<ContentViewModel>();

    ProductViewModel loadedProduct = Provider.of<ProductListViewModel>(
      context,
      listen: false,
    ).findById(content.productId);

    return ScreenBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
        double topPadding,
        double bottomPadding,
        bool isKeyboardActive,
        double screenWidth,
        double screenHeight,
      ) {
        bool hideDetails = screenWidth < 315;
        return Scaffold(
          body: SingleChildScrollView(
            child: ConditionalRowColumn(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
              children: <Widget>[
                Stack(
                  children: [
                    SizedBox(
                      width: context.layout.breakpoint == LayoutBreakpoint.sm &&
                              screenWidth / screenHeight > 1
                          ? screenWidth / 2
                          : screenWidth,
                      height:
                          context.layout.breakpoint == LayoutBreakpoint.sm &&
                                  screenWidth / screenHeight > 1
                              ? screenHeight
                              : screenWidth,
                      child: kIsWeb ||
                              !Platform.environment.containsKey('FLUTTER_TEST')
                          ? Image.network(
                              loadedProduct.imageUrl!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset('assets/images/test.png'),
                    ),
                    Positioned(
                      left: 0.0,
                      top: 0.0,
                      child: CloseCustomButtom(
                        context: context,
                        content: content,
                        sizeWidth: screenWidth,
                        sideHeight: screenHeight,
                        onPressed: () {
                          if (context.layout.breakpoint < LayoutBreakpoint.md) {
                            content.updateMainContentIndex(Plp.pageIndex);
                          } else {
                            content.updateSideBarIndex(Filter.pageIndex);
                          }
                        },
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      bottom:
                          context.layout.breakpoint == LayoutBreakpoint.sm &&
                                  screenWidth / screenHeight > 1
                              ? null
                              : 0.0,
                      top: context.layout.breakpoint == LayoutBreakpoint.sm &&
                              screenWidth / screenHeight > 1
                          ? 0.0
                          : null,
                      child: Consumer<ProductListViewModel>(
                        builder: (context, __, _) => ElevatedButton(
                          style: CustomTheme.buttonStyleIcon,
                          onHover: (_) {},
                          onPressed: () {
                            setState(() {
                              loadedProduct.toggleFavoriteStatus();
                              Provider.of<ProductListViewModel>(context,
                                      listen: false)
                                  .refreshProduct(loadedProduct);
                            });
                          },
                          child: _addFavoriteButton(loadedProduct.isFavorite,
                              screenWidth, screenHeight),
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  width: context.layout.breakpoint == LayoutBreakpoint.sm &&
                          screenWidth / screenHeight > 1
                      ? screenWidth / 2
                      : screenWidth,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(10, 0, 0, 0),
                        offset: Offset(0, -10),
                        blurRadius: 10,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(getProportionateScreenWidth(
                      CustomTheme.smallPadding,
                      parentWidth: screenWidth,
                    )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (context.layout.breakpoint == LayoutBreakpoint.sm &&
                            screenWidth / screenHeight > 1)
                          SizedBox(height: topPadding),
                        Text(loadedProduct.title!,
                            style: Theme.of(context).textTheme.headline5),
                        Row(
                          children: [
                            Text(
                              'ID: ${loadedProduct.id}',
                              style: Theme.of(context).textTheme.caption,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text('EUR ${loadedProduct.price}'),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                          child: ListView.separated(
                            itemCount: loadedProduct.categories.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return ItemCategoryTag(
                                  value: false,
                                  category: loadedProduct.categories[index]);
                            },
                            separatorBuilder:
                                (BuildContext context, int index) =>
                                    const SizedBox(
                              width: 6,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            loadedProduct.description!,
                            style: CustomTheme.bodyStyle,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Size: ', style: CustomTheme.bodyStyle),
                            DropdownButton<int>(
                              value: selectedSize == 0
                                  ? loadedProduct
                                      .sizes![0] //productModel.sizes[0]
                                  : selectedSize,
                              icon: const Icon(Icons.arrow_downward),
                              elevation: 16,
                              underline: Container(
                                height: 2,
                                color: Colors.deepPurpleAccent,
                              ),
                              onChanged: (int? value) {
                                setState(() {
                                  selectedSize = value!;
                                });
                              },
                              items: loadedProduct.sizes!
                                  .map<DropdownMenuItem<int>>((int value) {
                                return DropdownMenuItem<int>(
                                  value: value,
                                  child: Text("$value",
                                      style: CustomTheme.bodyStyle),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: getProportionateScreenHeight(30,
                                parentHeight: screenHeight)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _requestButton(loadedProduct, hideDetails),
                            SizedBox(
                                width: getProportionateScreenWidth(5,
                                    parentWidth: screenWidth)),
                            _addToCartButton(loadedProduct, hideDetails),
                          ],
                        ),
                        SizedBox(height: bottomPadding),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
