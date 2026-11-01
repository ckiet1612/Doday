# Doday G2 – Đặc tả trải nghiệm prototype

Trạng thái: **Quyết định UX G2-DEC-04…07, 13 APPROVED 01/11/2026** (Q-17 chưa chạy, được miễn cho việc duyệt G2 theo G2-DEC-14) · 31/10/2026, cập nhật 01/11/2026 · Prototype: target `DodayG2` (Sources/DodayG2). Duyệt phương án G2 (G2-DEC-01) **không** phải duyệt UI này.

## 1. Nguyên tắc

- **Hai khu vực chính:** Camera và Bản đồ (thanh dưới). Profile là phụ (nút ảnh đại diện góc phải). Không có Home/Feed, chat, follower, tracking nền.
- **Private-only 1.0.** Không có điều khiển public/friends hay bề mặt cộng đồng. Nhãn “Chỉ mình bạn / Chỉ mình bạn xem được” xuất hiện ở Camera và màn xem lại. ID yêu cầu PUB chỉ giữ để truy vết, prototype không triển khai.
- **Camera không chờ.** Lưu không cần tiêu đề, bộ sưu tập, địa điểm hay Google. Nhận diện không bao giờ chặn Xong.
- **Map dùng được khi chưa chụp**, kể cả khi chưa có nơi đã lưu.
- **Trung thực về trạng thái:** “Đã lưu trên máy · chưa đồng bộ” khác “Đã đồng bộ”. G2 không có máy chủ nên không bao giờ hiện “Đã đồng bộ”. Không hứa bản đồ offline hay upload khi mất mạng.
- **Nhãn fixture rõ ràng:** “G2 · FIXTURE” trên thanh điều hướng, “Dữ liệu mẫu Doday · không phải Google” ở chi tiết, “Ảnh mẫu… không phải Google Photos”.

## 2. Cấu trúc màn hình

| Màn | Vào từ | Nội dung chính | Truy vết |
| --- | --- | --- | --- |
| Lần đầu (Onboarding) | Mở app lần đầu | Chọn ngôn ngữ; 3 ý: chụp nhanh, bản đồ của bạn, chỉ mình bạn (Hide/zone bật sẵn); “Bắt đầu” | DEC-01, DEC-31 |
| Camera | Mặc định khi mở app | Preview 1:1; chip “Chỉ mình bạn”; chip một chạm **Ảnh sắp chụp: ẩn/có vị trí**; nút chụp, chọn ảnh thư viện, đổi camera; dòng “Mặc định ảnh mới…”; “Đã lưu trên máy · chưa đồng bộ” | J1, BR-M2, addendum §3.1, G2-DEC-06 |
| Xem lại Moment (sheet) | Sau chụp/chọn; mở từ nhật ký | Ảnh vuông đã xử lý; “Đã lưu trên máy”; thời điểm “Chụp lúc / Thời điểm thêm”; tiêu đề tùy chọn đếm 0/120; công tắc **Ẩn vị trí ảnh này**; khối địa điểm; lỗi xử lý (Thử lại/Xóa nháp); “Chưa đồng bộ”; Xong | J1 B4–B5, BR-M1/M10/M11 |
| Chọn địa điểm (sheet) | Xem lại → “Chọn địa điểm” | Nhận diện mẫu (ngữ cảnh rõ / nhiều ứng viên / không ngữ cảnh) chỉ khi gate cho phép. Chọn thủ công chỉ khi Hide tắt **và** vùng không chặn (bảo vệ tắt, hoặc ảnh chắc chắn ở ngoài); nếu không thì các dòng bị khóa, kèm lý do. Lưu không nơi | BR-L*, DEC-27, addendum §3.2 |
| Bản đồ | Thanh dưới | Ô tìm tên/khu vực; sơ đồ fixture có marker Muốn ghé/Đã ghé/kết quả; nút Gần tôi, Chờ (badge), Đã lưu; danh sách kết quả mở rộng được | J3, DEC-29, A12 |
| Bottom sheet địa điểm | Chạm marker/kết quả | Detent vừa: tên (dữ liệu đang có), Lưu/Đã lưu, Chỉ đường, Muốn ghé/Đã ghé, nhãn, bộ sưu tập, “Xem chi tiết”. **Không gọi Details** | J3 B3 |
| Chi tiết | “Xem chi tiết” (kéo lớn) | Khối thông tin (gọi Details một lần): trạng thái, giờ, rating; cảnh báo đóng cửa; banner đã chuyển; Xem ảnh / Xem từng đánh giá (mỗi nút một lệnh); khối **Khoảnh khắc của bạn tại đây** | J3 B4/B4a, J4, DEC-28, G2-DEC-05 |
| Nơi đã lưu | Map → Đã lưu; Profile | Lọc Tất cả/Muốn ghé/Đã ghé; lọc bộ sưu tập; Chờ xử lý (badge); vuốt để bỏ lưu (không xóa ảnh) | MVP-17/28, A12 |
| Chờ xử lý | Map → Chờ; Saved; Profile | Dán link HTTPS; mục PENDING (host, thời điểm, kiểu dữ liệu nhận); “Chọn địa điểm cho liên kết” → lưu Muốn ghé | J2, EXT-*, A13 |
| Share Extension | Share Sheet ở app khác | Trạng thái tài khoản; kiểu dữ liệu nhận; “Lưu liên kết · PENDING”; Đóng | J2 B1–B2 |
| Profile | Nút ảnh đại diện | Tài khoản mẫu; Khoảnh khắc của tôi; Nơi đã lưu; Chờ xử lý (n); Cài đặt; G2 Lab; đổi tài khoản/đăng xuất | DEC-30 |
| Khoảnh khắc của tôi (nhật ký) | Profile | Theo ngày, mới nhất trước; thumbnail; tiêu đề; giờ chụp/thêm; “Đã lưu trên máy · chưa đồng bộ”; Vị trí ẩn / tên nơi / Chưa gắn; “Cần xử lý ảnh”; vuốt để xóa có xác nhận | DEC-30, A12 |
| Cài đặt | Profile | Ngôn ngữ; **Ẩn vị trí cho ảnh mới** (mặc định bật); **Ẩn trong vùng riêng tư** (mặc định bật, tắt cần xác nhận); danh sách vùng (thêm tại vị trí hiện tại, sửa tên, bán kính 100–1.000 m bước 50, xóa); xác nhận danh sách; **Cho phép nhận diện bên ngoài** (mặc định tắt, riêng với quyền GPS) | DEC-31, BATCH-AB §4, A3 |
| G2 Lab | Profile | Tình huống fixture; canary; ảnh thư viện mẫu B3; trace; đo sơ bộ; mở Google Maps với Place ID thật; Maps SDK khóa | Spike |

