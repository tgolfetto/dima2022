import 'package:dima2022/view/widgets/ui_widgets/appbar_widget/user_avatar.dart';
import 'package:dima2022/view_models/request_view_models/request_view_model.dart';
import 'package:dima2022/view_models/user_view_models/user_view_model.dart';
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
                if (requestsData.requests.isNotEmpty)
                  if (isClerk)
                    for (var group
                        in groupByUser(requestsData.requests).entries)
                      ...getUserGroup(group, spacing, requestsData)
                  else
                    getRequestLineItems(requestsData.requests)
                else
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
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
      },
    );
  }

  List<SliverMargin> getUserGroup(
      MapEntry<UserViewModel, List<RequestViewModel>> group,
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
                  leading: UserAvatar(
                    avatarUrl: group.key.profileImageUrl,
                    onPressed: () {},
                  ),
                  trailing: Text(
                    ' #Requests: ${group.value.length}',
                    style: CustomTheme.bodyStyle,
                  ),
                  title: Text(
                    group.key.name,
                    style: CustomTheme.headingStyle,
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${group.key.email}',
                        style: CustomTheme.bodyStyle,
                      ),
                      const Gutter(),
                      Row(
                        children: [
                          Text(
                            'Size: ${group.key.size}',
                            style: CustomTheme.bodyStyle,
                          ),
                          const Gutter(),
                          Text(
                            'Shoe Size: ${group.key.shoeSizeString}',
                            style: CustomTheme.bodyStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   mainAxisSize: MainAxisSize.max,
                //   children: [
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         UserAvatar(
                //           avatarUrl: group.key.profileImageUrl,
                //           onPressed: () {},
                //         ),
                //         Text(
                //           group.key.name,
                //           style: CustomTheme.headingStyle,
                //         ),
                //       ],
                //     ),
                //     Text(
                //       ' #Requests: ${group.value.length}',
                //       style: CustomTheme.bodyStyle,
                //     ),
                //   ],
                // ),
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
          ),
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
