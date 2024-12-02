import 'package:codersgym/features/code_editor/presentation/pages/code_editor_page.dart';
import 'package:flutter/material.dart';

// Test Case Result Enum
enum TestCaseResultStatus { pending, passed, failed, error }

// Test Case class
class TestCase {
  TextEditingController inputController = TextEditingController();
  TextEditingController expectedOutputController = TextEditingController();
  TestCaseResult? result;
}

// Test Case Result Model
class TestCaseResult {
  final dynamic output;
  final TestCaseResultStatus status;

  TestCaseResult({this.output, required this.status});
}

class TestCaseManager extends StatefulWidget {
  final String code;
  final String language;

  const TestCaseManager({Key? key, required this.code, required this.language})
      : super(key: key);

  @override
  _TestCaseManagerState createState() => _TestCaseManagerState();
}

class _TestCaseManagerState extends State<TestCaseManager> {
  // State Variables
  List<TestCase> _testCases = [];
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    // Add initial test case
    _addTestCase();
  }

  void _addTestCase() {
    setState(() {
      _testCases.add(TestCase());
    });
  }

  void _removeTestCase(int index) {
    setState(() {
      _testCases.removeAt(index);
      // Ensure at least one test case exists
      if (_testCases.isEmpty) {
        _addTestCase();
      }
    });
  }

  Future<void> _runTestCases() async {}

  // Placeholder for code execution
  Future<dynamic> _executeCode(String code, String input) async {
    // Implement your code execution logic here
    // This could be a call to a backend service,
    // or a local code execution environment
    await Future.delayed(const Duration(seconds: 1));
    return input; // Dummy implementation
  }

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
            boxShadow: [],
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
                      'Test Cases',
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
                          onPressed: _addTestCase,
                        ),
                        // Run Test Cases Button
                        OutlinedButton.icon(
                          onPressed: _runTestCases,
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Run Code'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // // Test Cases List
              // ListView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemCount: _testCases.length,
              //   itemBuilder: (context, index) {
              //     final testCase = _testCases[index];
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
              //                 controller: testCase.inputController,
              //                 decoration: InputDecoration(
              //                   labelText: 'Input',
              //                   border: const OutlineInputBorder(),
              //                   suffixIcon: _testCases.length > 1
              //                       ? IconButton(
              //                           icon: const Icon(Icons.delete,
              //                               color: Colors.red),
              //                           onPressed: () => _removeTestCase(index),
              //                         )
              //                       : null,
              //                 ),
              //                 maxLines: 2,
              //               ),
              //               const SizedBox(height: 12),

              //               // Expected Output TextField
              //               TextField(
              //                 controller: testCase.expectedOutputController,
              //                 decoration: const InputDecoration(
              //                   labelText: 'Expected Output',
              //                   border: OutlineInputBorder(),
              //                 ),
              //                 maxLines: 2,
              //               ),

              //               // Test Result Display
              //               if (testCase.result != null)
              //                 Padding(
              //                   padding: const EdgeInsets.only(top: 12.0),
              //                   child: _buildTestResultWidget(testCase.result!),
              //                 ),
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

  Widget _buildTestResultWidget(TestCaseResult result) {
    Color color;
    IconData icon;
    String text;

    switch (result.status) {
      case TestCaseResultStatus.passed:
        color = Colors.green;
        icon = Icons.check_circle;
        text = 'Passed';
        break;
      case TestCaseResultStatus.failed:
        color = Colors.red;
        icon = Icons.cancel;
        text = 'Failed';
        break;
      case TestCaseResultStatus.error:
        color = Colors.orange;
        icon = Icons.error;
        text = 'Error';
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
        text = 'Pending';
    }

    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        if (result.output != null) ...[
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Output: ${result.output}',
              style: const TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    for (var testCase in _testCases) {
      testCase.inputController.dispose();
      testCase.expectedOutputController.dispose();
    }
    super.dispose();
  }
}

// Example Usage in a Full Screen
class CodeEditorScreen extends StatelessWidget {
  final String initialCode;
  final String language;

  const CodeEditorScreen(
      {Key? key, required this.initialCode, required this.language})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Editor'),
      ),
      body: Stack(
        children: [
          // Code Editor Placeholder
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Enter your code here',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
              ),
            ),
          ),

          // Test Case Manager as a bottom sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TestCaseManager(
              code: initialCode,
              language: language,
            ),
          ),
        ],
      ),
    );
  }
}