## 3. Hành trình thành kịch bản thử (Q-17)

Kịch bản chi tiết cho người thử ở [usability-report.md](usability-report.md) §3. Bảng dưới là đường đi chuẩn và điều kiện hoàn thành.

| Luồng | Đường đi chuẩn trong prototype | Hoàn thành khi |
| --- | --- | --- |
| **J1** Chụp và lưu | Camera → chụp (máy thật) / chọn ảnh → màn xem lại → (tùy chọn) tiêu đề, Ẩn vị trí → Xong | Moment có trong “Khoảnh khắc của tôi”, không bị buộc nhập gì |
| **J2** Lưu link TikTok/Instagram | TikTok/Instagram → Chia sẻ → Doday G2 → Lưu liên kết · PENDING. (Dự phòng nếu chưa có extension: Map → Chờ → dán link → Lưu) | Link có trong Chờ xử lý với PENDING; (tùy chọn) chọn địa điểm → Muốn ghé |
| **J3** Khám phá rồi lưu | Map → tìm “Garden” → chạm kết quả → Lưu | Nút đổi thành “Đã lưu”, marker đổi kiểu. Không có nội dung cộng đồng |
| **J4** Kiểm tra nơi đã lưu, mở chỉ đường | Map → Đã lưu → chọn nơi → Xem chi tiết → đọc trạng thái → Chỉ đường | Người thử nói được trạng thái mở/đóng và tới bước chuyển sang Google Maps |

## 4. Ma trận trạng thái

