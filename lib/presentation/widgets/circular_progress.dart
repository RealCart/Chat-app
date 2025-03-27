import 'package:chat_app/core/utils/colors.dart';
import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: AppColors.darkGreen,
    );
  }
}
