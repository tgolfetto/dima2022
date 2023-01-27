import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/user_view_models/user_view_model.dart';

import 'chat_side.dart';
import 'request_side_clerk.dart';

class RequestSide extends StatefulWidget {
  static const routeName = '/requests';
  static const pageIndex = 9;

  const RequestSide({super.key});

  @override
  State<RequestSide> createState() => _RequestSideState();
}

class _RequestSideState extends State<RequestSide> {
  late bool isClerk;

  @override
  void initState() {
    isClerk = Provider.of<UserViewModel>(context, listen: false).isClerk;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isClerk ? const RequestClerkSide() : const ChatSide();
  }
}
