import 'package:chat_app/data/repositories/sign_in_REPOSITORY_impl.dart';
import 'package:chat_app/data/repositories/sign_up_repository_impl.dart';
import 'package:chat_app/data/sources/remote/firebase_auth_remote.dart';
import 'package:chat_app/data/sources/remote/firebase_firestore_remote.dart';
import 'package:chat_app/domain/repositories/sign_in_repository.dart';
import 'package:chat_app/domain/repositories/sign_up_repository.dart';
import 'package:chat_app/domain/usecases/sign_in_usecase.dart';
import 'package:chat_app/domain/usecases/sign_up_usecase.dart';

import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:cloud_firestore/cloud_firestore.dart' as fbStore;

import 'package:get_it/get_it.dart';

final sl = GetIt.I;

void setupServiceLocator() {
  // firebase instance;
  sl.registerLazySingleton<fbAuth.FirebaseAuth>(
      () => fbAuth.FirebaseAuth.instance);
  sl.registerLazySingleton<fbStore.FirebaseFirestore>(
      () => fbStore.FirebaseFirestore.instance);

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

  // usecases
  sl.registerFactory(() => SignUpUsecase(sl<SignUpRepository>()));

  sl.registerFactory(() => SignInUsecase(sl<SignInRepository>()));
}
