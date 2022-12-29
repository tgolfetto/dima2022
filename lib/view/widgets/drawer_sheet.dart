import 'package:dima2022/view/homepage_screen.dart';
import 'package:dima2022/view_models/content_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrawerSheet extends StatefulWidget {
  int index;
  int productId;

  DrawerSheet({super.key, this.productId = 0, this.index = 0});

  @override
  DrawerSheetState createState() => DrawerSheetState();
}

class DrawerSheetState extends State<DrawerSheet> {
  Map<String, bool?> checkboxes = {};

  @override
  Widget build(BuildContext context) {
    //return AnimatedResize(
    //  child:
    final content = context.read<ContentViewModel>();
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.search), hintText: 'Search'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
            child: Text('${content.sideBarIndex}'),
            ),
          CheckboxListTile(
            title: Text('Brand1'),
            value: checkboxes['New'] ?? false,
            onChanged: (value) => setState(() => checkboxes['New'] = value),
          ),
        ],
      ),
      //),
    );
  }
}
