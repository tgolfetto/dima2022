import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../models/request/request_status.dart';
import '../../../../view_models/request_view_models/request_list_view_model.dart';
import '../../../../view_models/request_view_models/request_view_model.dart';
import '../../common/custom_theme.dart';
import '../../common/animated_circular_progress_indicator.dart';
import '../../homepage_widgets/screen_builder.dart';
import '../../homepage_widgets/requests/request_line_widget.dart';
import '../../ui_widgets/number_container_box.dart';
import '../profile_side/user_input_widget.dart';

class RequestClerkSide extends StatefulWidget {
  const RequestClerkSide({super.key});

  @override
  State<RequestClerkSide> createState() => _RequestClerkSideState();
}

class _RequestClerkSideState extends State<RequestClerkSide> {
  late Future _requestsFuture;

  Future _obtainRequestsFuture() {
    return Provider.of<RequestListViewModel>(context, listen: false)
        .fetchAllRequests();
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
            builder: (context, requestsData, child) => ScreenBuilder(builder: (
              BuildContext context,
              BoxConstraints constraints,
              double topPadding,
              double bottomPadding,
              bool isKeyboardActive,
              double screenWidth,
              double screenHeight,
            ) {
              return CustomScrollView(
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
                    ),
                  ),
                  const SliverGutter(),
                  if (requestsData.assignedRequests.isNotEmpty)
                    //if (isClerk)
                    for (var group
                        in requestsData.groupByRequestStatus().entries)
                      ...getUserGroup(group, spacing, requestsData)
                  // else
                  //   getRequestLineItems(
                  //       requestsData.getRequestsAssignedTo(userViewModel))
                  else
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CardHeader(
                            formKey: GlobalKey(),
                            pageController: PageController(),
                            topPadding: topPadding,
                            nextButton: false,
                            textTitle: 'You do not have any requests yet.',
                            textSubtitle: 'You currently have no requests.',
                            backButton: false,
                          ),
                          Lottie.asset('assets/animated/no_orders.json'),
                        ],
                      ),
                    ),
                ],
              );
            }),
          );
        }
      },
    );
  }

  List<SliverMargin> getUserGroup(
      MapEntry<RequestStatus, List<RequestViewModel>> group,
      spacing,
      RequestListViewModel requestData) {
    return [
      SliverMargin(
        margin: context.layout.breakpoint == LayoutBreakpoint.xs
            ? EdgeInsets.symmetric(horizontal: CustomTheme.spacePadding)
            : EdgeInsets.symmetric(horizontal: CustomTheme.mediumPadding),
        sliver: SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: CustomTheme.smallPadding),
            child: Column(
              children: [
                ExpansionTile(
                  title: Text(
                    group.key.name[0].toUpperCase() +
                        group.key.name.substring(1),
                    style: CustomTheme.headingStyle,
                  ),
                  trailing: CustomContainer(
                    width: 35,
                    height: 35,
                    text: '${group.value.length}',
                    textSize: 15,
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
      getRequestLineItems(group.value),
    ];
  }

  SliverMargin getRequestLineItems(requestsListData) {
    return SliverMargin(
      margin: context.layout.breakpoint == LayoutBreakpoint.xs
          ? EdgeInsets.symmetric(horizontal: CustomTheme.spacePadding)
          : EdgeInsets.symmetric(horizontal: CustomTheme.mediumPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => RequestLineItem(
            requestViewModel: requestsListData[index],
            height: 110,
          ),
          childCount: requestsListData.length,
        ),
      ),
    );
  }

  // Map<RequestStatus, List<RequestViewModel>> groupByRequestStatus(
  //     List<RequestViewModel> items) {
  //   var groups = <RequestStatus, List<RequestViewModel>>{};
  //   for (var item in items) {
  //     RequestStatus status = item.status;
  //     if (!groups.containsKey(status)) {
  //       groups[status] = [item];
  //     } else {
  //       groups[status]?.add(item);
  //     }
  //   }
  //   return groups;
  // }
}
