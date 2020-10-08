import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading, this.changeTx);
  final bool isLoading;
  final void Function(
    String email,
    String password,
    String firstName,
    String medName,
    String lastName,
    int age,
    String gender,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  final void Function(bool isLogin) changeTx;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _firstName = '';
  String _medName = '';
  String _lastName = '';
  String _gender = 'Male';
  String _userPassword = '';
  int _age = 0;
  bool _obscureText = true;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _firstName.trim(),
        _medName.trim(),
        _lastName.trim(),
        _age,
        _gender,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        borderOnForeground: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 20,
        color: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
          side: BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),

        // color: Colors.white,
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      key: ValueKey('email'),
                      enableSuggestions: false,
                      style: GoogleFonts.aclonica(),
                      toolbarOptions: ToolbarOptions(
                        copy: true,
                        paste: true,
                        selectAll: true,
                      ),
                      validator: (val) {
                        if (val.isEmpty || !val.contains('@')) {
                          return "Please Enter a valid email address.";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Email address",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Theme.of(context).accentColor,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                      ),
                      onSaved: (val) {
                        _userEmail = val;
                      },
                    ),
                  ),
                  if (!_isLogin)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        key: ValueKey('name'),
                        style: GoogleFonts.aclonica(),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          paste: true,
                          selectAll: true,
                        ),
                        validator: (val) {
                          if (val.isEmpty || val.length < 8) {
                            return "Please Enter at least 8 characters.";
                          }
                          if (!(val.trim().split(" ").length >= 2 &&
                              val.trim().split(" ").length <= 3)) {
                            return "Name must contains two words at least";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Name",
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).accentColor,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.green, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                        onSaved: (val) {
                          final List<String> name = val.split(' ');
                          _firstName = name[0];
                          _medName = name[1];
                          if (name.length > 2)
                            _lastName = name[2];
                          else
                            _lastName = '';
                        },
                      ),
                    ),
                  if (!_isLogin)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        key: ValueKey('age'),
                        style: GoogleFonts.aclonica(),
                        enableSuggestions: false,
                        keyboardType: TextInputType.number,
                        toolbarOptions: ToolbarOptions(
                          copy: true,
                          paste: true,
                          selectAll: true,
                        ),
                        validator: (val) {
                          if (val.isEmpty) {
                            return "Age can't be Empty";
                          }
                          if (int.tryParse(val.trim()) == null) {
                            return "Bad age format please change it";
                          }
                          if (int.tryParse(val.trim()) < 8) {
                            return "You must be more than 8 years old.";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Age",
                          prefixIcon: Icon(
                            Icons.update,
                            color: Theme.of(context).accentColor,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.green, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                        onSaved: (val) {
                          _age = int.tryParse(val.trim());
                        },
                      ),
                    ),
                  if (!_isLogin)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: DropdownButtonFormField(
                        value: _gender,
                        isDense: true,
                        decoration: InputDecoration(
                          hintText: "Gender",
                          hintStyle: GoogleFonts.aclonica(),
                          prefixIcon: Icon(
                            Icons.accessibility,
                            color: Theme.of(context).accentColor,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0)),
                            borderSide:
                                BorderSide(color: Colors.green, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Colors.green, width: 2),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            child: Text(
                              'Male',
                              style: GoogleFonts.aclonica(),
                            ),
                            value: 'Male',
                          ),
                          DropdownMenuItem(
                            child: Text(
                              'Female',
                              style: GoogleFonts.aclonica(),
                            ),
                            value: 'Female',
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _gender = value.toString();
                          });
                        },
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      key: ValueKey('password'),
                      style: GoogleFonts.aclonica(),
                      enableSuggestions: false,
                      toolbarOptions: ToolbarOptions(
                        copy: true,
                        paste: true,
                        selectAll: true,
                      ),
                      validator: (val) {
                        if (val.isEmpty || val.length < 7) {
                          return "Password must be at least 7 characters Long.";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: _obscureText
                                ? Theme.of(context).accentColor
                                : Theme.of(context).errorColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                        hintText: "Password",
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Theme.of(context).accentColor,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                      ),
                      obscureText: _obscureText,
                      onSaved: (val) {
                        _userPassword = val;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      splashColor: Colors.black,
                      onPressed: _trySubmit,
                      child: Container(
                        width: double.infinity,
                        height: 40,
                        child: Center(
                          child: Text(
                            _isLogin ? 'Login' : 'SignUp',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      color: Colors.blue,
                    ),
                  if (!widget.isLoading)
                    FlatButton(
                      textColor: Colors.white,
                      onPressed: () {
                        widget.changeTx(!_isLogin);
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(
                        _isLogin ? 'Creat new account' : "Already have account",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
