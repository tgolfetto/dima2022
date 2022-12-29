import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  static const int pageIndex = 6;

  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.search), hintText: 'Search'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Text('xxx'),
        ),
      ],
    );
  }
}
