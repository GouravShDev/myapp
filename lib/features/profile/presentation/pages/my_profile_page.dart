import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/api/api_state.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/profile/domain/model/user_profile.dart';
import 'package:codersgym/features/profile/presentation/blocs/user_profile/user_profile_cubit.dart';
import 'package:codersgym/features/profile/presentation/widgets/leetcode_profile.dart';
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
        body: BlocBuilder<UserProfileCubit, ApiState<UserProfile, Exception>>(
          builder: (context, state) {
            return state.when(
              onInitial: () => const Center(child: CircularProgressIndicator()),
              onLoading: () => const Center(child: CircularProgressIndicator()),
              onLoaded: (userProfile) {
                return SafeArea(
                  child: LeetcodeProfile(
                    userProfile: userProfile,
                  ),
                );
              },
              onError: (exception) {
                return AppErrorWidget(
                  onRetry: () {
                    final authState = context.read<AuthBloc>().state;
                    if (authState is Authenticated) {
                      context
                          .read<UserProfileCubit>()
                          .getUserProfile(authState.userName);
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
