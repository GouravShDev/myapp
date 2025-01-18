import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/services/analytics.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/auth/presentation/widgets/username_dialog.dart';
import 'package:codersgym/features/common/widgets/app_updater.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:codersgym/features/auth/presentation/widgets/leetcode_login_button.dart';
import 'package:codersgym/features/auth/presentation/widgets/typing_text_animation.dart';
import 'package:codersgym/gen/assets.gen.dart';

import '../../../../core/routes/app_router.gr.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
        body: Center(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthenticatedWithLeetcodeAccount ||
              state is AuthenticatedWithLeetcodeUserName) {
            AnalyticsService().logLogin(method: state.toString());
            context.router.root.replace(const DashboardRoute());
          }
        },
        child: AppUpdater(
          child: SafeArea(
            child: CustomScrollView(slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        child: TypingTextAnimation(
                          text: 'Welcome \nTo \nCoders Gym',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ), // Use theme style for title
                        ),
                      ),
                      SvgPicture.asset(
                        Assets.icons.coding,
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        fit: BoxFit.cover,
                      ),
                      const Spacer(),
                      LeetCodeLoginButton(),
                      const SizedBox(height: 8),
                      Text(
                        "---OR---",
                        style: textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final username = await showDialog<String>(
                            context: context,
                            builder: (BuildContext context) {
                              return const UsernameDialog();
                            },
                          );

                          if (username != null &&
                              username.isNotEmpty &&
                              context.mounted) {
                            context.read<AuthBloc>().add(
                                  AuthLoginWithLeetcodeUserName(
                                    leetcodeUserName: username,
                                  ),
                                );
                          }
                        },
                        child: const Text("Enter Your UserName"),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    ));
  }
}
