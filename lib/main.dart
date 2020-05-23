import 'package:chat/services/auth-services.dart';
import 'package:chat/services/firebase-database.dart';
import 'package:flutter/material.dart';

import 'helper/app-routes.dart';
import 'helper/app-strings.dart';
import 'helper/app-theme.dart';
import 'pages/chat-list.dart';
import 'pages/dashboard-page.dart';
import 'pages/login-page.dart';
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
          return MaterialPageRoute(
            builder: (context) {
              return ChatBoard(
                auth: args.auth,
                userid: args.userid,
                firebaseDatabase: args.firebaseDatabase,
                chatid: args.chatid,
              );
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      routes: {
        // ApllicationRoutes.routeToDashboard: (context) => ChatBoard(
        //       firebaseDatabase: BaseFirebaseDatabase(),
        //       auth: Auth(),
        //       userid: null,
        //       chatid: null,
        //     ),
        ApllicationRoutes.routeToLogin: (context) => Loginpage(
              auth: Auth(),
            ),
        ApllicationRoutes.routeToSignUp: (context) => Signuppage(
              auth: Auth(),
            ),
        ApllicationRoutes.routeToChatList: (context) => ChatList(
              auth: Auth(),
              firebaseDatabase: BaseFirebaseDatabase(),
              userid: null,
            ),
        // AppConstant.routeToSplashScreen: (context) => SplashScreen(
        //     'assets/splash.flr', Login(),
        //     startAnimation: 'Untitled',
        //     backgroundColor: Theme.of(context).primaryColor),
      },
    );
  }
}
