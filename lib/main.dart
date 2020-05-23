import 'package:chat/pages/contact-page.dart';
import 'package:chat/services/auth-services.dart';
import 'package:chat/services/firebase-database.dart';
import 'package:flutter/material.dart';

import 'helper/app-routes.dart';
import 'helper/app-strings.dart';
import 'helper/app-theme.dart';
import 'pages/chat-list.dart';
import 'pages/dashboard-page.dart';
import 'pages/login-page.dart';
import 'pages/profile-page.dart';
import 'pages/sign-up.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.apptitle,
      theme: themeData,
      debugShowCheckedModeBanner: false,
      initialRoute: ApllicationRoutes.routeToLogin,
      onGenerateRoute: (settings) {
        if (settings.name == ApllicationRoutes.routeToDashboard) {
          final ChatBoard args = settings.arguments;
          return getPageRoute(
            ChatBoard(
              auth: args.auth,
              userid: args.userid,
              firebaseDatabase: args.firebaseDatabase,
              chatid: args.chatid,
              displayName: args.displayName,
            ),
          );
        } else if (settings.name == ApllicationRoutes.routeToChatList) {
          final ChatList args = settings.arguments;
          return getPageRoute(
            ChatList(
              auth: args.auth,
              userid: args.userid,
              firebaseDatabase: args.firebaseDatabase,
            ),
          );
        } else if (settings.name == ApllicationRoutes.routeToProfile) {
          final ProfilePage args = settings.arguments;
          return getPageRoute(
            ProfilePage(
              auth: args.auth,
              userid: args.userid,
              firebaseDatabase: args.firebaseDatabase,
            ),
          );
        } else if (settings.name == ApllicationRoutes.routeToContacts) {
          final ContactList args = settings.arguments;
          return getPageRoute(
            ContactList(
              auth: args.auth,
              userid: args.userid,
              firebaseDatabase: args.firebaseDatabase,
            ),
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      routes: {
        ApllicationRoutes.routeToLogin: (context) => Loginpage(
              auth: Auth(),
            ),
        ApllicationRoutes.routeToSignUp: (context) => Signuppage(
              auth: Auth(),
            ),
        // AppConstant.routeToSplashScreen: (context) => SplashScreen(
        //     'assets/splash.flr', Login(),
        //     startAnimation: 'Untitled',
        //     backgroundColor: Theme.of(context).primaryColor),
      },
    );
  }

  MaterialPageRoute getPageRoute(dynamic constructor) => MaterialPageRoute(
        builder: (context) {
          return constructor;
        },
      );
}
