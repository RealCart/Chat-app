import 'package:chat_app/core/error/failure.dart';
import 'package:chat_app/core/usecase/usecase.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/repositories/sign_in_repository.dart';
import 'package:dartz/dartz.dart';

class SignInUsecase implements Usecase<Either, SignInReq> {
  SignInUsecase(this.repository);

  final SignInRepository repository;

  @override
  Future<Either<Failure, UserEntity>> call({required SignInReq params}) {
    return repository.singIn(email: params.email, password: params.password);
  }
}

class SignInReq {
  SignInReq({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
