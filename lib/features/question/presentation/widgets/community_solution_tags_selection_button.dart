import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Tag {
  final String name;
  final String slug;
  final int count;
  final TagType type;

  Tag({
    required this.name,
    required this.slug,
    required this.count,
    required this.type,
  });
}

enum TagType {
  knowledge,
  language,
}

class CommunitySolutionTagsSelectionButton extends HookWidget {
  const CommunitySolutionTagsSelectionButton({
    super.key,
    this.initialValue,
    required this.onTagsSelected,
    required this.knowledgeTags,
    required this.languageTags,
  });

  final Set<Tag>? initialValue;
  final Function(Set<Tag> selectedTags) onTagsSelected;
  final List<Tag> knowledgeTags;
  final List<Tag> languageTags;

  void _showTagSelectionDialog(
      BuildContext context, ValueNotifier<Set<Tag>?> selectedTags) async {
    Set<Tag>? result = await showDialog<Set<Tag>>(
      context: context,
      builder: (BuildContext context) {
        return TagSelectionDialog(
          knowledgeTags: knowledgeTags,
          languageTags: languageTags,
          selectedTags: selectedTags.value,
        );
      },
    );
    if (result != null) {
      selectedTags.value = result;
      onTagsSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTags = useState<Set<Tag>?>(initialValue);
    final currentTags = selectedTags.value;

    // Count by tag type
    final knowledgeCount =
        currentTags?.where((tag) => tag.type == TagType.knowledge).length ?? 0;
    final languageCount =
        currentTags?.where((tag) => tag.type == TagType.language).length ?? 0;
    final totalCount = currentTags?.length ?? 0;

    return InkWell(
      onTap: () => _showTagSelectionDialog(context, selectedTags),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
        ),
        child: Icon(
          Icons.tag,
          size: 18,
          color: totalCount > 0 ? Theme.of(context).primaryColor : null,
        ),
      ),
    );
  }
}

class TagSelectionDialog extends StatefulWidget {
  final List<Tag> knowledgeTags;
  final List<Tag> languageTags;
  final Set<Tag>? selectedTags;

  const TagSelectionDialog({
    super.key,
    required this.knowledgeTags,
    required this.languageTags,
    required this.selectedTags,
  });

  @override
  TagSelectionDialogState createState() => TagSelectionDialogState();
}

class TagSelectionDialogState extends State<TagSelectionDialog> {
  late Set<Tag> _tempSelectedTags;

  @override
  void initState() {
    super.initState();
    _tempSelectedTags = Set<Tag>.from(widget.selectedTags ?? {});
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
        child:
            Text('Select Tags', style: Theme.of(context).textTheme.titleLarge),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      actionsPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  'Knowledge Areas',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.knowledgeTags.map((tag) {
                    final isSelected = _tempSelectedTags.contains(tag);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _tempSelectedTags.remove(tag);
                          } else {
                            _tempSelectedTags.add(tag);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).focusColor,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Theme.of(context).cardColor,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tag.name,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.black26
                                    : Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tag.count.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isSelected ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const Divider(
                height: 32,
                thickness: 1,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  'Programming Languages',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                width: double.maxFinite,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.languageTags.map((tag) {
                    final isSelected = _tempSelectedTags.contains(tag);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _tempSelectedTags.remove(tag);
                          } else {
                            _tempSelectedTags.add(tag);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).focusColor,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Theme.of(context).cardColor,
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tag.name,
                              style: TextStyle(
                                color: isSelected ? Colors.black : Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.black26
                                    : Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tag.count.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isSelected ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(_tempSelectedTags);
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }
}
