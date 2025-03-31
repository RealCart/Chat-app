import 'package:chat_app/core/routes/app_routes.dart';
import 'package:chat_app/core/utils/colors.dart';
import 'package:chat_app/core/utils/text_styles.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/usecases/get_all_users_usecase.dart';
import 'package:chat_app/domain/usecases/get_current_user_usecase.dart';
import 'package:chat_app/presentation/bloc/user_list_bloc/user_list_bloc.dart';
import 'package:chat_app/presentation/widgets/chat_tile.dart';
import 'package:chat_app/presentation/widgets/circular_progress.dart';
import 'package:chat_app/presentation/widgets/text_search_field.dart';
import 'package:chat_app/presentation/widgets/user_avatar.dart';
import 'package:chat_app/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:go_router/go_router.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({super.key});

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<UserEntity>? _filteredUsers;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
              _filteredUsers ??= state.users;

              void searchUsers(String query) {
                final suggestions = state.users.where((user) {
                  final name = user.username.toLowerCase();
                  final input = query.toLowerCase();
                  return name.contains(input);
                }).toList();
                setState(() {
                  _filteredUsers = suggestions;
                });
              }

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
                            child: UserAvatar(
                              imageUrl: state.currentUser.imageUrl,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextSearchField(
                        onChanged: (text) => searchUsers(text),
                      ),
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
                            uid: _filteredUsers![index].uid,
                            imageUrl: _filteredUsers![index].imageUrl,
                            username: _filteredUsers![index].username,
                            onTap: () => context.pushNamed(
                              AppRoutes.chatPage.name,
                              pathParameters: {
                                'uid': _filteredUsers![index].uid,
                              },
                            ),
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
                        itemCount: _filteredUsers!.length,
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
