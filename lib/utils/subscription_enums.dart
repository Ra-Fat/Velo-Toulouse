/// Maps to Firestore `duration_kind`: day | monthly | annual.
///
/// Legacy values month/year are still accepted for backward compatibility.
enum SubscriptionType { day, monthly, annual }

extension SubscriptionTypeX on SubscriptionType {
  
  // just a helper to turn string to enum value used at dto
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

enum SubscriptionStatus { active, expired, cancelled }
