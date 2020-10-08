import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String email;
  final String firstName;
  final String medName;
  final String lastName;
  final String imageProfileUrl;
  final String imageCoverUrl;
  final String gender;
  final String country;
  final String city;
  final String about;
  final int age;
  final bool isActive;

  User({
    @required this.id,
    @required this.email,
    @required this.firstName,
    @required this.medName,
    @required this.lastName,
    @required this.imageProfileUrl,
    @required this.imageCoverUrl,
    @required this.gender,
    @required this.country,
    @required this.city,
    @required this.about,
    @required this.age,
    @required this.isActive,
  });
}
