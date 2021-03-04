import 'package:chit_chat/widgets/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final controlScroll = ScrollController();
void scrolldown() {
  controlScroll.animateTo(
    0.0,
    duration: Duration(milliseconds: 300),
    curve: Curves.fastOutSlowIn,
  );
}

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return StreamBuilder(
          stream: Firestore.instance
              .collection('chat')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data.documents;

            return ListView.builder(
              controller: controlScroll,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (ctx, index) {
                return MessageBubble(
                  chatDocs[index]['text'],
                  chatDocs[index]['userid'] == snapshot.data.uid,
                  chatDocs[index]['username'],
                  chatDocs[index]['userImage'],
                  key: ValueKey(
                    chatDocs[index].documentID,
                  ),
                );
              },
              itemCount: chatDocs.length,
            );
          },
        );
      },
    );
  }
}
