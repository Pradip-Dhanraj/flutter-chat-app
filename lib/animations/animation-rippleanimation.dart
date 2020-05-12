import 'package:flutter/material.dart';

class RippleAnimation extends StatefulWidget {
  final Widget child;
  final Color color;
  RippleAnimation({
    @required this.child,
    @required this.color,
  });
  @override
  _RippleAnimationState createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation>
    with TickerProviderStateMixin {
  AnimationController _rippleController;
  Animation<double> _rippleAnimation;

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _rippleController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 1,
      ),
    );
    _rippleAnimation = Tween(begin: 50.0, end: 80.0).animate(_rippleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _rippleController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _rippleController.forward();
        }
      });
    _rippleController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _rippleController,
      builder: (buildcontext, child) {
        return Container(
          height: _rippleAnimation.value,
          width: _rippleAnimation.value,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
          ),
          child: widget.child,
        );
      },
    );
  }
}
