import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hihellochat/models/user.dart';
import 'package:hihellochat/providers/users.dart';

import 'package:hihellochat/widgets/users/users_style.dart';
import 'package:provider/provider.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({Key key, this.userId}) : super(key: key);
  final String userId;

  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  String _searchKey = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            onChanged: (val) {
              setState(() {
                _searchKey = val;
              });
            },
            toolbarOptions: ToolbarOptions(
              copy: true,
              paste: true,
              selectAll: true,
            ),
            enableSuggestions: false,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: "Name / Email",
              hasFloatingPlaceholder: true,
              labelText: 'Search',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey),
              contentPadding: EdgeInsets.all(8),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
                size: 30,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                borderSide: BorderSide(color: Colors.green, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.green, width: 2),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            //margin: EdgeInsets.symmetric(horizontal: 3 ),
            decoration: BoxDecoration(
//                gradient: LinearGradient(
//                  begin: Alignment.topLeft,
//                  end: Alignment.bottomRight,
//                  colors: [
//                    Colors.deepPurpleAccent,
//                    Colors.deepPurple,
//                    Colors.black54,
//                   // Colors.purpleAccent,
//                  ],
//                ),
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50),
                topRight: Radius.circular(50),
              ),
            ),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .orderBy(
                    'isactive',
                    descending: true,
                  )
                  .snapshots(),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                Provider.of<Users>(context, listen: false)
                    .updateUsers(chatSnapshot.data.documents);
                if (_searchKey.trim().isNotEmpty)
                  try {
                    final List<User> searchList = Provider.of<Users>(context)
                        .getUserByNameOrEmail(_searchKey.trim());
                    if (searchList.length == 0)
                      return Center(
                        child: Text(
                          'No such Name or Email you have to type the full email to find someone with the email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      );
                    return ListView.builder(
                      itemCount: searchList.length,
                      itemBuilder: (ctx, index) {
                        if ((Provider.of<Users>(context, listen: false)
                                    .myData
                                    .email ==
                                searchList[index].email) &&
                            searchList.length == 1)
                          return Container(
                            height: MediaQuery.of(context).size.height * .4,
                            child: Center(
                              child: Text(
                                'You cannot search for yourself',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          );
                        if (Provider.of<Users>(context, listen: false)
                                .myData
                                .email ==
                            searchList[index].email) return Container();
                        return UsersStyle(
                          index: -1,
                          searchUser: searchList[index],
                        );
                      },
                    );
                  } catch (err) {}
                final chatDocs = chatSnapshot.data.documents;
                  return ListView.builder(
                      itemCount: chatDocs.length,
                      itemBuilder: (ctx, index) {
                        if (Provider.of<Users>(context, listen: false)
                            .isMe(index, widget.userId)) return Container();
                        return UsersStyle(
                          index: index,
                        );
                      });
              },
            ),
          ),
        ),
      ],
    );
  }
}
