import 'package:flutter/material.dart';
import 'package:layout/layout.dart';

import '../../../../utils/size_config.dart';
import '../../../../view_models/request_view_models/request_view_model.dart';
import '../../../../view_models/user_view_models/user_view_model.dart';
import '../../common/custom_theme.dart';
import '../../ui_widgets/appbar_widget/user_avatar.dart';
import '../../ui_widgets/glass_rounded_container.dart';

class UserInfo extends StatelessWidget {
  final MapEntry<UserViewModel, List<RequestViewModel>> group;
  final EdgeInsets itemPadding;
  final double radius;
  final double opacity;
  final bool enableBorder;
  final bool enableShadow;

  const UserInfo({
    Key? key,
    required this.group,
    this.itemPadding = const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    this.radius = 20.0,
    this.opacity = 0.8,
    this.enableBorder = false,
    this.enableShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassRoundedContainer(
      margin: const EdgeInsets.all(0),
      itemPadding: itemPadding,
      radius: BorderRadius.circular(radius),
      opacity: opacity,
      enableBorder: enableBorder,
      enableShadow: enableShadow,
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
                context.layout.breakpoint == LayoutBreakpoint.xs
                    ? '#${group.value.length}'
                    : '#Requests: ${group.value.length}',
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
                    group.key.email,
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
          ],
        ),
      ),
    );
  }
}
