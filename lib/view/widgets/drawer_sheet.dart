import 'package:flutter/material.dart';

class DrawerSheet extends StatefulWidget {
  const DrawerSheet({Key? key}) : super(key: key);
  @override
  _DrawerSheetState createState() => _DrawerSheetState();
}

class _DrawerSheetState extends State<DrawerSheet> {
  Map<String, bool?> checkboxes = {};

  @override
  Widget build(BuildContext context) {
    //return AnimatedResize(
    //  child:
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
            child: Text('Filters'),
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
