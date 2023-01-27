import 'package:flutter/material.dart';
import '../../../../models/product/product_type.dart';
import '../../common/tag.dart';

class ProductTypeTag extends Tag {
  ProductTypeTag({
    required ProductType type,
    bool hideDetails = false,
    Key? key,
    ValueChanged<bool>? onChanged,
    double? fontSize,
    required bool value,
  }) : super(
          key: key,
          text: type.name[0].toUpperCase() + type.name.substring(1),
          hideDetails: hideDetails,
          upperCase: false,
          onChanged: onChanged,
          fontSize: fontSize,
          isChecked: value,
        );
}
