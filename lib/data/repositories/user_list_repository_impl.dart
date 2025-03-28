import 'package:chat_app/core/utils/image_utils.dart';
import 'package:chat_app/data/sources/remote/firebase_firestore_remote.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/user_list_repository.dart';
import 'package:chat_app/service_locator.dart';
import 'package:dartz/dartz.dart';

import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/material.dart';

class UserListRepositoryImpl implements UserListRepository {
  final FirebaseFirestoreRemote firebaseFirestoreRemote;

  UserListRepositoryImpl({
    required this.firebaseFirestoreRemote,
  });

  @override
  Future<Either<String, List<UserEntity>>> getAllUsers() async {
    try {
      final usersData = await firebaseFirestoreRemote
          .getAllUsersDataExcept(sl<fbAuth.FirebaseAuth>().currentUser!.uid);
      print(">>>>>>>>>>>>>>>>>>>> ALL USERS: ${usersData}");
      return Right(
        usersData.map((map) {
          return UserEntity(
            uid: map['uid'] as String,
            username: map['name'] as String,
            imageUrl: map['image'] as String?,
          );
        }).toList(),
      );
    } catch (e) {
      return (Left(e.toString()));
    }
  }

  @override
  Future<Either<String, UserEntity>> getUserById(String uid) async {
    try {
      final data = await firebaseFirestoreRemote.getUserData(uid);
      return Right(UserEntity(
        uid: data!['uid'] as String,
        username: data['name'] as String,
        imageUrl: data['image'] as String?,
      ));
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final data = await firebaseFirestoreRemote.getUserData(
      sl<fbAuth.FirebaseAuth>().currentUser!.uid,
    );
    return UserEntity(
      uid: sl<fbAuth.FirebaseAuth>().currentUser!.uid,
      imageUrl: data!['image'],
      username: data['name'],
      email: sl<fbAuth.FirebaseAuth>().currentUser!.email,
    );
  }
}
