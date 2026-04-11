/// App-wide session (pre–real auth). Single source of truth for the current user id.
abstract final class AppSession {
  AppSession._();

  /// Seeded Firestore user document id and mock-repo default user.
  static const String userId = '1';
}
