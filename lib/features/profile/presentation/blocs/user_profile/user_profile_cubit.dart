import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/features/profile/domain/repository/profile_repository.dart';
import 'package:equatable/equatable.dart';

typedef UserProfileState = ApiState<UserProfile, Exception>;

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit(this._profileRepository) : super(ApiState.initial());
  final ProfileRepository _profileRepository;

  Future<void> getUserProfile(String userName) async {
    emit(ApiLoading());
    final result = await _profileRepository.getUserProfile(userName);
    result.when(
      onSuccess: (profile) {
        emit(ApiLoaded(profile));
      },
      onFailure: (exception) {
        emit(ApiError(exception));
      },
    );
  }
}
