/// Manages Demo / Guest mode across the application.
///
/// When active, data sources fall back to realistic mock fixtures so the user
/// can explore all features (Home, Orders, Projects, Profile) without signing in
/// and without encountering 401 Unauthenticated errors.
class AppDemoService {
  AppDemoService._();

  static bool _isDemoMode = false;

  static bool get isDemoMode => _isDemoMode;

  static void setDemoMode(bool value) {
    _isDemoMode = value;
  }
}
