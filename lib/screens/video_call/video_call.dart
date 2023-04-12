import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderlycompanion/models/user.dart';
import 'package:elderlycompanion/screens/home/home_screen.dart';
import 'package:elderlycompanion/widgets/app_default.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';

class VideoCall extends StatefulWidget {
  final String userID, elderID;

  const VideoCall({Key key, this.userID, this.elderID}) : super(key: key);
  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final serverText = TextEditingController();
  TextEditingController roomText;
  TextEditingController subjectText =
      TextEditingController(text: "Urgent Video Call");
  TextEditingController nameText = TextEditingController(text: "");
  TextEditingController emailText = TextEditingController(text: "");
  TextEditingController iosAppBarRGBAColor =
      TextEditingController(text: "#0080FF80"); //transparent blue
  var isAudioOnly = false;
  var isAudioMuted = false;
  var isVideoMuted = false;

  @override
  void initState() {
    super.initState();
    roomText = TextEditingController(text: widget.userID);
    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  @override
  void dispose() {
    super.dispose();
    serverText.dispose();
    roomText.dispose();
    subjectText.dispose();
    nameText.dispose();
    emailText.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ElderlyAppBar(),
      drawer: AppDrawer(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('relatives')
              .doc(widget.userID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Relative relative = Relative();
              relative.getData(snapshot.data.data());

              roomText.value = TextEditingValue(text: widget.elderID);
              nameText.value = TextEditingValue(text: relative.name);
              emailText.value = TextEditingValue(text: relative.email);
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CheckboxListTile(
                      title: Text("Audio Only"),
                      value: isAudioOnly,
                      onChanged: _onAudioOnlyChanged,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    CheckboxListTile(
                      title: Text("Audio Muted"),
                      value: isAudioMuted,
                      onChanged: _onAudioMutedChanged,
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    CheckboxListTile(
                      title: Text("Video Muted"),
                      value: isVideoMuted,
                      onChanged: _onVideoMutedChanged,
                    ),
                    Divider(
                      height: 48.0,
                      thickness: 2.0,
                    ),
                    FutureBuilder(
                        future: null,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              height: 64.0,
                              width: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: () {
                                  _joinMeeting();
                                },
                                child: Text(
                                  "Start now",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                ),
                              ),
                            );
                          } else
                            return SizedBox(
                              height: 64.0,
                              width: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: () {
                                  _joinMeeting();
                                },
                                child: Text(
                                  "Start now",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
                                ),
                              ),
                            );
                        }),
                    SizedBox(
                      height: 48.0,
                    ),
                  ],
                ),
              );
            } else
              return CircularProgressIndicator();
          }),
    );
  }

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  _joinMeeting() async {
    String serverUrl =
        serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    try {
      var options = JitsiMeetingOptions()
        ..room = roomText.text
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        ..userEmail = emailText.text
        ..iosAppBarRGBAColor = iosAppBarRGBAColor.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted;

      debugPrint("Jitsi MeetingOptions: $options");
      await JitsiMeet.joinMeeting(options,
          listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
            debugPrint("${options.room} will join with message: $message");
          }, onConferenceJoined: ({message}) {
            debugPrint("${options.room} joined with message: $message");
          }, onConferenceTerminated: ({message}) {
            debugPrint("${options.room} terminated with message: $message");
          }));
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broad-casted with message: $message");
  }

  void _onConferenceJoined({message}) {
    debugPrint("_onConferenceJoined broad-casted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    debugPrint("_onConferenceTerminated broad-casted with message: $message");
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return HomeScreen();
    }));
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}
