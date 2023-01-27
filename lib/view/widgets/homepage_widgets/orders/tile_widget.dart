import 'package:flutter/material.dart';

import '../../../../utils/size_config.dart';

class TileWidget extends StatelessWidget {
  final String textDescription;
  final String textValue;

  const TileWidget({
    super.key,
    required this.textDescription,
    required this.textValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [
            Colors.white,
            Color.fromARGB(255, 237, 237, 237),
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
      margin: const EdgeInsets.all(6),
      padding: EdgeInsets.all(getProportionateScreenWidth(6)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              textDescription,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(115, 39, 39, 39),
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(6)),
            Text(
              textValue,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w600,
                color: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
