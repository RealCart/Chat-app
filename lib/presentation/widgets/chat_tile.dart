import 'package:chat_app/core/utils/text_styles.dart';
import 'package:chat_app/presentation/widgets/user_avatar.dart';
import 'package:flutter/material.dart';

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
