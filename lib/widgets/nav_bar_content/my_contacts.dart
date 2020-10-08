import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hihellochat/providers/users.dart';
import 'package:hihellochat/widgets/users/friends_style.dart';
import 'package:provider/provider.dart';

class MyContacts extends StatelessWidget {
  const MyContacts({Key key, this.userId}) : super(key: key);
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: FutureBuilder(
        future: Firestore.instance
            .collection('users')
            .document(userId)
            .collection('contacts')
            .getDocuments(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> contactsSnapshot) {
          if (contactsSnapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Column(
                children: <Widget>[
                  LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  Expanded(child: Container(),),
                ],
              ),
            );
          }
          final contDocs = contactsSnapshot.data.documents;
          return ListView.builder(
            itemCount: contDocs.length,
            itemBuilder: (ctx, index) {
              return StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .document(contDocs[index].documentID)
                    .snapshots(),
                builder: (ctx, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  Provider.of<Users>(context).updateUser(userSnapshot.data);
                  return FriendsStyle(
                    id: userSnapshot.data.data['userid'],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
