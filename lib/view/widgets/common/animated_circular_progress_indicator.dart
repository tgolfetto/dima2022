import 'package:flutter/material.dart';

class AnimateCircularProgressIndicator extends StatefulWidget {
  const AnimateCircularProgressIndicator({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AnimateCircularProgressIndicatorState createState() =>
      _AnimateCircularProgressIndicatorState();
}

class _AnimateCircularProgressIndicatorState
    extends State<AnimateCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: _animation.value,
      color: Colors.teal,
    );
  }
}
