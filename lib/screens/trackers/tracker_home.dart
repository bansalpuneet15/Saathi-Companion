import 'package:elderlycompanion/screens/trackers/blood_pressure/blood_pressure_tracker_screen.dart';
import 'package:elderlycompanion/screens/trackers/blood_sugar/blood_sugar_tracker_screen.dart';
import 'package:elderlycompanion/screens/trackers/sleep/sleep_tracker_screen.dart';
import 'package:elderlycompanion/screens/trackers/weight/weight_tracker_screen.dart';
import 'package:elderlycompanion/widgets/app_default.dart';
import 'package:flutter/material.dart';

class TrackerHomeScreen extends StatefulWidget {
  final String uid;

  const TrackerHomeScreen({Key key, this.uid}) : super(key: key);
  @override
  _TrackerHomeScreenState createState() => _TrackerHomeScreenState();
}

class _TrackerHomeScreenState extends State<TrackerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElderlyAppBar(),
      drawer: AppDrawer(),
      body: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Text(
                'Health Trackers',
                style: TextStyle(
                  fontSize: 32,
                  color: Color(0xff3d5afe),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            margin: EdgeInsets.all(15),
            child: ListTile(
              title: Text('Weight'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return WeightTrackerScreen(
                    uid: widget.uid,
                  );
                }));
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(15),
            child: ListTile(
              title: Text('Sleep'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SleepTrackerScreen(
                    uid: widget.uid,
                  );
                }));
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(15),
            child: ListTile(
              title: Text('Blood Pressure'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BloodPressureTrackerScreen(
                    uid: widget.uid,
                  );
                }));
              },
            ),
          ),
          Card(
            margin: EdgeInsets.all(15),
            child: ListTile(
              title: Text('Blood Sugar'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BloodSugarTrackerScreen(
                    uid: widget.uid,
                  );
                }));
              },
            ),
          ),
        ],
      ),
    );
  }
}
