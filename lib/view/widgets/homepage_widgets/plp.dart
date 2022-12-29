import 'package:dima2022/utils/size_config.dart';
import 'package:dima2022/view/custom_theme.dart';
import 'package:dima2022/view/grid_delegate.dart';
import 'package:flutter/material.dart';
import 'package:dima2022/view/widgets/product_line_item.dart';
import 'package:layout/layout.dart';

import '../../../view_models/product_view_models/product_view_model.dart';
import '../../../view_models/product_view_models/products_view_model.dart';

class Plp extends StatefulWidget {
  static const routeName = '/plp';
  const Plp({super.key});

  @override
  State<Plp> createState() => _PlpState();
}

class _PlpState extends State<Plp> {
  Widget get _filterButton {
    return context.layout.breakpoint >= LayoutBreakpoint.lg
        ? const Spacer()
        : ElevatedButton(
            style: CustomTheme.buttonStyleIcon,
            onPressed: () => {
              /// TODO: Open filter
            },
            child: const Icon(Icons.filter_list),
          );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    List<ProductViewModel> productsVM = ProductListViewModel().items;
    for (ProductViewModel p in productsVM) {
      items.add(LineItem(
        id: p.id!,
        title: p.title!,
        description: p.description!,
        price: p.price!,
        sizes: p.sizes!,
        imageUrl: p.imageUrl!,
      ));
    }

    /// Mock products
    for (int i = 0; i < 10; i++) {
      items.add(LineItem(
        id: '-NEPxPT8F5BFAZbWokNb',
        title: 'Blue T-Shirt',
        description: 'These are blue jeans made of 99% cotton and 1% spandex',
        price: 29.99,
        sizes: const [32, 34, 36],
        imageUrl: 'https://i.pravatar.cc/150?img=4',
      ));
    }

    final double spacing =
        BreakpointValue(xs: CustomTheme.smallPadding).resolve(context);

    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          const SliverGutter(),
          SliverMargin(
              margin: context.layout.breakpoint == LayoutBreakpoint.xs
                  ? EdgeInsets.symmetric(
                      horizontal:
                          getProportionateScreenWidth(CustomTheme.spacePadding))
                  : EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(
                          CustomTheme.mediumPadding)),
              sliver: SliverToBoxAdapter(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product list',
                        style: CustomTheme.headingStyle,
                      ),
                      _filterButton
                    ]),
              )),
          const SliverGutter(),
          SliverMargin(
            margin: context.layout.breakpoint == LayoutBreakpoint.xs
                ? EdgeInsets.symmetric(
                    horizontal:
                        getProportionateScreenWidth(CustomTheme.spacePadding))
                : EdgeInsets.symmetric(
                    horizontal:
                        getProportionateScreenWidth(CustomTheme.mediumPadding)),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate.fixed(items),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.layout.value(
                  xs: 2,
                  sm: 2,
                  md: 2,
                  lg: 3,
                  xl: 4,
                ),
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
                childAspectRatio: 0.54,
              ),
            ),
          ),
        ],
      ),
    );

    // return SingleChildScrollView(
    //   child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround, children: rows),
    // );
  }
}
