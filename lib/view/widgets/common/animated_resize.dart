import 'package:flutter/material.dart';

import '../../../utils/size_config.dart';

class AnimatedResize extends StatefulWidget {
  final Widget child;

  const AnimatedResize({Key? key, required this.child}) : super(key: key);
  @override
  _AnimatedResizeState createState() => _AnimatedResizeState();
}

class _AnimatedResizeState extends State<AnimatedResize>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animationController.forward();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('ciao');
    animationController.forward();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    //animationController.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig()..init(context);
    return Container(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          final t = Curves.easeInOutQuart.transform(animationController.value);
          return SizedBox.fromSize(
            size: Size(getProportionateScreenWidth(40 * (t * 2.2 + 1)),
                double.infinity),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(t * 16 + 8),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}