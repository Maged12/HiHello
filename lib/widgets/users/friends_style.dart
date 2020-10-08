import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hihellochat/providers/users.dart';
import 'package:hihellochat/screens/chat_screen.dart';
import 'package:provider/provider.dart';

class FriendsStyle extends StatelessWidget {
  const FriendsStyle({this.id});
  final String id;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context).getUserById(id);
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ChatScreen(
                  userId: id,
                ),
              ),
            );
          },
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
