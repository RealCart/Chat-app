import 'package:chat_app/core/utils/colors.dart';
import 'package:flutter/material.dart';

enum CustomTextStyle {
  s32w600,
  s16w500,
  s12w500,
  s15w600,
  s14w500,
}

TextStyle getTextStyle(CustomTextStyle textStyle,
    {Color color = AppColors.primaryColor}) {
  switch (textStyle) {
    case CustomTextStyle.s32w600:
      return TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      );
    case CustomTextStyle.s16w500:
      return TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      );
    case CustomTextStyle.s15w600:
      return TextStyle(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
      );
    case CustomTextStyle.s14w500:
      return TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      );
    case CustomTextStyle.s12w500:
      return TextStyle(
        fontSize: 12.0,
        fontWeight: FontWeight.w500,
      );
  }
}
