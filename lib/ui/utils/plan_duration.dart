import 'package:project/models/subscription/subscription.dart';
import 'package:project/core/subscription_enums.dart';

(String, String, String) planDuration(Subscription s) {
  final now = DateTime.now();
  late DateTime start;
  late DateTime end;
  String renews;

  start = DateTime(now.year, now.month, now.day);

  switch (s.durationKind) {
    case SubscriptionType.day:
      end = start.add(const Duration(days: 1));
      renews = 'Does not renew';
      break;
    case SubscriptionType.monthly:
      end = DateTime(start.year, start.month + 1, start.day);
      renews = 'Monthly — cancel anytime';
      break;
    case SubscriptionType.annual:
      end = DateTime(start.year + 1, start.month, start.day);
      renews = 'Yearly — cancel anytime';
      break;
  }

  String _monthShort(int month) {
    const months = [
      '', // for 1-based month
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month];
  }

  String _format(DateTime date) {
    // Example: 5 Apr 2026
    return '${date.day} ${_monthShort(date.month)} ${date.year}';
  }

  return (_format(start), _format(end), renews);
}
