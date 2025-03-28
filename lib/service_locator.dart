import 'package:chat_app/data/repositories/chat_repository_impl.dart';
import 'package:chat_app/data/repositories/sign_in_REPOSITORY_impl.dart';
import 'package:chat_app/data/repositories/sign_up_repository_impl.dart';
import 'package:chat_app/data/repositories/user_list_repository_impl.dart';
import 'package:chat_app/data/sources/remote/firebase_auth_remote.dart';
import 'package:chat_app/data/sources/remote/firebase_firestore_remote.dart';
import 'package:chat_app/domain/repositories/chat_repository.dart';
import 'package:chat_app/domain/repositories/sign_in_repository.dart';
import 'package:chat_app/domain/repositories/sign_up_repository.dart';
import 'package:chat_app/domain/repositories/user_list_repository.dart';
import 'package:chat_app/domain/usecases/get_all_users_usecase.dart';
import 'package:chat_app/domain/usecases/get_current_user_usecase.dart';
import 'package:chat_app/domain/usecases/get_messages_usecase.dart';
import 'package:chat_app/domain/usecases/get_user_by_id_usecase.dart';
import 'package:chat_app/domain/usecases/send_message_usecase.dart';
import 'package:chat_app/domain/usecases/sign_in_usecase.dart';
import 'package:chat_app/domain/usecases/sign_up_usecase.dart';

import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:cloud_firestore/cloud_firestore.dart' as fbStore;
import 'package:firebase_database/firebase_database.dart' as fbRealBase;

import 'package:get_it/get_it.dart';

final sl = GetIt.I;

void setupServiceLocator() {
  // firebase instance;
  sl.registerLazySingleton<fbAuth.FirebaseAuth>(
      () => fbAuth.FirebaseAuth.instance);
  sl.registerLazySingleton<fbStore.FirebaseFirestore>(
      () => fbStore.FirebaseFirestore.instance);
  sl.registerLazySingleton<fbRealBase.FirebaseDatabase>(
      () => fbRealBase.FirebaseDatabase.instance);

  // firebase remote data;
  sl.registerLazySingleton<FirebaseAuthRemote>(
      () => FirebaseAuthRemoteImpl(sl<fbAuth.FirebaseAuth>()));
  sl.registerLazySingleton<FirebaseFirestoreRemote>(
      () => FirebaseFirestoreRemoteImpl(sl<fbStore.FirebaseFirestore>()));

  // firebase repositories;
  sl.registerLazySingleton<SignUpRepository>(
    () => SignUpRepositoryImpl(
      firebaseAuth: sl<FirebaseAuthRemote>(),
      firebaseFireStore: sl<FirebaseFirestoreRemote>(),
    ),
  );

  sl.registerLazySingleton<SignInRepository>(
    () => SignInRepositoryImpl(sl<FirebaseAuthRemote>()),
  );

  sl.registerLazySingleton<ChatRepository>(
    () =>
        ChatRepositoryImpl(firestoreDataSource: sl<FirebaseFirestoreRemote>()),
  );

  sl.registerLazySingleton<UserListRepository>(
    () => UserListRepositoryImpl(
        firebaseFirestoreRemote: sl<FirebaseFirestoreRemote>()),
  );

  // usecases
  sl.registerFactory(() => SignUpUsecase(sl<SignUpRepository>()));

  sl.registerFactory(() => SignInUsecase(sl<SignInRepository>()));

  sl.registerFactory(
    () => GetAllUsersUsecase(sl<UserListRepository>()),
  );

  sl.registerFactory(() => GetCurrentUserUsecase(sl<UserListRepository>()));

  sl.registerFactory(
    () => GetUserByIdUsecase(sl<UserListRepository>()),
  );

  sl.registerFactory(
    () => GetMessagesUsecase(sl<ChatRepository>()),
  );

  sl.registerFactory(
    () => SendMessageUsecase(sl<ChatRepository>()),
  );
}
