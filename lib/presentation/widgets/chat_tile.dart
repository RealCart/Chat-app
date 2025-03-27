import 'package:chat_app/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.05,
          backgroundColor: AppColors.green,
          backgroundImage: null,
          child: SvgPicture.asset(
            "assets/icons/user.svg",
            width: 35.0,
            height: 35.0,
          ),
        ),
        Column(
          children: [],
        ),
        Column(
          children: [],
        ),
      ],
    );
  }
}
