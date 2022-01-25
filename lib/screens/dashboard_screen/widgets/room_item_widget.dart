import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tea_talks/screens/messaging_screen/messaging_screen.dart';
import 'package:tea_talks/services/encryption_service.dart';
import 'package:tea_talks/utility/firebase_constants.dart';
import 'package:tea_talks/utility/ui_constants.dart';
import 'package:tea_talks/widgets/card_text_field.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class RoomItemWidget extends StatelessWidget {
  RoomItemWidget({
    required this.roomData,
    required this.showProgressIndicator,
    required this.context,
  });

  final context;
  final roomData;
  final showProgressIndicator;

  void showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 1500),
        content: Text(
          error,
          style: kLabelTextStyle.copyWith(color: kWhite),
        ),
      ),
    );
  }

  void navigate(var password) async {
    String udid = await FlutterUdid.udid;

    final route = MaterialPageRoute(
      builder: (ctx) => MessagingScreen(
        roomData: roomData,
        password: password,
        name: udid,
      ),
    );

    // move to new screen
    Navigator.push(context, route);
  }

  void enterRoom(String roomId, String password, var context) async {
    Navigator.pop(context);

    showProgressIndicator(true);

    try {
      assert(password.isNotEmpty);

      final docSnapshot = await FirebaseFirestore.instance
          .collection(kRoomCollection)
          .doc(roomId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data;

        String actualRoomId = (data() as dynamic)[kRoomId];
        String encryptedRoomId = (data() as dynamic)[kEncryptedRoomId];
        String decryptedRoomId = '';

        try {
          decryptedRoomId = EncryptionService.decrypt(
              actualRoomId, password, encryptedRoomId);
        } catch (_) {
          showProgressIndicator(false);
          showError('Wrong Password');
          return;
        }

        if (decryptedRoomId == roomId) {
          showProgressIndicator(false);
          navigate(password);
        }
      } else {
        showProgressIndicator(false);
        showError('Room does not exists');
      }
    } catch (e) {
      if (e.toString().toLowerCase().contains('assertion')) {
        showProgressIndicator(false);
        showError('Password can\'t be empty');
      } else {
        showError('Invalid Room ID');
        showProgressIndicator(false);
      }
    }
  }

  void showLoginDialog(var context) {
    final passwordController = TextEditingController();

    final alertBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      side: const BorderSide(
        width: 2.0,
        color: kImperialOrange,
      ),
    );

    final alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: true,
      isOverlayTapDismiss: false,
      alertBorder: alertBorder,
      titleStyle:
          kHeadingTextStyle.copyWith(color: kImperialOrange, fontSize: 30),
    );

    final alertContent = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(height: 5),
        Text(
          'Room ID ${roomData[kRoomId]}',
          style: kLabelTextStyle,
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 10),
        CardTextField(
          iconData: FontAwesomeIcons.lock,
          controller: passwordController,
          labelText: 'Password',
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
        ),
      ],
    );

    final dialogButton = DialogButton(
      height: 50,
      width: 120,
      onPressed: () => enterRoom(
        roomData[kRoomId],
        passwordController.text.trim(),
        context,
      ),
      child: const Text(
        "Verify",
        style: kGeneralTextStyle,
      ),
    );

    Alert(
      style: alertStyle,
      context: context,
      title: roomData[kRoomName],
      content: alertContent,
      buttons: [
        dialogButton,
      ],
      closeFunction: () {},
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: kImperialOrange, width: 1),
    );

    const contentPadding = EdgeInsets.symmetric(
      vertical: 10,
      horizontal: 10,
    );

    return Card(
      color: Colors.white,
      elevation: 5,
      shape: shape,
      margin: const EdgeInsets.only(
        bottom: 5,
        top: 10,
      ),
      child: InkWell(
        onTap: () => showLoginDialog(context),
        splashColor: kImperialOrange.withAlpha(100),
        child: Padding(
          padding: contentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                roomData[kRoomName],
                style: kHeadingTextStyle.copyWith(fontSize: 30, color: kBlack),
              ),
              const SizedBox(height: 20),
              Text(
                'Room ID: ${roomData[kRoomId]}',
                style: kGeneralTextStyle.copyWith(fontSize: 15, color: kBlack),
              ),
              Text(
                'created at ${roomData[kRoomCreationDate]}',
                style: kLabelTextStyle.copyWith(fontSize: 15, color: kBlack),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
