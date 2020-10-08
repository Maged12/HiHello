import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hihellochat/models/user.dart';
import 'package:hihellochat/providers/users.dart';
import 'package:provider/provider.dart';

class NewMessageStyle extends StatelessWidget {
  NewMessageStyle({
    this.message,
    this.time,
    this.senderId,
    this.docId,
    this.chatdocId,
    this.key,
    this.isReceived,
    this.isSeen,
    this.receiverId,
  });
  final String message;
  final String senderId;
  final String receiverId;
  final String docId;
  final String chatdocId;
  final Timestamp time;
  final bool isReceived;
  final bool isSeen;
  final Key key;
  @override
  Widget build(BuildContext context) {
    final User myData = Provider.of<Users>(context, listen: false).myData;
    final bool isActive = Provider.of<Users>(context, listen: false)
        .getUserById(receiverId)
        .isActive;
    final bool isMe = myData.id == senderId;
    if (!isMe) {
      Firestore.instance
          .collection('chats')
          .document(chatdocId)
          .collection('messages')
          .document(docId)
          .updateData(
        {
          'isreceived': true,
          'isseen': true,
        },
      );
    }else{
      if(isActive){
        Firestore.instance
            .collection('chats')
            .document(chatdocId)
            .collection('messages')
            .document(docId)
            .updateData(
          {
            'isreceived': true,
          },
        );
      }
    }

    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (isMe)
          Text(
            TimeOfDay.fromDateTime(
              DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch),
            ).format(context),
            style: TextStyle(color: Colors.black),
          ),
        Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.width * 0.1,
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isMe ? Colors.blueGrey : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(80),
              topLeft: Radius.circular(80),
              bottomRight: isMe ? Radius.circular(0) : Radius.circular(80),
              bottomLeft: isMe ? Radius.circular(80) : Radius.circular(0),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                child: Text(
                  message,
                  textAlign: isMe ? TextAlign.end : TextAlign.start,
                  style: GoogleFonts.mcLaren(
                    color: isMe
                        ? Colors.white
                        : Theme.of(context).accentTextTheme.title.color,
                    fontSize: 15,
                  ),
                ),
              ),
              if (isMe)
                Icon(
                  (isReceived) ? Icons.done_all : Icons.done,
                  color: (isSeen) ? Colors.green : Colors.white,
                  size: 15,
                ),
            ],
          ),
        ),
        if (!isMe)
          Text(
            TimeOfDay.fromDateTime(
              DateTime.fromMicrosecondsSinceEpoch(time.microsecondsSinceEpoch),
            ).format(context),
            style: TextStyle(color: Colors.black),
          ),
      ],
    );
  }
}
