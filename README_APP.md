# CineNova - App đặt vé cho khách hàng (Flutter, Android + iOS)

Một mã nguồn Flutter chạy trên **Android và iOS** (điện thoại, tablet), giao diện và chức năng giống nhau trên hai hệ điều hành. Icon app, màn hình dọc, thanh trạng thái đã cấu hình sẵn. App dùng chung API và database với trang quản trị: vé khách đặt trên app hiện ngay ở **Hóa đơn** (kênh Online) và ở sơ đồ ghế của **Bán vé tại quầy**.

## Chức năng

| Màn hình | Nội dung |
|---|---|
| Phim (trang chủ) | Băng chuyền **phim nổi bật do AI đề xuất**, phim đang chiếu, sắp chiếu (điểm khán giả, phân loại tuổi), ưu đãi đang chạy |
| Chi tiết phim | Thông tin, trailer, lời quảng bá; chọn ngày (7 ngày), khu vực, suất chiếu theo từng rạp, số ghế còn |
| Rạp | 80 chi nhánh theo 16 quận, tìm kiếm; lịch chiếu của từng rạp |
| Chọn ghế | Sơ đồ ghế thật (thường / VIP / ghế đôi), **giữ ghế 10 phút** khi chọn, đồng hồ đếm ngược, tự cập nhật 5 giây / lần (thấy ngay ghế người khác vừa mua) |
| Thanh toán | Bắp nước, mã khuyến mãi, dùng điểm thành viên, ví điện tử / thẻ / chuyển khoản (**cổng thanh toán mô phỏng**) |
| Vé của tôi | Vé sắp xem / đã xem, **vé điện tử có mã QR** (nhân viên nhập / quét mã ở màn hình Soát vé) |
| Tài khoản | Đăng ký / đăng nhập bằng số điện thoại, hạng thẻ, điểm, tiến độ lên hạng, sửa thông tin, đổi địa chỉ máy chủ |

Điện thoại dùng thanh điều hướng dưới; tablet lớn (iPad, tablet Android) dùng thanh bên trái và bố cục 2 cột.

## Cài đặt lần đầu

1. Cài **Flutter SDK** (bản stable mới nhất): https://docs.flutter.dev/get-started/install, rồi chạy `flutter doctor`.
   - **Android** (Windows hoặc Mac): Android Studio, cài Android SDK và tạo một máy ảo (Device Manager).
   - **iOS**: bắt buộc máy **Mac** có Xcode và CocoaPods (`sudo gem install cocoapods` hoặc `brew install cocoapods`).
2. Phía máy chủ (project CinemaAdmin): chạy `NANG_CAP_DATABASE.cmd` (hoặc `XOA_VA_TAO_LAI_DATABASE.cmd`) một lần, sau đó chạy API:
   - máy ảo Android / iPhone simulator trên cùng máy: `CHAY_API.cmd`;
   - điện thoại thật: `CHAY_API_LAN.cmd` (điện thoại và máy tính cùng mạng Wi-Fi, cho phép qua Windows Firewall).
3. Tạo phần nền tảng cho app (chỉ làm 1 lần):
   - Windows: chạy **`TAO_APP.cmd`** trong thư mục `cinenova_app`;
   - Mac: `./tao_app.sh`.

   Lệnh này chạy `flutter create . --platforms=android,ios` (sinh thư mục `android/`, `ios/`, không đụng `lib/`), `flutter pub get`, rồi `dart run tool/setup_platforms.dart` để cấp quyền Internet, cho phép gọi API http trong mạng nội bộ, đặt tên **CineNova** và thay icon.

## Chạy app

| Thiết bị | Cách chạy | Địa chỉ API |
|---|---|---|
| Máy ảo Android | Mở máy ảo trong Android Studio, chạy `CHAY_APP_ANDROID.cmd` (`flutter run`) | tự dùng `http://10.0.2.2:5099` |
| Điện thoại Android thật | Bật *USB debugging*, cắm cáp, `flutter run`; hoặc `BUILD_APK.cmd` rồi gửi file `app-release.apk` sang điện thoại để cài | vào **Tài khoản > Máy chủ**, nhập `http://<IP máy tính>:5099` (IP hiện ở cửa sổ `CHAY_API_LAN.cmd`), bấm Kiểm tra |
| iPhone simulator (Mac) | `open -a Simulator` rồi `flutter run` | API (SQL Server LocalDB) chạy trên máy Windows: chạy `CHAY_API_LAN.cmd` ở máy Windows, trong app nhập `http://<IP máy Windows>:5099` |
| iPhone thật (Mac) | Mở `ios/Runner.xcworkspace` bằng Xcode, mục *Signing & Capabilities* chọn Team (Apple ID miễn phí cũng được), cắm iPhone, `flutter run` | như điện thoại Android thật |

