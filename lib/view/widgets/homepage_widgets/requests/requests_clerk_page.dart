import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/request_view_models/request_list_view_model.dart';
import '../../../../view_models/request_view_models/request_view_model.dart';
import '../../../../view_models/user_view_models/user_view_model.dart';

import '../../common/custom_theme.dart';
import '../../sidebar_widgets/profile_side/user_input_widget.dart';
import 'request_entry.dart';
import 'user_info.dart';
import '../screen_builder.dart';

class RequestsClerkPage extends StatefulWidget {
  const RequestsClerkPage({super.key});

  @override
  State<RequestsClerkPage> createState() => _RequestsClerkPageState();
}

class _RequestsClerkPageState extends State<RequestsClerkPage> {
  bool checkAssignedClerk = false;

  @override
  Widget build(BuildContext context) {
    final double spacing =
        BreakpointValue(xs: CustomTheme.smallPadding).resolve(context);

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
        bool hideDetails = screenWidth < 715;
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: topPadding,
              ),
            ),
            SliverMargin(
                margin: context.layout.breakpoint == LayoutBreakpoint.xs
                    ? EdgeInsets.symmetric(horizontal: CustomTheme.spacePadding)
                    : EdgeInsets.symmetric(
                        horizontal: CustomTheme.mediumPadding),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Outstanding requests',
                        style: CustomTheme.headingStyle,
                      ),
                    ],
                  ),
                )),
            const SliverGutter(),
            if (requestsData.requests.isNotEmpty)
              for (var group
                  in groupByUser(requestsData.outstandingRequests).entries)
                ...getUserGroup(group, spacing, hideDetails)
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
            SliverToBoxAdapter(
              child: SizedBox(
                height: bottomPadding,
              ),
            ),
          ],
        );
      }),
    );
  }

  List<SliverMargin> getUserGroup(
      MapEntry<UserViewModel, List<RequestViewModel>> group,
      spacing,
      bool hideDetails) {
    return [
      SliverMargin(
        margin: context.layout.breakpoint == LayoutBreakpoint.xs
            ? EdgeInsets.symmetric(horizontal: CustomTheme.spacePadding)
            : EdgeInsets.symmetric(horizontal: CustomTheme.mediumPadding),
        sliver: SliverToBoxAdapter(
          child: UserInfo(
            group: group,
          ),
        ),
      ),
      SliverMargin(
        margin: context.layout.breakpoint == LayoutBreakpoint.xs
            ? EdgeInsets.all(CustomTheme.spacePadding)
            : EdgeInsets.only(
                top: CustomTheme.mediumPadding,
                right: CustomTheme.mediumPadding,
                left: CustomTheme.mediumPadding),
        sliver: SliverToBoxAdapter(
          child: RequestHeadingEntry(hideDetails: hideDetails),
        ),
      ),
      getRequestLineItems(group.value, hideDetails),
      SliverMargin(
        margin: context.layout.breakpoint == LayoutBreakpoint.xs
            ? EdgeInsets.all(CustomTheme.spacePadding)
            : EdgeInsets.all(CustomTheme.mediumPadding),
        sliver: const SliverToBoxAdapter(
          child: Gutter(),
        ),
      ),
    ];
  }

  SliverMargin getRequestLineItems(requestsListData, bool hideDetails) {
    return SliverMargin(
      margin: context.layout.breakpoint == LayoutBreakpoint.xs
          ? EdgeInsets.symmetric(horizontal: CustomTheme.spacePadding)
          : EdgeInsets.symmetric(horizontal: CustomTheme.mediumPadding),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            RequestViewModel request = requestsListData[index];
            checkAssignedClerk = request.clerk != null ? true : false;
            return RequestEntry(
              request: request,
              hideDetails: hideDetails,
              checkAssignedClerk: checkAssignedClerk,
              onChanged: (bool value) {
                setState(() {
                  checkAssignedClerk = value;
                });

                request.assignClerk(
                  checkAssignedClerk
                      ? Provider.of<UserViewModel>(context, listen: false)
                      : null,
                );
                Provider.of<RequestListViewModel>(context, listen: false)
                    .updateAssignedRequests();
              },
            );
          },
          childCount: requestsListData.length,
        ),
      ),
    );
  }

  // helper function to group the items by user
  Map<UserViewModel, List<RequestViewModel>> groupByUser(
      List<RequestViewModel> items) {
    var groups = <UserViewModel, List<RequestViewModel>>{};
    for (var item in items) {
      UserViewModel user = UserViewModel.fromExistingUser(item.user);

      if (!groups.containsKey(user)) {
        groups[user] = [item];
      } else {
        groups[user]?.add(item);
      }
    }
    return groups;
  }
}
