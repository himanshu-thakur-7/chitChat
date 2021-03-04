import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/messages.dart' as mess;

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _messageController = TextEditingController();
  void _sendmessage() async {
    final user = await FirebaseAuth.instance.currentUser();

    final userName =
        await Firestore.instance.collection('users').document(user.uid).get();
    FocusScope.of(context).unfocus();
    mess.scrolldown();
    _messageController.clear();

    Firestore.instance.collection('chat').add(
      {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userid': user.uid,
        'username': userName['username'],
        'userImage': userName['imageurl'],
      },
    );
    _enteredMessage = '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: Colors.white),
              controller: _messageController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    28,
                  ),
                  borderSide:
                      new BorderSide(color: Theme.of(context).accentColor),
                ),
                fillColor: Colors.white,
                hintText: 'Type your message..',
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              onChanged: (val) {
                setState(
                  () {
                    _enteredMessage = val;
                  },
                );
              },
            ),
          ),
          SizedBox(
            width: 8,
          ),
          CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.6),
              child: IconButton(
                icon: Icon(Icons.send),
                color: Theme.of(context).accentColor,
                onPressed: _enteredMessage.trim().isEmpty
                    ? null
                    : () {
                        _sendmessage();
                      },
              ))
        ],
      ),
    );
  }
}
