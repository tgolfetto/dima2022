// ignore_for_file: sort_child_properties_last

import 'package:dima2022/utils/size_config.dart';
import 'package:dima2022/view/widgets/ui_widgets/appbar_widget/user_avatar.dart';
import 'package:dima2022/view/widgets/ui_widgets/glass_rounded_container.dart';
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
import 'request_tag.dart';

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
  bool checkAssignedClerk = false;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        // Get the screen width and height from the MediaQuery object
        double screenWidth = constraints.maxWidth;

        // Determine if the screen width is lower than a certain threshold
        bool hideDetails = screenWidth < 715;
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
                                isClerk
                                    ? 'Outstanding requests'
                                    : 'My Requests',
                                style: CustomTheme.headingStyle,
                              ),
                            ],
                          ),
                        )),
                    const SliverGutter(),
                    if (requestsData.requests.isNotEmpty)
                      if (isClerk)
                        for (var group
                            in groupByUser(requestsData.outstandingRequests)
                                .entries)
                          ...getUserGroup(group, spacing, hideDetails)
                      else
                        getRequestCard(requestsData.requests)
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
      },
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
          child: GlassRoundedContainer(
            margin: EdgeInsets.all(0),
            itemPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            radius: BorderRadius.circular(20.0),
            opacity: 0.8,
            enableBorder: false,
            enableShadow: true,
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
                      style: CustomTheme.smallBodyStyle,
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
                        SizedBox(height: getProportionateScreenHeight(10)),
                        Row(
                          children: [
                            Text(
                              'Size: ${group.key.size}',
                              style: CustomTheme.smallBodyStyle,
                            ),
                            const Gutter(),
                            Text(
                              'Shoe Size: ${group.key.shoeSizeString}',
                              style: CustomTheme.smallBodyStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //const Divider(),
                ],
              ),
            ),
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
          child: Container(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: CustomTheme.mediumPadding,
                  vertical: CustomTheme.spacePadding),
              child: Row(
                children: [
                  Flexible(
                    flex: 5,
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          const Expanded(
                            flex: 1,
                            child: Text("Status"),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Text("Product"),
                          ),
                          const Expanded(
                            flex: 1,
                            child: Text("Size"),
                          ),
                          if (!hideDetails)
                            const Expanded(
                              flex: 1,
                              child: Text("Message"),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: const [Text('Manage')],
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
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

  SliverMargin getRequestCard(requestsListData) {
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
            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: CustomTheme.mediumPadding,
                      vertical: CustomTheme.spacePadding),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 5,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: RequestTag(
                                  status: request.status,
                                  hideDetails: hideDetails),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(request.products.first.title!),
                            ),
                            Expanded(
                              flex: 1,
                              child:
                                  Text(request.products.first.sizes.toString()),
                            ),
                            if (!hideDetails)
                              Expanded(
                                flex: 1,
                                child: Text(request.message),
                              ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                value: checkAssignedClerk,
                                onChanged: (bool value) {
                                  setState(() {
                                    checkAssignedClerk = value;
                                  });

                                  request.assignClerk(
                                    checkAssignedClerk
                                        ? Provider.of<UserViewModel>(context,
                                            listen: false)
                                        : null,
                                  );
                                },
                                activeColor: CustomTheme.secondaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
