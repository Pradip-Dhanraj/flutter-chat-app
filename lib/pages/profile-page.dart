import 'package:chat/helper/app-helper-functions.dart';
import 'package:chat/helper/app-strings.dart';
import 'package:chat/helper/app-theme.dart';
import 'package:chat/models/chat-model.dart';
import 'package:chat/services/auth-services.dart';
import 'package:chat/services/firebase-database.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Auth auth;
  final BaseFirebaseDatabase firebaseDatabase;
  final userid;
  ProfilePage({
    @required this.auth,
    @required this.firebaseDatabase,
    @required this.userid,
  });
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController usernameController;
  @override
  void initState() {
    usernameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    usernameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: getDrawer(
      //   context: context,
      //   userid: widget.userid,
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: chambray,
          child: Icon(
            Icons.arrow_back_ios,
            color: wattle,
          ),
          onPressed: () {
            Navigator.pop(context);
          }),
      appBar: getAppBarUpdated(
        "Profile",
        context,
        widget.userid,
        showProfileIcon: false,
        showExitIcon: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: usernameController,
          ),
          RaisedButton(
            child: Text("save"),
            onPressed: () {
              if (usernameController.text == "") return;
              var profile = Profile(
                usernameController.text,
                widget.userid,
              );
              widget.firebaseDatabase.pushDataWithKey(
                key: widget.userid,
                dbName: AppStrings.profiledb,
                model: profile,
              );
            },
          ),
        ],
      ),
    );
  }
}
