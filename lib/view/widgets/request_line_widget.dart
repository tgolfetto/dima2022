import 'package:dima2022/models/request/request_status.dart';
import 'package:dima2022/view_models/user_view_models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../view_models/request_view_models/request_view_model.dart';
import '../custom_theme.dart';

class RequestLineItem extends StatefulWidget {
  final RequestViewModel requestViewModel;

  const RequestLineItem({super.key, required this.requestViewModel});

  @override
  State<RequestLineItem> createState() => _RequestLineItemState();
}

class _RequestLineItemState extends State<RequestLineItem> {
  bool checkAssignedClerk = false;
  bool checkCompletedTask = false;

  @override
  Widget build(BuildContext context) {
    RequestViewModel request = widget.requestViewModel;
    bool isClerk = Provider.of<UserViewModel>(context, listen: false).isClerk;
    checkAssignedClerk = request.clerk != null ? true : false;
    checkCompletedTask =
        request.status == RequestStatus.completed ? true : false;
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
                  ),
                  isClerk
                      ? Row(
                          children: [
                            Checkbox(
                                value: checkAssignedClerk,
                                onChanged: (bool? value) {
                                  setState(() {
                                    checkAssignedClerk = value!;
                                  });

                                  request.assignClerk(
                                    checkAssignedClerk
                                        ? Provider.of<UserViewModel>(context,
                                            listen: false)
                                        : null,
                                  );
                                }),
                            Text('Assign me'),
                          ],
                        )
                      : Row(
                          children: [
                            Checkbox(
                                value: checkCompletedTask,
                                onChanged: (bool? value) {
                                  if (request.status ==
                                      RequestStatus.accepted) {
                                    setState(() {
                                      checkCompletedTask = value!;
                                    });
                                    if (checkCompletedTask)
                                      request.updateStatus(
                                          RequestStatus.completed);
                                  }
                                }),
                            Text('Request completed'),
                          ],
                        ),
                ],
              )),
        ));
  }
}
