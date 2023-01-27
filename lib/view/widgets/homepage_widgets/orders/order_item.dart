import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import '../../../../view_models/order_view_models/order_view_model.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderViewModel orderViewModel;

  const OrderItemWidget(this.orderViewModel, {super.key});

  @override
  OrderItemWidgetState createState() => OrderItemWidgetState();
}

class OrderItemWidgetState extends State<OrderItemWidget> {
  @override
  Widget build(BuildContext context) {
    var order = widget.orderViewModel;
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ExpansionTile(
            textColor: Colors.teal,
            iconColor: const Color.fromARGB(255, 0, 132, 118),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: ${order.id}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Total: € ${order.amount}',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 4,
                ),
                child: SizedBox(
                  height: order.products.length * 56.0 + 10,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: order.products
                        .map((prod) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Text(
                                      prod.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Text(
                                      '${prod.quantity}x €${prod.price}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
