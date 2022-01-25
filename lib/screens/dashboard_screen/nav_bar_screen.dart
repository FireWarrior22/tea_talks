import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tea_talks/screens/dashboard_screen/add_room_screen.dart';
import 'package:tea_talks/screens/dashboard_screen/widgets/nav_item.dart';
import 'package:tea_talks/utility/ui_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBarScreen extends StatelessWidget {
  final onPressed;

  const NavBarScreen({
    required this.onPressed,
  });

  @override
  void _launchURL() async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  Widget build(BuildContext context) {
    return Container(
      color: kImperialOrange.withOpacity(0.10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'Menu',
                  style:
                      kHeadingTextStyle.copyWith(fontSize: 30, color: kBlack),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                NavItem(
                  onTap: onPressed,
                  title: 'Close Navigation Bar',
                  iconData: FontAwesomeIcons.times,
                  subTitle: null,
                ),
                const SizedBox(height: 30),
                NavItem(
                  onTap: () {
                    final route =
                        MaterialPageRoute(builder: (ctx) => AddRoomScreen());
                    Navigator.push(context, route);
                  },
                  title: 'New Room',
                  iconData: FontAwesomeIcons.users,
                  subTitle: 'Add a new room. And, invite your friends.',
                ),
                const SizedBox(height: 30),
                NavItem(
                  onTap: _launchURL,
                  title: 'Report a bug',
                  iconData: FontAwesomeIcons.bug,
                  subTitle: 'File an issue on the Github Repo',
                ),
              ],
            ),
          ),
          const Expanded(
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
