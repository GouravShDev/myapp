import 'package:codersgym/features/question/domain/model/contest.dart';
import 'package:flutter/material.dart';

class ContestReminderDialog extends StatefulWidget {
  final Contest contest;

  const ContestReminderDialog({
    Key? key,
    required this.contest,
  }) : super(key: key);

  @override
  _ContestReminderDialogState createState() => _ContestReminderDialogState();
}

class _ContestReminderDialogState extends State<ContestReminderDialog> {
  // ReminderType _selectedType = ReminderType.notification;
  Duration _selectedDuration = const Duration(hours: 1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Set Contest Reminder',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Reminder Type Selector
            // Row(
            //   children: [
                // _ReminderTypeOption(
                //   icon: Icons.notifications_outlined,
                //   label: 'Notification',
                //   isSelected: _selectedType == ReminderType.notification,
                //   onTap: () =>
                //       setState(() => _selectedType = ReminderType.notification),
                // ),
                // const SizedBox(width: 12),
                // _ReminderTypeOption(
                //   icon: Icons.alarm_outlined,
                //   label: 'Alarm',
                //   isSelected: _selectedType == ReminderType.alarm,
                //   onTap: () =>
                //       setState(() => _selectedType = ReminderType.alarm),
                // ),
            //   ],
            // ),

            // const SizedBox(height: 24),
            Text(
              'Remind me before:',
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 16),

            // Timeline-style Duration Selector
            _TimelineDurationSelector(
              selectedDuration: _selectedDuration,
              onDurationChanged: (duration) {
                setState(() => _selectedDuration = duration);
              },
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _saveReminder(context),
                    child: const Text('Set'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveReminder(BuildContext context) {
    Navigator.of(context).pop(
      _selectedDuration,
    );
  }
}

class _TimelineDurationSelector extends StatelessWidget {
  final Duration selectedDuration;
  final ValueChanged<Duration> onDurationChanged;

  const _TimelineDurationSelector({
    required this.selectedDuration,
    required this.onDurationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 100,
      child: Stack(
        children: [
          // Timeline line
          Positioned(
            left: 0,
            right: 0,
            top: 40,
            child: Container(
              height: 3,
              color: theme.dividerColor,
            ),
          ),
          // Time points
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TimePoint(
                duration: const Duration(minutes: 15),
                isSelected: selectedDuration.inMinutes == 15,
                onTap: () => onDurationChanged(const Duration(minutes: 15)),
              ),
              _TimePoint(
                duration: const Duration(minutes: 30),
                isSelected: selectedDuration.inMinutes == 30,
                onTap: () => onDurationChanged(const Duration(minutes: 30)),
              ),
              _TimePoint(
                duration: const Duration(hours: 1),
                isSelected: selectedDuration.inHours == 1,
                onTap: () => onDurationChanged(const Duration(hours: 1)),
              ),
              _TimePoint(
                duration: const Duration(hours: 2),
                isSelected: selectedDuration.inHours == 2,
                onTap: () => onDurationChanged(const Duration(hours: 2)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimePoint extends StatelessWidget {
  final Duration duration;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimePoint({
    required this.duration,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatDuration(duration),
            style: TextStyle(
              color: isSelected ? theme.primaryColor : theme.hintColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? theme.primaryColor
                  : theme.scaffoldBackgroundColor,
              border: Border.all(
                color: isSelected ? theme.primaryColor : theme.dividerColor,
                width: 2,
              ),
            ),
            child: isSelected
                ? Icon(Icons.check_rounded,
                    size: 18, color: theme.colorScheme.onPrimary)
                : null,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h';
    }
    return '${duration.inMinutes}m';
  }
}

// class _ReminderTypeOption extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final bool isSelected;
//   final VoidCallback onTap;
//
//   const _ReminderTypeOption({
//     required this.icon,
//     required this.label,
//     required this.isSelected,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     return Expanded(
//       child: Material(
//         color: isSelected
//             ? theme.primaryColor.withOpacity(0.1)
//             : Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//         child: InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(12),
//           child: Container(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: isSelected ? theme.primaryColor : theme.dividerColor,
//                 width: 2,
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               children: [
//                 Icon(
//                   icon,
//                   color: isSelected ? theme.primaryColor : theme.hintColor,
//                   size: 28,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     color: isSelected ? theme.primaryColor : theme.hintColor,
//                     fontWeight:
//                         isSelected ? FontWeight.bold : FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
