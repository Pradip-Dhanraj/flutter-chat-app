import 'dart:math';

import 'package:flutter/material.dart';

enum RotationDirection { left, right }

class RotationAnimation extends StatefulWidget {
  final double degree;
  final RotationDirection direction;
  final int duration;
  final Widget child;
  final Function function;

  const RotationAnimation({
    @required this.child,
    this.degree = 180,
    this.direction = RotationDirection.left,
    this.duration = 500,
    this.function,
  });
  @override
  _RotationAnimationState createState() => _RotationAnimationState();
}

class _RotationAnimationState extends State<RotationAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: widget.duration,
        ));
    // animation = CurvedAnimation(
    //   parent: controller,
    //   curve: Curves.easeIn,
    // );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeIn));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          //print("${widget.degree}");
          return Transform.rotate(
            angle: controller.value * widget.degree / 360 * 2 * pi,
            child: GestureDetector(
              onTap: () {
                if (controller.status == AnimationStatus.completed) {
                  controller.reverse();
                } else if (controller.status == AnimationStatus.dismissed) {
                  controller.forward();
                }

                if (widget.function != null)
                  widget.function();
                else
                  print("Icon tapped");
              },
              child: widget.child,
            ),
          );
        });
  }

// @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//         animation: controller,
//         builder: (BuildContext context, Widget child) {
//           return Transform.rotate(
//             angle: widget.degree * controller.value,
//             child: GestureDetector(
//               onTap: () {
//                 controller.forward();
//                 print("Icon tapped");
//               },
//               child: widget.child,
//             ),
//           );
//         });
//   }

}
