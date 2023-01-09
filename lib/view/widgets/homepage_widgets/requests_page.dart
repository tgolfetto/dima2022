import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../view_models/request_view_models/request_list_view_model.dart';

import '../../custom_theme.dart';
import '../common/animated_circular_progress_indicator.dart';
import '../request_line_widget.dart';
import '../sidebar_widgets/profile_side/user_input_widget.dart';

class RequestPage extends StatefulWidget {
  static const routeName = '/requests';
  static const pageIndex = 2;

  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  late Future _requestsFuture;

  Future _obtainRequestsFuture() {
    return Provider.of<RequestListViewModel>(context, listen: false)
        .fetchRequests();
  }

  @override
  void initState() {
    _requestsFuture = _obtainRequestsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double spacing =
        BreakpointValue(xs: CustomTheme.smallPadding).resolve(context);

    return FutureBuilder(
        future: _requestsFuture,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: AnimatedCircularProgressIndicator(),
            );
          }
          if (dataSnapshot.error != null) {
            // ERROR HANDLING
            return const Center(
              child: Text('An error occured!'),
            );
          } else {
            return Consumer<RequestListViewModel>(
              builder: (context, requestsData, child) => CustomScrollView(
                slivers: [
                  const SliverGutter(),
                  SliverMargin(
                      margin: context.layout.breakpoint == LayoutBreakpoint.xs
                          ? EdgeInsets.symmetric(
                              horizontal: CustomTheme.spacePadding)
                          : EdgeInsets.symmetric(
                              horizontal: CustomTheme.mediumPadding),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'My Requests',
                              style: CustomTheme.headingStyle,
                            ),
                          ],
                        ),
                      )),
                  const SliverGutter(),
                  requestsData.requests.isNotEmpty
                      ? SliverMargin(
                          margin:
                              context.layout.breakpoint == LayoutBreakpoint.xs
                                  ? EdgeInsets.symmetric(
                                      horizontal: CustomTheme.spacePadding)
                                  : EdgeInsets.symmetric(
                                      horizontal: CustomTheme.mediumPadding),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => RequestLineItem(
                                requestViewModel: requestsData.requests[index],
                              ),
                              childCount: requestsData.requests.length,
                            ),
                          ),
                        )
                      : SliverToBoxAdapter(
                          child: Column(
                            children: [
                              CardHeader(
                                formKey: GlobalKey(),
                                pageController: PageController(),
                                nextButton: false,
                                textTitle: 'You do not have any requests yet.',
                                textSubtitle: 'You currently have no requests.',
                                backButton: false,
                              ),
                              Lottie.asset('../assets/animated/no_orders.json'),
                            ],
                          ),
                        ),
                ],
              ),
            );
          }
        });

    // List<RequestViewModel> rqList = Provider.of<RequestListViewModel>(
    //   context,
    //   listen: false,
    // ).requests;
    // List<Widget> items = [];
    // for (RequestViewModel rq in rqList) {
    //   items.add(RequestLineItem(
    //     rq: rq.request,
    //   ));
    // }
    // items.add(RequestLineItem(
    //     rq: Request(
    //         id: '1001',
    //         user: User(email: 'thomas@email.it'),
    //         clerk: null,
    //         message: 'Please give me this item',
    //         products: [
    //           Product(title: 'Tshirt grigia', sizes: [44, 46])
    //         ],
    //         status: RequestStatus.pending)));
    // return Container(
    //   color: CustomTheme.secondaryBackgroundColor,
    //   child: ListView(
    //     children: items,
    //   ),
    // );
  }
}
