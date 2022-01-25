import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:tea_talks/services/encryption_service.dart';
import 'package:tea_talks/utility/firebase_constants.dart';
import 'package:tea_talks/utility/ui_constants.dart';
import 'package:tea_talks/widgets/card_text_field.dart';

class AddRoomScreen extends StatefulWidget {
  @override
  _AddRoomScreenState createState() => _AddRoomScreenState();
}

class _AddRoomScreenState extends State<AddRoomScreen> {
  final _firestore = FirebaseFirestore.instance;

  final _roomNameController = TextEditingController();
  final _roomPasswordController = TextEditingController();

  bool showProgress = false;

  void createNewRoom() async {
    setState(() {
      showProgress = true;
    });

    String inputRoomName = _roomNameController.text.trim();
    String inputRoomPassword = _roomPasswordController.text.trim();

    _roomPasswordController.clear();
    _roomNameController.clear();

    assert(inputRoomName.isNotEmpty);
    assert(inputRoomPassword.isNotEmpty);

    var ref = _firestore.collection(kRoomCollection).doc();

    String roomId = ref.id;
    String roomName = inputRoomName;
    String roomCreationDate =
        DateFormat('HH:mm, dd MMMM, yyyy').format(DateTime.now());
    String encryptedRoomId =
        EncryptionService.encrypt(roomId, inputRoomPassword, roomId);

    await ref.set({
      kRoomId: roomId,
      kEncryptedRoomId: encryptedRoomId,
      kRoomName: roomName,
      kRoomCreationDate: roomCreationDate,
    });

    // close the screen
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _roomPasswordController.dispose();
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSteelBlue,
      body: ModalProgressHUD(
        inAsyncCall: showProgress,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Add a new Room',
                  style: kHeadingTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'To add a new room, please enter a password. After which, you will be provided with an auto-generated Room ID. Share the ID with other\'s to allow them to join your room.',
                  style: kLightLabelTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                CardTextField(
                  controller: _roomNameController,
                  labelText: 'Room Name',
                  keyboardType: TextInputType.visiblePassword,
                  iconData: FontAwesomeIcons.napster,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                CardTextField(
                  controller: _roomPasswordController,
                  obscureText: true,
                  labelText: 'New Room Password',
                  keyboardType: TextInputType.visiblePassword,
                  iconData: FontAwesomeIcons.lock,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  //padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  child: const Text(
                    'Create Room',
                    style: kGeneralTextStyle,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    primary: kImperialOrange,
                    onPrimary: kWhite,
                    elevation: 10.0,
                  ),
                  onPressed: createNewRoom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
