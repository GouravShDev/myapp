import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/utils/app_constants.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:codersgym/features/settings/presentation/blocs/app_info/app_info_cubit.dart';
import 'package:codersgym/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              final userName =
                  (authState is Authenticated) ? authState.userName : null;

              return BlocBuilder<AppInfoCubit, AppInfoState>(
                builder: (context, state) {
                  return switch (state) {
                    AppInfoInitial() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    AppInfoLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    AppInfoLoaded() => SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: CircleAvatar(
                                      radius: 48,
                                      backgroundColor: theme.focusColor,
                                      child: CircleAvatar(
                                        foregroundImage: AssetImage(
                                            Assets.images.appIcon.path),
                                        radius: 40,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    AppConstants.appName,
                                    style: textTheme.headlineSmall,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(),
                            ListTile(
                              leading: Icon(
                                Icons.terminal,
                                color: theme.primaryColor,
                              ),
                              title: const Text("Coding Expereince"),
                              onTap: () {
                                final router = context.router;
                                router?.push(
                                  const CodingExperienceRoute(),
                                );
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                Icons.notifications,
                                color: theme.primaryColor,
                              ),
                              title: const Text("Notifications"),
                              onTap: () {
                                AutoRouter.of(context)
                                    .push(const NotificationRoute());
                              },
                            ),
                            // Report Bug Section
                            ListTile(
                              leading: Icon(
                                Icons.bug_report,
                                color: theme.primaryColor,
                              ),
                              title: const Text("Report a Bug"),
                              onTap: () {
                                final Uri emailUri = Uri(
                                  scheme: 'mailto',
                                  path: AppConstants.reportBugEmail,
                                  queryParameters: {
                                    'subject': 'Bug Report from ${userName}',
                                    'body': 'Please describe the issue here...',
                                  },
                                );
                                _launchUrl(emailUri);
                              },
                            ),

                            // Source Code Section
                            ListTile(
                              leading: Icon(
                                Icons.code,
                                color: theme.primaryColor,
                              ),
                              title: const Text("Source Code"),
                              onTap: () {
                                final uri =
                                    Uri.tryParse(AppConstants.sourceCodeUrl);
                                if (uri != null) _launchUrl(uri);
                              },
                            ),
                            // What's new in this version Code
                            ListTile(
                              leading: Icon(
                                Icons.new_releases_outlined,
                                color: theme.primaryColor,
                              ),
                              title: const Text("What's new in this release"),
                              onTap: () {
                                final uri = Uri.tryParse(
                                  AppConstants.releaseNoteUrl.replaceAll(
                                    '{versionName}',
                                    state.appVersionName,
                                  ),
                                );
                                if (uri != null) _launchUrl(uri);
                              },
                            ),
                            // Update Section

                            // Version Section
                            ListTile(
                              leading: Icon(
                                Icons.info_outline,
                                color: theme.primaryColor,
                              ),
                              title: const Text("Version"),
                              subtitle: Text(state.appVersionName),
                              subtitleTextStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                              onTap: () async {
                                showAboutDialog(
                                  context: context,
                                  applicationName: AppConstants.appName,
                                  applicationVersion: state.appVersionName,
                                  applicationIcon: Image.asset(
                                    Assets.images.appIcon.path,
                                    width: 60,
                                    height: 60,
                                  ),
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                          "This app is used to view leetcode problem in mobile friendly view."),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Currntly Logged as:",
                                    style: textTheme.titleMedium,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  if (authState
                                      is AuthenticatedWithLeetcodeAccount)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${userName}",
                                          style: textTheme.bodyLarge,
                                        ),
                                        const SizedBox(width: 6),
                                        Icon(
                                          Icons.verified,
                                          color: theme.primaryColor,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  if (authState
                                      is AuthenticatedWithLeetcodeUserName)
                                    Text(
                                      "Guest User : ${userName}",
                                      style: textTheme.bodyLarge,
                                    ),
                                ],
                              ),
                            ),

                            Center(
                              child: TextButton.icon(
                                onPressed: () {
                                  context.read<AuthBloc>().add(AuthLogout());
                                },
                                label: const Text("Logout"),
                                icon: const Icon(Icons.logout_rounded),
                              ),
                            )
                          ],
                        ),
                      )
                  };
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
