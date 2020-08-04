import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File image) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedFile = await picker.getImage(
                      source: ImageSource.camera,
                      imageQuality: 95,
                      maxWidth: 950,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _image = File(pickedFile.path);
                      });
                      widget.imagePickFn(File(pickedFile.path));
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Feather.camera),
                      Text('Camera'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedFile =
                        await picker.getImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _image = File(pickedFile.path);
                      });
                      widget.imagePickFn(File(pickedFile.path));
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(AntDesign.picture),
                      Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white30,
          backgroundImage: _image != null ? FileImage(_image) : null,
          child: _image == null
              ? Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.black.withOpacity(.2),
                )
              : null,
        ),
        InkWell(
          onTap: _pickImage,
          child: CircleAvatar(
            backgroundColor: Colors.pink.withOpacity(0.7),
            radius: 15,
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
      ],
    );
  }
}
