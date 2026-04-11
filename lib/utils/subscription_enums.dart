/// Maps to Firestore `duration_kind`: day | monthly | annual.
///
/// Legacy values month/year are still accepted for backward compatibility.
enum SubscriptionType { day, monthly, annual }

extension SubscriptionTypeX on SubscriptionType {
  /// Firestore / seed script string for `duration_kind`.
  String get durationKindString {
    switch (this) {
      case SubscriptionType.day:
        return 'day';
      case SubscriptionType.monthly:
        return 'monthly';
      case SubscriptionType.annual:
        return 'annual';
    }
  }

  static SubscriptionType fromDurationKind(String value) {
    switch (value) {
      case 'day':
        return SubscriptionType.day;
      case 'monthly':
      case 'month':
        return SubscriptionType.monthly;
      case 'annual':
      case 'year':
        return SubscriptionType.annual;
      default:
        throw FormatException('Unknown duration_kind: $value');
    }
  }
}

/// Lifecycle of a user's purchased pass (derived + stored flags).
enum SubscriptionStatus { active, expired, cancelled }
