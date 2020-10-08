import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hihellochat/models/user.dart';
import 'package:hihellochat/providers/users.dart';
import 'package:hihellochat/widgets/profile/edit_form_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = false;
  String _snakemassage = '';
  String _name = '';
  String _about = '';
  int _age;
  String _gender = '';
  String _country = '';
  String _city = '';
  User _myData;

  String _nameValidation(String val) {
    _snakemassage = '';
    if (val.isEmpty) {
      _snakemassage += "> Name can't be empty.\n";
      return '*';
    } else if (!(val.trim().split(" ").length >= 2 &&
        val.trim().split(" ").length <= 3)) {
      _snakemassage +=
          "> Please enter a valid Name that contains firstname, midname (optional), lastname.\n";
      return '*';
    } else if (val.trim().length > 25) {
      _snakemassage += "> Name can't be more than 25 letters.\n";
      return '*';
    } else if (val.trim().split(' ').contains('[A-Za-z]+|[ء-ي]+')) {
      _snakemassage += '> only Arabic and English alphabet are allowed.\n';
      return '*';
    }
    return null;
  }

  String _aboutValidation(String val) {
    if (val.trim().toLowerCase().contains('fuck')) {
      _snakemassage += "> The F word isn't allowed in the about section.\n";
      return '*';
    }
    return null;
  }

  String _ageValidation(String val) {
    if (val.isEmpty) {
      _snakemassage += "> age can't be empty \n";
      return '*';
    } else if (int.tryParse(val.trim()) == null) {
      _snakemassage += "> bad age format please change it\n";
      return '*';
    }
    return null;
  }

  void _nameSave(String val) {
    _name = val.trim();
  }

  void _aboutSave(String val) {
    _about = val.trim();
  }

  void _ageSave(String val) {
    _age = int.tryParse(val.trim()) ?? 20;
  }

  void _countrySave(String val) {
    _country = val.trim();
  }

  void _citySave(String val) {
    _city = val.trim();
  }

  void _onSubmit(
    String id,
    String name,
    String about,
    int age,
    String country,
    String city,
  ) async {
    final List<String> nameList = name.split(' ');
    final String firstName = nameList[0];
    final String medName = nameList[1];
    final String lastName = nameList.length > 2 ? nameList[2] : '';
    setState(() {
      _isLoading = true;
    });
    Firestore.instance.collection('users').document(id).updateData(
      {
        'firstname': firstName,
        'medname': medName,
        'lastname': lastName,
        'about': about,
        'age': age,
        'country': country,
        'city': city,
      },
    ).then((_) {
      setState(() {
        _isLoading = false;
      });
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }).timeout(Duration(seconds: 10), onTimeout: () {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            'Network problem please check your network',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(seconds: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      _onSubmit(_myData.id, _name, _about, _age, _country, _city);
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(
            _snakemassage,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          duration: Duration(seconds: 4),
//          action: SnackBarAction(
//            textColor: Colors.blue,
//            onPressed: () {},
//            label: 'lol',
//          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _myData = Provider.of<Users>(context).myData;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: _isLoading ? false : true,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.pacifico(),
        ),
        centerTitle: true,
      ),
      key: _scaffoldKey,
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _trySubmit,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.save,
                color: Colors.white,
              ),
            ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
//              Colors.orangeAccent,
//              Colors.orange,
//              Colors.orange[600],
              Colors.black,
              Colors.blue
            ],
          ),
        ),
        child: Center(
          child: _isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text(
                      'Please wait... ',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        EditFormField(
                          hint: 'Name',
                          icon: Icons.person,
                          type: TextInputType.text,
                          data: TextEditingController(
                            text:
                                "${_myData.firstName} ${_myData.medName} ${_myData.lastName}",
                          ),
                          onValidation: _nameValidation,
                          onSave: _nameSave,
                        ),
                        EditFormField(
                          hint: 'About',
                          icon: Icons.assignment,
                          type: TextInputType.text,
                          data: TextEditingController(text: _myData.about),
                          onValidation: _aboutValidation,
                          onSave: _aboutSave,
                        ),
                        EditFormField(
                          hint: 'Age',
                          icon: Icons.update,
                          type: TextInputType.number,
                          data: TextEditingController(
                              text: _myData.age.toString()),
                          onValidation: _ageValidation,
                          onSave: _ageSave,
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: DropdownButtonFormField(
                            value: _gender.isEmpty ? _myData.gender : _gender,
                            isDense: true,
//                      itemHeight: 48,
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
                        EditFormField(
                          hint: 'Country',
                          icon: Icons.map,
                          type: TextInputType.text,
                          data: TextEditingController(text: _myData.country),
                          onValidation: (_) {
                            return null;
                          },
                          onSave: _countrySave,
                        ),
                        EditFormField(
                          hint: 'City',
                          icon: Icons.home,
                          type: TextInputType.text,
                          data: TextEditingController(text: _myData.city),
                          onValidation: (_) {
                            return null;
                          },
                          onSave: _citySave,
                        ),
                        SizedBox(
                          height: 50,
                        ),
//                  Padding(
//                    padding: const EdgeInsets.all(8),
//                    child: TextFormField(
//                      validator: (val) {
//                        _scaffoldKey.currentState.showSnackBar(
//                          SnackBar(
//                            content: Text(
//                              _nameValidation(val),
//                              textAlign: TextAlign.center,
//                            ),
//                            duration: Duration(seconds: 1),
//                            action: SnackBarAction(
//                              textColor: Colors.blue,
//                              onPressed: () {},
//                              label: 'lol',
//                            ),
//                            shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(50)),
//                          ),
//                        );
//                        return null;
//                      },
//                      keyboardType: TextInputType.text,
//                      decoration: InputDecoration(
//                        hintText: "Name",
//                        prefixIcon: Icon(
//                          Icons.person,
//                          color: Theme.of(context).accentColor,
//                        ),
//                        filled: true,
//                        fillColor: Colors.white,
//                        enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                          borderSide: BorderSide(color: Colors.green, width: 2),
//                        ),
//                        focusedBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                          borderSide: BorderSide(color: Colors.green, width: 2),
//                        ),
//                      ),
//                      onSaved: (val) {
//                        _name = val;
//                      },
//                    ),
//                  ),
//                  Padding(
//                    padding: const EdgeInsets.all(8),
//                    child: TextFormField(
//                      validator: (val) {
////                        _scaffoldKey.currentState.showSnackBar(
////                          SnackBar(
////                            content: Text(
////                              _nameValidation(val),
////                              textAlign: TextAlign.center,
////                            ),
////                            duration: Duration(seconds: 1),
////                            action: SnackBarAction(
////                              textColor: Colors.blue,
////                              onPressed: () {},
////                              label: 'lol',
////                            ),
////                            shape: RoundedRectangleBorder(
////                                borderRadius: BorderRadius.circular(50)),
////                          ),
////                        );
//                        return null;
//                      },
//                      keyboardType: TextInputType.text,
//                      decoration: InputDecoration(
//                        hintText: "About",
//                        prefixIcon: Icon(
//                          Icons.assignment,
//                          color: Theme.of(context).accentColor,
//                        ),
//                        filled: true,
//                        fillColor: Colors.white,
//                        enabledBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                          borderSide: BorderSide(color: Colors.green, width: 2),
//                        ),
//                        focusedBorder: OutlineInputBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                          borderSide: BorderSide(color: Colors.green, width: 2),
//                        ),
//                      ),
//                      onSaved: (val) {
//                        _about = val;
//                      },
//                    ),
//                  ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
