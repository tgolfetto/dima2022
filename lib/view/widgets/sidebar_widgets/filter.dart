import 'package:flutter/material.dart';
import 'package:layout/layout.dart';
import 'package:provider/provider.dart';

import '../../../view_models/content_view_model.dart';
import '../../custom_theme.dart';
import '../homepage_widgets/plp.dart';

class Filter extends StatefulWidget {
  static const int pageIndex = 6;

  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  bool favoriteFilter =  false;

  Widget _backButton(BuildContext content) {
    final content = context.read<ContentViewModel>();
    return context.layout.breakpoint < LayoutBreakpoint.md
        ? ElevatedButton(
            style: CustomTheme.buttonStyleIcon,
            onPressed: () {
              content.updateMainContentIndex(Plp.pageIndex);
            },
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.close),
                  Text('Close', style: CustomTheme.bodyStyle)
                ]),
          )
        : const Spacer();
  }

  @override
  Widget build(BuildContext context) {
    favoriteFilter = Provider.of<ContentViewModel>(context, listen: false).filterFavorites;
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return CustomTheme.secondaryColor;
      }
      return CustomTheme.primaryColor;
    }

    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(alignment: Alignment.centerLeft, child: _backButton(context)),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: CustomTheme.smallPadding,
              horizontal: CustomTheme.mediumPadding),
          child: Text(
            'Filters:',
            style: CustomTheme.headingStyle,
          ),
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: CustomTheme.smallPadding,
                  horizontal: CustomTheme.mediumPadding),
              child: Text('Favorite items ', style: CustomTheme.bodyStyle),
            ),
            Checkbox(
              checkColor: CustomTheme.backgroundColor,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: favoriteFilter,
              onChanged: (bool? value) {
                setState(() {
                  favoriteFilter = value!;
                  Provider.of<ContentViewModel>(context, listen: false).toggleFilterFavorites();
                });
              },
            )
          ],
        )
      ],
    ));
  }
}
