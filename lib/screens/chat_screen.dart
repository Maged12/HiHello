import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hihellochat/models/user.dart';
import 'package:hihellochat/providers/users.dart';
import 'package:hihellochat/widgets/chat/custom_app_bar.dart';
import 'package:hihellochat/widgets/chat/new_message.dart';
import 'package:provider/provider.dart';

import '../widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    @required this.userId,
  });
  final String userId;

  String _getChatUid(String myId, String userId) {
    return (myId.compareTo(userId) > 0) ? myId + userId : userId + myId;
  }

  @override
  Widget build(BuildContext context) {
    final User userData =
        Provider.of<Users>(context, listen: false).getUserById(userId);
    final User myData = Provider.of<Users>(context, listen: false).myData;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            CustomAppBar(
              userData,
            ),
            Expanded(
              child: Messages(
                _getChatUid(myData.id, userData.id),
              ),
            ),
            NewMessage(
              userData.id,
              _getChatUid(myData.id, userData.id),
            ),
          ],
        ),
      ),
    );
  }
}
