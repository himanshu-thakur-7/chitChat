import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isme;
  final Key key;
  final String userName;
  final String url;
  MessageBubble(this.message, this.isme, this.userName, this.url, {this.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          key: key,
          mainAxisAlignment:
              isme ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isme
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: isme ? Radius.circular(12) : Radius.circular(0),
                  bottomRight: isme ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: 150,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            Theme.of(context).accentTextTheme.headline6.color,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    message,
                    style: (TextStyle(
                      color: Theme.of(context).accentTextTheme.headline5.color,
                    )),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: -10,
          left: isme ? null : 120,
          right: isme ? 120 : null,
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(url),
          ),
        )
      ],
      overflow: Overflow.visible,
    );
  }
}
