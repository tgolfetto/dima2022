import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../view_models/order_view_models/order_view_model.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderViewModel orderViewModel;

  const OrderItemWidget(this.orderViewModel, {super.key});

  @override
  _OrderItemWidgetState createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    var order = widget.orderViewModel;
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('€${order.amount}'),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              height: min(order.products.length * 20.0 + 10, 100),
              child: ListView(
                children: order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              prod.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantity}x €${prod.price}',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
