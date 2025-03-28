import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/image_utils.dart';
import 'package:chat_app/core/utils/text_styles.dart';
import 'package:chat_app/domain/entities/message_entity.dart';
import 'package:chat_app/domain/usecases/get_messages_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_by_id_usecase.dart';
import 'package:chat_app/domain/usecases/send_message_usecase.dart';
import 'package:chat_app/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/presentation/widgets/circular_progress.dart';
import 'package:chat_app/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
    super.key,
    required this.otherUserUid,
  });

  final String otherUserUid;
  final TextEditingController _controller = TextEditingController();

  Map<String, List<MessageEntity>> _groupMessagesByDate(
      List<MessageEntity> messages) {
    final Map<String, List<MessageEntity>> grouped = {};
    for (var msg in messages) {
      String dateKey = DateFormat('yyyy-MM-dd').format(msg.timestamp);
      if (grouped[dateKey] == null) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(msg);
    }
    return grouped;
  }

  String _getHeaderLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));
    final dateToCompare = DateTime(date.year, date.month, date.day);

    if (dateToCompare == today) {
      return "Сегодня";
    } else if (dateToCompare == yesterday) {
      return "Вчера";
    } else {
      return DateFormat.yMMMMd('ru').format(date);
    }
  }

  List<Widget> _buildGroupedMessages(List<MessageEntity> messages) {
    final groupedMessages = _groupMessagesByDate(messages);
    final sortedKeys = groupedMessages.keys.toList()..sort();

    final List<Widget> widgets = [];
    for (var key in sortedKeys) {
      DateTime groupDate = DateTime.parse(key);
      String headerLabel = _getHeaderLabel(groupDate);
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(headerLabel),
              ],
            ),
          ),
        ),
      );
      groupedMessages[key]!.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      for (var msg in groupedMessages[key]!) {
        final bool isMine =
            msg.senderId == sl<fbAuth.FirebaseAuth>().currentUser!.uid;
        widgets.add(
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
                spacing: 15.0,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    msg.content,
                    style: getTextStyle(
                      CustomTextStyle.s14w500,
                      color: isMine ? AppColors.darkGreen : AppColors.black,
                    ),
                  ),
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
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        getMessagesUsecase: sl<GetMessagesUsecase>(),
        sendMessageUsecase: sl<SendMessageUsecase>(),
        getUserByIdUsecase: sl<GetUserByIdUsecase>(),
      )..add(LoadChatEvent(otherUserUid)),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgress(),
              ),
            );
          } else if (state is ChatError) {
            return Scaffold(
              body: Center(
                child: Text(state.message),
              ),
            );
          } else if (state is ChatLoaded) {
            final messages = state.messages;
            return SafeArea(
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(70.0),
                  child: Container(
                    decoration: const BoxDecoration(),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 12.0,
                          ),
                          child: GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              width: 30.0,
                              decoration: BoxDecoration(),
                              child: SvgPicture.asset(
                                "assets/icons/arrow_back.svg",
                                width: 20.0,
                                height: 20.0,
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width * 0.08,
                          backgroundImage: state.user.imageUrl != null
                              ? MemoryImage(
                                  ImageUtils.base64ToImageBytes(
                                      state.user.imageUrl!),
                                )
                              : null,
                          backgroundColor: AppColors.green,
                          child: state.user.imageUrl != null
                              ? null
                              : SvgPicture.asset("assets/icons/user.svg"),
                        ),
                        const SizedBox(width: 12.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.user.username,
                              style: getTextStyle(CustomTextStyle.s15w600),
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
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<ChatBloc, ChatState>(
                        builder: (context, state) {
                          return ListView(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            children: _buildGroupedMessages(messages),
                          );
                        },
                      ),
                    ),
                    Builder(builder: (context) {
                      return _buildMessageInput(context);
                    }),
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

  Widget _buildMessageInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 14.0,
        bottom: 23.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12.0),
            child: Container(
              width: 42.0,
              height: 42.0,
              decoration: BoxDecoration(
                color: AppColors.stroke,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SvgPicture.asset(
                "assets/icons/folder_clip.svg",
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
          SizedBox(width: 8.0),
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
                      SendMessageEvent(text, otherUserUid),
                    );
                _controller.clear();
              }
            },
          )
        ],
      ),
    );
  }
}
