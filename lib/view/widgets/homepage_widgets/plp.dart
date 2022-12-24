import 'package:dima2022/view/grid_delegate.dart';
import 'package:flutter/material.dart';
import 'package:dima2022/view/widgets/product_line_item.dart';
import 'package:layout/layout.dart';
import '../../../model/product.dart';

class Plp extends StatefulWidget {
  const Plp({super.key});

  @override
  State<Plp> createState() => _PlpState();
}

class _PlpState extends State<Plp> {
  final int _productPerRow = 2;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    /*List<ProductModel> products = Product.retrieveProductList();
    for (int i = 1; i <= products.length; i++) {
      ProductModel p = products[i - 1];
      items.add(LineItem(
          model: p.model, name: p.name, price: p.price, sizes: p.sizes));
    }

     */
    /// Mock products
    for(int i= 0; i < 10 ; i++){
      items.add(const LineItem(model: 1, name: 'T-shirt', price: 19.99, sizes: [44, 46, 48],));
    }

    final double spacing = const BreakpointValue(xs: 0.0, sm: 10.0).resolve(context);

    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          const SliverGutter(),
          const SliverToBoxAdapter(
            child: Margin(
              child: Text('Section Title'),
            ),
          ),
          const SliverGutter(),
          SliverMargin(
            margin: context.layout.breakpoint == LayoutBreakpoint.xs
                ? EdgeInsets.zero
                : null,
            sliver: SliverGrid(
              delegate: SliverChildListDelegate.fixed(items),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndMainAxisExtent(
                crossAxisCount: context.layout.value(
                  xs: 1,
                  sm: 2,
                  md: 2,
                  lg: 3,
                  xl: 4,
                ),
                mainAxisExtent: 60,
                mainAxisSpacing: spacing,
                crossAxisSpacing: spacing,
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
