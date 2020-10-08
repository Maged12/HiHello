//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:hihellochat/models/user.dart';
//import 'package:hihellochat/providers/users.dart';
//import 'package:provider/provider.dart';
//
//class MessageStyle extends StatelessWidget {
//  MessageStyle({
//    this.message,
//    this.time,
//    this.senderId,
//    this.receiverId,
//    this.key,
//  });
//  final String message;
//  final String senderId;
//  final String receiverId;
//  final Timestamp time;
//  final Key key;
//  @override
//  Widget build(BuildContext context) {
//    final User myData = Provider.of<Users>(context, listen: false).myData;
//    final bool isMe = myData.id == senderId;
//    return Row(
//      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//      children: <Widget>[
//        if (isMe)
//          Text(
//            TimeOfDay.fromDateTime(
//              DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch),
//            ).format(context),
//            style: TextStyle(color: Colors.black),
//          ),
//        Container(
//          constraints: BoxConstraints(
//            minHeight: MediaQuery.of(context).size.width * 0.1,
//            minWidth: MediaQuery.of(context).size.width * 0.2,
//            maxWidth: MediaQuery.of(context).size.width * 0.7,
//          ),
//          padding: EdgeInsets.all(12),
//          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
//          decoration: BoxDecoration(
//            color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
//            borderRadius: BorderRadius.only(
//              topRight: Radius.circular(12),
//              topLeft: Radius.circular(12),
//              bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
//              bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
//            ),
//          ),
//          child: Column(
//            crossAxisAlignment:
//                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//            children: <Widget>[
//              Row(
//                mainAxisSize: MainAxisSize.min,
//                children: <Widget>[
//                  if (!isMe)
//                    GestureDetector(
//                      onTap: () {
//                        print('lol');
//                        showDialog(
//                            context: context,
//                            builder: (BuildContext context) {
//                              return SimpleDialog(
//                                title: Image.network(
//                                  imageUrl,
//                                  width: double.infinity,
//                                  height: 100,
//                                  fit: BoxFit.cover,
//                                ),
//                                children: <Widget>[
//                                  SimpleDialogOption(
//                                    onPressed: () {
//                                      Navigator.pop(
//                                        context,
//                                      );
//                                    },
//                                    child: Text('Message $userName'),
//                                  ),
//                                  SimpleDialogOption(
//                                    onPressed: () {
//                                      Navigator.pop(context);
//                                    },
//                                    child: const Text('State department'),
//                                  ),
//                                ],
//                              );
//                            });
//                      },
//                      child: Padding(
//                        padding: const EdgeInsets.only(right: 8.0),
//                        child: CircleAvatar(
//                          radius: 11,
//                          backgroundColor: Colors.grey,
//                          backgroundImage: NetworkImage(imageUrl),
//
////                    ActiveIcon(
////                      imageUrl: imageUrl,
////                      isActive: isActive,
//                        ),
//                      ),
//                    ),
//                  Text(
//                    userName,
//                    style: TextStyle(
//                      fontWeight: FontWeight.bold,
//                      color: isMe
//                          ? Colors.black
//                          : Theme.of(context).accentTextTheme.title.color,
//                    ),
//                  ),
//                  if (isMe)
//                    Padding(
//                      padding: const EdgeInsets.only(left: 8),
//                      child: CircleAvatar(
//                        radius: 11,
//                        backgroundColor: Colors.grey,
//                        backgroundImage: NetworkImage(imageUrl),
//                      ),
//                    ),
//                ],
//              ),
//              Container(
//                constraints: BoxConstraints(
//                  minWidth: MediaQuery.of(context).size.width * 0.2,
//                  maxWidth: MediaQuery.of(context).size.width * 0.7,
//                ),
//                child: Text(
//                  message,
//                  textAlign: isMe ? TextAlign.end : TextAlign.start,
//                  style: TextStyle(
//                    color: isMe
//                        ? Colors.black
//                        : Theme.of(context).accentTextTheme.title.color,
//                  ),
//                ),
//              ),
//            ],
//          ),
//        ),
//        if (!isMe)
//          Text(
//            TimeOfDay.fromDateTime(
//              DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch),
//            ).format(context),
//            style: TextStyle(color: Colors.black),
//          ),
//      ],
//    );
//  }
//}
