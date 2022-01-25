import 'package:flutter/material.dart';
import 'package:tea_talks/utility/ui_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class NavItem extends StatelessWidget {
  final title;
  final iconData;
  final subTitle;
  final onTap;

  NavItem({
    required this.title,
    required this.iconData,
    required this.subTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: kTitleTextStyle,
      ),
      onTap: onTap,
      leading: Icon(
        iconData,
        color: kImperialOrange,
        size: 30,
      ),
      subtitle: subTitle != null
          ? Text(
              subTitle,
              style: kLightLabelTextStyle.copyWith(color: kBlack),
            )
          : null,
    );
  }
}