| Trạng thái | Cách hiện trong prototype | Tái hiện |
| --- | --- | --- |
| Lần đầu | Onboarding toàn màn hình, chọn ngôn ngữ | Cài mới / `--g2-onboarding` |
| Chưa đăng nhập | Dải “Chưa đăng nhập · cần đăng nhập trước khi chụp”; nút chụp/chọn ảnh tắt; Map vẫn mở; Chờ xử lý báo không lưu dữ liệu vô chủ; extension không ghi | Đăng xuất trong Profile |
| Camera bị từ chối / hạn chế | “Camera chưa được cấp quyền” + Mở Cài đặt + “Vẫn chọn ảnh thư viện và dùng Bản đồ được” / “Camera bị hạn chế trên thiết bị này” | Cài đặt iOS |
| Không có camera (simulator) | “Không có camera khả dụng” + nút ảnh mẫu | Simulator |
| Vị trí từ chối / hạn chế | Văn bản giải thích; vẫn lưu không nơi; Gần tôi tắt có giải thích, tìm theo tên vẫn dùng | Cài đặt iOS |
| GPS gần đúng / cũ | “Chỉ có vị trí gần đúng; không tự gắn” / “Vị trí cũ hơn 60 giây; không dùng”; gate “unreliable” | Precise Location tắt; Lab mẫu gần đúng/cũ |
| Trong / gần vùng riêng tư, hoặc chưa chắc | “Ảnh ở trong vùng riêng tư nên không gắn được địa điểm. Ảnh vẫn được lưu.” / “Chưa chắc ảnh ở ngoài vùng riêng tư…”. **Không** được tự chọn nơi; chọn thủ công không vượt và không tắt bảo vệ (addendum §3.2). Ảnh thư viện xét theo GPS của chính ảnh. Ảnh chụp chỉ xét theo lần kiểm vị trí trong 60 giây sau khi chụp; ngoài khoảng đó là không chắc | Lab vùng canary + mẫu; test `AppModelTests`, UI `testManualPlaceStaysBlockedWhileZoneIsUncertain` |
| Chưa consent | “Chưa cho phép nhận diện bên ngoài; không gửi tọa độ” | Mặc định |
| Không địa điểm | “Không có địa điểm phù hợp” / nhánh “không ngữ cảnh” | Lab “Không có nơi” |
| Nhiều ứng viên | “Cần xác nhận: chọn một trong các nơi dưới đây” / danh sách nhiều kết quả | Lab “Nhiều ứng viên” |
| Offline | Banner: bản đồ nền có thể không hiện, **không có bản đồ offline**, nơi đã lưu vẫn ở danh sách; chi tiết “Không cập nhật được thông tin lúc này” | Lab “Mất mạng” |
| Google lỗi / hết quota | “Không tải được dữ liệu mới…” / “Google hết quota. Dữ liệu trên máy vẫn còn.”; ảnh/review lỗi riêng từng khối | Lab |
| Hết quyền lưu dữ liệu Google | Không marker; tên thay bằng nhãn người dùng/“Địa điểm đã lưu” + Place ID; “không tự gọi Places. Mở để làm mới chủ động” | Lab “Hết quyền dùng trường” |
| Địa điểm đóng cửa | Cảnh báo đỏ “Đóng cửa vĩnh viễn. Bản lưu của bạn được giữ.” | Lab “Nơi đóng cửa” / Test Archive |
| Địa điểm đã chuyển | Banner “Địa điểm này đã chuyển” → hộp thoại Xem nơi mới / Giữ bản lưu hiện tại (cả hai luôn hiện, không dùng role cancel bị ẩn); không tự chuyển | Lab “Nơi đã chuyển” |
| Nháp lỗi xử lý | “Đã lưu trên máy – cần xử lý ảnh” + Thử lại / Xóa nháp; nguồn còn | Lab “Lỗi xử lý ảnh” |
| Hàng đợi chờ | Moment: “Chưa đồng bộ · bản thử G2 không có máy chủ”; link: PENDING có badge ở Map/Saved/Profile | Mặc định |
| Ảnh thư viện không GPS | “Ảnh không có GPS đọc được · không thay bằng vị trí hiện tại” | Lab “Ảnh không có GPS” / ảnh thật |
| Ảnh thư viện lệch >1 km (B3) | Khi gắn nơi: hộp thoại “Ảnh cách nơi này hơn 1 km” → Vẫn gắn / Lưu không nơi / Hủy | Lab “Ảnh có GPS giả cách ~2,2 km” → Chọn địa điểm → Test Garden |
| Link trùng | Banner trong màn Chờ xử lý “Đã có trong Doday” (không mở hộp thoại, không đóng màn) | Dán lại cùng link |
| Link không hợp lệ / chưa đăng nhập | Banner đỏ “Chưa lưu: cần tài khoản đang hoạt động và một liên kết HTTPS hợp lệ.” | Dán `http://…` hoặc text không có link |

