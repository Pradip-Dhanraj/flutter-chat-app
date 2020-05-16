import 'package:chat/services/auth-services.dart';
import 'package:chat/services/firebase-database.dart';
import 'package:flutter/material.dart';

import 'helper/app-routes.dart';
import 'helper/app-strings.dart';
import 'helper/app-theme.dart';
import 'pages/dashboard-page.dart';
import 'pages/login-page.dart';

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
      routes: {
        ApllicationRoutes.routeToDashboard: (context) => ChatBoard(
            firebaseDatabase: BaseFirebaseDatabase(),
              auth: Auth(),
            ),
        ApllicationRoutes.routeToLogin: (context) => Loginpage(
              auth: Auth(),
            ),
        // AppConstant.routeToSplashScreen: (context) => SplashScreen(
        //     'assets/splash.flr', Login(),
        //     startAnimation: 'Untitled',
        //     backgroundColor: Theme.of(context).primaryColor),
      },
    );
  }
}
