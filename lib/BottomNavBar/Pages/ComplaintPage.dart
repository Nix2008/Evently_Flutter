import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently/BottomNavBar/Pages/MapPage.dart';
import 'package:flutter/material.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:url_launcher/url_launcher.dart';

class ComplaintPage extends StatefulWidget {
  @override
  _ComplaintPageState createState() => _ComplaintPageState();
}

class _ComplaintPageState extends State<ComplaintPage> {
  @override
  void initState() {
    super.initState();
    getDriversList().then((results) {
      setState(() {
        querySnapshot = results;
      });
    });
  }

  QuerySnapshot querySnapshot;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showDrivers(),
    );
  }

  Widget showDrivers() {
    if (querySnapshot != null) {
      return ListView.builder(
        primary: false,
        itemCount: querySnapshot.documents.length,
        padding: EdgeInsets.all(12),
        itemBuilder: (context, i) {
          return Column(
            children: <Widget>[
              ExpansionTileCard(
                leading: CircleAvatar(
                  child: Text("new"),
                ),
                title: Text("${querySnapshot.documents[i].data['Title']}"),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text("${querySnapshot.documents[i].data['Date']}"),
                    Text("${querySnapshot.documents[i].data['Category']}"),
                  ],
                ),
                children: <Widget>[
                  Divider(
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                          "${querySnapshot.documents[i].data['Description']}"),
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    buttonHeight: 52.0,
                    buttonMinWidth: 90.0,
                    children: <Widget>[
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        onPressed: () {
                          _launchURL();
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.navigate_before),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Text('Navigate me'),
                          ],
                        ),
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MapPage()),
                          );
                        },
                        child: Column(
                          children: <Widget>[
                            Icon(Icons.open_in_browser),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Text('Open'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      );
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  _launchURL() async {
    const url = 'https://goo.gl/maps/xFJ8h4dwZX53rnxa6';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  //get firestore instance
  getDriversList() async {
    return await Firestore.instance.collection('events').getDocuments();
  }
}
