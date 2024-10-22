import 'package:flutter/material.dart';

import '../../../../models/product/category.dart';
import '../../../../utils/size_config.dart';

class CategoryGrid extends StatefulWidget {
  final List<ItemCategory> selectedCategories;
  const CategoryGrid({super.key, required this.selectedCategories});

  @override
  CategoryGridState createState() {
    return CategoryGridState();
  }
}

class CategoryGridState extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: ItemCategory.values.map((category) {
        return Container(
          decoration: widget.selectedCategories.contains(category)
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff3e9f96),
                      Color.fromARGB(255, 13, 122, 113),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(1, 4),
                      blurRadius: 4,
                    ),
                  ],
                )
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: const LinearGradient(
                    colors: [
                      Colors.white,
                      Color.fromARGB(255, 237, 237, 237),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(1, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
          margin: const EdgeInsets.all(6),
          padding: EdgeInsets.all(getProportionateScreenWidth(6)),
          child: InkWell(
            onTap: () {
              setState(() {
                !widget.selectedCategories.contains(category)
                    ? widget.selectedCategories.add(category)
                    : widget.selectedCategories.remove(category); // = category;
              });
            },
            child: Center(
              child: Text(
                category.toString().split('.')[1],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: widget.selectedCategories.contains(category)
                      ? Colors.white
                      : const Color.fromARGB(115, 39, 39, 39),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
