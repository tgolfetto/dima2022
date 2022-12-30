import 'package:dima2022/utils/size_config.dart';
import 'package:dima2022/view/custom_theme.dart';
import 'package:dima2022/view/grid_delegate.dart';
import 'package:flutter/material.dart';
import 'package:dima2022/view/widgets/product_line_item.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../models/product/products.dart';
import '../../../view_models/content_view_model.dart';
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

  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    //Provider.of<Products>(context).fetchAndSetProducts(); /THIS WON'T WORK HERE --> WE HAVE TO MOVE IT IN didChangeDependencies
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<ProductListViewModel>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
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
    List<Widget> items = [];
    if(_isLoading){
      items.add(const Text('Loading products...'))
    }else {
      final products = context.read<ProductListViewModel>();
      for (ProductViewModel p in products.items) {
        items.add(LineItem(
          id: p.id!,
          title: p.title!,
          description: p.description!,
          price: p.price!,
          sizes: p.sizes!,
          imageUrl: p.imageUrl!,
        ));
      }
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
                      _filterButton(context)
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
  }
}
