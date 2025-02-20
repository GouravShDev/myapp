import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/routes/app_router.gr.dart';
import 'package:codersgym/core/utils/inherited_provider.dart';
import 'package:codersgym/features/common/widgets/app_error_widget.dart';
import 'package:codersgym/features/common/widgets/app_pagination_list.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:codersgym/features/question/presentation/blocs/community_solutions/community_solutions_bloc.dart';
import 'package:codersgym/features/question/presentation/widgets/community_solution_tags_selection_button.dart';
import 'package:codersgym/features/question/presentation/widgets/solution_post_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuestionCommunitySolution extends HookWidget {
  const QuestionCommunitySolution({super.key, required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    final communitySolutionCubit = context.read<CommunitySolutionsBloc>();

    useEffect(
      () {
        communitySolutionCubit.add(FetchCommunitySolutionListEvent(
          questionTitleSlug: question.titleSlug ?? '',
        ));
        return null;
      },
      [],
    );
    return Column(
      children: [
        const SizedBox(
          height: 8,
        ),
        // Filter widget with padding
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: SolutionFilterSearchBar(
              // knowledgeTags: knowledgeTags,
              // languageTags: languageTags,
              // onFiltersChanged: handleFiltersChanged,
              ),
        ),
        BlocBuilder<CommunitySolutionsBloc, CommunitySolutionsState>(
          builder: (context, state) {
            final solutions = state.solutions;
            if (state.isLoading && solutions.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state.error != null) {
              return AppErrorWidget(
                onRetry: () {
                  communitySolutionCubit.add(FetchCommunitySolutionListEvent(
                    questionTitleSlug: question.titleSlug ?? '',
                  ));
                },
              );
            }
            return Expanded(
              child: AppPaginationList(
                scrollController:
                    InheritedDataProvider.of<ScrollController>(context),
                itemBuilder: (context, index) {
                  return SolutionPostTile(
                    postDetail: solutions[index],
                    onCardTap: () {
                      AutoRouter.of(context).push(
                        CommunityPostRoute(
                          postDetail: solutions[index],
                        ),
                      );
                    },
                  );
                },
                itemCount: solutions.length,
                moreAvailable: state.moreSolutionsAvailable,
                loadMoreData: () {
                  communitySolutionCubit.add(FetchCommunitySolutionListEvent(
                    questionTitleSlug: question.titleSlug ?? '',
                  ));
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

// Models for tags
class KnowledgeTag {
  final String name;
  final String slug;
  final int count;

  KnowledgeTag({required this.name, required this.slug, required this.count});
}

class LanguageTag {
  final String name;
  final String slug;
  final int count;

  LanguageTag({required this.name, required this.slug, required this.count});
}

// Main filter widget with expandable tags row
class SolutionFilterSearchBar extends StatefulWidget {
  // final List<KnowledgeTag> knowledgeTags;
  // final List<LanguageTag> languageTags;
  // final Function(List<String>, List<String>, String, String) onFiltersChanged;

  const SolutionFilterSearchBar({
    Key? key,
    // required this.knowledgeTags,
    // required this.languageTags,
    // required this.onFiltersChanged,
  }) : super(key: key);

  @override
  _SolutionFilterSearchBarState createState() =>
      _SolutionFilterSearchBarState();
}

class _SolutionFilterSearchBarState extends State<SolutionFilterSearchBar> {
  List<String> selectedKnowledgeTags = [];
  List<String> selectedLanguageTags = [];
  String searchQuery = '';
  String sortOption = 'HOT';

  final List<String> sortOptions = ['HOT', 'Votes', 'Recent'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _notifyFiltersChanged() {
    // widget.onFiltersChanged(
    //   selectedKnowledgeTags,
    //   selectedLanguageTags,
    //   searchQuery,
    //   sortOption,
    // );
  }

  void _toggleKnowledgeTag(String slug) {
    setState(() {
      if (selectedKnowledgeTags.contains(slug)) {
        selectedKnowledgeTags.remove(slug);
      } else {
        selectedKnowledgeTags.add(slug);
      }
      _notifyFiltersChanged();
    });
  }

  void _toggleLanguageTag(String slug) {
    setState(() {
      if (selectedLanguageTags.contains(slug)) {
        selectedLanguageTags.remove(slug);
      } else {
        selectedLanguageTags.add(slug);
      }
      _notifyFiltersChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Convert your tag data to the unified Tag model
    final knowledgeTags = [
      Tag(
          name: "Backtracking",
          slug: "backtracking",
          count: 462,
          type: TagType.knowledge),
      Tag(name: "String", slug: "string", count: 276, type: TagType.knowledge),
      Tag(
          name: "Dynamic Programming",
          slug: "dp",
          count: 389,
          type: TagType.knowledge),
      Tag(name: "Arrays", slug: "arrays", count: 512, type: TagType.knowledge),
      Tag(name: "Trees", slug: "trees", count: 304, type: TagType.knowledge),
    ];

    final languageTags = [
      Tag(name: "C++", slug: "cpp", count: 574, type: TagType.language),
      Tag(name: "Java", slug: "java", count: 348, type: TagType.language),
      Tag(name: "Python", slug: "python", count: 421, type: TagType.language),
      Tag(
          name: "JavaScript",
          slug: "javascript",
          count: 267,
          type: TagType.language),
      Tag(name: "Go", slug: "go", count: 128, type: TagType.language),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row: Search bar and sort filter
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Bar
              Expanded(
                flex: 4,
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                      _notifyFiltersChanged();
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              CommunitySolutionTagsSelectionButton(
                knowledgeTags: knowledgeTags,
                languageTags: languageTags,
                onTagsSelected: (selectedTags) {
                  // Handle selected tags
                  final knowledgeCount = selectedTags
                      .where((tag) => tag.type == TagType.knowledge)
                      .length;
                  final languageCount = selectedTags
                      .where((tag) => tag.type == TagType.language)
                      .length;
                  print(
                      'Selected $knowledgeCount knowledge tags and $languageCount language tags');
                },
              ),
              const SizedBox(width: 8),
              // Sort Filter
              SortDropdown(
                onSortChanged: (String) {},
              ),
              // IntrinsicWidth(
              //   child: DropdownButtonFormField<String>(
              //     value: sortOption,
              //     icon: Transform(
              //       alignment: Alignment.center,
              //       transform: Matrix4.identity()
              //         ..rotateZ(-90 * (pi / 180)) // Rotate -90 degrees
              //         ..scale(0.8) // Scale down to 80% of the original size
              //         ..translate(10.0, 8.0), // Translate to the right (x-axis)
              //       child: Icon(
              //         Icons.sort_sharp,
              //         color: Theme.of(context).hintColor,
              //       ),
              //     ),
              //     isDense: true,
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderSide: BorderSide.none,
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              //       filled: true,
              //       fillColor: Theme.of(context).cardColor,
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide.none,
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide.none,
              //         borderRadius: BorderRadius.circular(10.0),
              //       ),
              //     ),
              //     borderRadius: BorderRadius.circular(8.0),
              //     padding: EdgeInsets.zero,
              //     style: Theme.of(context).textTheme.titleMedium,
              //     hint: const Text('Sort'),
              //     items: sortOptions.map((String option) {
              //       return DropdownMenuItem<String>(
              //         value: option,
              //         child: Text(option, style: const TextStyle(fontSize: 12)),
              //       );
              //     }).toList(),
              //     onChanged: (String? newValue) {
              //       if (newValue != null) {
              //         setState(() {
              //           sortOption = newValue;
              //           _notifyFiltersChanged();
              //         });
              //       }
              //     },
              //   ),
              // ),
              //
            ],
          ),
        ),

        // const SizedBox(height: 12),

        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(
            //   height: 36,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: widget.languageTags.map((tag) {
            //       final isSelected = selectedLanguageTags.contains(tag.slug);
            //       return Padding(
            //         padding: const EdgeInsets.only(right: 8),
            //         child: ChoiceChip(
            //           label: Text('${tag.name} (${tag.count})'),
            //           selected: isSelected,
            //           onSelected: (_) => _toggleLanguageTag(tag.slug),
            //           labelStyle: const TextStyle(fontSize: 12),
            //           padding: EdgeInsets.zero,
            //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //         ),
            //       );
            //     }).toList(),
            //   ),
            // ),
            // // const SizedBox(height: 12),
            // Row(
            //   children: [
            //     // Scrollable knowledge tags
            //     Expanded(
            //       child: SizedBox(
            //         height: 36,
            //         child: ListView(
            //           scrollDirection: Axis.horizontal,
            //           children: widget.knowledgeTags.map((tag) {
            //             final isSelected =
            //                 selectedKnowledgeTags.contains(tag.slug);
            //             return Padding(
            //               padding: const EdgeInsets.only(right: 8),
            //               child: ChoiceChip(
            //                 label: Text('${tag.name} (${tag.count})'),
            //                 selected: isSelected,
            //                 showCheckmark: true,
            //                 color: WidgetStateProperty.resolveWith<Color?>(
            //                       (Set<WidgetState> states) {
            //                     if (states.contains(WidgetState.selected)) {
            //                       return Theme.of(context).primaryColor; // Selected state color
            //                     }
            //                     if (states.contains(WidgetState.disabled)) {
            //                       return Theme.of(context).cardColor; // Disabled state color
            //                     }
            //                     return Theme.of(context).cardColor; // Default color
            //                   },
            //                 ),
            //                 onSelected: (_) => _toggleKnowledgeTag(tag.slug),
            //                 labelStyle: const TextStyle(fontSize: 12),
            //                 padding: EdgeInsets.zero,
            //                 materialTapTargetSize:
            //                     MaterialTapTargetSize.shrinkWrap,
            //               ),
            //             );
            //           }).toList(),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            //
          ],
        ),

        // Show active filters (only if any selected)
        if ((selectedKnowledgeTags.isNotEmpty ||
            selectedLanguageTags.isNotEmpty))
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                //   ...selectedLanguageTags.map((slug) {
                //     final tag =
                //         widget.languageTags.firstWhere((t) => t.slug == slug);
                //     return Chip(
                //       label: Text(tag.name, style: const TextStyle(fontSize: 11)),
                //       deleteIcon: const Icon(Icons.close, size: 14),
                //       onDeleted: () => _toggleLanguageTag(slug),
                //       visualDensity: VisualDensity.compact,
                //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //     );
                //   }),
                //   ...selectedKnowledgeTags.map((slug) {
                //     final tag =
                //         widget.knowledgeTags.firstWhere((t) => t.slug == slug);
                //     return Chip(
                //       label: Text(tag.name, style: const TextStyle(fontSize: 11)),
                //       deleteIcon: const Icon(Icons.close, size: 14),
                //       onDeleted: () => _toggleKnowledgeTag(slug),
                //       visualDensity: VisualDensity.compact,
                //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                //     );
                //   }),
              ],
            ),
          ),
      ],
    );
  }
}

class MobileFilterablePaginatedListScreen extends StatefulWidget {
  const MobileFilterablePaginatedListScreen({Key? key, required this.list})
      : super(key: key);
  final Widget list;

  @override
  _MobileFilterablePaginatedListScreenState createState() =>
      _MobileFilterablePaginatedListScreenState();
}

class _MobileFilterablePaginatedListScreenState
    extends State<MobileFilterablePaginatedListScreen> {
  // Sample data
  final List<KnowledgeTag> knowledgeTags = [
    KnowledgeTag(name: "Backtracking", slug: "backtracking", count: 462),
    KnowledgeTag(name: "String", slug: "string", count: 276),
    KnowledgeTag(name: "Dynamic Programming", slug: "dp", count: 389),
    KnowledgeTag(name: "Arrays", slug: "arrays", count: 512),
    KnowledgeTag(name: "Trees", slug: "trees", count: 304),
  ];

  final List<LanguageTag> languageTags = [
    LanguageTag(name: "C++", slug: "cpp", count: 574),
    LanguageTag(name: "Java", slug: "java", count: 348),
    LanguageTag(name: "Python", slug: "python", count: 421),
    LanguageTag(name: "JavaScript", slug: "javascript", count: 267),
    LanguageTag(name: "Go", slug: "go", count: 128),
  ];

  // These would store the current filter state
  List<String> activeKnowledgeTags = [];
  List<String> activeLanguageTags = [];
  String currentSearchQuery = '';
  String currentSortOption = 'HOT';

  void handleFiltersChanged(
    List<String> knowledgeTags,
    List<String> languageTags,
    String searchQuery,
    String sortOption,
  ) {
    setState(() {
      activeKnowledgeTags = knowledgeTags;
      activeLanguageTags = languageTags;
      currentSearchQuery = searchQuery;
      currentSortOption = sortOption;

      // Here you would update your paginated list based on these filters
      _refreshPaginatedList();
    });
  }

  void _refreshPaginatedList() {
    // Call your existing pagination logic with the new filters
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Your existing paginated list would go here
        Expanded(
          child: widget.list,
        ),
      ],
    );
  }
}

class TerminalLoadingIndicator extends StatefulWidget {
  final double size;
  final Color cursorColor;
  final Duration blinkDuration;
  final int dotCount;
  final bool showBackground;

  const TerminalLoadingIndicator({
    Key? key,
    this.size = 40.0,
    this.cursorColor = const Color(0xFF4CAF50),
    this.blinkDuration = const Duration(milliseconds: 500),
    this.dotCount = 3,
    this.showBackground = true,
  }) : super(key: key);

  @override
  State<TerminalLoadingIndicator> createState() =>
      _TerminalLoadingIndicatorState();
}

class _TerminalLoadingIndicatorState extends State<TerminalLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: widget.blinkDuration.inMilliseconds * widget.dotCount),
    )..repeat();

    _setupAnimations();
  }

  void _setupAnimations() {
    _dotAnimations = List<Animation<double>>.generate(
      widget.dotCount,
      (i) => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: 1.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 20,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 1.0),
          weight: 60,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: 1.0, end: 0.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 20,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            i / widget.dotCount,
            (i + 1) / widget.dotCount,
            curve: Curves.linear,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (widget.showBackground)
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(widget.size / 8),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildCursor(),
              SizedBox(width: widget.size / 7),
              ..._buildDots(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCursor() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final blinkValue = (_controller.value * 5).floor() % 2 == 0 ? 1.0 : 0.2;
        return Container(
          width: widget.size / 5,
          height: widget.size / 2.5,
          decoration: BoxDecoration(
            color: widget.cursorColor.withOpacity(blinkValue),
            borderRadius: BorderRadius.circular(2),
          ),
        );
      },
    );
  }

  List<Widget> _buildDots() {
    return List<Widget>.generate(
      widget.dotCount,
      (i) => AnimatedBuilder(
        animation: _dotAnimations[i],
        builder: (context, child) {
          return Container(
            width: widget.size / 10,
            height: widget.size / 10,
            margin: EdgeInsets.symmetric(horizontal: widget.size / 20),
            decoration: BoxDecoration(
              color: widget.cursorColor.withOpacity(_dotAnimations[i].value),
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}

class SortDropdown extends StatefulWidget {
  const SortDropdown({
    Key? key,
    required this.onSortChanged,
    this.initialSort,
  }) : super(key: key);

  final Function(String) onSortChanged;
  final String? initialSort;

  @override
  State<SortDropdown> createState() => _SortDropdownState();
}

class _SortDropdownState extends State<SortDropdown> {
  String? sortOption;

  final List<Map<String, dynamic>> sortOptions = [
    {
      'value': 'HOT',
      'icon': Icons.local_fire_department,
      'color': Colors.orange,
    },
    {
      'value': 'Votes',
      'icon': Icons.thumb_up_alt_outlined,
      'color': Colors.blue,
    },
    {
      'value': 'Recent',
      'icon': Icons.access_time,
      'color': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    sortOption = widget.initialSort ?? sortOptions[0]['value'];
  }

  // Helper to get current icon data
  Map<String, dynamic> get _currentSortData {
    return sortOptions.firstWhere(
      (option) => option['value'] == sortOption,
      orElse: () => sortOptions[0],
    );
  }

  @override
  Widget build(BuildContext context) {

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 54),
      child: IntrinsicWidth(
        child: DropdownButtonFormField<String>(
          value: sortOption,
          isDense: true,
          isExpanded: false,
          icon: Transform(
            alignment: Alignment.centerRight,
            transform: Matrix4.identity()
              ..rotateZ(-270 * (pi / 180))
              ..scale(1.8)
              ..translate(4.0, 4.0),
            child: Icon(
              Icons.sort_sharp,
              color: Theme.of(context).hintColor,
              size: 12,
            ),
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            filled: true,
            fillColor: Theme.of(context).cardColor,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          borderRadius: BorderRadius.circular(8.0),
          padding: EdgeInsets.zero,
          style: Theme.of(context).textTheme.titleMedium,
          // Show only the icon when dropdown is closed
          selectedItemBuilder: (BuildContext context) {
            return sortOptions.map<Widget>((Map<String, dynamic> option) {
              return Center(
                child: Icon(
                  option['icon'] as IconData,
                  color: option['color'] as Color,
                  size: 20,
                ),
              );
            }).toList();
          },
          items: sortOptions.map((Map<String, dynamic> option) {
            return DropdownMenuItem<String>(
              value: option['value'] as String,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    option['icon'] as IconData,
                    color: option['color'] as Color,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    option['value'] as String,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                sortOption = newValue;
                widget.onSortChanged(newValue);
              });
            }
          },
        ),
      ),
    );
  }
}

// Example Usage:
class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  String currentSort = 'HOT';

  void _handleSortChange(String newSort) {
    setState(() {
      currentSort = newSort;
      // Add your sorting logic here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sort Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SortDropdown(
                  initialSort: currentSort,
                  onSortChanged: _handleSortChange,
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Your content here
            Center(
              child: Text(
                'Currently sorting by: $currentSort',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
