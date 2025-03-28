import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TextSearchField extends StatelessWidget {
  const TextSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      style: getTextStyle(CustomTextStyle.s16w500, color: AppColors.gray),
      cursorColor: AppColors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.stroke,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 20,
          minHeight: 20,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 11.0,
          ),
          child: SvgPicture.asset(
            "assets/icons/seatch_prefix_icon.svg",
            width: 20,
            height: 20,
          ),
        ),
        labelText: "Поиск",
      ),
    );
  }
}
