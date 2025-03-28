import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/image_utils.dart';
import 'package:chat_app/core/utils/text_styles.dart';
import 'package:chat_app/domain/usecases/get_all_users_usecase.dart';
import 'package:chat_app/domain/usecases/get_current_user_usecase.dart';
import 'package:chat_app/presentation/bloc/user_list_bloc/user_list_bloc.dart';
import 'package:chat_app/presentation/widgets/chat_tile.dart';
import 'package:chat_app/presentation/widgets/circular_progress.dart';
import 'package:chat_app/presentation/widgets/text_search_field.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:go_router/go_router.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserListBloc(
        getAllUsersUsecase: sl<GetAllUsersUsecase>(),
        getCurrentUserUsecase: sl<GetCurrentUserUsecase>(),
      )..add(LoadUsersEvent()),
      child: SafeArea(
        child: BlocBuilder<UserListBloc, UserListState>(
          builder: (context, state) {
            if (state is UserListLoading) {
              return Scaffold(
                body: Center(
                  child: CircularProgress(),
                ),
              );
            }

            if (state is UserListError) {
              return Scaffold(
                body: Center(
                  child: Text(state.message),
                ),
              );
            }

            if (state is UserListLoaded) {
              return Scaffold(
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
                            onTap: () {
                              sl<fbAuth.FirebaseAuth>().signOut();
                              context.goNamed(AppRoutes.signIn.name);
                            },
                            child: CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.07,
                              backgroundColor: AppColors.green,
                              backgroundImage:
                                  state.currentUser.imageUrl != null
                                      ? MemoryImage(
                                          ImageUtils.base64ToImageBytes(
                                            state.currentUser.imageUrl!,
                                          ),
                                        )
                                      : null,
                              child: state.currentUser.imageUrl != null
                                  ? null
                                  : SvgPicture.asset(
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
                        itemBuilder: (context, index) {
                          return ChatTile(
                            uid: state.users[index].uid,
                            imageUrl: state.users[index].imageUrl,
                            username: state.users[index].username,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: AppColors.stroke,
                            height: 1.0,
                            indent: 20.0,
                            endIndent: 20.0,
                          );
                        },
                        itemCount: state.users.length,
                      ),
                    )
                  ],
                ),
              );
            }

            return Container();
          },
        ),
      ),
    );
  }
}
