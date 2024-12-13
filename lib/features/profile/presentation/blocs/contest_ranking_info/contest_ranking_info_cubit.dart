import 'package:bloc/bloc.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/profile/domain/model/contest_ranking_info.dart';
import 'package:codersgym/features/profile/domain/repository/profile_repository.dart';

typedef ContestRankingInfoState = ApiState<ContestRankingInfo, Exception>;

class ContestRankingInfoCubit extends Cubit<ContestRankingInfoState> {
  ContestRankingInfoCubit(this._profileRepository) : super(ApiState.initial());
  final ProfileRepository _profileRepository;

  Future<void> getContestRankingInfo(String userName) async {
    emit(ApiLoading());
    final rankingInfoResult =
        await _profileRepository.getContestRankingInfo(userName);
    rankingInfoResult.when(
      onSuccess: (contestRankingInfo) {
        emit(
          ApiLoaded(
            contestRankingInfo,
          ),
        );
      },
      onFailure: (exception) => emit(
        ApiError(exception),
      ),
    );
  }
}
