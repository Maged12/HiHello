import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hihellochat/models/user.dart';
import 'package:hihellochat/providers/users.dart';
import 'package:provider/provider.dart';

class NewMessage extends StatefulWidget {
  NewMessage(
    this.userId,
    this.docId,
  );
  final String userId;
  final String docId;
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> with WidgetsBindingObserver {
  final _controller = TextEditingController();
  var _enteredMessage = '';

  void _sendMessage(String myId, String userId, bool isActive) async {
    FocusScope.of(context).unfocus();
    DocumentReference ref = Firestore.instance
        .collection('chats')
        .document(widget.docId)
        .collection('messages')
        .document();
    ref.setData(
      {
        'text': _enteredMessage.trim(),
        'time': Timestamp.now(),
        'senderId': myId,
        'receiverId': userId,
        'isreceived': isActive,
        'isseen': false,
        'docId':ref.documentID,
      },
    );
//        .add(
//      {
//        'text': _enteredMessage.trim(),
//        'time': Timestamp.now(),
//        'senderId': myId,
//        'receiverId': userId,
//        'isreceived': isActive,
//        'isseen': false,
//      },
//    );
    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final User userData =
        Provider.of<Users>(context, listen: false).getUserById(widget.userId);
    final User myData = Provider.of<Users>(context, listen: false).myData;
    return Container(
//      margin: EdgeInsets.only(top: 8),
//      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      color: Colors.teal,
//      decoration: BoxDecoration(
//        gradient: LinearGradient(
//          colors: [
//            Colors.black38,
//            Colors.black87,
//          ],
//          begin: Alignment.topLeft,
//          end: Alignment.bottomRight,
//        ),
//      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: TextFormField(
                controller: _controller,
                onChanged: (val) {
                  setState(
                    () {
                      _enteredMessage = val;
                    },
                  );
                },
                toolbarOptions: ToolbarOptions(
                  copy: true,
                  paste: true,
                  selectAll: true,
                ),
                enableSuggestions: false,
                style: GoogleFonts.aclonica(),
                decoration: InputDecoration(
                  labelText: 'Send a message....',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    borderSide: BorderSide(color: Colors.green, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.green, width: 1),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send,
                color:
                    (_enteredMessage.trim().isNotEmpty) ? Colors.white : null),
            onPressed: (_enteredMessage.trim().isEmpty)
                ? null
                : () {
                    _sendMessage(
                      myData.id,
                      userData.id,
                      userData.isActive,
                    );
                  },
          ),
        ],
      ),
    );
  }
}
