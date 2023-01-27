import 'package:flutter/material.dart';

import '../../../../view_models/request_view_models/request_view_model.dart';
import '../../common/custom_theme.dart';
import 'request_tag.dart';

class RequestHeadingEntry extends StatelessWidget {
  final bool hideDetails;

  const RequestHeadingEntry({
    Key? key,
    required this.hideDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: CustomTheme.mediumPadding,
          vertical: CustomTheme.spacePadding),
      child: Row(
        children: [
          Flexible(
            flex: hideDetails ? 4 : 5,
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
          Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [Text('Manage')],
            ),
          ),
        ],
      ),
    );
  }
}

class RequestEntry extends StatefulWidget {
  final RequestViewModel request;
  final bool hideDetails;
  final bool checkAssignedClerk;
  final Function(bool)? onChanged;

  const RequestEntry({
    Key? key,
    required this.request,
    required this.hideDetails,
    required this.checkAssignedClerk,
    this.onChanged,
  }) : super(key: key);

  @override
  State<RequestEntry> createState() => _RequestEntryState();
}

class _RequestEntryState extends State<RequestEntry> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: CustomTheme.mediumPadding,
          vertical: CustomTheme.spacePadding),
      child: Row(
        children: [
          Flexible(
            flex: widget.hideDetails ? 4 : 5,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: RequestTag(
                      status: widget.request.status,
                      hideDetails: widget.hideDetails),
                ),
                Expanded(
                  flex: 2,
                  child: Text(widget.request.products.first.title!),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                      widget.request.products.first.sizes!.first.toString()),
                ),
                if (!widget.hideDetails)
                  Expanded(
                    flex: 1,
                    child: Text(widget.request.message),
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
                    value: widget.checkAssignedClerk,
                    onChanged: widget.onChanged,
                    activeColor: CustomTheme.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
