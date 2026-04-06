/// Maps to Firestore `duration_kind`: day | month | year (see [SubscriptionTypeX.fromDurationKind]).
enum SubscriptionType {
  day,
  monthly,
  annual,
}

extension SubscriptionTypeX on SubscriptionType {
  /// Firestore / seed script string for `duration_kind`.
  String get durationKindString {
    switch (this) {
      case SubscriptionType.day:
        return 'day';
      case SubscriptionType.monthly:
        return 'month';
      case SubscriptionType.annual:
        return 'year';
    }
  }

  static SubscriptionType fromDurationKind(String value) {
    switch (value) {
      case 'day':
        return SubscriptionType.day;
      case 'month':
        return SubscriptionType.monthly;
      case 'year':
        return SubscriptionType.annual;
      default:
        throw FormatException('Unknown duration_kind: $value');
    }
  }
}

/// Lifecycle of a user's purchased pass (derived + stored flags).
enum SubscriptionStatus {
  active,
  expired,
  cancelled,
}
