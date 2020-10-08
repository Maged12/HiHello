import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hihellochat/models/user.dart';

class CustomAppBar extends StatelessWidget {
  final User userData;

  CustomAppBar(
    this.userData,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .1,
//color: Colors.black45,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black38,
            Colors.black87,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            bottom: 2,
            left: 45,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              backgroundImage: userData.imageProfileUrl.isNotEmpty
                  ? CachedNetworkImageProvider(
                      userData.imageProfileUrl,
                    )
                  : AssetImage('assets/person2.png'),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 120,
            child: Text(
              userData.lastName.isEmpty
                  ? '${userData.firstName} ${userData.medName}'
                  : '${userData.firstName} ${userData.lastName}',
              style: GoogleFonts.mcLaren(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
          if (userData.isActive)
            Positioned(
              bottom: 1,
              left: 84,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 7,
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: Color(0xff00FF00),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
