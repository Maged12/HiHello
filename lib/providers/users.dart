import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class Users with ChangeNotifier {
  List<User> _users = [];
  User _myData;
  User get myData {
    return _myData;
  }

  List<User> get users {
    return [..._users];
  }

//  StreamSubscription streamSubscription;
//  User getMyData(String userId){
//    return _users.firstWhere((val){
//      return val.id == userId;
//    });
//  }

  void updateUsers(List<DocumentSnapshot> docList) {
    _users = docList
        .map(
          (doc) => User(
            email: doc.data['email'],
            firstName: doc.data['firstname'],
            medName: doc.data['medname'],
            lastName: doc.data['lastname'],
            imageProfileUrl: doc.data['image_url'],
            id: doc.data['userid'],
            about: doc.data['about'],
            age: doc.data['age'],
            city: doc.data['city'],
            country: doc.data['country'],
            gender: doc.data['gender'],
            imageCoverUrl: doc.data['profile_url'],
            isActive: doc.data['isactive'],
          ),
        )
        .toList();
  }

  void updateUser(DocumentSnapshot userSnapshot) {
    final newUser = User(
      email: userSnapshot.data['email'],
      firstName: userSnapshot.data['firstname'],
      medName: userSnapshot.data['medname'],
      lastName: userSnapshot.data['lastname'],
      imageProfileUrl: userSnapshot.data['image_url'],
      id: userSnapshot.data['userid'],
      about: userSnapshot.data['about'],
      age: userSnapshot.data['age'],
      city: userSnapshot.data['city'],
      country: userSnapshot.data['country'],
      gender: userSnapshot.data['gender'],
      imageCoverUrl: userSnapshot.data['profile_url'],
      isActive: userSnapshot.data['isactive'],
    );
    final int index = _users.indexWhere((user) {
      return user.id == newUser.id;
    });
    _users.removeAt(index);
    _users.insert(index, newUser);
  }

  User getUser(int index) {
    return (index >= 0) ? _users[index] : null;
  }

  List<User> getUserByNameOrEmail(String searchWord) {
    List<User> users = [];
    try {
      users.add(
        _users.firstWhere(
          (user) {
            return user.email == searchWord;
          },
        ),
      );
    } catch (err) {}
    users.addAll(
      _users.where((user) {
        final String name = user.firstName + user.medName + user.lastName;
        return name.toUpperCase().contains(searchWord.toUpperCase());
      }),
    );
    return users;
  }

  User getUserById(String userId) {
    User user = _users.firstWhere((user) {
      return user.id == userId;
    });
    return user;
  }

  bool isMe(int index, String userid) {
    if (_users[index].id == userid) {
      _myData = _users[index];
      return true;
    }
    return false;
  }

//  void cancelStream() async {
//    print('cancle');
//    await streamSubscription.cancel();
//  }

}
//  Future<int> update() async{
//         var result = stream.map((qShot) => qShot.documents
//        .map(
//          (doc) => User(
//            email: doc.data['email'],
//            firstName: doc.data['firstname'],
//            lastName: doc.data['lastname'],
//            imageProfileUrl: doc.data['image_url'],
//            id: doc.data['userid'],
//            about: doc.data['about'],
//            age: doc.data['age'],
//            city: doc.data['city'],
//            country: doc.data['country'],
//            gender: doc.data['gender'],
//            imageCoverUrl: doc.data['profile_url'],
//            isActive: doc.data['isactive'],
//          ),
//        ).toList()
//        ).first;
//     _users = await result;
//     print(_users.length);
//     return _users.length;
//     _users.forEach((user) {
//       print(user.firstName);
//     });
//    Future<List<User>> result;
//    int length = 0 ;
//    streamSubscription = stream.listen(
//      (value) {
//        print(value);
//        _users = value.documents
//            .map(
//              (doc) => User(
//                email: doc.data['email'],
//                firstName: doc.data['firstname'],
//                lastName: doc.data['lastname'],
//                imageProfileUrl: doc.data['image_url'],
//                id: doc.data['userid'],
//                about: doc.data['about'],
//                age: doc.data['age'],
//                city: doc.data['city'],
//                country: doc.data['country'],
//                gender: doc.data['gender'],
//                imageCoverUrl: doc.data['profile_url'],
//                isActive: doc.data['isactive'],
//              ),
//            )
//            .toList();
//      },
//    );
//    print(_users.length);
//    return _users.length;
//  }

////    StreamBuilder(stream: Firestore.instance
////        .collection('users')
////        .orderBy(
////      'isactive',
////      descending: true,
////    )
////        .snapshots(),builder: (ctx, chatSnapshot),);

////     var result = stream.map((qShot) => qShot.documents
////        .map(
////          (doc) => User(
////            email: doc.data['email'],
////            firstName: doc.data['firstname'],
////            lastName: doc.data['lastname'],
////            imageProfileUrl: doc.data['image_url'],
////            id: doc.data['userid'],
////            isActive: doc.data['isactive'],
////          ),
////        ).toList()
////        ).first;
////     _users = await result;
////     _users.forEach((user) {
////       print(user.firstName);
////     });
