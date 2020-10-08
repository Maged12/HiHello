import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hihellochat/screens/about_app.dart';
import 'package:hihellochat/screens/myprofile.dart';

class FutureDrawer extends StatelessWidget {
  const FutureDrawer({Key key, this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firestore.instance.collection('users').document(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
          margin: EdgeInsets.only(bottom: 10, right: 7, left: 7),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                Colors.blue,
              ],
            ),
            color: Colors.blueGrey,
            borderRadius: BorderRadius.all(
              Radius.circular(80),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .72,
                height: MediaQuery.of(context).size.height * .45,
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(120),
                    bottomRight: Radius.circular(120),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 72,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage:
                            snapshot.data["image_url"].toString().isNotEmpty
                                ? CachedNetworkImageProvider(
                                    snapshot.data["image_url"])
                                : AssetImage('assets/person2.png'),
                        radius: 70,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        '${snapshot.data["firstname"]} ${snapshot.data["medname"]} ${snapshot.data["lastname"]}',
                        style: GoogleFonts.mcLaren(
                            fontSize: 20, color: Colors.lightBlueAccent),
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyProfile()),
                  );
                },
                leading: Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.white,
                ),
                title: Text(
                  "Your Profile",
                  style: GoogleFonts.mcLaren(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.white,
                thickness: 1.5,
                indent: 10,
                endIndent: 25,
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AboutApp(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.smartphone,
                  size: 30,
                  color: Colors.white,
                ),
                title: Text(
                  "About",
                  style: GoogleFonts.mcLaren(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.white,
                thickness: 1.5,
                indent: 10,
                endIndent: 25,
              ),
              ListTile(
                onTap: () async {
                  Navigator.of(context).pop();
                  await Firestore.instance
                      .collection('users')
                      .document(userId)
                      .updateData(
                    {
                      'isactive': false,
                    },
                  );
                  //Provider.of<Users>(context,listen: false).cancelStream();
                  FirebaseAuth.instance.signOut();
                },
                leading: Icon(
                  Icons.exit_to_app,
                  size: 30,
                  color: Colors.white,
                ),
                title: Text(
                  "Log Out",
                  style: GoogleFonts.mcLaren(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
