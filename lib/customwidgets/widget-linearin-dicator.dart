import 'package:flutter/material.dart';

class LinearIndicator extends StatefulWidget {
  final Color backgroundcolor;
  final double value;
  final Color indicatorcolor;
  final double total;
  LinearIndicator({
    @required this.total,
    @required this.value,
    this.indicatorcolor,
    this.backgroundcolor,
  });
  @override
  _LinearIndicatorState createState() => _LinearIndicatorState();
}

class _LinearIndicatorState extends State<LinearIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 800,
        ));
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print('${(widget.value / widget.total) }');
    return AnimatedBuilder(
        animation: controller,
        builder: (BuildContext context, Widget child) {
          return LinearProgressIndicator(
            value: (widget.value / widget.total) * controller.value,
            backgroundColor: (widget.backgroundcolor == null)
                ? Colors.black
                : widget.backgroundcolor,
            valueColor: new AlwaysStoppedAnimation<Color>(
              (widget.indicatorcolor == null)
                  ? Theme.of(context).accentColor
                  : widget.indicatorcolor,
            ),
          );
        });
  }
}
