#MISE description="Build the flutter app"

$ErrorActionPreference = "Stop"

flutter clean
flutter pub get
flutter build appbundle
