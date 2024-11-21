import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:codersgym/features/question/presentation/blocs/community_post_detail/community_post_detail_cubit.dart';
import 'package:codersgym/features/question/presentation/widgets/editorial_html.dart';
import 'package:codersgym/features/question/presentation/widgets/question_community_solution.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class CommunityPostPage extends HookWidget implements AutoRouteWrapper {
  const CommunityPostPage({
    super.key,
    required this.postDetail,
  });
  final CommunitySolutionPostDetail postDetail;

  @override
  Widget build(BuildContext context) {
    final communityPostCubit = context.read<CommunityPostDetailCubit>();
    useEffect(() {
      communityPostCubit.getCommunitySolutionsDetails(postDetail);
      return null;
    }, []);
    return Scaffold(
        appBar: AppBar(
          title: Text(postDetail?.title ?? 'Post detail'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              BlocBuilder<CommunityPostDetailCubit, CommunityPostDetailState>(
            builder: (context, state) {
              return state.when(
                onInitial: () => SizedBox.shrink(),
                onLoading: () => Center(child: CircularProgressIndicator()),
                onLoaded: (updatedPostDetail) {
                  return Markdown(
                    data: updatedPostDetail.post?.content ?? '',
                    onTapLink: (text, href, title) async {
                      if (href == null) return;
                      final uri = Uri.parse(href);
                      if (!await launchUrl(uri)) {
                        throw Exception('Could not launch $uri');
                      }
                    },
                    extensionSet: md.ExtensionSet(
                      md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                      <md.InlineSyntax>[
                        md.EmojiSyntax(),
                        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                      ],
                    ),
                  );
                },
                onError: (exception) => Text(exception.toString()),
              );
            },
          ),
        ));
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt.get<CommunityPostDetailCubit>(),
        ),
      ],
      child: this,
    );
  }
}
