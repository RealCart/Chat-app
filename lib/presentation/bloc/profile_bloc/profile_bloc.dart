import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetCurrentUserUsecase usecase;

  ProfileBloc(this.usecase) : super(ProfileInitial()) {
    on<GetUserEvent>(_onGetCurrentUser);
  }

  _onGetCurrentUser(GetUserEvent event, Emitter emit) async {
    emit(ProfileLoadingState());
    try {
      final response = await usecase();
      emit(ProfileLoadedState(response));
    } catch (e) {
      emit(ProfileErrorState(e.toString()));
    }
  }
}
