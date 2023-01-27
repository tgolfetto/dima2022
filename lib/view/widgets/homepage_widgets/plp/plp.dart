import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/content_view_models/content_view_model.dart';
import '../../../../view_models/product_view_models/products_view_model.dart';

import '../../common/custom_theme.dart';
import 'product_line_item.dart';
import '../../sidebar_widgets/filter.dart';
import '../screen_builder.dart';

class Plp extends StatefulWidget {
  static const routeName = '/plp';
  static const pageIndex = 0;

  const Plp({super.key});

  @override
  State<Plp> createState() => _PlpState();
}

class _PlpState extends State<Plp> {
  late Map<String, dynamic> filters;
  late ValueNotifier<bool> loadingNotifier;

  @override
  void initState() {
    super.initState();

    if (!context.read<ProductListViewModel>().isLoaded) {
      loadingNotifier = ValueNotifier<bool>(true);
    } else {
      loadingNotifier = ValueNotifier<bool>(false);
    }
  }

  @override
  void didChangeDependencies() {
    if (!context.read<ProductListViewModel>().isLoaded) {
      loadingNotifier.value = true;
      Provider.of<ProductListViewModel>(context, listen: false)
          .fetchAndSetProducts()
          .then((_) {
        loadingNotifier.value = false;
        context.read<ProductListViewModel>().isLoaded = true;
      });
    }

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
    final products = Provider.of<ProductListViewModel>(context,
        listen: false); //context.read<ProductListViewModel>();

    final double spacing =
        BreakpointValue(xs: CustomTheme.smallPadding).resolve(context);

    return ScreenBuilder(builder: (
      BuildContext context,
      BoxConstraints constraints,
      double topPadding,
      double bottomPadding,
      bool isKeyboardActive,
      double screenWidth,
      double screenHeight,
    ) {
      return Scrollbar(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: topPadding,
              ),
            ),
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
              ),
            ),
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
                          .map((p) => ProductLineItem(productViewModel: p))
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
                        childAspectRatio: context.layout.breakpoint ==
                                    LayoutBreakpoint.sm ||
                                context.layout.breakpoint == LayoutBreakpoint.md
                            ? 0.54
                            : 0.5,
                      ),
                    );
                  }
                },
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: bottomPadding,
              ),
            ),
          ],
        ),
      );
    });
  }
}
