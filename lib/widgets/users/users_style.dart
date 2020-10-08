import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hihellochat/models/user.dart';
import 'package:hihellochat/providers/users.dart';
import 'package:hihellochat/screens/user_profile.dart';
import 'package:provider/provider.dart';

class UsersStyle extends StatelessWidget {
  const UsersStyle({this.index, this.searchUser});
  final int index;
  final User searchUser;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context).getUser(index) ?? searchUser;
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => UserProfile(
                  userId: user.id,
                ),
              ),
            );
          },
          isThreeLine: true,
          leading: Stack(
            overflow: Overflow.visible,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40.0),
                child: user.imageProfileUrl.isNotEmpty
                    ? CachedNetworkImage(
                        height: 55,
                        width: 55,
                        fit: BoxFit.cover,
                        imageUrl: user.imageProfileUrl,
                        placeholder: (ctx, url) =>
                            const CircularProgressIndicator(
                          backgroundColor: Colors.black54,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          'person2.png',
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        ),
                      )
                    : CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        backgroundImage: AssetImage('person2.png'),
                      ),
              ),
              if (user.isActive)
                Positioned(
                  right: 3,
                  bottom: 0,
                  child: CircleAvatar(
                    radius: 7,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 6,
                      backgroundColor: Color(0xff00FF00),
                    ),
                  ),
                ),
            ],
          ),
          title: Text(
            '${user.firstName} ${user.medName} ${user.lastName}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w900,
              fontSize: 17,
            ),
          ),
          subtitle: Text(
            user.about.isEmpty ? 'No Description' : '${user.about}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Divider(
          endIndent: 10,
          indent: 10,
          color: Colors.black,
        ),
      ],
    );
  }
}
//Column(
//children: <Widget>[
//Container(
//padding: const EdgeInsets.all(8),
//height: 120,
//child: Row(
//mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//children: <Widget>[
////            ClipRRect(
////              borderRadius: BorderRadius.circular(50.0),
////              child: FadeInImage(
////                fit: BoxFit.cover,
////                width: 100,
////                height: 100,
////                placeholder: AssetImage('person2.png'),
////                image: NetworkImage(imageUrl),
////              ),
////            ),

//SizedBox(
//width: 150,
//child:
//textAlign: TextAlign.center,
//),
//),
//],
//),
//),

//],
//);
