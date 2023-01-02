import 'package:flutter/cupertino.dart';

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
    return Container(
      color: CustomTheme.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Status: ${request.status}',
            style: CustomTheme.bodyStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${request.id}', style: CustomTheme.bodyStyle),
              Text('${request.message}', style: CustomTheme.bodyStyle),
            ],
          ),
          Text(
            'Product: ${request.products}',
            style: CustomTheme.bodyStyle,
          )
        ],
      ),
    );
  }
}
