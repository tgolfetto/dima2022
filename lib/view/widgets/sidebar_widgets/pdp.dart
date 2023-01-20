import 'package:dima2022/utils/size_config.dart';
import 'package:dima2022/view/widgets/common/custom_button.dart';
import 'package:dima2022/view/widgets/homepage_widgets/category_tag.dart';
import 'package:dima2022/view/widgets/ui_widgets/glass_rounded_container.dart';
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

  Widget _backButton(
      ContentViewModel content, double sizeWidth, double sideHeight) {
    SizeConfig().init(context);
    var marginWidth = getProportionateScreenWidth(10, parentWidth: sizeWidth);
    var marginHeight =
        getProportionateScreenHeight(20, parentHeight: sideHeight);
    return GlassRoundedContainer(
        margin: EdgeInsets.symmetric(
            vertical: marginHeight,
            horizontal: marginWidth / marginHeight * marginHeight),
        itemPadding: const EdgeInsets.symmetric(horizontal: 5),
        radius: BorderRadius.circular(20.0),
        opacity: 0.45,
        enableShadow: true,
        enableBorder: false,
        child: CustomButton(
          transparent: true,
          outline: false,
          icon: Icons.close,
          text: 'Close',
          onPressed: () {
            if (context.layout.breakpoint < LayoutBreakpoint.md) {
              content.updateMainContentIndex(Plp.pageIndex);
            } else {
              content.updateSideBarIndex(Filter.pageIndex);
            }
          },
        ));
  }

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

  Widget _requestButton(productId) {
    return CustomButton(
      onPressed: () => {
        ///TODO: request this productId
      },
      transparent: false,
      outline: true,
      text: 'Request',
      icon: Icons.try_sms_star,
    );
  }

  Widget _addToCartButton(productId) {
    return CustomButton(
      onPressed: () => {
        Provider.of<CartViewModel>(
          context,
          listen: false,
        ).addSingleItem(productId)
      },
      transparent: false,
      outline: false,
      text: 'Add to cart',
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

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isKeyboardActive = MediaQuery.of(context).viewInsets.bottom > 0;
        double sideWidth = constraints.maxWidth;
        double sideHeight = constraints.maxHeight;

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Expanded(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            child: Image.network(loadedProduct.imageUrl!),
                          ),
                          Positioned(
                            left: 0.0,
                            top: 0.0,
                            child: _backButton(content, sideWidth, sideHeight),
                          ),
                          Positioned(
                            right: 0.0,
                            bottom: 0.0,
                            child: Consumer<ProductListViewModel>(
                              builder: (context, __, _) => ElevatedButton(
                                style: CustomTheme.buttonStyleIcon,
                                onHover: (_) {},
                                onPressed: () {
                                  setState(() {
                                    loadedProduct.toggleFavoriteStatus();
                                  });
                                },
                                child: _addFavoriteButton(
                                    loadedProduct.isFavorite,
                                    sideWidth,
                                    sideHeight),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(22),
                                topRight: Radius.circular(22))),
                        child: Padding(
                          padding: EdgeInsets.all(getProportionateScreenWidth(
                            CustomTheme.smallPadding,
                            parentWidth: sideWidth,
                          )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ItemCategoryTag(
                                        category:
                                            loadedProduct.categories[index]);
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
                              Text(loadedProduct.description!,
                                  style: CustomTheme.bodyStyle),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Size: ',
                                        style: CustomTheme.bodyStyle),
                                    DropdownButton<int>(
                                      value: dropdownValue == 0
                                          ? loadedProduct
                                              .sizes![0] //productModel.sizes[0]
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
                                      items: loadedProduct
                                          .sizes! //productModel.sizes
                                          .map<DropdownMenuItem<int>>(
                                              (int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text("$value",
                                              style: CustomTheme.bodyStyle),
                                        );
                                      }).toList(),
                                    ),
                                  ]),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Margin(
                                    margin: EdgeInsets.only(
                                        right: CustomTheme.spacePadding),
                                    child: _requestButton(loadedProduct.id),
                                  ),
                                  _addToCartButton(loadedProduct.id)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
