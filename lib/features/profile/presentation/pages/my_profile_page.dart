import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/features/profile/presentation/blocs/contest_ranking_info/contest_ranking_info_cubit.dart';
import 'package:codersgym/features/profile/presentation/blocs/cubit/user_profile_calendar_cubit.dart';
import 'package:codersgym/features/profile/presentation/blocs/user_profile/user_profile_cubit.dart';
import 'package:codersgym/features/profile/presentation/widgets/leetcode_profile.dart';
import 'package:codersgym/features/profile/presentation/widgets/leetcode_profile_report_card.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

@RoutePage()
class MyProfilePage extends HookWidget {
  const MyProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: BlocBuilder<UserProfileCubit, UserProfileState>(
          builder: (context, state) {
            return state.mayBeWhen(
              onLoaded: (profile) {
                return FloatingActionButton(
                  onPressed: () {
                    LeetcodeProfileReportCard.show(
                      context,
                      profile: profile,
                      profileCalendarCubit: context.read(),
                      rankingInfoCubit: context.read(),
                    );
                  },
                  child: const Icon(
                    Icons.share_rounded,
                  ),
                );
              },
              orElse: () => SizedBox.shrink(),
            );
          },
        ),
        body: BlocBuilder<UserProfileCubit, ApiState<UserProfile, Exception>>(
          builder: (context, state) {
            return state.when(
              onInitial: () => const Center(child: CircularProgressIndicator()),
              onLoading: () => const Center(child: CircularProgressIndicator()),
              onLoaded: (userProfile) {
                return LeetcodeProfile(
                  userProfile: userProfile,
                );
              },
              onError: (exception) {
                return Text(exception.toString());
              },
            );
          },
        ),
      ),
    );
  }
}
