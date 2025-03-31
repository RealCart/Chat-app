import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserAvatar extends StatefulWidget {
  const UserAvatar({super.key, required this.imageUrl});

  final String? imageUrl;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  MemoryImage? _cachedImage;

  @override
  void initState() {
    super.initState();
    _updateImage();
  }

  @override
  void didUpdateWidget(covariant UserAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _updateImage();
    }
  }

  void _updateImage() {
    if (widget.imageUrl != null) {
      _cachedImage =
          MemoryImage(ImageUtils.base64ToImageBytes(widget.imageUrl!));
    } else {
      _cachedImage = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: MediaQuery.of(context).size.width * 0.075,
      backgroundColor: AppColors.green,
      backgroundImage: _cachedImage,
      child: _cachedImage != null
          ? null
          : SvgPicture.asset(
              "assets/icons/user.svg",
              width: 25.0,
              height: 25.0,
            ),
    );
  }
}
