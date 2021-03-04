import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePicture extends StatefulWidget {
  final void Function(File pickedImg) pickedfn;
  ProfilePicture(this.pickedfn);

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File _profilePic;
  int selectedoption = 0;
  Future<void> _setProfilePic() async {
    selectedoption = 0;
    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Choose Image from'),
              actions: [
                Row(
                  children: [
                    Column(
                      children: [
                        FlatButton.icon(
                          onPressed: () {
                            selectedoption = 1;
                            Navigator.of(ctx).pop();
                          },
                          icon: Icon(
                            Icons.camera_alt,
                            color: Theme.of(context).accentColor,
                          ),
                          label: Text(
                            'Camera',
                          ),
                          textColor: Theme.of(context).accentColor,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        FlatButton.icon(
                          onPressed: () {
                            selectedoption = 2;
                            Navigator.of(ctx).pop();
                          },
                          icon: Icon(
                            Icons.photo,
                            color: Theme.of(context).accentColor,
                          ),
                          label: Text(
                            'Gallery',
                          ),
                          textColor: Theme.of(context).accentColor,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ));
    PickedFile _pic = await ImagePicker().getImage(
      source: selectedoption == 1
          ? ImageSource.camera
          : selectedoption == 2
              ? ImageSource.gallery
              : Image.asset('images/dark.jpg'),
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _profilePic = File(_pic.path);
      if (selectedoption == 0) {
        _profilePic = null;
      }
    });
    widget.pickedfn(_profilePic);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
          radius: 52,
          backgroundImage: (selectedoption == 0 || _profilePic == null)
              ? null
              : FileImage(_profilePic),
          child: _profilePic == null
              ? Icon(
                  Icons.add_a_photo,
                  color: Theme.of(context).primaryColor,
                  size: 51,
                )
              : null,
        ),
        FlatButton.icon(
          onPressed: () {
            _setProfilePic();
          },
          icon: Icon(
            Icons.image,
            color: Theme.of(context).primaryColor,
          ),
          label: Text(
            'Profile Photo',
          ),
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
