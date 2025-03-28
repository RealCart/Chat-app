import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/text_styles.dart';
import 'package:chat_app/domain/usecases/get_messages_usecase.dart';
import 'package:chat_app/domain/usecases/send_message_usecase.dart';
import 'package:chat_app/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_app/service_locator.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatPage extends StatelessWidget {
  ChatPage({
    super.key,
    required this.otherUserUid,
  });

  final String otherUserUid;

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        getMessagesUsecase: sl<GetMessagesUsecase>(),
        sendMessageUsecase: sl<SendMessageUsecase>(),
      )..add(LoadChatEvent(otherUserUid)),
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(65.0),
            child: Container(
              decoration: BoxDecoration(),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 33.0,
                      right: 19.0,
                    ),
                    child: GestureDetector(
                      child: SvgPicture.asset(
                        "assets/icons/arrow_back.svg",
                        width: 20.0,
                        height: 20.0,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.08,
                  ),
                  SizedBox(width: 12.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Сережа",
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
                    if (state is ChatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChatError) {
                      return Center(child: Text(state.message));
                    } else if (state is ChatLoaded) {
                      final messages = state.messages;
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final msg = messages[index];
                          final isMine = (msg.senderId ==
                              sl<fbAuth.FirebaseAuth>().currentUser!.uid);
                          return Align(
                            alignment: isMine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isMine
                                    ? Colors.blue[100]
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(msg.content),
                            ),
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
              Builder(builder: (context) {
                return _buildMessageInput(context);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Введите сообщение",
              contentPadding: EdgeInsets.all(8),
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
    );
  }
}
