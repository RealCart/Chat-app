import 'package:chat_app/data/sources/local/local_data_source.dart';
import 'package:chat_app/data/sources/remote/firebase_firestore_remote.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/user_list_repository.dart';
import 'package:chat_app/service_locator.dart';
import 'package:dartz/dartz.dart';

import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

class UserListRepositoryImpl implements UserListRepository {
  final FirebaseFirestoreRemote firebaseFirestoreRemote;
  final LocalDataSource userCacheLocalDataSource;
  final int freshnessThreshold = 5 * 60 * 1000;

  UserListRepositoryImpl({
    required this.firebaseFirestoreRemote,
    required this.userCacheLocalDataSource,
  });

  @override
  Future<Either<String, List<UserEntity>>> getAllUsers() async {
    try {
      final currentUid = sl<fbAuth.FirebaseAuth>().currentUser!.uid;

      final localUsers =
          await userCacheLocalDataSource.getAllUsersDataExcept(currentUid);

      bool cacheIsFresh = false;
      if (localUsers.isNotEmpty) {
        final lastUpdated = localUsers.first['lastUpdated'] as int;
        final age = DateTime.now().millisecondsSinceEpoch - lastUpdated;
        cacheIsFresh = age < freshnessThreshold;
      }

      if (localUsers.isNotEmpty && cacheIsFresh) {
        final users = localUsers.map((map) {
          return UserEntity(
            uid: map['uid'] as String,
            username: map['username'] as String,
            imageUrl: map['imageUrl'] as String?,
          );
        }).toList();
        return Right(users);
      } else {
        final usersData =
            await firebaseFirestoreRemote.getAllUsersDataExcept(currentUid);
        final users = usersData.map((map) {
          return UserEntity(
            uid: map['uid'] as String,
            username: map['name'] as String,
            imageUrl: map['image'] as String?,
          );
        }).toList();

        for (final user in users) {
          await userCacheLocalDataSource.saveUserData(
            uid: user.uid,
            username: user.username,
            imageUrl: user.imageUrl,
          );
        }
        return Right(users);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> getUserById(String uid) async {
    try {
      final localData = await userCacheLocalDataSource.getUserData(uid);
      if (localData != null) {
        final lastUpdated = localData['lastUpdated'] as int;
        final age = DateTime.now().millisecondsSinceEpoch - lastUpdated;
        if (age < freshnessThreshold) {
          return Right(UserEntity(
            uid: localData['uid'] as String,
            username: localData['username'] as String,
            imageUrl: localData['imageUrl'] as String?,
          ));
        }
      }

      final data = await firebaseFirestoreRemote.getUserData(uid);
      if (data != null) {
        final user = UserEntity(
          uid: data['uid'] as String,
          username: data['name'] as String,
          imageUrl: data['image'] as String?,
        );
        await userCacheLocalDataSource.saveUserData(
          uid: user.uid,
          username: user.username,
          imageUrl: user.imageUrl,
        );
        return Right(user);
      } else {
        return Left("Ошибка: данные пользователя не найдены");
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final currentUid = sl<fbAuth.FirebaseAuth>().currentUser!.uid;

    final localData = await userCacheLocalDataSource.getUserData(currentUid);
    bool cacheIsFresh = false;
    if (localData != null) {
      final lastUpdated = localData['lastUpdated'] as int;
      final age = DateTime.now().millisecondsSinceEpoch - lastUpdated;
      cacheIsFresh = age < freshnessThreshold;
    }

    if (localData != null && cacheIsFresh) {
      return UserEntity(
        uid: localData['uid'] as String,
        username: localData['username'] as String,
        imageUrl: localData['imageUrl'] as String?,
        email: sl<fbAuth.FirebaseAuth>().currentUser!.email,
      );
    } else {
      final data = await firebaseFirestoreRemote.getUserData(currentUid);
      if (data != null) {
        final user = UserEntity(
          uid: data['uid'] as String,
          username: data['name'] as String,
          imageUrl: data['image'] as String?,
          email: sl<fbAuth.FirebaseAuth>().currentUser!.email,
        );
        await userCacheLocalDataSource.saveUserData(
          uid: user.uid,
          username: user.username,
          imageUrl: user.imageUrl,
        );
        return user;
      } else {
        throw Exception("Данные текущего пользователя не найдены");
      }
    }
  }
}
