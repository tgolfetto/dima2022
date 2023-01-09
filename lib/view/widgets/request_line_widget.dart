import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

import '../../view_models/request_view_models/request_view_model.dart';
import '../custom_theme.dart';

class RequestLineItem extends StatefulWidget {
  final RequestViewModel requestViewModel;

  const RequestLineItem({super.key, required this.requestViewModel});

  @override
  State<RequestLineItem> createState() => _RequestLineItemState();
}

class _RequestLineItemState extends State<RequestLineItem> {
  @override
  Widget build(BuildContext context) {
    RequestViewModel request = widget.requestViewModel;
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
                    'Product: ${request.products[0].title} - Size: ${request.products[0].sizes}',
                    style: CustomTheme.bodySecondStyle,
                  )
                ],
              )),
        ));
  }
}
