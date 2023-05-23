import 'package:elderlycompanion/screens/elders/link_elder.dart';
import 'package:elderlycompanion/screens/home/home_screen.dart';
import 'package:elderlycompanion/screens/loading/loading_screen.dart';
import 'package:elderlycompanion/services/auth.dart' as Auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:sweet_alert_dialogs/sweet_alert_dialogs.dart';

final auth = FirebaseAuth.instance;
final user = User;
Future<User> getUser() async {
  return await auth.currentUser;
}

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Drawer(
        elevation: 1,
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return HomeScreen();
                  }));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        DrawerHeader(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: Divider.createBorderSide(context,
                                      color: Colors.transparent, width: 0))),
                          child: Container(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Saathi ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 32.0,
                                  ),
                                ),
                                Text(
                                  'Sampark',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w100,
                                    fontSize: 32.0,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListButtons(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LinkElder();
                            }));
                          },
                          icon: Icons.person_add,
                          text: 'Link Elder',
                        ),
                        ListButtons(
                          onTap: () {},
                          icon: Icons.description,
                          text: 'Instructions',
                        ),
                        ListButtons(
                          onTap: () async {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Log-out from the App"),
                                    content: Text('Are you Sure '),
                                    // alertType: RichAlertType.WARNING,
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text("Yes"),
                                        onPressed: () async {
                                          await auth.signOut();
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return LoadingScreen(
                                              auth: Auth.Auth(),
                                            );
                                          }));
                                        },
                                      ),
                                      TextButton(
                                        child: Text("No"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: Icons.exit_to_app,
                          text: 'Sign Out',
                        ),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Divider(
                          indent: 30,
                          endIndent: 30,
                          thickness: 1.5,
                          color: Colors.grey.shade200,
                        ),
                        ListButtons(
                          onTap: () {},
                          icon: Icons.share,
                          text: 'Share Care App ',
                        ),
                        ListButtons(
                          onTap: () {},
                          icon: Icons.help_outline,
                          text: 'Help and Feedback',
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListButtons extends StatelessWidget {
  final String text;
  final icon;
  final onTap;
  ListButtons({this.text, this.icon, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 9),
      child: InkWell(
        splashColor: Color(0xffBA6ABC3),
        onTap: onTap,
        focusColor: Colors.green,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              text,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            leading: Icon(
              icon,
              size: 25,
              color: Colors.grey.shade600,
            ),
          ),
        ),
      ),
    );
  }
}

class ElderlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height = 56;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Saathi '),
              Text(
                'Sampark',
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 1,
          actions: <Widget>[
//            GestureDetector(
//              onTap: () {
//                //Navigator.pushNamed(context, ProfileScreen.id);
//              },
//              child: CircleAvatar(
//                radius: 20,
//                backgroundColor: Colors.white,
//                child: Icon(
//                  Icons.perm_identity,
//                  size: 30,
//                  color: Color(0xff5e444d),
//                ),
//              ),
//            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
