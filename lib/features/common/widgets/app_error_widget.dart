import 'package:flutter/material.dart';

class AppErrorWidget extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final String? retryButtonText;
  final bool showRetryButton;

  const AppErrorWidget({
    super.key,
    this.message,
    this.onRetry,
    this.retryButtonText,
    this.showRetryButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Code-themed error illustration
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '{ 404 }',
                        style: textTheme.displaySmall?.copyWith(
                          color: colorScheme.error,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '// Exception caught',
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.error.withOpacity(0.8),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              message ?? 'Oops! Something went wrong.',
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            if (showRetryButton) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: Text(
                  retryButtonText ?? 'Recompile',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Usage examples:

// 1. Basic compilation error
// AppErrorWidget(
//   message: 'Compilation failed',
//   onRetry: () => recompileCode(),
// )

// 2. Network error
// AppErrorWidget(
//   message: 'Failed to sync your code',
//   retryButtonText: 'Sync Again',
//   onRetry: () => syncCode(),
// )

// 3. Runtime error
// AppErrorWidget(
//   message: 'Runtime error in test cases',
//   retryButtonText: 'Run Tests Again',
//   onRetry: () => runTests(),
// )