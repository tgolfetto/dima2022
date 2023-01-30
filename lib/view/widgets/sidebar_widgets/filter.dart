import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../models/product/category.dart';
import '../../../models/product/product_type.dart';
import '../../../utils/size_config.dart';
import '../../../view_models/content_view_models/content_view_model.dart';

import '../common/custom_theme.dart';

import '../homepage_widgets/plp/plp.dart';
import '../homepage_widgets/screen_builder.dart';
import 'pdp_side/category_tag.dart';
import 'pdp_side/product_type_tag.dart';
import 'profile_side/user_input_widget.dart';

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
  num rating = 0;

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

    Map<String, dynamic> filters =
        Provider.of<ContentViewModel>(context).filters;

    return ScreenBuilder(builder: (
      BuildContext context,
      BoxConstraints constraints,
      double topPadding,
      double bottomPadding,
      bool isKeyboardActive,
      double screenWidth,
      double screenHeight,
    ) {
      return SingleChildScrollView(
        child: Consumer<ContentViewModel>(
          builder: (context, content, _) => Margin(
            margin: EdgeInsets.only(
              top: getProportionateScreenHeight(10) +
                  MediaQuery.of(context).padding.top,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0), //.copyWith(top: topPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CardHeader(
                    formKey: GlobalKey(),
                    pageController: PageController(),
                    topPadding: topPadding,
                    nextButton: false,
                    textTitle: 'Filters',
                    textSubtitle: '',
                    backButton: true,
                    backIcon: context.layout.breakpoint < LayoutBreakpoint.md
                        ? Icons.close
                        : null,
                    onPressedBack: () {
                      final content = context.read<ContentViewModel>();
                      content.updateMainContentIndex(Plp.pageIndex);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: CustomTheme.smallPadding,
                                horizontal: CustomTheme.mediumPadding),
                            child: Text('Favorite items ',
                                style: CustomTheme.bodyStyle),
                          )),
                      Expanded(
                          flex: 2,
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Checkbox(
                                checkColor: CustomTheme.backgroundColor,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: filters['favorite'] ?? favoriteFilter,
                                onChanged: (bool? value) {
                                  setState(() {
                                    favoriteFilter = value!;
                                  });
                                  updateFilters();
                                },
                              )))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: CustomTheme.smallPadding,
                                horizontal: CustomTheme.mediumPadding),
                            child: Text('Price', style: CustomTheme.bodyStyle),
                          )),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: CustomTheme.smallPadding,
                              horizontal: CustomTheme.mediumPadding),
                          child: RangeSlider(
                            values: RangeValues(
                                filters['priceMin'] ??
                                    priceMin.round().toDouble(),
                                filters['priceMax'] ??
                                    priceMax.round().toDouble()),
                            min: 0,
                            max: 10000,
                            divisions: 500,
                            activeColor: CustomTheme.secondaryColor,
                            inactiveColor:
                                CustomTheme.secondaryColor.withAlpha(90),
                            labels: RangeLabels(
                                '\$${filters['priceMin'] ?? priceMin}',
                                '\$${filters['priceMax'] ?? priceMax}'),
                            onChanged: (RangeValues values) {
                              setState(() {
                                priceMin = values.start;
                                priceMax = values.end;
                              });
                              updateFilters();
                            },
                          ),
                        ),
                      ),
                    ],
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
                    child: SizedBox(
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 14.0,
                        children: List<Widget>.generate(
                          ItemCategory.values.length,
                          (int index) {
                            var option = ItemCategory.values[index];
                            return ItemCategoryTag(
                              category: option,
                              value: filters['categories'] != null
                                  ? filters['categories'].contains(option)
                                  : selectedCategories.contains(option),
                              fontSize: 14,
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
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  const Gutter(),
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
                    child: SizedBox(
                      child: Wrap(
                        spacing: 10.0,
                        runSpacing: 14.0,
                        children: List<Widget>.generate(
                          ProductType.values.length,
                          (int index) {
                            var option = ProductType.values[index];
                            return ProductTypeTag(
                              type: option,
                              value: filters['productTypes'] != null
                                  ? filters['productTypes'].contains(option)
                                  : selectedProductTypes.contains(option),
                              fontSize: 14,
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
                            );
                          },
                        ).toList(),
                      ),
                    ),
                  ),
                  const Gutter(),
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
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3, color: Colors.greenAccent)),
                      ),
                      value: filters['rating'] != null
                          ? num.parse('${filters['rating']}')
                          : rating,
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
                  SizedBox(
                    height: bottomPadding,
                  )
                ],
              ),

              // context.layout.breakpoint < LayoutBreakpoint.md
              //     ? CloseCustomButtom(
              //         context: context,
              //         content: content,
              //         sizeWidth: screenWidth,
              //         sideHeight: screenHeight,
              //         onPressed: () {
              //           content.updateMainContentIndex(Plp.pageIndex);
              //         },
              //       )
              //     : const SizedBox(),
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //       vertical: CustomTheme.smallPadding,
              //       horizontal: CustomTheme.mediumPadding),
              //   child: Text(
              //     'Filters:',
              //     style: CustomTheme.headingStyle,
              //   ),
              // ),

              // Padding(
              //   padding: EdgeInsets.symmetric(
              //       vertical: CustomTheme.smallPadding,
              //       horizontal: CustomTheme.mediumPadding),
              //   child: ElevatedButton(
              //     child: Text('Apply Filters'),
              //     onPressed: () {},
              //   ),
              // ),
            ),
          ),
        ),
      );
    });
  }
}
