import 'dart:io';

import 'package:chit_chat/widgets/profile_pic_setter.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn);
  final Future<void> Function(
    String email,
    String password,
    String userName,
    File img,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  var _isLogin = true;
  var isloading = false;
  File _usrImgFile;
  void _pickedImage(File image) {
    _usrImgFile = image;
  }

  @override
  Widget build(BuildContext context) {
    final _form = GlobalKey<FormState>();
    void _submitForm() async {
      bool isValid = _form.currentState.validate();

      if (_usrImgFile == null && !_isLogin) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a profile picture'),
            backgroundColor: Colors.black,
          ),
        );
        return;
      }

      if (isValid) {
        //  FocusScope.of(context).unfocus();
        _form.currentState.save();

        setState(() {
          isloading = true;
        });
        await widget.submitFn(_userEmail.trim(), _userPassword.trim(),
            _userName.trim(), _usrImgFile, _isLogin, context);
        setState(() {
          isloading = false;
        });
      }
    }

    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Colors.white,
              Colors.grey.withOpacity(0.7),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) ProfilePicture(_pickedImage),
                    TextFormField(
                      validator: (Value) {
                        if (Value.isEmpty ||
                            (!(Value.contains('@') &&
                                Value.contains('.com')))) {
                          return 'Please enter a valid email address.';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email)),
                      onSaved: (val) {
                        _userEmail = val;
                        //  print(_userEmail);
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Please enter a username (atleast 4 characters).';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Username',
                            icon: Icon(Icons.account_circle)),
                        onSaved: (val) {
                          _userName = val;
                          //  print(_userName);
                        },
                      ),
                    TextFormField(
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Please enter a password (atleast 7 characters).';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        icon: Icon(Icons.security),
                      ),
                      obscureText: true,
                      obscuringCharacter: '*',
                      onSaved: (val) {
                        _userPassword = val;
                        //  print(_userPassword);
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    isloading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : RaisedButton(
                            onPressed: () {
                              _submitForm();
                            },
                            child: Text(_isLogin ? 'Login' : 'Signup'),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                          ),
                    if (!isloading)
                      FlatButton(
                        child: Text(_isLogin
                            ? 'Create Account'
                            : 'I already have an account'),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        textColor: Theme.of(context).accentColor.withRed(140),
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
