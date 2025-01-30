import 'package:auto_route/auto_route.dart';
import 'package:codersgym/core/utils/string_extension.dart';
import 'package:codersgym/features/code_editor/domain/model/coding_key_config.dart';
import 'package:codersgym/features/code_editor/domain/model/programming_language.dart';
import 'package:codersgym/features/code_editor/presentation/blocs/customize_coding_experience/customize_coding_experience_bloc.dart';
import 'package:codersgym/features/code_editor/presentation/widgets/coding_keys.dart';
import 'package:codersgym/features/common/widgets/app_code_editor_field.dart';
import 'package:codersgym/injection.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:reorderables/reorderables.dart';
import 'package:vibration/vibration.dart';

const String sampleCode = """class Solution {
public:
    bool twoSum(string s, int k) {
        
    }
};""";

@RoutePage()
class CodingExperiencePage extends StatelessWidget implements AutoRouteWrapper {
  const CodingExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    final codeExpBloc = context.read<CustomizeCodingExperienceBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customize Experience"),
      ),
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: const Text(
                'Coding Experience Settings',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ListTile(
                leading: const Icon(Icons.palette),
                title: const Text("Themes"),
                onTap: () {
                  Navigator.pop(context);
                  showThemePickerBottomSheet(
                    context,
                    (selectedThemeId) {
                      codeExpBloc.add(
                        CustomizeCodingExperienceOnThemeChanged(
                          selectedThemeId.id,
                        ),
                      );
                    },
                  );
                }
                //   showModalBottomSheet(
                //     context: context,
                //     isScrollControlled: true,
                //     builder: (BuildContext context) {
                //       return DraggableScrollableSheet(
                //         initialChildSize: 0.9,
                //         minChildSize: 0.5,
                //         maxChildSize: 0.95,
                //         builder: (_, controller) => Container(
                //           decoration: BoxDecoration(
                //             color: Theme.of(context).cardColor,
                //             borderRadius: const BorderRadius.vertical(
                //                 top: Radius.circular(20)),
                //           ),
                //           child: Column(
                //             children: [
                //               Padding(
                //                 padding: const EdgeInsets.all(8.0),
                //                 child: Text('Select Theme',
                //                     style:
                //                         Theme.of(context).textTheme.titleLarge),
                //               ),
                //               Expanded(
                //                 child: GridView.builder(
                //                   shrinkWrap: true,
                //                   controller: controller,
                //                   padding: const EdgeInsets.all(10),
                //                   gridDelegate:
                //                       const SliverGridDelegateWithFixedCrossAxisCount(
                //                     crossAxisCount: 3,
                //                     childAspectRatio: 1.5,
                //                     crossAxisSpacing: 10,
                //                     mainAxisSpacing: 10,
                //                   ),
                //                   itemCount: themeMap.length,
                //                   itemBuilder: (context, index) {
                //                     final themeName =
                //                         themeMap.keys.elementAt(index);
                //                     return GestureDetector(
                //                       onTap: () {
                //                         // codeExpBloc.add(ThemeChangedEvent(themeName));
                //                         Navigator.pop(context);
                //                       },
                //                       child: Container(
                //                         decoration: BoxDecoration(
                //                           color: Colors.transparent,
                //                           borderRadius: BorderRadius.circular(10),
                //                           border: Border.all(
                //                             color: Theme.of(context)
                //                                 .primaryColor
                //                                 .withOpacity(0.5),
                //                           ),
                //                         ),
                //                         child: Center(
                //                           child: Text(
                //                             themeName,
                //                             textAlign: TextAlign.center,
                //                             style: Theme.of(context)
                //                                 .textTheme
                //                                 .bodyMedium,
                //                           ),
                //                         ),
                //                       ),
                //                     );
                //                   },
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                //   );
                // },
                ),
            ListTile(
              leading: const Icon(Icons.import_export),
              title: const Text("Export Configuration"),
              onTap: () {
                // Implement export logic
                Navigator.pop(context);
                // Show export dialog or perform export action
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text("Import Configuration"),
              onTap: () {
                // Implement import logic
                Navigator.pop(context);
                // Show import dialog or perform import action
              },
            ),
          ],
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, __) async {
          if (didPop) {
            return;
          }
          if (codeExpBloc.state.modificationStatus !=
              ConfigurationModificationStatus.unsaved) {
            Navigator.pop(context);
            return;
          }
          final shouldGoBack = await SaveConfigurationDialog.show(context) ??
              false; // Default to staying on the page if the dialog is dismissed
          if (!shouldGoBack) {
            return;
          }
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
        child: SafeArea(
          child: Center(
            child: CustomizableKeyboard(
              codeController: CodeController(
                text: sampleCode,
                language: ProgrammingLanguage.cpp.mode,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<CustomizeCodingExperienceBloc>()
        ..add(
          CustomizeCodingExperienceLoadConfiguration(),
        ),
      child: this,
    );
  }
}

void showThemePickerBottomSheet(
    BuildContext context, Function(AppCodeEditorTheme) onThemeSelected) {
  showModalBottomSheet(
    context: context,
    barrierColor: Colors.black.withOpacity(0.1),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose a Theme',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: AppCodeEditorField.codeEditorThemes.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final theme = AppCodeEditorField.codeEditorThemes[index];
                  return InkWell(
                    onTap: () {
                      onThemeSelected(theme);
                      //  Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.data['title']?.color ??
                              Theme.of(context).primaryColor,
                        ),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            theme.id.convertToTitleCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

class CustomizableKeyboard extends StatefulWidget {
  final CodeController codeController;

  const CustomizableKeyboard({
    super.key,
    required this.codeController,
  });

  @override
  State<CustomizableKeyboard> createState() => _CustomizableKeyboardState();
}

class _CustomizableKeyboardState extends State<CustomizableKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<CustomizeCodingExperienceBloc,
              CustomizeCodingExperienceState>(
            buildWhen: (previous, current) =>
                previous.isCustomizing != current.isCustomizing ||
                previous.editorThemeId != current.editorThemeId,
            builder: (context, state) {
              // return HighlightView(
              //   sampleCode,
              //   language: "cpp",
              //   theme: themeMap[state.editorThemeId]!,
              // );
              return AppCodeEditorField(
                codeController: widget.codeController,
                enabled: !state.isCustomizing,
                editorThemeId: state.editorThemeId,
              );
            },
          ),
        ),
        CustomizableCodingKeys(
          codeController: widget.codeController,
        ),
      ],
    );
  }
}

