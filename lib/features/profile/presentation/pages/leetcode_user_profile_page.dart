import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/features/profile/presentation/blocs/user_profile/user_profile_cubit.dart';
import 'package:codersgym/features/profile/presentation/widgets/leetcode_profile.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class LeetcodeUserProfilePage extends HookWidget {
  final String userName;

  const LeetcodeUserProfilePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final profileCubit = getIt.get<UserProfileCubit>();

    useEffect(
      () {
        profileCubit.getUserProfile(userName);
        return;
      },
      [],
    );
    return Scaffold(
      body: BlocBuilder<UserProfileCubit, ApiState<UserProfile, Exception>>(
        bloc: profileCubit,
        builder: (context, state) {
          return state.when(
            onInitial: () => const Center(child: CircularProgressIndicator()),
            onLoading: (_) => const Center(child: CircularProgressIndicator()),
            onLoaded: (userProfile) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: LeetcodeProfile(
                    userProfile: userProfile,
                  ),
                ),
              );
            },
            onError: (exception) {
              return Text(exception.toString());
            },
          );
        },
      ),
    );
  }
}
