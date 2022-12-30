import 'package:dima2022/view_models/content_view_model.dart';
import 'package:layout/layout.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../custom_theme.dart';
import 'sidebar_widgets/pdp.dart';

class LineItem extends StatefulWidget {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  final List<int> sizes;
  bool isFavorite = false;

  LineItem(
      {super.key,
      required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      required this.sizes});

  @override
  State<LineItem> createState() => _LineItemState();
}

class _LineItemState extends State<LineItem> {
  int dropdownValue = 0;
  int productId = 0;

  Widget get _addToCartButton {
    return ElevatedButton(
      style: CustomTheme.buttonStyleIcon,
      onPressed: () => {
        /// TODO: add to cart
      },
      child: const Icon(Icons.add_shopping_cart),
    );
  }

  ElevatedButton get _addToFavoriteButton {
    return ElevatedButton(
      style: CustomTheme.buttonStyleIcon,
      onPressed: () => {
        /// TODO: add to fav
        setState(() {
          widget.isFavorite = !widget.isFavorite;
        })
      },
      child: widget.isFavorite
          ? const Icon(Icons.favorite)
          : const Icon(Icons.favorite_border),
    );
  }


  @override
  Widget build(BuildContext context) {
    final content = context.read<ContentViewModel>();
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(children: [
            GestureDetector(
              onTap: () {
                content.updateProductId(widget.id);
                if(context.layout.breakpoint < LayoutBreakpoint.lg){
                  content.updateMainContentIndex(Pdp.pageIndex);
                }else{
                  content.updateSideBarIndex(Pdp.pageIndex);
                }
              },
              child: Image.asset(widget.imageUrl),
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              child: _addToFavoriteButton,
            )
          ]),
          Text(
            widget.title,
            style: CustomTheme.headingStyle,
          ),
          Text('EUR ${widget.price}', style: CustomTheme.bodyStyle),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Size:', style: CustomTheme.bodyStyle),
              DropdownButton<int>(
                value: dropdownValue == 0 ? widget.sizes[0] : dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 1,
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (int? value) {
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: widget.sizes.map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("$value"),
                  );
                }).toList(),
              ),
              _addToCartButton,
            ],
          )
        ],
      ),

    );
  }
}