## 5. Quy tắc riêng tư trong UI

- **Hide ba phạm vi (G2-DEC-06):** chip Camera = ảnh sắp chụp (tự trở về mặc định sau chụp); công tắc xem lại = chỉ ảnh này; Cài đặt = mặc định ảnh mới, “Không đổi ảnh cũ”. Bật Hide ở ảnh đã có nơi thì bỏ liên kết nơi của ảnh đó. Đổi Hide làm tăng revision và hủy mẫu vị trí đang giữ.
- **Zone:** công tắc mặc định bật. Tắt cần xác nhận bằng **alert có nút Hủy rõ ràng** (iOS mới biến confirmation dialog thành popover không có Hủy), nội dung “Không tắt Hide, không cấp consent, không hiện lại ảnh cũ hoặc phát lại hàng chờ”. Danh sách vùng chỉ ở máy, theo tài khoản, không sao lưu. Thêm vùng cần mẫu chính xác ≤50 m. Danh sách chưa xác nhận → nhận diện ngoài máy bị chặn. Tâm vùng không hiển thị ở nhật ký/bằng chứng.
- **Consent nhận diện** là công tắc riêng, mặc định tắt, có giải thích quan hệ với Hide/zone. Đổi quyền hủy ngữ cảnh đang chờ.
- **Visited** chỉ do người dùng chọn; nhãn “GPS không bao giờ tự đặt Đã ghé”.
- **Chỉ đường** không gửi vị trí; Place ID fixture không mở Google Maps (tránh chỉ đường sai).

## 6. B3 và movedPlace (đề xuất chốt ở G2)

- **Cảnh báo thư viện (G2-DEC-04):** chỉ hiện khi người dùng *gắn* một nơi cho ảnh thư viện có GPS **của chính ảnh**, ảnh không Hide, zone cho phép, và khoảng cách >1 km. Không bao giờ so với GPS hiện tại, không chặn lưu. Ảnh thật so với nơi fixture: hiện “Không so được… địa điểm mẫu không có tọa độ thật”.
- **movedPlace (G2-DEC-05):** banner trong khối thông tin; “Xem nơi mới” mở chi tiết nơi mới, người dùng tự Lưu; “Giữ bản lưu hiện tại” là mặc định hủy.

## 7. Ngôn ngữ, accessibility, kích thước màn hình

- Thông báo thành công/lỗi khi đang ở trong sheet hiện **ngay trong sheet** (banner) hoặc alert do chính lớp trên cùng sở hữu. Phát hiện G2: alert gắn ở màn gốc làm sheet “Chờ xử lý” bị đóng sau khi lưu link (UI test J2), đã sửa.
- Mô tả quyền vị trí nêu đủ ba mục đích, chỉ khi người dùng yêu cầu: kiểm tra vùng trên máy, và nếu cho phép thì tìm nơi gần và gợi ý địa điểm cho ảnh.
- Tiếng Việt mặc định, tiếng Anh chọn ở Onboarding/Cài đặt, đổi ngay không cần khởi động lại. Chuỗi dùng hàm `t(vi, en)` trong prototype. G3 chuyển sang String Catalog (DODAY-L10N-01). Mô tả quyền iOS có bản `vi`/`en` (`InfoPlist.strings`).
- Font hệ thống theo Dynamic Type. Vùng chạm chính ≥44 pt. Nút chỉ có biểu tượng có `accessibilityLabel` (Chụp ảnh, Chọn một ảnh, Đổi sang camera trước/sau, Hồ sơ, Xóa tìm kiếm, Mở rộng/Thu gọn). Marker đọc “tên, muốn ghé/đã ghé/kết quả chưa lưu”. Tab đang chọn có trait `isSelected`.
- Bố cục cuộn được trên màn nhỏ. Preview camera giữ 1:1 theo chiều rộng. Danh sách Map thu/mở 138/320 pt. Chỉ portrait trên iPhone, iPad chạy chế độ tương thích (DEC-03).
- Chưa kiểm VoiceOver/tương phản trên máy thật; ảnh chụp simulator ở [evidence.md](evidence.md) §4.

## 8. Ngoài phạm vi prototype

Đăng nhập Apple/OTP thật, đồng bộ/backend G3, cổng tuổi/người đại diện (DEC-24), xóa tài khoản, bản đồ Google thật (khóa), dữ liệu Places thật, pipeline codec G4, gom cụm marker, hỗ trợ/Support URL.
