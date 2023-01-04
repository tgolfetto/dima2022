import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../view_models/order_view_models/orders_view_model.dart';

import '../../custom_theme.dart';
import '../common/animated_circular_progress_indicator.dart';
import '../order_item.dart';

class OrdersPage extends StatefulWidget {
  static const routeName = '/orders';
  static const pageIndex = 3;

  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<OrdersViewModel>(context, listen: false)
        .fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _obtainOrdersFuture();
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     Provider.of<ProductListViewModel>(context, listen: false)
  //         .fetchAndSetProducts()
  //         .then((_) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     });
  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    final double spacing =
        BreakpointValue(xs: CustomTheme.smallPadding).resolve(context);
    return FutureBuilder(
      future: _ordersFuture,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: AnimateCircularProgressIndicator(),
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
                            horizontal: (CustomTheme.spacePadding))
                        : EdgeInsets.symmetric(
                            horizontal: CustomTheme.mediumPadding),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Orders',
                              style: CustomTheme.headingStyle,
                            ),
                          ]),
                    )),
                const SliverGutter(),
                SliverMargin(
                  margin: context.layout.breakpoint == LayoutBreakpoint.xs
                      ? EdgeInsets.symmetric(
                          horizontal: CustomTheme.spacePadding)
                      : EdgeInsets.symmetric(
                          horizontal: CustomTheme.mediumPadding),
                  sliver: SliverGrid(
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
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => OrderItemWidget(
                        orderData.items[index],
                      ),
                      childCount: orderData.items.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
