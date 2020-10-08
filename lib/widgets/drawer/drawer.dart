import 'package:flutter/material.dart';
import 'package:hihellochat/widgets/drawer/futuredrawer.dart';
import 'package:hihellochat/widgets/drawer/normaldrawer.dart';
import 'package:provider/provider.dart';
import 'package:hihellochat/providers/users.dart';

class DraWer extends StatelessWidget {
  const DraWer({Key key, this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    final myData = Provider.of<Users>(context, listen: false).myData;
    return Drawer(
      child: myData == null
          ? FutureDrawer(
              userId: userId,
            )
          : NormalDrawer(),
    );
  }
}
