import 'package:chat/helper/app-routes.dart';
import 'package:chat/models/chat-model.dart';
import 'package:chat/pages/contact-page.dart';
import 'package:chat/pages/dashboard-page.dart';
import 'package:chat/pages/login-page.dart';
import 'package:chat/pages/profile-page.dart';
import 'package:chat/services/auth-services.dart';
import 'package:chat/services/firebase-database.dart';
import 'package:flutter/material.dart';

Widget getDrawer({
  @required BuildContext context,
  @required String userid,
}) {
  return Drawer(
    elevation: 100,
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Column(
            children: <Widget>[
              Text(
                'JCI',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Icon(
                  Icons.dashboard,
                  color: Colors.white,
                  size: 100,
                ),
              )
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.black,
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.dashboard,
            color: Colors.black,
          ),
          title: Text(
            'Dashboard',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            routeToPage(
              context: context,
              action: NaivigationRoute.replace,
              page: ChatBoard(
                auth: Auth(),
                firebaseDatabase: BaseFirebaseDatabase(),
                userid: userid,
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.card_travel,
            color: Colors.black,
          ),
          title: Text(
            'Profile',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            // Update the state of the app.
            // ...
            routeToPage(
              context: context,
              action: NaivigationRoute.replace,
              page: ProfilePage(
                auth: Auth(),
                firebaseDatabase: BaseFirebaseDatabase(),
                userid: userid,
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.hot_tub,
            color: Colors.black,
          ),
          title: Text(
            'Contact Page',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            // Update the state of the app.
            // ...
            routeToPage(
              context: context,
              action: NaivigationRoute.replace,
              page: ContactList(
                auth: Auth(),
                firebaseDatabase: BaseFirebaseDatabase(),
                userid: userid,
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.contact_mail,
            color: Colors.black,
          ),
          title: Text(
            'Login Page',
            style: TextStyle(fontSize: 20),
          ),
          onTap: () {
            // Update the state of the app.
            // ...
            routeToPage(
              context: context,
              action: NaivigationRoute.replace,
              page: Loginpage(
                auth: Auth(),
              ),
            );
          },
        ),
        // ListTile(
        //   leading: Icon(
        //     Icons.exit_to_app,
        //     color: Colors.black,
        //   ),
        //   title: Text(
        //     'ChatPage',
        //     style: TextStyle(fontSize: 20),
        //   ),
        //   onTap: () {
        //     // Update the state of the app.
        //     // ...
        //     routeToPage(
        //       context: context,
        //       action: NaivigationRoute.replace,
        //       page: ChatBoard(
        //         auth: Auth(),
        //         firebaseDatabase: BaseFirebaseDatabase(),
        //         userid: userid,
        //       ),
        //     );
        //   },
        // ),
      ],
    ),
  );
}

void popupDialog({
  @required BuildContext context,
  String header = "Alert",
  @required String message,
  String canceltext = "Ok",
}) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(header.toUpperCase()),
        content: new Text(message.toUpperCase()),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text(canceltext),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void onLoading(
  BuildContext context, {
  bool show = true,
}) {
  if (show) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
            child: Container(
          height: 100,
          width: 100,
          color: Colors.white10.withOpacity(.1),
          child: Center(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(
                  backgroundColor: Colors.black,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: new Text("Loading"),
                ),
              ],
            ),
          ),
        ));
      },
    );
  } else {
    Navigator.pop(context);
  }
}

Widget getAppBarUpdated(String title, BuildContext context, String userid) {
  return AppBar(
    backgroundColor: Colors.black,
    title: Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 17,
        color: Colors.white,
      ),
    ),
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.account_circle,
          color: Colors.white,
        ),
        onPressed: () {
          print("profile clicked");
          routeToPage(
            context: context,
            action: NaivigationRoute.replace,
            page: ProfilePage(
              auth: Auth(),
              firebaseDatabase: BaseFirebaseDatabase(),
              userid: userid,
            ),
          );
        },
      ),
      IconButton(
        icon: Icon(
          Icons.ac_unit,
          color: Colors.white,
        ),
        onPressed: () => {print("notification clicked")},
      ), //JCI logo
    ],
    leading: Builder(builder: (context) {
      return IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
          print("app bar");
        },
      );
    }),
  );
}
