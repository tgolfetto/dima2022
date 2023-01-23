import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';
import '../../../view_models/order_view_models/orders_view_model.dart';
import '../../custom_theme.dart';
import '../common/animated_circular_progress_indicator.dart';
import '../homepage_widgets/tile_widget.dart';

class OrderSide extends StatefulWidget {
  static const pageIndex = 11;

  const OrderSide({super.key});

  @override
  State<OrderSide> createState() => _OrderSideState();
}

class _OrderSideState extends State<OrderSide> {

  SliverMargin getTileGrid(spacing, OrdersViewModel orderData) {
    Map<String, String> tiles = {
      "Total Orders": orderData.getTotalCount().toString(),
      "Average Order Amount":
          "€ ${orderData.getAverageAmount().toStringAsFixed(2)}",
      "Maximum Order Amount":
          "€ ${orderData.getMaxAmount().toStringAsFixed(1)}",
      "Minimum Order Amount":
          "€ ${orderData.getMinAmount().toStringAsFixed(2)}",
      "Month with Highest Orders": orderData.computeExpensiveMonth(),
    };

    return SliverMargin(
      margin: context.layout.breakpoint == LayoutBreakpoint.xs
          ? EdgeInsets.symmetric(horizontal: CustomTheme.spacePadding)
          : EdgeInsets.symmetric(horizontal: CustomTheme.mediumPadding),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.layout.value(
            xs: 1,
            sm: 1,
            md: 1,
            lg: 2,
            xl: 2,
          ),
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: 1.5,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return TileWidget(
              textDescription: tiles.entries.elementAt(index).key,
              textValue: tiles.entries.elementAt(index).value,
            );
          },
          childCount: tiles.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double spacing =
        BreakpointValue(xs: CustomTheme.smallPadding).resolve(context);
    late var ordersFuture = Provider.of<OrdersViewModel>(context, listen: false)
        .fetchAndSetOrders();
    return FutureBuilder(
        future: ordersFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: AnimatedCircularProgressIndicator(),
            );
          }
          if (dataSnapshot.error != null) {
            // ERROR HANDLING
            return const Center(
              child: Text('An error occured!'),
            );
          } else {
            return Consumer<OrdersViewModel>(
              builder: (context, orderData, child) => CustomScrollView(
                slivers: [
                  const SliverGutter(),
                  SliverMargin(
                      margin: context.layout.breakpoint == LayoutBreakpoint.xs
                          ? EdgeInsets.symmetric(
                              horizontal: CustomTheme.spacePadding)
                          : EdgeInsets.symmetric(
                              horizontal: CustomTheme.mediumPadding),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Orders statistics',
                              style: CustomTheme.headingStyle,
                            ),
                          ],
                        ),
                      )),
                  const SliverGutter(),
                  orderData.items.isNotEmpty
                      ? getTileGrid(spacing, orderData)
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Before seeing the statistics you need an order',
                            style: CustomTheme.bodyStyle,
                            textAlign: TextAlign.left,
                          ),
                        ),
                ],
              ),
            );
          }
        });
  }
}
