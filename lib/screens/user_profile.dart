import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hihellochat/providers/users.dart';
import 'package:hihellochat/screens/chat_screen.dart';
import 'package:hihellochat/widgets/profile/active_picture.dart';
import 'package:provider/provider.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({
    this.userId,
  });
  final String userId;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context).getUserById(widget.userId);
//    final user2 =Provider.of<Users>(context).getUserById(userId);
//    print('user name 2 ${user2.firstName}');
//    print('user name 2 ${user2.isActive}');
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: "Press here to send a Message",
          elevation: 10,
          child: Icon(
            Icons.chat,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  userId: user.id,
                ),
              ),
            );
          },
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ActivePicture(
                isActive: user.isActive,
                imageCoverUrl: user.imageCoverUrl,
                imageProfileUrl: user.imageProfileUrl,
              ),
              Center(
                child: Text(
                  "${user.firstName} ${user.medName} ${user.lastName}",
                  style: GoogleFonts.abel(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
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
                    user.about.isEmpty ? "No Description" : user.about,
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
                  'Age : ${user.age}',
                  style: GoogleFonts.aclonica(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 20),
                child: Text(
                  'Gender : ${user.gender}',
                  style: GoogleFonts.aclonica(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (user.country.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 20),
                  child: Text(
                    'Country : ${user.country}',
                    style: GoogleFonts.aclonica(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (user.city.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'City : ${user.city}',
                    style: GoogleFonts.aclonica(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