class CustomizableCodingKeys extends StatefulWidget {
  const CustomizableCodingKeys({super.key, required this.codeController});
  final CodeController codeController;

  @override
  State<CustomizableCodingKeys> createState() => _CustomizableCodingKeysState();
}

class _CustomizableCodingKeysState extends State<CustomizableCodingKeys> {
  Widget _buildBasicKeyButton({
    required VoidCallback onPressed,
    required Widget child,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        foregroundColor: Colors.white,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      child: child,
    );
  }

  Widget _buildKeyButton(
      ({CodingKeyConfig key, String keyId}) keyPair, int index) {
    final key = keyPair.key;
    final codingExpBloc = context.read<CustomizeCodingExperienceBloc>();
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        width: constraints.maxWidth / 7,
        height: 40,
        key: ValueKey(keyPair.keyId),
        child: _buildBasicKeyButton(
          onPressed: () async {
            // show dialog where there is dialog which allow user to select coding key to replace current key
            final replacedKey = await CodingKeyReplacementDialog.show(
              context,
              key.id,
              CodingKeyConfig.defaultCodingKeyConfiguration,
            );
            if (replacedKey != null) {
              codingExpBloc.add(
                CustomizeCodingExperienceOnReplaceKeyConfig(
                  keyIndex: index,
                  replaceKeyId: replacedKey,
                ),
              );
            }
          },
          child: switch (key) {
            CodingTextKeyConfig() => Text(
                key.label,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            CodingIconKeyConfig() => Icon(key.icon),
          },
        ),
      );
    });
  }

  Widget _buildReorderableWrap() {
    // Used for adding separator between keys rows
    const secondRowStartIndex = 6;
    const secondRowEndIndex = 13;
    return BlocBuilder<CustomizeCodingExperienceBloc,
        CustomizeCodingExperienceState>(
      buildWhen: (previous, current) =>
          previous.isReordering != current.isReordering ||
          previous.isCustomizing != current.isCustomizing ||
          previous.configurationLoaded != current.configurationLoaded ||
          previous.configuration != current.configuration,
      builder: (context, codingExpState) {
        if (!codingExpState.configurationLoaded) {
          return const SizedBox.shrink();
        }
        if (!codingExpState.isCustomizing) {
          return CodingKeys(
            codeController: widget.codeController,
            codingKeyIds: codingExpState.configuration
                .map(
                  (e) => e.key.id,
                )
                .toList(),
          );
        }
        return ReorderableWrap(
          children: codingExpState.configuration.mapIndexed((index, keyPair) {
            final key = _buildKeyButton(keyPair, index);

            if (index > secondRowStartIndex &&
                index <= secondRowEndIndex &&
                !codingExpState.isReordering) {
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
                child: key,
              );
            }
            return key;
          }).toList(),
          onReorder: (oldIndex, newIndex) {
            context.read<CustomizeCodingExperienceBloc>().add(
                  CustomizeCodingExperienceKeySwap(
                    oldIndex: oldIndex,
                    newIndex: newIndex,
                  ),
                );
          },
          onNoReorder: (int index) {
            //debugPrint('${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
          },
          onReorderStarted: (int index) {
            _vibrateKey();
            context.read<CustomizeCodingExperienceBloc>().add(
                  CustomizeCodingExperienceOnReorrderingStart(),
                );

            //debugPrint('${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
          },
          buildDraggableFeedback: (context, constraints, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  width: 2,
                ),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              width: constraints.maxWidth * 1.1,
              height: constraints.maxHeight * 1.1,
              child: child,
            );
          },
        );
      },
    );
  }

  Future<void> _vibrateKey() async {
    // Check if the device can vibrate
    if (await Vibration.hasVibrator() ?? false) {
      // Android-style haptic feedback pattern
      Vibration.vibrate(duration: 50, amplitude: 128);
    } else {
      // Fallback to system haptic feedback
      HapticFeedback.heavyImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor.withOpacity(0.4),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocConsumer<CustomizeCodingExperienceBloc,
                CustomizeCodingExperienceState>(
              listener: (context, state) {
                if (state.modificationStatus ==
                    ConfigurationModificationStatus.saved) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Configuration saved successfully'),
                    ),
                  );
                }
              },
              buildWhen: (previous, current) =>
                  previous.isCustomizing != current.isCustomizing,
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.isCustomizing
                          ? "Hold Keys To Rearrange"
                          : "Current Coding Keys Layout",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton.icon(
                      icon:
                          Icon(state.isCustomizing ? Icons.check : Icons.edit),
                      label: Text(state.isCustomizing ? "Save" : "Edit"),
                      onPressed: () {
                        context.read<CustomizeCodingExperienceBloc>().add(
                              CustomizeCodingExperienceOnKeysEditSaveModeToggle(),
                            );
                      },
                    ),
                  ],
                );
              },
            ),
          ),

          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.elasticInOut,
            child: _buildReorderableWrap(),
          ),
          // ],
          // ),
        ],
      ),
    );
  }
}

