import 'dart:async';
import 'package:flutter/material.dart';

class Delayedaimation extends StatefulWidget {
  final Widget child;
  final int milliseconsdelay;
  final Offset transition;
  final Duration animationduration;

  Delayedaimation({
    @required this.milliseconsdelay,
    @required this.child,
    this.transition = const Offset(0.0, 0.35),
    this.animationduration = const Duration(milliseconds: 800) ,
  });

  @override
  _DelayedaimationState createState() => _DelayedaimationState();
}

class _DelayedaimationState extends State<Delayedaimation>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationduration,
    );

    var fade = CurvedAnimation(curve: Curves.decelerate, parent: _controller);

    _animation =
        Tween<Offset>(begin: widget.transition, end: Offset.zero).animate(fade);

    if (widget.milliseconsdelay == null) {
      _controller.forward();
    } else {
      Timer(Duration(milliseconds: widget.milliseconsdelay), () {
        _controller.forward();
      });
      super.initState();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: SlideTransition(
        position: _animation,
        child: widget.child,
      ),
    );
  }
}
