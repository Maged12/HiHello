import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  const ImageUpload(
    this.imagePicked,
  );
  final void Function(File pickedImage) imagePicked;
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File _image;
  void _getImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    setState(() {
      _image = File(pickedFile.path);
    });
    widget.imagePicked(_image);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          minRadius: 20,
          maxRadius: 40,
          backgroundImage: _image == null
              ? AssetImage('person${Random().nextInt(2) + 1}.png')
              : FileImage(_image),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _getImage,
          icon: Icon(Icons.photo_library),
          label: Text(
            'Upload image from the gallery',
          ),
        )
      ],
    );
  }
}
