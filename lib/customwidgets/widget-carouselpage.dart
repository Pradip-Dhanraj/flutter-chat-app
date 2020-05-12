import 'dart:async';

import 'package:chat/animations/animation-delayedanimation.dart';
import 'package:flutter/material.dart';

class CarouselPage extends StatefulWidget {
  final List<Object> itemsSource;
  final Function templateFunction;
  CarouselPage({@required this.itemsSource, @required this.templateFunction});

  @override
  _CarouselPageState createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  String activeTag;
  int currentPage;
  PageController controller;
  Timer autoTimer;
  @override
  void initState() {
    controller = PageController(
      initialPage: 0,
      keepPage: false,
    );
    controller.addListener(() {
      int next = controller.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
    autoTimer = Timer.periodic(
      Duration(seconds: 8),
      (_) async {
        if (autoTimer.isActive) {
          if (controller.page == widget.itemsSource.length) {
            await controller.animateTo(
              0,
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          } else {
            await controller.nextPage(
              duration: Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          }
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    autoTimer.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.fromIterable(widget.itemsSource),
      initialData: [],
      builder: (context, AsyncSnapshot snap) {
        return PageView.builder(
            controller: controller,
            itemCount: widget.itemsSource.length + 1,
            itemBuilder: (BuildContext context, int currentIdx) {
              if (currentIdx == 0) {
                return _buildTagPage(context);
              } else if (widget.itemsSource.length >= currentIdx) {
                // Active page
                bool active = currentIdx == currentPage;
                return _buildStoryPage(
                    widget.itemsSource[currentIdx - 1], active);
              } else {
                return Container();
              }
              //  bool active = currentIdx == currentPage;
              //   return _buildStoryPage(
              //       widget.itemsSource[currentIdx], active);
            });
      },
    );
  }

  _buildTagPage(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'JCI COVID-19 HIGHLIGHTS',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white54,
              ),
            ),
            Text('JCI OFFICE LOCATIONS',
                style: TextStyle(
                  color: Colors.white54,
                )),
          ],
        ));
  }

  _buildStoryPage(Object data, bool active) {
    // Animated Properties
    //final double blur = active ? 30 : 0;
    //final double offset = active ? 20 : 0;
    //final double top = active ? 100 : 200;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.all(5),
      height: double.infinity,
      width: 100,
      child: Delayedaimation(
        milliseconsdelay: 600,
        child: widget.templateFunction(data),
        transition: Offset(0.1, 0.0),
      ),
    );
  }
}
