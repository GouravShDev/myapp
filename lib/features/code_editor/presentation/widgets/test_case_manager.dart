import 'package:codersgym/features/code_editor/presentation/pages/code_editor_page.dart';
import 'package:codersgym/features/question/domain/model/question.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TestCaseManager extends StatelessWidget {
  final List<TestCase> testcases;

  const TestCaseManager({
    super.key,
    required this.testcases,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.2,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Testcases',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        // Add Test Case Button
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {},
                        ),
                        // Run Test Cases Button
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Run Code'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              TestCaseManagerWidget(
                testcases: testcases,
              ),

              // Test Cases List
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemCount: testcases.length,
              //   itemBuilder: (context, index) {
              //     final testCase = testcases[index];
              //     return Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Card(
              //         child: Padding(
              //           padding: const EdgeInsets.all(12.0),
              //           child: Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               // Input TextField
              //               TextField(
              //                 decoration: InputDecoration(
              //                   labelText: 'Input',
              //                   border: const OutlineInputBorder(),
              //                   suffixIcon: testcases.length > 1
              //                       ? IconButton(
              //                           icon: const Icon(Icons.delete,
              //                               color: Colors.red),
              //                           onPressed: () {},
              //                         )
              //                       : null,
              //                 ),
              //                 maxLines: 2,
              //               ),
              //               const SizedBox(height: 12),

              //               // Expected Output TextField
              //               const TextField(
              //                 decoration: InputDecoration(
              //                   labelText: 'Expected Output',
              //                   border: OutlineInputBorder(),
              //                 ),
              //                 maxLines: 2,
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     );
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }
}

class TestCaseManagerWidget extends HookWidget {
  const TestCaseManagerWidget({
    super.key,
    required this.testcases,
  });
  final List<TestCase> testcases;

  @override
  Widget build(BuildContext context) {
    final currentTestcases = useState(testcases);
    final selectedTestcase = useState(testcases.first);
    return Column(
      children: [
        Row(
          children: [
            ...List.generate(
              currentTestcases.value.length,
              (index) {
                // Wrap the Card with Dismissible
                return Dismissible(
                  key: Key(
                      currentTestcases.value[index].toString()), // Unique key
                  direction: DismissDirection.horizontal,
                  confirmDismiss: (direction) async {
                    if (currentTestcases.value.length == 1) {
                      // Show a snackbar or dialog indicating the last testcase can't be deleted
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Cannot delete the last testcase')),
                      );
                      return false; // Prevent dismissal
                    }
                    return true; // Allow dismissal
                  },
                  onDismissed: (direction) {
                    currentTestcases.value.removeAt(index);
                  },
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                  ),
                  child: InkWell(
                    // Wrap with InkWell for tap functionality
                    onTap: () {
                      // Update the selected testcase
                      selectedTestcase.value = currentTestcases.value[index];
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Case ${index + 1}"),
                      ),
                    ),
                  ),
                );
              },
            ),
            // Limit adding to a maximum of 5 testcases
            if (currentTestcases.value.length < 5)
              IconButton(
                onPressed: () {
                  currentTestcases.value.add(selectedTestcase.value);
                },
                icon: const Icon(Icons.add),
              ),
          ],
        ),
        ...List.generate(
          selectedTestcase.value.inputs.length,
          (index) {
            final currentInput = selectedTestcase.value.inputs[index];
            return Column(
              children: [
                Text("Input ${index + 1}"),
                const SizedBox(
                  height: 4,
                ),
                TextFormField(
                  initialValue: currentInput,
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
