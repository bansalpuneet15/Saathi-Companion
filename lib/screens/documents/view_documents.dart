import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elderlycompanion/models/image.dart';
import 'package:elderlycompanion/screens/documents/document_detail_screen.dart';
import 'package:elderlycompanion/widgets/app_default.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewDocuments extends StatefulWidget {
  final String uid;
  static const String id = 'View_Documents_Screen';

  const ViewDocuments({Key key, this.uid}) : super(key: key);
  @override
  _ViewDocumentsState createState() => _ViewDocumentsState();
}

class _ViewDocumentsState extends State<ViewDocuments> {
  TextEditingController nameController;

  String userId;
  @override
  void initState() {
    nameController = TextEditingController();
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: ElderlyAppBar(),
      body: ListView(children: <Widget>[
        FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('documents')
                .doc(widget.uid)
                .collection('file')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null)
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('No Documents added'),
                      ),
                    ],
                  );
                ImageModel images = ImageModel();
                List<Widget> imageWidgets = List<Widget>();
                List<ImageClass> imageList = List<ImageClass>();
                List<ImageClass> searchImageList = List<ImageClass>();
                imageList =
                    searchImageList = images.getAllImages(snapshot.data);
                if (nameController.text.isEmpty || nameController.text == '')
                  imageWidgets = addImages(imageWidgets, imageList);
                else {
                  searchImageList = images.searchImages(nameController.text);
                  imageWidgets = addImages(imageWidgets, searchImageList);
                }
                return Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                          color: Color(0xff42495D),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular((40)),
                              bottomLeft: Radius.circular((40)))),
                      child: TextField(
                        onSubmitted: (v) {
                          if (v.isNotEmpty || v == '') {
                            setState(() {
                              searchImageList = images.searchImages(v);
                              imageWidgets =
                                  addImages(imageWidgets, searchImageList);
                            });
                          }
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50)),
                            suffixIcon: Icon(
                              Icons.search,
                              color: Colors.black,
                            ),
                            hintText: 'Search for files'),
                        controller: nameController,
                        onChanged: (v) {
                          if (v.isNotEmpty || v == '') {
                            setState(() {
                              searchImageList = images.searchImages(v);
                              imageWidgets =
                                  addImages(imageWidgets, searchImageList);
                            });
                          }
                        },
                      ),
                    ),
                    searchImageList.length > 0
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Documents ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Files not Found',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 30),
                            ),
                          ),
                    Column(
                      children: imageWidgets,
                    )
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Please wait.'),
                    ),
                    CircularProgressIndicator()
                  ],
                );
              }
            })
      ]),
    );
  }

  List<Widget> addImages(
      List<Widget> imageWidgets, List<ImageClass> imageList) {
    for (var image in imageList) {
      imageWidgets.add(InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DocumentDetail(image);
          }));
        },
        child: Hero(
          tag: image.name,
          child: Container(
            margin: EdgeInsets.only(bottom: 35),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    image.url,
                  )),
            ),
            child: SizedBox(
              width: 250,
              height: 250,
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(99),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: 250,
                      height: 35,
                      child: Center(
                        child: Text(
                          image.name,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ))),
            ),
          ),
        ),
      ));
    }

    return imageWidgets;
  }

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
  // }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
