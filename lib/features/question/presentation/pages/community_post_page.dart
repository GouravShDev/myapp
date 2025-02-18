import 'package:auto_route/auto_route.dart';
import 'package:codersgym/features/common/widgets/leetcode_markdown/leetcode_markdown_widget.dart';
import 'package:codersgym/features/question/domain/model/community_solution_post_detail.dart';
import 'package:codersgym/features/question/presentation/blocs/community_post_detail/community_post_detail_cubit.dart';
import 'package:codersgym/injection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
          title: Text(postDetail.title ?? 'Post detail'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              BlocBuilder<CommunityPostDetailCubit, CommunityPostDetailState>(
            builder: (context, state) {
              return state.when(
                onInitial: () => const SizedBox.shrink(),
                onLoading: (_) =>
                    const Center(child: CircularProgressIndicator()),
                onLoaded: (updatedPostDetail) {
                  return LeetcodeMarkdownWidget(
                    data: updatedPostDetail.post?.content ?? '',
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

