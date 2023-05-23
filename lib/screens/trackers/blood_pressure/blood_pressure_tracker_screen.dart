import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderlycompanion/models/tracker.dart';
import 'package:elderlycompanion/widgets/app_default.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:elderlycompanion/models/user.dart';
import 'chart_widget.dart';

class BloodPressureTrackerScreen extends StatefulWidget {
  final String uid;

  const BloodPressureTrackerScreen({Key key, this.uid}) : super(key: key);
  @override
  _BloodPressureTrackerScreenState createState() =>
      _BloodPressureTrackerScreenState();
}

class _BloodPressureTrackerScreenState
    extends State<BloodPressureTrackerScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  getCurrentUser() {
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
  double averageDiastolic, averageSystolic, averagePulse;
  BloodPressureTracker bloodPressure;
  Relative relative = Relative();
  getDocumentList() async {
    relativeSnapshot = await FirebaseFirestore.instance
        .collection('relatives')
        .doc(userId)
        .get();
    relative.getData(relativeSnapshot.data());
    bloodPressure = BloodPressureTracker();
    snapshot = await FirebaseFirestore.instance
        .collection('tracker')
        .doc(relative.elderUID)
        .collection('blood_pressure')
        .get();
    averageDiastolic = 0;
    double totalDiastolic = 0, totalSystolic = 0, totalPulse = 0;

    List<BloodPressure> list = bloodPressure.loadData(snapshot);
    for (var s in list) {
      totalDiastolic += s.diastolic;
      totalSystolic += s.systolic;
      totalPulse += s.pulse;
    }
    setState(() {
      averageDiastolic = totalDiastolic / list.length;
      averageSystolic = totalSystolic / list.length;
      averagePulse = totalPulse / list.length;
    });

    return snapshot;
  }

  PageController _controller;

  @override
  void initState() {
    getCurrentUser();
    _controller = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          FutureBuilder(
              future: getDocumentList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: Text(
                            'Diastolic ',
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xff3d5afe),
                            ),
                          ),
                        ),
                      ),
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
                              child: BloodPressureChart(
                                animate: true,
                                userID: relative.elderUID,
                                type: 'diastolic',
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
                          subtitle: Text('Average Diastolic '),
                          title: Text(averageDiastolic.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else
                  return SizedBox();
              }),
          FutureBuilder(
              future: getDocumentList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: Text(
                            'Systolic',
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xff3d5afe),
                            ),
                          ),
                        ),
                      ),
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
                              child: BloodPressureChart(
                                animate: true,
                                userID: relative.elderUID,
                                type: 'systolic',
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
                          subtitle: Text('Average Systolic'),
                          title: Text(averageSystolic.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else
                  return SizedBox();
              }),
          FutureBuilder(
              future: getDocumentList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20, 8, 20, 0),
                          child: Text(
                            'Pulse',
                            style: TextStyle(
                              fontSize: 32,
                              color: Color(0xff3d5afe),
                            ),
                          ),
                        ),
                      ),
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
                              child: BloodPressureChart(
                                animate: true,
                                userID: relative.elderUID,
                                type: 'pulse',
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
                          subtitle: Text('Average Pulse'),
                          title: Text(averageSystolic.toStringAsFixed(2)),
                        ),
                      )
                    ],
                  );
                } else
                  return SizedBox();
              })
        ],
      ),
      appBar: ElderlyAppBar(),
      drawer: AppDrawer(),
    );
  }
}
