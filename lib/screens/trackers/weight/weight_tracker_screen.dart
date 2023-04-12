import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderlycompanion/models/tracker.dart';
import 'package:elderlycompanion/screens/trackers/weight/chart_widget.dart';
import 'package:elderlycompanion/widgets/app_default.dart';
import 'package:elderlycompanion/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WeightTrackerScreen extends StatefulWidget {
  final String uid;

  const WeightTrackerScreen({Key key, this.uid}) : super(key: key);
  @override
  _WeightTrackerScreenState createState() => _WeightTrackerScreenState();
}

class _WeightTrackerScreenState extends State<WeightTrackerScreen> {
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
  double averageWeight;
  WeightTracker weightTracker;
  getDocumentList() async {
    Relative relative = Relative();
    relativeSnapshot = await FirebaseFirestore.instance
        .collection('relatives')
        .doc(userId)
        .get();
    relative.getData(relativeSnapshot.data());
    weightTracker = WeightTracker();
    snapshot = await FirebaseFirestore.instance
        .collection('tracker')
        .doc(relative.elderUID)
        .collection('weight')
        .get();
    averageWeight = 0;
    double totalWeight = 0;

    List<Weight> list = weightTracker.loadData(snapshot);
    for (var s in list) {
      totalWeight += s.weight;
    }
    setState(() {
      averageWeight = totalWeight / list.length;
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
                'Weight Tracker',
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
                            //minWidth: MediaQuery.of(context).size.width ,
                            maxHeight: MediaQuery.of(context).size.height / 1.7,
                            maxWidth: MediaQuery.of(context).size.width *
                                (snapshot.data.docs.length / 3),
                          ),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              // child: WeightChart(
                              //   animate: true,
                              //   userID: userId,
                              // ),
                              child: Text('Hello'),
                            ),
                            margin: EdgeInsets.all(8),
                          ),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 8, right: 8),
                        child: ListTile(
                          subtitle: Text('Average Weight'),
                          title: Text(averageWeight.toStringAsFixed(2)),
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
