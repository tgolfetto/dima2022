import 'package:flutter/material.dart';

import 'package:layout/layout.dart';

import '../../../../view_models/order_view_models/orders_view_model.dart';
import '../../common/custom_theme.dart';
import 'tile_widget.dart';

class OrderStatGrid extends StatelessWidget {
  const OrderStatGrid({
    Key? key,
    required this.spacing,
    required this.orderData,
    required this.crossAxisCount,
  }) : super(key: key);

  final double spacing;
  final OrdersViewModel orderData;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
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
          crossAxisCount: crossAxisCount,
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
}
