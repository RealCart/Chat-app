import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/image_utils.dart';
import 'package:chat_app/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.imageUrl,
    required this.username,
    required this.uid,
  });

  final String? imageUrl;
  final String username;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pushNamed(
        AppRoutes.chatPage.name,
        pathParameters: {
          'uid': uid,
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        child: Row(
          spacing: 12.0,
          children: [
            CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.05,
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
            ),
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
