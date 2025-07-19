# MISE description="Run API tests for the server"

$ErrorActionPreference = "Stop"
flutter config --enable-windows-desktop
flutter test -d windows integration_test/main_test.dart --dart-define=IS_TESTING=true