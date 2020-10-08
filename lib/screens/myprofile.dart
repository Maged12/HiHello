import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hihellochat/providers/users.dart';
import 'package:hihellochat/screens/edit_profile.dart';
import 'package:hihellochat/screens/image_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

enum imageStatus { cover, profile }

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  String _coverUrl;
  String _profileUrl;
  bool _loadProfile = false;
  bool _loadCover = false;
  void _getImage(
    String userId,
    imageStatus status,
  ) {
    ImagePicker()
        .getImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    )
        .then(
      (val) async {
        if (val != null) {
          if (status == imageStatus.cover) {
            setState(
              () {
                _loadCover = true;
              },
            );
            final ref = FirebaseStorage.instance
                .ref()
                .child('user_image')
                .child(userId + 'Cover.png');
            await ref.putFile(File(val.path)).onComplete;
            final url = await ref.getDownloadURL();
            Firestore.instance.collection('users').document(userId).updateData({
              'profile_url': url,
            });
            setState(() {
              _coverUrl = url.toString();
              _loadCover = false;
            });
          } else {
            setState(
              () {
                _loadProfile = true;
              },
            );
            final ref = FirebaseStorage.instance
                .ref()
                .child('user_image')
                .child(userId + '.png');
            await ref.putFile(File(val.path)).onComplete;
            final url = await ref.getDownloadURL();
            Firestore.instance.collection('users').document(userId).updateData({
              'image_url': url,
            });
            setState(() {
              _profileUrl = url.toString();
              _loadProfile = false;
            });
          }
        }
      },
    );

    //widget.imagePicked(_image);
  }

  @override
  Widget build(BuildContext context) {
    final myData = Provider.of<Users>(context).myData;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          label: Text(
            'Profile',
            style: GoogleFonts.mcLaren(),
          ),
          tooltip: "Press here to edit your profile",
          elevation: 10,
          icon: Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditProfile(),
              ),
            );
          },
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height * .4 + 80,
                  ),
                  Hero(
                    tag: myData.imageCoverUrl.isEmpty
                        ? 'Cover'
                        : myData.imageCoverUrl,
                    child: GestureDetector(
                      onTap: myData.imageCoverUrl.isNotEmpty
                          ? _loadCover
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ImageScreen(
                                        image: _coverUrl ??
                                                myData.imageCoverUrl.isEmpty
                                            ? "Cover"
                                            : myData.imageCoverUrl,
                                      ),
                                    ),
                                  );
                                }
                          : null,
                      child: !_loadCover
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: double.infinity,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                image: myData.imageCoverUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: _coverUrl == null
                                            ? CachedNetworkImageProvider(
                                                myData.imageCoverUrl,
                                              )
                                            : CachedNetworkImageProvider(
                                                _coverUrl),
                                        fit: BoxFit.cover)
                                    : null,
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(60),
                                  bottomRight: Radius.circular(60),
                                ),
                                //image:
                              ),
                            )
                          : Container(
                              child: Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: double.infinity,
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(60),
                                  bottomRight: Radius.circular(60),
                                ),
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.4 - 75,
                    right: MediaQuery.of(context).size.width * 0.5 - 75,
                    child: GestureDetector(
                      onTap: myData.imageProfileUrl.isNotEmpty
                          ? _loadProfile
                              ? null
                              : () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ImageScreen(
                                        image: _profileUrl ??
                                                myData.imageProfileUrl.isEmpty
                                            ? 'Profile'
                                            : myData.imageProfileUrl,
                                      ),
                                    ),
                                  );
                                }
                          : null,
                      child: CircleAvatar(
                        radius: 75,
                        backgroundColor: Colors.white,
                        child: _loadProfile
                            ? Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.black,
                                ),
                              )
                            : Hero(
                                tag: myData.imageProfileUrl.isEmpty
                                    ? 'Profile'
                                    : myData.imageProfileUrl,
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.white,
                                  backgroundImage:
                                      myData.imageProfileUrl.isNotEmpty
                                          ? _profileUrl == null
                                              ? CachedNetworkImageProvider(
                                                  myData.imageProfileUrl,
                                                )
                                              : CachedNetworkImageProvider(
                                                  _profileUrl,
                                                )
                                          : AssetImage('assets/person2.png'),
                                ),
                              ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 25,
                    right: MediaQuery.of(context).size.width * 0.5 - 65,
                    child: GestureDetector(
                      onDoubleTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        child: Center(
                          child: IconButton(
                            onPressed: _loadProfile
                                ? null
                                : () {
                                    _getImage(myData.id, imageStatus.profile);
                                  },
                            icon: Icon(
                              Icons.insert_photo,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 20,
                    child: Container(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            size: 15,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 60,
                    right: 15,
                    child: GestureDetector(
                      onDoubleTap: () {},
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Center(
                          child: IconButton(
                            onPressed: _loadCover
                                ? null
                                : () {
                                    _getImage(myData.id, imageStatus.cover);
                                  },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
//              SizedBox(
//                height: 75,
//              ),
              Center(
                child: Text(
                  "${myData.firstName} ${myData.medName} ${myData.lastName}",
                  style: GoogleFonts.abel(
                      fontSize: 27, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'About',
                      style: GoogleFonts.pacifico(
                        fontSize: 19,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .7,
                    height: 1,
                    color: Colors.black,
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: double.infinity,
                  child: Text(
                    myData.about.isEmpty ? "No Description" : myData.about,
                    style: GoogleFonts.mcLaren(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 20),
                child: Text(
                  'Age : ${myData.age}',
                  style: GoogleFonts.aclonica(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 20),
                child: Text(
                  'Gender : ${myData.gender}',
                  style: GoogleFonts.aclonica(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (myData.country.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 20),
                  child: Text(
                    'Country : ${myData.country}',
                    style: GoogleFonts.aclonica(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (myData.city.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'City : ${myData.city}',
                    style: GoogleFonts.aclonica(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//CachedNetworkImage(
//                                          height: 60,
//                                          width: 60,
//fit: BoxFit.cover,
//imageUrl: myData.imageCoverUrl,
//placeholder: (ctx, url) =>
//const CircularProgressIndicator(
//backgroundColor: Colors.black54,
//),
//errorWidget: (context, url, error) =>
//Image.asset(
//'person2.png',
//fit: BoxFit.cover,
//width: 60,
//height: 60,
//),
//)

//NetworkImage(myData.imageCoverUrl)
