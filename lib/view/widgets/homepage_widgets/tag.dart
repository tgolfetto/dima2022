import 'package:dima2022/view/custom_theme.dart';
import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';

class Tag extends StatefulWidget {
  final Color? backgroundColor;
  final Color? gradientBackgroundColor;
  final IconData? icon;
  final String text;
  final bool hideDetails;
  final bool upperCase;
  final ValueChanged<bool>? onChanged;

  Tag({
    this.backgroundColor,
    this.gradientBackgroundColor,
    this.icon,
    required this.text,
    this.hideDetails = false,
    this.upperCase = true,
    this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  _TagState createState() => _TagState();
}

class _TagState extends State<Tag> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                widget.backgroundColor ?? CustomTheme.secondaryBackgroundColor,
                widget.gradientBackgroundColor ??
                    CustomTheme.secondaryBackgroundColor,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(1, 4),
                blurRadius: 4,
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              if (widget.onChanged != null) {
                setState(() {
                  _isChecked = !_isChecked;
                });
                widget.onChanged!(_isChecked);
              }
              ;
            },
            child: Row(
              children: [
                widget.icon != null
                    ? Icon(
                        widget.icon,
                        color: widget.backgroundColor != null
                            ? CustomTheme.backgroundColor
                            : CustomTheme.primaryColor,
                        size: getProportionateScreenHeight(15),
                      )
                    : const SizedBox(
                        width: 0,
                      ),
                if (!widget.hideDetails)
                  Text(
                    widget.upperCase ? widget.text.toUpperCase() : widget.text,
                    style: TextStyle(
                        color: _isChecked
                            ? Colors.green
                            : (widget.backgroundColor != null
                                ? CustomTheme.backgroundColor
                                : CustomTheme.primaryColor),
                        fontSize: getProportionateScreenHeight(11),
                        fontWeight: FontWeight.w600),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
