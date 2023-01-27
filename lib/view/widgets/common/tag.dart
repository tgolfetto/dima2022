import 'package:flutter/material.dart';

import 'custom_theme.dart';

class Tag extends StatefulWidget {
  final Color? backgroundColor;
  final Color? gradientBackgroundColor;
  final IconData? icon;
  final String text;
  final bool hideDetails;
  final bool upperCase;
  final ValueChanged<bool>? onChanged;
  final double? fontSize;
  final bool isChecked;

  const Tag({
    this.backgroundColor,
    this.gradientBackgroundColor,
    this.icon,
    required this.text,
    this.hideDetails = false,
    this.upperCase = true,
    this.onChanged,
    this.fontSize,
    required this.isChecked,
    Key? key,
  }) : super(key: key);

  @override
  TagState createState() => TagState();
}

class TagState extends State<Tag> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = widget.isChecked;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                widget.backgroundColor ??
                    (widget.isChecked
                        ? Colors.teal
                        : CustomTheme.secondaryBackgroundColor),
                widget.gradientBackgroundColor ??
                    (widget.isChecked
                        ? const Color.fromARGB(255, 13, 122, 113)
                        : CustomTheme.secondaryBackgroundColor)
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
                  isChecked = !isChecked;
                  widget.onChanged!(isChecked);
                });
              }
            },
            child: Row(
              children: [
                widget.icon != null
                    ? Icon(
                        widget.icon,
                        color: widget.backgroundColor != null
                            ? CustomTheme.backgroundColor
                            : CustomTheme.primaryColor,
                        size: 15,
                      )
                    : const SizedBox(
                        width: 0,
                      ),
                if (!widget.hideDetails)
                  Text(
                    widget.upperCase ? widget.text.toUpperCase() : widget.text,
                    style: TextStyle(
                      color: widget.isChecked
                          ? CustomTheme.backgroundColor
                          : (widget.backgroundColor != null
                              ? CustomTheme.backgroundColor
                              : CustomTheme.primaryColor),
                      fontSize: widget.fontSize ?? 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
