import 'package:flutter/material.dart';
import 'package:tea_talks/services/encoding_decoding_service.dart';
import 'package:tea_talks/utility/firebase_constants.dart';
import 'package:tea_talks/utility/ui_constants.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble({
    required this.chatData,
    required this.name,
    required this.password,
  });

  final dynamic chatData;
  final String name;
  final String password;

  // UI constants
  final borderRadius = 20.0;

  @override
  Widget build(BuildContext context) {
    String documentId = chatData['id'];

    var chatContents = EncodingDecodingService.decryptAndDecode(
      chatData['data'],
      documentId,
      password,
    );

    bool isMe = (name == chatContents[kUserName]);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        margin: EdgeInsets.only(
          bottom: 5.0,
          top: 5.0,
          left: isMe ? 100.0 : 0.0,
          right: isMe ? 0.0 : 100.0,
        ),
        decoration: BoxDecoration(
          color: isMe ? kImperialOrange : kImperialOrange.withOpacity(0.08),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(isMe ? 0.0 : borderRadius),
            bottomRight: Radius.circular(isMe ? 0.0 : borderRadius),
            topLeft: Radius.circular(isMe ? borderRadius : 0.0),
            bottomLeft: Radius.circular(isMe ? borderRadius : 0.0),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              chatContents[kTimestamp].toString().split(', ')[0],
              style: kLightestTextStyle.copyWith(
                color: isMe ? kWhite : kBlack,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              chatContents[kMessageBody],
              style: kLabelTextStyle.copyWith(
                color: isMe ? kWhite : kBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
