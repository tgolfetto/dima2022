import 'package:flutter/material.dart';

class CheckableIconContainer extends StatefulWidget {
  final IconData icon;
  final Function(bool) onChanged;
  final bool disabled;
  final bool hidden;
  final bool value;

  const CheckableIconContainer({
    super.key,
    required this.icon,
    required this.onChanged,
    this.disabled = false,
    this.hidden = false,
    required this.value,
  });

  @override
  CheckableIconContainerState createState() => CheckableIconContainerState();
}

class CheckableIconContainerState extends State<CheckableIconContainer> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = widget.value;
    return widget.hidden
        ? const SizedBox(height: 0)
        : Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: widget.disabled
                  ? const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 245, 245, 245),
                        Color.fromARGB(255, 237, 237, 237),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [
                        Color(0xff3e9f96),
                        Color.fromARGB(255, 13, 122, 113),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(1, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                widget.icon,
                color: widget.disabled
                    ? Colors.grey
                    : const Color.fromARGB(255, 237, 237, 237),
              ),
              onPressed: widget.disabled
                  ? null
                  : () {
                      setState(() {
                        isChecked = !isChecked;
                        widget.onChanged(isChecked);
                      });
                    },
            ),
          );
  }
}
