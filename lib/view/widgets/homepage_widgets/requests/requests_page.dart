import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/request_view_models/request_list_view_model.dart';
import '../../../../view_models/user_view_models/user_view_model.dart';
import '../../common/animated_circular_progress_indicator.dart';
import 'requests_clerk_page.dart';
import 'requests_user_page.dart';

class RequestPage extends StatefulWidget {
  static const routeName = '/requests';
  static const pageIndex = 2;

  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  late Future _requestsFuture;
  late bool isClerk;

  Future _obtainRequestsFuture() {
    isClerk = Provider.of<UserViewModel>(context, listen: false).isClerk;
    return isClerk
        ? Provider.of<RequestListViewModel>(context, listen: false)
            .fetchAllRequests()
        : Provider.of<RequestListViewModel>(context, listen: false)
            .fetchRequests();
  }

  @override
  void initState() {
    _requestsFuture = _obtainRequestsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isClerk = Provider.of<UserViewModel>(context).isClerk;

    return FutureBuilder(
      future: _requestsFuture,
      builder: (ctx, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: AnimatedCircularProgressIndicator(),
          );
        }
        if (dataSnapshot.error != null) {
          return const Center(
            child: Text('An error occured!'),
          );
        } else {
          return isClerk ? const RequestsClerkPage() : const RequestUserPage();
        }
      },
    );
  }
}
