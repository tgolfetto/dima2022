import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:layout/layout.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/order_view_models/order_view_model.dart';
import '../../../../view_models/order_view_models/orders_view_model.dart';

import '../../common/custom_theme.dart';
import '../../common/animated_circular_progress_indicator.dart';
import 'order_item.dart';
import '../../sidebar_widgets/profile_side/user_input_widget.dart';
import '../screen_builder.dart';
import 'orders_stat_grid.dart';

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
            return const Center(
              child: Text('An error occured!'),
            );
          } else {
            return Consumer<OrdersViewModel>(
              builder: (context, orderData, child) => ScreenBuilder(builder: (
                BuildContext context,
                BoxConstraints constraints,
                double topPadding,
                double bottomPadding,
                bool isKeyboardActive,
                double screenWidth,
                double screenHeight,
              ) {
                return CustomScrollView(
                  key: const Key('orderMain'),
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: topPadding,
                      ),
                    ),
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
                                'Orders',
                                style: CustomTheme.headingStyle,
                              ),
                            ],
                          ),
                        )),
                    const SliverGutter(),
                    orderData.items.isNotEmpty
                        ? context.layout.breakpoint >= LayoutBreakpoint.md
                            ? const SliverToBoxAdapter()
                            : OrderStatGrid(
                                spacing: spacing,
                                orderData: orderData,
                                crossAxisCount: context.layout.value(
                                  xs: 2,
                                  sm: 3,
                                  md: 2,
                                  lg: 4,
                                  xl: 4,
                                ),
                              )
                        : SliverToBoxAdapter(
                            child: Column(
                              children: [
                                CardHeader(
                                  formKey: GlobalKey(),
                                  pageController: PageController(),
                                  topPadding: topPadding,
                                  nextButton: false,
                                  textTitle: 'You do not have any orders yet.',
                                  textSubtitle:
                                      'You currently have no orders. Check out our store to start making purchases!',
                                  backButton: false,
                                ),
                                Lottie.asset('assets/animated/no_orders.json'),
                              ],
                            ),
                          ),
                    for (var group in groupByMonth(orderData.items).entries)
                      ...getGroup(group, spacing, orderData),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: bottomPadding,
                      ),
                    ),
                  ],
                );
              }),
            );
          }
        });
  }

  List<Widget> getGroup(group, spacing, OrdersViewModel orderData) {
    return [
      SliverMargin(
        margin: context.layout.breakpoint == LayoutBreakpoint.xs
            ? EdgeInsets.symmetric(horizontal: CustomTheme.spacePadding)
            : EdgeInsets.symmetric(horizontal: CustomTheme.mediumPadding),
        sliver: SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: CustomTheme.smallPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      group.key,
                      style: CustomTheme.headingStyle,
                    ),
                    Text(
                      '€ ${orderData.getOrdersPerMonthData().entries.firstWhere((element) => element.key == group.key).value.toStringAsFixed(2)}',
                      style: CustomTheme.bodyStyle,
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
      SliverMargin(
        margin: context.layout.breakpoint == LayoutBreakpoint.xs
            ? EdgeInsets.symmetric(horizontal: CustomTheme.spacePadding)
            : EdgeInsets.symmetric(horizontal: CustomTheme.mediumPadding),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => OrderItemWidget(
              group.value[index],
            ),
            childCount: group.value.length,
          ),
        ),
      ),
      SliverMargin(
        margin: context.layout.breakpoint == LayoutBreakpoint.xs
            ? EdgeInsets.symmetric(horizontal: CustomTheme.spacePadding)
            : EdgeInsets.symmetric(horizontal: CustomTheme.mediumPadding),
        sliver: SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: CustomTheme.smallPadding),
            child: const Gutter(),
          ),
        ),
      ),
    ];
  }

// helper function to group the items by month
  Map<String, List<OrderViewModel>> groupByMonth(List<OrderViewModel> items) {
    var groups = <String, List<OrderViewModel>>{};
    for (var item in items) {
      var month = DateFormat.MMMM().format(item.dateTime);
      if (!groups.containsKey(month)) {
        groups[month] = [item];
      } else {
        groups[month]?.add(item);
      }
    }
    return groups;
  }
}
