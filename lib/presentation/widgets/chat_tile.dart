import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/image_utils.dart';
import 'package:chat_app/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.imageUrl,
    required this.username,
    required this.uid,
    required this.onTap,
  });

  final String? imageUrl;
  final String username;
  final String uid;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Row(
          spacing: 12.0,
          children: [
            UserAvatar(imageUrl: imageUrl),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  username,
                  style: getTextStyle(
                    CustomTextStyle.s15w600,
                  ),
                )
              ],
            ),
            Column(
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.width * 0.075,
      backgroundColor: AppColors.green,
      backgroundImage: imageUrl != null
          ? MemoryImage(ImageUtils.base64ToImageBytes(imageUrl!))
          : null,
      child: imageUrl != null
          ? null
          : SvgPicture.asset(
              "assets/icons/user.svg",
              width: 25.0,
              height: 25.0,
            ),
    );
  }
}
