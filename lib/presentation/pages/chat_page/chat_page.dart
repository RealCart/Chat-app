import 'dart:io';
import 'dart:typed_data';

import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/image_utils.dart';
import 'package:chat_app/core/utils/media_image.dart';
import 'package:chat_app/core/utils/message_utils.dart';
import 'package:chat_app/core/utils/text_styles.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/usecases/get_messages_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_by_id_usecase.dart';
import 'package:chat_app/domain/usecases/send_message_usecase.dart';
import 'package:chat_app/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/presentation/widgets/circular_progress.dart';
import 'package:chat_app/presentation/widgets/user_avatar.dart';
import 'package:chat_app/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.otherUserUid,
  });

  final String otherUserUid;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _showScrollDownButton = false;

  final Map<String, Uint8List> _imageCache = {};

  Uint8List _getCachedImage(String base64String) {
    if (_imageCache.containsKey(base64String)) {
      return _imageCache[base64String]!;
    } else {
      final bytes = ImageUtils.base64ToImageBytes(base64String);
      _imageCache[base64String] = bytes;
      return bytes;
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset >
          _scrollController.position.minScrollExtent + 300) {
        if (!_showScrollDownButton) {
          setState(() {
            _showScrollDownButton = true;
          });
        }
      } else {
        if (_showScrollDownButton) {
          setState(() {
            _showScrollDownButton = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<Widget> _buildGroupedMessages(List<MessageEntity> messages) {
    final groupedMessages = MessageUtils.groupMessagesByDate(messages);
    final sortedKeys = groupedMessages.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    final List<Widget> widgets = [];
    for (var key in sortedKeys) {
      DateTime groupDate = DateTime.parse(key);
      String headerLabel = MessageUtils.getHeaderLabel(groupDate);
      groupedMessages[key]!.sort((a, b) => b.timestamp.compareTo(a.timestamp));

      final List<Widget> groupWidgets = [];
      for (var msg in groupedMessages[key]!) {
        final bool isMine =
            msg.senderId == sl<fbAuth.FirebaseAuth>().currentUser!.uid;
        groupWidgets.add(
          Align(
            alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isMine ? AppColors.green : AppColors.stroke,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  msg.content != null
                      ? Flexible(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6,
                            ),
                            child: Text(
                              msg.content!,
                              style: getTextStyle(
                                CustomTextStyle.s14w500,
                                color: isMine
                                    ? AppColors.darkGreen
                                    : AppColors.black,
                              ),
                            ),
                          ),
                        )
                      : Flexible(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.6,
                            ),
                            child: Image(
                              image: MemoryImage(
                                _getCachedImage(msg.image!),
                              ),
                            ),
                          ),
                        ),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat.Hm().format(msg.timestamp),
                    style: getTextStyle(
                      CustomTextStyle.s12w500,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
      groupWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(child: Text(headerLabel)),
        ),
      );
      widgets.addAll(groupWidgets);
    }
    return widgets;
  }

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 23.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            height: 1.0,
            color: AppColors.stroke,
          ),
          const SizedBox(height: 13.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final chatBloc = context.read<ChatBloc>();
                    final MediaImage mediaImage = MediaImage();
                    final File? file = await mediaImage.getImageInGallery();
                    if (!mounted) return;
                    if (file != null) {
                      final String imageBase64 =
                          await ImageUtils.imageFileToBase64(file);
                      chatBloc.add(
                        SendMessageEvent(
                          widget.otherUserUid,
                          imageBase64: imageBase64,
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.stroke,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: SvgPicture.asset("assets/icons/folder_clip.svg"),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Сообщение",
                      contentPadding: EdgeInsets.all(8),
                      fillColor: AppColors.stroke,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = _controller.text.trim();
                    if (text.isNotEmpty) {
                      context.read<ChatBloc>().add(
                          SendMessageEvent(widget.otherUserUid, content: text));
                      _controller.clear();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        getMessagesUsecase: sl<GetMessagesUsecase>(),
        sendMessageUsecase: sl<SendMessageUsecase>(),
        getUserByIdUsecase: sl<GetUserByIdUsecase>(),
      )..add(LoadChatEvent(widget.otherUserUid)),
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ChatLoading) {
            return Scaffold(
              body: Center(child: CircularProgress()),
            );
          } else if (state is ChatError) {
            return Scaffold(
              body: Center(child: Text(state.message)),
            );
          } else if (state is ChatLoaded) {
            final messages = state.messages;
            return SafeArea(
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(70.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.5),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => context.pop(),
                                child: Container(
                                  width: 30.0,
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: SvgPicture.asset(
                                    "assets/icons/arrow_back.svg",
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                ),
                              ),
                              UserAvatar(imageUrl: state.user.imageUrl),
                              const SizedBox(width: 12.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.user.username,
                                    style:
                                        getTextStyle(CustomTextStyle.s15w600),
                                  ),
                                  Text(
                                    "В сети",
                                    style: getTextStyle(
                                      CustomTextStyle.s12w500,
                                      color: AppColors.dartGray,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1.0,
                          color: AppColors.stroke,
                        )
                      ],
                    ),
                  ),
                ),
                body: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned.fill(
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.transparent],
                          stops: const [0.85, 1.0],
                        ).createShader(bounds),
                        blendMode: BlendMode.dstIn,
                        child: ListView(
                          controller: _scrollController,
                          reverse: true,
                          padding: const EdgeInsets.fromLTRB(
                              10.0, 10.0, 10.0, 100.0),
                          children: _buildGroupedMessages(messages),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: _buildMessageInput(context),
                    ),
                    if (_showScrollDownButton)
                      Positioned(
                        right: 16,
                        bottom: 120,
                        child: FloatingActionButton(
                          onPressed: _scrollToBottom,
                          backgroundColor: AppColors.stroke,
                          elevation: 0,
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.black,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
