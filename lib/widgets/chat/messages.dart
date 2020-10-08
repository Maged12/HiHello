import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hihellochat/widgets/chat/new_message_style.dart';

class Messages extends StatelessWidget {
  Messages(this.docId);
  final String docId;

  String getTime(Timestamp time) {
    int day = time.toDate().day;
    int mon = time.toDate().month;
    String month = mon < 10 ? '0$mon' : mon.toString();
    int year = time.toDate().year;
    String date = '';
    if (DateTime.now().day - time.toDate().day < 1) {
      date = 'Today';
    } else if (DateTime.now().day - time.toDate().day < 2) {
      date = 'Yesterday';
    } else {
      date = '$day/$month/$year';
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue,
            Colors.white54,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('chats')
            .document(docId)
            .collection('messages')
            .orderBy(
              'time',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final chatDocs = chatSnapshot.data.documents;
          if (chatDocs.length == 1) {
            print('added');
            try {
              CollectionReference ref = Firestore.instance.collection('users');
              ref
                  .document(chatDocs[0]['senderId'])
                  .collection('contacts')
                  .document(chatDocs[0]['receiverId'])
                  .setData(
                {
                  'id': chatDocs[0]['receiverId'],
                },
                merge: true,
              );
              ref
                  .document(chatDocs[0]['receiverId'])
                  .collection('contacts')
                  .document(chatDocs[0]['senderId'])
                  .setData(
                {
                  'id': chatDocs[0]['senderId'],
                },
                merge: true,
              );
            } on PlatformException catch (err) {
              print(err.message);
            }
          }
          return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (ctx, index) {
                return Column(
                  children: <Widget>[
                    if (index < chatDocs.length - 1 &&
                        chatDocs[index]['time'].toDate().day !=
                            chatDocs[index + 1]['time'].toDate().day)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          getTime(chatDocs[index]['time']),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),
                    if (index == chatDocs.length - 1)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Text(
                          getTime(chatDocs[index]['time']),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                      ),

                    NewMessageStyle(
                      message: chatDocs[index]['text'],
                      time: chatDocs[index]['time'],
                      senderId: chatDocs[index]['senderId'],
                      docId: chatDocs[index]['docId'],
                      chatdocId: docId,
                      receiverId: chatDocs[index]['receiverId'],
                      isReceived: chatDocs[index]['isreceived'],
                      isSeen: chatDocs[index]['isseen'],
                      key: ValueKey(chatDocs[index].documentID),
                    )
                  ],
                );

              });
        },
      ),
    );
  }
}