Có thể đặt sẵn địa chỉ API khi build: `flutter build apk --dart-define=API_BASE=http://192.168.1.10:5099`.

Tài khoản khách mẫu: màn hình đăng nhập hiện 6 khách thành viên (bấm để điền), mật khẩu `CineNova@2026`. Khách đã đăng ký tại quầy có thể **Đăng ký** bằng đúng số điện thoại để giữ điểm và hạng thẻ.

Phát hành chính thức: Google Play (phí 25 USD một lần, `flutter build appbundle`), App Store (tài khoản Apple Developer 99 USD / năm, `flutter build ipa` trên Mac). Khi phát hành, API phải đặt trên máy chủ có HTTPS và tên miền; khi đó có thể gỡ quyền HTTP (usesCleartextTraffic / NSAllowsArbitraryLoads) trong `tool/setup_platforms.dart`.

iPhone cài bằng Apple ID miễn phí chỉ dùng được 7 ngày, sau đó cài lại bằng Xcode; muốn phát cho nhiều người thử dùng TestFlight (cần tài khoản Developer).

## Cấu trúc mã

```
lib/
  main.dart              khởi động, khóa màn hình dọc, theme
  core/api.dart          gọi REST API (/api/app/...), xử lý lỗi tiếng Việt
  core/state.dart        AppState: máy chủ, phiên đăng nhập (lưu bằng shared_preferences)
  core/theme.dart        màu thương hiệu dùng chung với web quản trị, font Be Vietnam Pro (đóng gói sẵn)
  core/format.dart       định dạng tiền, ngày giờ
  widgets/common.dart    poster, điểm, phân loại tuổi, dải chọn ngày, Loader...
  screens/               shell, home, movie, cinemas, seats, checkout, ticket, my_tickets, account
tool/setup_platforms.dart  cấu hình quyền mạng, tên app, icon cho Android / iOS
assets/branding/           icon app (Android mipmap, iOS AppIcon) vẽ sẵn
test/widget_test.dart      kiểm thử đơn vị (flutter test)
```

## Luồng đặt vé và chống bán trùng ghế

1. Khách chạm ghế → `POST /api/app/showtimes/{id}/hold` → `sp_HoldSeats` ghi bảng `SeatHolds` (hết hạn sau 10 phút hoặc khi suất bắt đầu). Ghế người khác vừa giữ trả về lỗi 409, app báo và tải lại sơ đồ.
2. Trong thời gian giữ, quầy bán vé thấy ghế ở trạng thái "Online đang giữ" và không bán được (`sp_CreateBooking` kiểm tra).
3. Thanh toán → `POST /api/app/bookings` → `sp_CreateBooking` (kênh Online) kiểm tra lại toàn bộ trong 1 transaction: ghế phải đang do chính khách giữ, chưa ai mua; tạo hóa đơn, vé, tích điểm, xóa giữ chỗ.
4. Rời màn hình chọn ghế mà không thanh toán → app gửi `DELETE .../hold` trả ghế.

## Giới hạn của bản đồ án

- Thanh toán là **mô phỏng** (không trừ tiền). Bản thật: tích hợp VNPay / MoMo sandbox, chỉ tạo vé khi cổng báo thành công (IPN).
- Đăng ký chưa xác minh OTP SMS.
- Cập nhật sơ đồ ghế bằng cách hỏi lại máy chủ mỗi 5 giây (đủ cho demo); bản thật có thể dùng SignalR / WebSocket.
- App gọi API bằng http trong mạng nội bộ (đã cho phép trong cấu hình Android / iOS) để demo; bản phát hành phải dùng https.
- Mã nguồn được kiểm tra cú pháp Dart tự động nhưng **chưa được build trong môi trường soạn đồ án** (không tải được Flutter SDK). Lần chạy đầu trên máy bạn, nếu `flutter analyze` hoặc build báo lỗi, gửi lại thông báo lỗi để sửa.
