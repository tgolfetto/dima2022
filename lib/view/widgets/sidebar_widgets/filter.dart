import 'package:dima2022/models/product/product_type.dart';
import 'package:dima2022/utils/size_config.dart';
import 'package:dima2022/view/widgets/homepage_widgets/category_tag.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../models/product/category.dart';
import '../../../view_models/content_view_models/content_view_model.dart';
import '../../custom_theme.dart';
import '../homepage_widgets/plp.dart';

class Filter extends StatefulWidget {
  static const int pageIndex = 6;

  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  bool favoriteFilter = false;
  double priceMin = 0;
  double priceMax = 10000;
  List<ItemCategory> selectedCategories = [];
  List<ProductType> selectedProductTypes = [];
  int rating = 0;

  Widget _backButton(BuildContext content) {
    final content = context.read<ContentViewModel>();
    return context.layout.breakpoint < LayoutBreakpoint.md
        ? ElevatedButton(
            style: CustomTheme.buttonStyleIcon,
            onPressed: () {
              content.updateMainContentIndex(Plp.pageIndex);
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.close),
                  Text('Close', style: CustomTheme.bodyStyle)
                ]),
          )
        : const Spacer();
  }

  void updateFilters() {
    Map<String, dynamic> filters = {
      'favorite': favoriteFilter,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'categories': selectedCategories,
      'productTypes': selectedProductTypes,
      'rating': rating,
    };
    Provider.of<ContentViewModel>(context, listen: false).setFilters(filters);
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return CustomTheme.secondaryColor;
      }
      return CustomTheme.primaryColor;
    }

    Map<String, dynamic> filters = Provider.of<ContentViewModel>(context, listen: false).filters;

    return SingleChildScrollView(
      child: Consumer<ContentViewModel>(
        builder: (context, content, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              alignment: Alignment.centerLeft, child: _backButton(context)),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: CustomTheme.smallPadding,
                horizontal: CustomTheme.mediumPadding),
            child: Text(
              'Filters:',
              style: CustomTheme.headingStyle,
            ),
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: CustomTheme.smallPadding,
                    horizontal: CustomTheme.mediumPadding),
                child: Text('Favorite items ', style: CustomTheme.bodyStyle),
              ),
              Checkbox(
                checkColor: CustomTheme.backgroundColor,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: filters['favorite'] ?? favoriteFilter,
                onChanged: (bool? value) {
                  setState(() {
                    favoriteFilter = value!;
                  });
                  updateFilters();
                },
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: CustomTheme.smallPadding,
                horizontal: CustomTheme.mediumPadding),
            child: Text('Price', style: CustomTheme.bodyStyle),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: CustomTheme.smallPadding,
                horizontal: CustomTheme.mediumPadding),
            child: RangeSlider(
              values: RangeValues(filters['priceMin'] ?? priceMin, filters['priceMax'] ?? priceMax),
              min: 0,
              max: 10000,
              divisions: 1000,
              labels: RangeLabels('\$${filters['priceMin'] ?? priceMin}', '\$${filters['priceMax'] ?? priceMax}'),
              onChanged: (RangeValues values) {
                setState(() {
                  priceMin = values.start;
                  priceMax = values.end;
                });
                updateFilters();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: CustomTheme.smallPadding,
                horizontal: CustomTheme.mediumPadding),
            child: Text('Categories', style: CustomTheme.bodyStyle),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: CustomTheme.smallPadding,
                horizontal: CustomTheme.mediumPadding),
            child: SingleChildScrollView(
              child: SizedBox(
                height: getProportionateScreenHeight(80),
                child: ListView(
                  children: [
                    for (var option in ItemCategory.values)
                      // ItemCategoryTag(category: option)
                      CheckboxListTile(
                        title: Text(option.toString().split('.').last),
                        value: filters['categories'] != null? filters['categories'].contains(option) : selectedCategories.contains(option),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value!) {
                              selectedCategories.add(option);
                            } else {
                              selectedCategories.remove(option);
                            }
                          });
                          updateFilters();
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: CustomTheme.smallPadding,
                horizontal: CustomTheme.mediumPadding),
            child: Text('Product Types', style: CustomTheme.bodyStyle),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: CustomTheme.smallPadding,
                horizontal: CustomTheme.mediumPadding),
            child: SingleChildScrollView(
              child: SizedBox(
                height: getProportionateScreenHeight(100),
                child: ListView(
                  children: [
                    for (var option in ProductType.values)
                      CheckboxListTile(
                        title: Text(option.toString().split('.')[1]),
                        value: filters['productTypes'] != null? filters['productTypes'].contains(option) : selectedProductTypes.contains(option),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value!) {
                              selectedProductTypes.add(option);
                            } else {
                              selectedProductTypes.remove(option);
                            }
                          });
                          updateFilters();
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: CustomTheme.smallPadding,
                horizontal: CustomTheme.mediumPadding),
            child: Text('Rating', style: CustomTheme.bodyStyle),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: CustomTheme.smallPadding,
                horizontal: CustomTheme.mediumPadding),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              value: filters['rating'] != null? int.parse('${filters['rating']}') : rating,
              items: const [
                DropdownMenuItem(
                  value: 0,
                  child: Text('All'),
                ),
                DropdownMenuItem(
                  value: 4,
                  child: Text('4+'),
                ),
                DropdownMenuItem(
                  value: 3,
                  child: Text('3+'),
                ),
                DropdownMenuItem(
                  value: 2,
                  child: Text('2+'),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: Text('1+'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  rating = value!;
                });
                updateFilters();
              },
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(
          //       vertical: CustomTheme.smallPadding,
          //       horizontal: CustomTheme.mediumPadding),
          //   child: ElevatedButton(
          //     child: Text('Apply Filters'),
          //     onPressed: () {},
          //   ),
          // ),
        ],
      )),
    );
  }
}
