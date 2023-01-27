import 'package:flutter/material.dart';
import '../../../../models/product/category.dart';
import '../../common/tag.dart';

class ItemCategoryTag extends Tag {
  ItemCategoryTag({
    required ItemCategory category,
    bool hideDetails = false,
    Key? key,
    ValueChanged<bool>? onChanged,
    double? fontSize,
    required bool value,
  }) : super(
          key: key,
          //icon: _getIcon(category),
          text: category.name[0].toUpperCase() + category.name.substring(1),
          hideDetails: hideDetails,
          upperCase: false,
          onChanged: onChanged,
          fontSize: fontSize,
          isChecked: value,
        );

  static IconData _getIcon(ItemCategory category) {
    switch (category) {
      case ItemCategory.Men:
        return Icons.person_outline;
      case ItemCategory.Women:
        return Icons.person_outline;
      case ItemCategory.Kids:
        return Icons.child_friendly;
      case ItemCategory.Accessories:
        return Icons.key;
      case ItemCategory.Shoes:
        return Icons.shop;
      case ItemCategory.Outdoors:
        return Icons.nature;
      case ItemCategory.Tops:
        return Icons.short_text;
      case ItemCategory.Bottoms:
        return Icons.call_to_action;
      case ItemCategory.Dresses:
        return Icons.local_florist;
      case ItemCategory.Intimates:
        return Icons.favorite;
      case ItemCategory.Swimwear:
        return Icons.pool;
      case ItemCategory.Outerwear:
        return Icons.ac_unit;
      case ItemCategory.Activewear:
        return Icons.fitness_center;
      case ItemCategory.Loungewear:
        return Icons.weekend;
      case ItemCategory.Suits:
        return Icons.business_center;
      case ItemCategory.Formal:
        return Icons.event_seat;
    }
  }
}
