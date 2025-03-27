import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/text_styles.dart';
import 'package:chat_app/presentation/widgets/text_search_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Text(
                    "Чаты",
                    style: getTextStyle(CustomTextStyle.s32w600),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: MediaQuery.of(context).size.width * 0.07,
                      backgroundColor: AppColors.green,
                      backgroundImage: null,
                      child: SvgPicture.asset(
                        "assets/icons/user.svg",
                        width: 35.0,
                        height: 35.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TextSearchField(),
            ),
            const SizedBox(height: 24.0),
            Divider(
              height: 1.0,
              color: AppColors.stroke,
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {},
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1.0,
                    indent: 20.0,
                  );
                },
                itemCount: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
