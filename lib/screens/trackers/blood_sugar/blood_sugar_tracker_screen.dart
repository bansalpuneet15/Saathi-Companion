import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderlycompanion/models/tracker.dart';
import 'package:elderlycompanion/widgets/app_default.dart';
import 'package:elderlycompanion/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chart_widget.dart';

class BloodSugarTrackerScreen extends StatefulWidget {
  final String uid;

  const BloodSugarTrackerScreen({Key key, this.uid}) : super(key: key);
  @override
  _BloodSugarTrackerScreenState createState() =>
      _BloodSugarTrackerScreenState();
}

class _BloodSugarTrackerScreenState extends State<BloodSugarTrackerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getCurrentUser() {
    _auth.authStateChanges().listen((User user) {
      if (user == null) {
        print('No user is currently signed in.');
      } else {
        print('User ${user.uid} is currently signed in.');
        setState(() {
          userId = user.uid;
        });
      }
    });
  }
  // getCurrentUser() async {
  //   await FirebaseAuth.instance.currentUser().then((user) {
  //     setState(() {
  //       userId = user.uid;
  //     });
  //   });
  //   userId = widget.uid;
  // }

  QuerySnapshot snapshot;
  var relativeSnapshot;
  String userId;
  double averageValue;
  BloodSugarTracker bloodSugar;
  Relative relative = Relative();
  getDocumentList() async {
    relativeSnapshot = await FirebaseFirestore.instance
        .collection('relatives')
        .doc(userId)
        .get();
    relative.getData(relativeSnapshot.data());
    bloodSugar = BloodSugarTracker();
    snapshot = await FirebaseFirestore.instance
        .collection('tracker')
        .doc(relative.elderUID)
        .collection('blood_sugar')
        .get();
    averageValue = 0;
    double totalValue = 0;

    List<BloodSugar> list = bloodSugar.loadData(snapshot);
    for (var s in list) {
      totalValue += s.bloodSugar;
    }
    setState(() {
      averageValue = totalValue / list.length;
    });

    return snapshot;
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Text(
                'Blood Sugar Tracker',
                style: TextStyle(
                  fontSize: 32,
                  color: Color(0xff3d5afe),
                ),
              ),
            ),
          ),
          FutureBuilder(
              future: getDocumentList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          margin: EdgeInsets.all(15),
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 1.7,
                            maxWidth: MediaQuery.of(context).size.width *
                                (snapshot.data.docs.length / 2.5),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: BloodSugarChart(
                                animate: true,
                                userID: relative.elderUID,
                              ),
                              // child: Text('Hello'),
                            ),
                            margin: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: Text('Average Blood Sugar'),
                          title: Text(averageValue.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else
                  return SizedBox();
              }),
        ],
      ),
      appBar: ElderlyAppBar(),
      drawer: AppDrawer(),
    );
  }
}
