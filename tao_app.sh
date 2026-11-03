#!/bin/sh
# Máy Mac: tạo thư mục android/ios, tải thư viện, cấu hình quyền mạng + icon. Sau đó:
#   open -a Simulator && flutter run            (iPhone simulator)
#   flutter run -d <tên iPhone>                 (iPhone thật: mở ios/Runner.xcworkspace, chọn Team ở Signing & Capabilities)
set -e
cd "$(dirname "$0")"
flutter create . --project-name cinenova_app --org vn.cinenova --platforms=android,ios
flutter pub get
dart run tool/setup_platforms.dart
(cd ios && pod install --repo-update)
echo "XONG. Chạy: open -a Simulator && flutter run"
