import 'package:flutter/material.dart';
import '../../common/tag.dart';

import '../../../../models/request/request_status.dart';

class RequestTag extends Tag {
  RequestTag({
    Key? key,
    required RequestStatus status,
    bool hideDetails = false,
  }) : super(
          key: key,
          backgroundColor: _getBackgroundColor(status),
          gradientBackgroundColor: _getGradientBackgroundColor(status),
          icon: _getIcon(status),
          text: status.name[0].toUpperCase() + status.name.substring(1),
          hideDetails: hideDetails,
          isChecked: false,
        );

  static Color _getBackgroundColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return const Color(0xff9C27B0);
      case RequestStatus.accepted:
        return const Color(0xff3e9f96);
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.completed:
        return const Color(0xff3e9f96);
    }
  }

  static Color _getGradientBackgroundColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return const Color(0xff7B1FA2);
      case RequestStatus.accepted:
        return const Color.fromARGB(255, 13, 122, 113);
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.completed:
        return const Color.fromARGB(255, 13, 122, 113);
    }
  }

  static IconData _getIcon(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Icons.push_pin_outlined;
      case RequestStatus.accepted:
        return Icons.done;
      case RequestStatus.rejected:
        return Icons.draw_outlined;
      case RequestStatus.completed:
        return Icons.draw_outlined;
    }
  }
}
