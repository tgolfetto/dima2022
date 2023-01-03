import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

import '../../models/request/request.dart';
import '../custom_theme.dart';

class RequestLineItem extends StatefulWidget {
  final Request rq;

  const RequestLineItem({super.key, required this.rq});

  @override
  State<RequestLineItem> createState() => _RequestLineItemState();
}

class _RequestLineItemState extends State<RequestLineItem> {
  @override
  Widget build(BuildContext context) {
    Request request = widget.rq;
    return Margin(
      margin: EdgeInsets.all(CustomTheme.mediumPadding),
      child: Container(
          decoration: BoxDecoration(
            color: CustomTheme.secondaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.all(CustomTheme.smallPadding),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status: ${request.status}',
                style: CustomTheme.bodySecondStyle,
              ),
              Text('ID: ${request.id} - ${request.message}',
                  style: CustomTheme.bodySecondStyle),
              Text(
                'Product: ${request.products[0].title} - Size: ${request
                    .products[0].sizes}',
                style: CustomTheme.bodySecondStyle,
              )
            ],
          )),
    ));
  }
}
