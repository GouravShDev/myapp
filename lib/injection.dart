import 'package:codersgym/core/network/dio_network_service.dart';
import 'package:codersgym/core/network/network_service.dart';
import 'package:codersgym/core/utils/storage/local_storage_manager.dart';
import 'package:codersgym/core/utils/storage/storage_manager.dart';
import 'package:codersgym/features/auth/data/service/auth_service.dart';
import 'package:codersgym/features/auth/domain/service/auth_service.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/profile/data/repository/profile_repository.dart';
import 'package:codersgym/features/profile/presentation/blocs/contest_ranking_info/contest_ranking_info_cubit.dart';
import 'package:codersgym/features/profile/presentation/blocs/cubit/user_profile_calendar_cubit.dart';
import 'package:codersgym/features/profile/presentation/blocs/user_profile/user_profile_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/question_archieve/question_archieve_bloc.dart';
import 'package:codersgym/features/question/presentation/blocs/similar_question/similar_question_cubit.dart';
import 'package:codersgym/features/question/presentation/blocs/upcoming_contests/upcoming_contests_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:codersgym/core/api/leetcode_api.dart';
import 'package:codersgym/core/routes/app_router.dart';
import 'package:codersgym/features/question/data/repository/question_repository.dart';
import 'package:codersgym/features/question/domain/repository/question_repository.dart';
import 'package:codersgym/features/question/presentation/blocs/daily_challenge/daily_challenge_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/profile/domain/repository/profile_repository.dart';
import 'features/question/presentation/blocs/question_content/question_content_cubit.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // UTILS
  final sharedPref = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<StorageManager>(
    () => LocalStorageManager.getInstance(sharedPref),
  );

  // ROUTER
  getIt.registerSingleton(AppRouter());

  // SERVICE
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImp(
      getIt.get(),
      getIt.get(),
    ),
  );
  getIt.registerLazySingleton<NetworkService>(
    () => DioNetworkService(
      configuration: NetworkConfiguration(baseUrl: 'https://leetcode.com'),
      interceptors: [],
    ),
  );

  // REPOSITORY
  getIt.registerLazySingleton(
    () => LeetcodeApi(
      storageManger: getIt.get(),
      networkService: getIt.get(),
    ),
  );
  getIt.registerSingleton<QuestionRepository>(
    QuestionRepositoryImpl(
      getIt.get(),
    ),
  );
  getIt.registerSingleton<ProfileRepository>(
    ProfileRepositoryImp(
      getIt.get(),
    ),
  );

  // BLOC/CUBIT
  getIt.registerFactory(
    () => AuthBloc(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => DailyChallengeCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => QuestionContentCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => UserProfileCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => ContestRankingInfoCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => UserProfileCalendarCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => QuestionArchieveBloc(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => UpcomingContestsCubit(
      getIt.get(),
    ),
  );
  getIt.registerFactory(
    () => SimilarQuestionCubit(
      getIt.get(),
    ),
  );
}
