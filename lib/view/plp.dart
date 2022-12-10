import 'package:flutter/material.dart';
import 'package:dima2022/view/lineitem.dart';

class Plp extends StatefulWidget {
  const Plp({super.key});

  @override
  State<Plp> createState() => _PlpState();
}

class _PlpState extends State<Plp> {

  @override
  Widget build(BuildContext context) {
    return const LineItem(sku: 1, size: 48, isAddable: true); ///@TODO: get real list
  }
}