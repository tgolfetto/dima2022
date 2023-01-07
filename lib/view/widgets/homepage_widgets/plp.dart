import 'package:dima2022/view/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:dima2022/view/widgets/product_line_item.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../view_models/content_view_models/content_view_model.dart';
import '../../../view_models/position_view_models/position_view_model.dart';
import '../../../view_models/product_view_models/product_view_model.dart';
import '../../../view_models/product_view_models/products_view_model.dart';
import '../sidebar_widgets/filter.dart';

class Plp extends StatefulWidget {
  static const routeName = '/plp';
  static const pageIndex = 0;

  const Plp({super.key});

  @override
  State<Plp> createState() => _PlpState();
}

class _PlpState extends State<Plp> {
  var _isInit = true;
  var filters;
  final loadingNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      loadingNotifier.value = true;
      Provider.of<ProductListViewModel>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        loadingNotifier.value = false;
      });
    }
    _isInit = false;
    setState(() {
      filters = Provider.of<ContentViewModel>(context).filters;
    });

    super.didChangeDependencies();
  }

  Widget _filterButton(BuildContext context) {
    final content = context.read<ContentViewModel>();
    return context.layout.breakpoint < LayoutBreakpoint.md
        ? ElevatedButton(
            style: CustomTheme.buttonStyleIcon,
            onPressed: () => {content.updateMainContentIndex(Filter.pageIndex)},
            child: const Icon(Icons.filter_list),
          )
        : const Spacer();
  }

  @override
  Widget build(BuildContext context) {
    bool isFilterActive = filters.isNotEmpty;
    final products = context.read<ProductListViewModel>();

    final double spacing =
        BreakpointValue(xs: CustomTheme.smallPadding).resolve(context);

    return Scrollbar(
      child: CustomScrollView(
        slivers: [
          SliverMargin(
              margin: context.layout.breakpoint == LayoutBreakpoint.xs
                  ? EdgeInsets.symmetric(horizontal: (CustomTheme.spacePadding))
                  : EdgeInsets.symmetric(horizontal: CustomTheme.mediumPadding),
              sliver: SliverToBoxAdapter(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product list',
                        style: CustomTheme.headingStyle,
                      ),
                      _filterButton(context)
                    ]),
              )),
          const SliverGutter(),
          SliverMargin(
            margin: context.layout.breakpoint == LayoutBreakpoint.xs
                ? EdgeInsets.symmetric(horizontal: CustomTheme.spacePadding)
                : EdgeInsets.symmetric(horizontal: CustomTheme.mediumPadding),
            sliver: AnimatedBuilder(
              animation: loadingNotifier,
              builder: (context, child) {
                if (loadingNotifier.value) {
                  // Show the loading indicator
                  return const SliverToBoxAdapter(
                    child: Text('Loading products...'),
                  );
                } else {
                  // Show the list of products
                  final items = isFilterActive
                      ? products.filterByMultipleCriteria(filters)
                      : products.items;
                  return SliverGrid(
                    delegate: SliverChildListDelegate.fixed(items
                        .map((p) => LineItem(productViewModel: p))
                        .toList()),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: context.layout.value(
                        xs: 2,
                        sm: 3,
                        md: 2,
                        lg: 3,
                        xl: 4,
                      ),
                      mainAxisSpacing: spacing * 2,
                      crossAxisSpacing: spacing,
                      childAspectRatio: 0.5,
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
