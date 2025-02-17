import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/core/utils/bloc_extension.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/features/profile/domain/repository/profile_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class UserProfileCubit extends HydratedCubit<ApiState<UserProfile, Exception>> {
  UserProfileCubit(this._profileRepository) : super(ApiState.initial());
  final ProfileRepository _profileRepository;

  Future<void> getUserProfile(String userName) async {
    final result = await _profileRepository.getUserProfile(userName);
    result.when(
      onSuccess: (profile) {
        safeEmit(ApiLoaded(profile));
      },
      onFailure: (exception) {
        safeEmit(ApiError(exception));
      },
    );
  }

  @override
  ApiState<UserProfile, Exception>? fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return ApiState.initial();
    }
    return ApiLoading(cachedData: UserProfile.fromJson(json));
  }

  @override
  Map<String, dynamic>? toJson(ApiState<UserProfile, Exception> state) {
    return state.mayBeWhen(
      orElse: () => null,
      onLoaded: (value) => value.toJson(),
    );
  }
}
