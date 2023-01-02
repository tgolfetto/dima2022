import 'package:dima2022/utils/size_config.dart';
import 'package:dima2022/view/custom_theme.dart';
import 'package:flutter/material.dart';
import 'package:dima2022/view/widgets/product_line_item.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../models/product/product.dart';
import '../../../models/request/request.dart';
import '../../../models/request/request_status.dart';
import '../../../models/user/user.dart';
import '../../../view_models/content_view_model.dart';
import '../../../view_models/product_view_models/product_view_model.dart';
import '../../../view_models/product_view_models/products_view_model.dart';
import '../../../view_models/request_view_models/request_list_view_model.dart';
import '../../../view_models/request_view_models/request_view_model.dart';
import '../request_line_widget.dart';
import '../sidebar_widgets/filter.dart';

class RequestPage extends StatefulWidget {
  static const routeName = '/requests';
  static const pageIndex = 2;

  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    List<RequestViewModel> rqList = Provider.of<RequestListViewModel>(
      context,
      listen: false,
    ).requests;
    List<Widget> items = [];
    for (RequestViewModel rq in rqList) {
      items.add(RequestLineItem(
        rq: rq.request,
      ));
    }
    items.add(RequestLineItem(
        rq: Request(
            id: '1001',
            user: User(email: 'thomas@email.it'),
            clerk: null,
            message: 'Please give me this item',
            products: [
              Product(title: 'Tshirt grigia', sizes: [44, 46])
            ],
            status: RequestStatus.pending)));
    return Container(
      color: CustomTheme.secondaryBackgroundColor,
      child: ListView(
        children: items,
      ),
    );
  }
}
