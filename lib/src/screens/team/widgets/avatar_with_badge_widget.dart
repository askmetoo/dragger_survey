import 'package:dragger_survey/src/shared/shared.dart';
import 'package:dragger_survey/src/styles.dart';
import 'package:flutter/material.dart';
import 'package:rounded_letter/rounded_letter.dart';
import 'package:rounded_letter/shape_type.dart';

class AvatarWithBadge extends StatelessWidget {
  final Widget badge;
  final Widget avatar;
  final double badgeSize;
  final double badgeBorderWidht;
  final double avatarSize;
  final double avatarBorderWidht;

  AvatarWithBadge({
    this.badge,
    this.avatar,
    this.badgeSize = 30,
    this.badgeBorderWidht = 2,
    this.avatarSize = 52,
    this.avatarBorderWidht = 2,
  }) : super();

  @override
  Widget build(BuildContext context) {
    Widget defaultBadge = SizedBox(
      child: RoundedLetter(
        text: buildInitials(name: "John Doe"),
        fontColor: Styles.color_Primary,
        shapeType: ShapeType.circle,
        shapeColor: Styles.color_Secondary,
        borderColor: Styles.color_Primary,
        shapeSize: badgeSize - (badgeBorderWidht * 2),
        fontSize: (badgeSize / 2) - badgeBorderWidht,
        borderWidth: badgeBorderWidht,
      ),
    );

    Widget defaultAvatar = SizedBox(
      child: RoundedLetter(
        text: buildInitials(name: "Dragger"),
        fontColor: Styles.color_Primary,
        shapeType: ShapeType.circle,
        shapeColor: Styles.color_Secondary,
        borderColor: Styles.color_Primary,
        shapeSize: avatarSize - (avatarBorderWidht * 2),
        fontSize: (avatarSize / 2) - avatarBorderWidht,
        borderWidth: avatarBorderWidht,
      ),
    );

    return Container(
      child: SizedBox(
        width: avatarSize + (badgeSize / 4),
        height: avatarSize,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: avatar != null ? avatar : defaultAvatar,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: badge != null ? badge : defaultBadge,
            ),
          ],
        ),
      ),
    );
  }
}
