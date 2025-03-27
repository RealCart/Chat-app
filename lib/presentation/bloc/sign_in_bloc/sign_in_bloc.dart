import 'package:chat_app/domain/entities/user_auth_entity.dart';
import 'package:chat_app/domain/usecases/sign_in_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUsecase _usecase;

  SignInBloc(this._usecase) : super(SignInInitial()) {
    on<AuthSignInEvent>(_onSignIn);
  }

  _onSignIn(AuthSignInEvent event, Emitter emit) async {
    emit(SignInLoaddingState());
    final response = await _usecase(
      params: SignInReq(
        email: event.email,
        password: event.password,
      ),
    );

    response.fold((e) {
      emit(SignInErrorState(e.errorMessage));
    }, (data) {
      emit(SignInSuccessfullyState(data));
    });
  }
}
