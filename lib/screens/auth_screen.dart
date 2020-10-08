import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth/auth_form.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;
  bool _isLogin = true;
  void _changeText(bool isLogin) {
    setState(() {
      _isLogin = isLogin;
    });
  }

  void _submitAuthForm(
    String email,
    String password,
    String firstName,
    String medName,
    String lastName,
    int age,
    String gender,
    bool isLogin,
    BuildContext ctx,
  ) async {
    AuthResult authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .updateData({
          'isactive': true,
        });
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'firstname': firstName,
          'profile_url':"",
          'gender':gender,
          'medname': medName,
          'lastname': lastName,
          'age':age,
          'about':'',
          'city':'',
          'country':'',
          'image_url': "",
          'email': email,
          'userid': authResult.user.uid,
          'isactive': true,
        });
//        final ref = FirebaseStorage.instance
//            .ref()
//            .child('user_image')
//            .child(authResult.user.uid + '.png');
//        ref.putFile(imageFile).onComplete;
//        final url = ref.getDownloadURL();
//        Firestore.instance
//            .collection('users')
//            .document(authResult.user.uid)
//            .updateData({
//          'image_url': url,
//        });
//        _auth.signOut();
      }
    } on PlatformException catch (err) {
      String errorMes = 'An error occurred, please check your credentials!';
      if (err.message != null) {
        errorMes = err.message;
      }
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(
            errorMes,
          ),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.blue,
                Colors.blue[400],
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TyperAnimatedTextKit(
                    speed: Duration(milliseconds: 1000),
                    isRepeatingAnimation: false,
                    text: ['HiHello'],
                    textStyle: GoogleFonts.mcLaren(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              if (_isLogin)
                Padding(
                  padding: EdgeInsets.all(20),
                  child: FadeAnimatedTextKit(
                    text: [
                      'Login',
                      'Welcome back',
                    ],
                    repeatForever: true,
                    duration: Duration(milliseconds: 1500),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              if (!_isLogin)
                Container(
                  padding: EdgeInsets.only(
                    top: 15,
                    left: 20,
                  ),
                  child: FadeAnimatedTextKit(
                    text: [
                      'SignUp',
                      'it is great to meet you :)',
                    ],
                    repeatForever: true,
                    duration: Duration(milliseconds: 1500),
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              SizedBox(
                height: 30,
              ),
//              SizedBox(
//                height: 20,
//              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: AuthForm(
                    _submitAuthForm,
                    _isLoading,
                    _changeText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//Column(
//crossAxisAlignment: CrossAxisAlignment.start,
//children: <Widget>[
//Text(
//'Login',
//style: TextStyle(
//color: Colors.white,
//fontSize: 35,
//fontWeight: FontWeight.w700,
//),
//),
//SizedBox(
//height: 10,
//),
//Text(
//'Welcome back',
//style: TextStyle(
//color: Colors.white,
//fontSize: 18,
//),
//),
//],
//),