class CodingKeyReplacementDialog extends StatefulWidget {
  final String currentKey;

  const CodingKeyReplacementDialog({
    Key? key,
    required this.currentKey,
  }) : super(key: key);

  @override
  _CodingKeyReplacementDialogState createState() =>
      _CodingKeyReplacementDialogState();

  // Method to show the dialog
  static Future<String?> show(BuildContext context, String currentKey,
      List<String> currentConfiguration) {
    return showDialog<String>(
      context: context,
      builder: (context) => CodingKeyReplacementDialog(
        currentKey: currentKey,
      ),
    );
  }
}

class _CodingKeyReplacementDialogState
    extends State<CodingKeyReplacementDialog> {
  CodingKeyConfig? _selectedKey;
  late List<CodingKeyConfig> _availableKeys;

  @override
  void initState() {
    super.initState();

    // Get all available keys that are not already in the current configuration
    _availableKeys = CodingKeyConfig.lookupMap.values
        .map(
          (e) => e.call(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Replace ${_getKeyLabel(widget.currentKey)}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<CodingKeyConfig>(
            decoration: const InputDecoration(
              labelText: 'Select Replacement Key',
              border: OutlineInputBorder(),
            ),
            value: _selectedKey,
            isExpanded: true,
            hint: const Text('Choose a key'),
            items: _availableKeys.map((CodingKeyConfig item) {
              return DropdownMenuItem<CodingKeyConfig>(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      switch (item) {
                        CodingTextKeyConfig() => Text(
                            item.label,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        CodingIconKeyConfig() => Icon(item.icon),
                      },
                      Text(item.id.capitalizeFirstLetter()),
                    ],
                  ),
                ),
              );
            }).toList(),
            onChanged: (CodingKeyConfig? newValue) {
              setState(() {
                _selectedKey = newValue;
              });
            },
          ),
          if (_selectedKey != null) ...[
            const SizedBox(height: 16),
            Text(
              _selectedKey!.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        ElevatedButton(
          onPressed: _selectedKey != null
              ? () => Navigator.of(context).pop(_selectedKey!.id)
              : null,
          child: const Text('Replace'),
        ),
      ],
    );
  }

  // Helper method to get a more readable label for each key
  String _getKeyLabel(String key) {
    // Remove 'CodingKeyConfig' from the end of the key name
    return key.replaceAll('CodingKeyConfig', '');
  }
}

class SaveConfigurationDialog extends StatelessWidget {
  const SaveConfigurationDialog({super.key});

  static Future<bool?> show(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => const SaveConfigurationDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Warning'),
      content: const Text(
          'You have unsaved changes. Do you want to save your configuration before proceeding?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Discard'),
        ),
        TextButton(
          onPressed: () {
            context.read<CustomizeCodingExperienceBloc>().add(
                  CustomizeCodingExperienceOnSaveConfiguration(),
                );
            Navigator.of(context).pop(true);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
