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

  Widget _backButton(BuildContext content) {
    final content = context.read<ContentViewModel>();
    return context.layout.breakpoint < LayoutBreakpoint.md
        ? ElevatedButton(
            style: CustomTheme.buttonStyleOutline,
            onPressed: () {
              content.updateMainContentIndex(Plp.pageIndex);
            },
            child: const Icon(Icons.close),
          )
        : const Spacer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _backButton(context),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Text('filters'),
        ),
      ],
    );
  }
}
