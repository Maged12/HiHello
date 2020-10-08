import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hihellochat/widgets/drawer/drawer.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:hihellochat/widgets/nav_bar_content/all_users.dart';
import 'package:hihellochat/widgets/nav_bar_content/my_contacts.dart';

class MainScreen extends StatefulWidget {
  MainScreen(this.userId);
  final String userId;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  int _page = 0;
  int _index = 0;
  int _flag = 2;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void sendActive() async {
    if (_flag == 1) {
      _flag = 2;
      Firestore.instance.collection('users').document(widget.userId).updateData(
        {
          'isactive': true,
        },
      );
    }
  }

  void sendNotActive() async {
    if (_flag == 2) {
      _flag = 1;
      Firestore.instance.collection('users').document(widget.userId).updateData(
        {
          'isactive': false,
        },
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _flag == 1) {
      print('active');
      sendActive();
    } else if (state == AppLifecycleState.paused && _flag == 2) {
      print('notactive');
      sendNotActive();
    }
    super.didChangeAppLifecycleState(state);
  }

  Widget appUi(int page, String userId) {
    if (page == 0) {
      return AllUsers(
        userId: widget.userId,
      );
    } else {
      return MyContacts(
        userId: widget.userId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _index,
        height: 50.0,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 30,
            color: Colors.white,
          ),
          Icon(
            Icons.contacts,
            size: 30,
            color: Colors.white,
          ),
        ],
        color: Colors.deepPurple,
        buttonBackgroundColor: Colors.deepPurple,
        backgroundColor: Colors.white,
        animationCurve: Curves.bounceOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      drawer: DraWer(
        userId: widget.userId,
      ),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          "HiHello",
          style: TextStyle(letterSpacing: 3),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.deepPurple,
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          if (details.delta.dx > 0) {
            if (_page != 1) {
              setState(() {
                _index = 1;
                _page = 1;
              });
            }
          } else if (details.delta.dx < 0) {
            if (_page != 0) {
              setState(() {
                _index = 0;
                _page = 0;
              });
            }
          }
        },
        child: appUi(
          _page,
          widget.userId,
        ),
      ),
    );
  }
}
