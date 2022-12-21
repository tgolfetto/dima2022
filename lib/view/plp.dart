import 'package:dima2022/view/grid_delegate.dart';
import 'package:dima2022/view/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:dima2022/view/lineitem.dart';
import 'package:layout/layout.dart';
import '../model/product_query.dart';
import '../model_view/product.dart';

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
    List<ProductModel> products = Product.retrieveProductList();
    for (int i = 1; i <= products.length; i++) {
      ProductModel p = products[i - 1];
      items.add(LineItem(
          model: p.model, name: p.name, price: p.price, sizes: p.sizes));
    }

    final double spacing = BreakpointValue(xs: 0.0, sm: 10.0).resolve(context);

    return Scrollbar(
      child: Container(
        //color: Theme.of(context).scaffoldBackgroundColor,
        child: CustomScrollView(
          slivers: [
            SliverGutter(),
            SliverToBoxAdapter(
              child: Margin(
                child: Text('Section Title'),
              ),
            ),
            SliverGutter(),
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
      ),
    );

    // return SingleChildScrollView(
    //   child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround, children: rows),
    // );
  }
}
