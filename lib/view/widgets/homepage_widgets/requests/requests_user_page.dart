import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../../view_models/request_view_models/request_list_view_model.dart';

import '../../common/custom_theme.dart';
import 'request_line_widget.dart';
import '../../sidebar_widgets/profile_side/user_input_widget.dart';
import '../screen_builder.dart';

class RequestUserPage extends StatefulWidget {
  const RequestUserPage({super.key});

  @override
  State<RequestUserPage> createState() => RequestUserPageState();
}

class RequestUserPageState extends State<RequestUserPage> {
  bool checkAssignedClerk = false;

  @override
  Widget build(BuildContext context) {
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
          key: const Key('requestUserPage'),
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
                        'My Requests',
                        style: CustomTheme.headingStyle,
                      ),
                    ],
                  ),
                )),
            const SliverGutter(),
            if (requestsData.requests.isNotEmpty)
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
}
