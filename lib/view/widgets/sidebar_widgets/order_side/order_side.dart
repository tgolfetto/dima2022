import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';
import '../../../../view_models/order_view_models/orders_view_model.dart';
import '../../common/animated_circular_progress_indicator.dart';
import '../../common/custom_theme.dart';
import '../../homepage_widgets/orders/orders_stat_grid.dart';

class OrderSide extends StatefulWidget {
  static const pageIndex = 11;

  const OrderSide({super.key});

  @override
  State<OrderSide> createState() => _OrderSideState();
}

class _OrderSideState extends State<OrderSide> {
  late final Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<OrdersViewModel>(context, listen: false)
        .fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double spacing =
        BreakpointValue(xs: CustomTheme.smallPadding).resolve(context);

    return FutureBuilder(
        future: _ordersFuture,
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
                key: const Key('orderSide'),
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
                      ? OrderStatGrid(
                          spacing: spacing,
                          orderData: orderData,
                          crossAxisCount: context.layout.value(
                            xs: 1,
                            sm: 1,
                            md: 1,
                            lg: 2,
                            xl: 2,
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: Container(
                            margin:
                                context.layout.breakpoint == LayoutBreakpoint.xs
                                    ? EdgeInsets.symmetric(
                                        horizontal: CustomTheme.spacePadding)
                                    : EdgeInsets.symmetric(
                                        horizontal: CustomTheme.mediumPadding),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Before seeing the statistics you need an order',
                                style: CustomTheme.bodyStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            );
          }
        });
  }
}
