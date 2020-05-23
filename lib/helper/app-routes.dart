import 'package:flutter/material.dart';

class ApllicationRoutes {
  static const routeToDashboard = "/chat-board";
  static const routeToTest = "/test";
  static const routeToSignUp = "signup-page";
  static const routeToLogin = "login-page";
  static const routeToChatList = "chat-list";
  static const routeToProfile = "profile-page";
  static const routeToContacts = "contacts-page";
}

enum NaivigationRoute { push, pop, replace, dashboard }

void routeToPage({
  @required BuildContext context,
  String path,
  Object dataobject,
  Widget page,
  @required NaivigationRoute action,
}) {
  switch (action) {
    case NaivigationRoute.pop:
      Navigator.pop(context);
      break;
    case NaivigationRoute.push:
      Navigator.pushNamed(context, path, arguments: dataobject);
      break;
    case NaivigationRoute.replace:
      Route route = MaterialPageRoute(builder: (context) => page);
      Navigator.pushReplacement(context, route);
      break;
    case NaivigationRoute.dashboard:
      // Route _route = MaterialPageRoute(builder: (context) => Dashboard());
      // Navigator.pushReplacement(context, _route);
      break;
  }
}
