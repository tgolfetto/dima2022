import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:layout/layout.dart';

class WindowBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Container(
      height: 50,
      width: size.width,
      color: Color.fromARGB(255, 30, 96, 158),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Gutter(),
                Icon(Icons.arrow_back, size: 20),
                Gutter(),
                Icon(Icons.arrow_forward, color: theme.disabledColor, size: 20),
                Gutter(),
                Icon(Icons.access_time, size: 20),
                Gutter(),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 500),
                    height: 25,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 38, 93, 125),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Color(0xFF42484B), width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 16,
                          color: theme.disabledColor,
                        ),
                        Gutter(2),
                        Container(
                          constraints: BoxConstraints(maxWidth: 150),
                          child: Text(
                            'Buscar en Flutter España',
                            style: TextStyle(
                              fontSize: 12,
                              color: theme.disabledColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gutter(),
                Icon(Icons.help_outline, size: 20),
                Gutter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size(double.infinity, 38);
}
