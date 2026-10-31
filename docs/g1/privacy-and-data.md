# Doday 1.0 – Quyền riêng tư và mô hình dữ liệu (G1)

Trạng thái: APPROVED (đặc tả G1, G1-SIGNOFF) · Ngày lập: 30/10/2026 · Ngày duyệt: 31/10/2026, Chủ dự án kiêm PO/TL; biên bản approval-batch §6. Đây là đặc tả kỹ thuật/sản phẩm, **không** phải Privacy Policy công khai hoặc ý kiến pháp lý. DEC-12: ẩn ngay, xóa cứng ≤30 ngày, hết backup ≤35 ngày. Các dòng PROPOSED/NEEDS_CONFIRMATION vẫn cần chốt trước cổng tương ứng theo kế hoạch B; chưa có chuyên gia pháp lý độc lập được chỉ định.

**BATCH-AB:** A1–A14 và kế hoạch B1–B9 đã duyệt ngày 31/10/2026 (`approval-batch.md`). Chính sách kỹ thuật dưới đây không chứng minh tuân thủ luật; B5/B6 còn phải xác minh trước G2/G3.

## 1. Nguyên tắc

1. Thu thập tối thiểu: chỉ dữ liệu phục vụ chức năng đã mô tả trong `product-spec.md`.
2. 1.0 chỉ riêng tư (DEC-15/26, tái xác nhận OVERRIDE); bản chia sẻ sau dùng hai trục quyền độc lập do người dùng đặt, mặc định chưa cấu hình là ảnh riêng tư/vị trí ẩn (DEC-11/32). Vị trí cá nhân ≠ vị trí công khai [SRC §4.5].
3. Không theo dõi vị trí nền, không lịch sử hành trình tự động [SRC §16].
4. Không tracking quảng cáo trong 1.0 [APPROVED A9], không xin ATT theo thiết kế này. Vẫn phải kiểm SDK/thực thi ở G3/G12A; thêm SDK quảng cáo/attribution phải đánh giá lại (nguồn Apple User privacy and data use từ roadmap A7, **chưa truy cập lại** trong G1).
5. Dữ liệu Google tách khỏi dữ liệu Doday ở lưu trữ, API và giao diện [SRC §6.9].
6. Dữ liệu cục bộ phân vùng theo tài khoản; không có đường tự động chuyển dữ liệu giữa tài khoản (BR-A3, BR-A4).
7. Tách GPS đầu vào, Place nhận diện và Place hiển thị; quyền camera/GPS không cấp quyền chia sẻ/consent nhận diện. Hide hoặc zone đang bật/không chắc chắn chặn gửi tọa độ ngay trên máy và đường API không hợp lệ. Zone mặc định bật, cấu hình/tắt tại Cài đặt; Hide độc lập vẫn mặc định bật. Hợp đồng/revision và giới hạn tin cậy client ở phụ lục §2/3.
8. Quyền ảnh và vị trí là hai chính sách riêng theo OVERRIDE/DEC-25/26/32: 1.0 ảnh owner, nơi owner/hidden; API từ chối friends/public trên cả hai trục. Nguyên tắc ảnh public không nơi/mặc định cấu hình đã duyệt cho bản chia sẻ sau, không phải mở tính năng đó ở 1.0. Không trả raw GPS hoặc liên kết tới ảnh hạn chế qua tài nguyên địa điểm public.

## 2. Kiểm kê dữ liệu

| Dữ liệu | Mục đích | Nguồn / quyền iOS | Nơi lưu | Ai xem được | Gửi bên thứ ba |
| --- | --- | --- | --- | --- | --- |
| Định danh tài khoản (user ID, email hoặc Apple ID relay) | Đăng nhập, liên hệ hỗ trợ | Người dùng nhập / nhà cung cấp đăng nhập | Backend | Chủ tài khoản; OPS khi hỗ trợ | Nhà cung cấp auth/email (DEC-05, DEC-06) |
| Hồ sơ: ảnh đại diện, tên hiển thị, tên người dùng, giới thiệu | 1.0: chỉ chủ tài khoản xem; bản công khai: hiển thị cạnh nội dung công khai | Người dùng nhập | Backend + storage | 1.0: chỉ chủ. Bản công khai: [NEEDS_CONFIRMATION] trường nào (MVP-02) | Không |
| Năm sinh / nhóm tuổi | Cổng tuổi 13+ và xác định cần đồng ý của người đại diện (SAFE-11) | Người dùng nhập khi đăng ký | Backend (chỉ năm sinh hoặc nhóm tuổi [PROPOSED]) | Chủ; OPS khi hỗ trợ | Không |
| Email người đại diện + bản ghi đồng ý (thời điểm, phiên bản chính sách, trạng thái) | Bằng chứng đồng ý cho 13–15 tuổi (DEC-24) | Người dùng nhập; người đại diện xác nhận | Backend (email lưu dạng băm sau khi gửi xác nhận [PROPOSED]) | OPS khi hỗ trợ | Nhà cung cấp gửi email |
| Ảnh khoảnh khắc (bản tải lên + thumbnail) | Chức năng cốt lõi; 1:1 cắt giữa không preview, tối đa 2048/400 px đã duyệt (CROP, BR-M10) | Camera (NSCameraUsageDescription) / trình chọn ảnh hệ thống | Máy (nháp) → object storage riêng tư | 1.0: chỉ chủ; bản chia sẻ cần duyệt phát hành riêng | CDN/storage của DEC-06 |
| Ảnh gốc độ phân giải đầy đủ | Không tải lên (DEC-07 B, CROP đã duyệt) | – | Chỉ trên máy; không bảo đảm phục hồi ảnh gốc khi mất máy/xóa app | Chủ | Không |
| Tiêu đề ngắn | Chức năng cốt lõi | Người dùng nhập | Máy → backend | Theo quyền khoảnh khắc | Không |
| Nhật ký cá nhân (DATA-07) | Xem lại Moment/thời điểm đã lưu, gồm ảnh hidden/không nơi | Dữ liệu Doday có sẵn; không thêm quyền vị trí nền | View/query trên Moment và cache theo tài khoản, không bản sao hành trình | Chỉ chủ; API/RLS như Moment | Không cần Google để dựng nhật ký |
| Ảnh/review Google Places (GGL-04/10) | Xem dữ liệu địa điểm bên ngoài khi chủ động yêu cầu | Google Places; không suy thành ảnh/đánh giá Doday | Chỉ trong tác vụ xem theo điều khoản, không copy vào object store/DB/backup Doday; không cache photo name | Người đang xem trong app theo chính sách Google | Google nhận Place ID và request metadata cần thiết; không gửi raw GPS ảnh chỉ để xem ảnh/review |
| Vị trí lúc chụp (tọa độ, độ chính xác, thời điểm) | Đánh giá zone và nhận diện đủ điều kiện, không phải vị trí hiển thị | Core Location khi đang dùng app (NSLocationWhenInUseUsageDescription) | APPROVED ZONE/DEC-31: mẫu đầu vào chỉ RAM ≤60 s từ lúc nhận, không DB/queue/backup hoặc bản làm tròn; không gia hạn bằng retry | Chủ/tác vụ cục bộ; không trả cho người khác | Chỉ khi không Hide/zone/uncertain, có consent nhận diện và trigger được duyệt; không chuyển trước rồi mới kiểm zone |
| GPS trong metadata ảnh | Xét vùng/nhận diện trước xuất ảnh nếu gate cho phép | Metadata của chính ảnh, không GPS hiện tại thay thế | Gốc tại máy; APPROVED A1/DEC-31: mọi ảnh/thumbnail upload bỏ GPS, kể cả riêng tư. Place liên kết riêng | Chỉ chủ xem nguồn cục bộ; file upload không giữ GPS | Không nhận diện khi Hide hoặc zone đang bật chặn/uncertain |
| Home Privacy Zone và công tắc bảo vệ (tâm, radius, tên tùy chọn, bật/tắt, revision) | Bảo vệ khu vực người dùng chọn tại Cài đặt | Chủ động đặt; công tắc mặc định bật, có thể tắt | APPROVED ZONE/BATCH-AB/DEC-31: local theo tài khoản, không sync/cloud backup; radius 200 m (100–1.000 m), tắt giữ danh sách vùng | Chỉ chủ; không marker/địa chỉ/zone cho người khác; không kế thừa trạng thái tắt của tài khoản khác | Không gửi tọa độ zone/telemetry; tắt không cấp consent, tắt Hide hoặc mở public |
| Hide hiện tại/tương lai, quyền hiển thị vị trí, privacy revision | Gate nhận diện, render/API ACL, hủy retry quyền cũ | Người dùng; zone có thể ép hidden | Máy + backend chỉ cờ/revision/audience, không chứa tâm zone hoặc raw GPS | Chủ; server chỉ quyền tối thiểu; audience chia sẻ chỉ bản PUB, không 1.0 | Không gửi cờ kèm tọa độ riêng tư tới provider |
| Place (Doday Place ID, Google Place ID, tên/tọa độ nơi thủ công) | Liên kết nội dung | Google Places / người dùng | Backend | Nơi Google: theo nội dung công khai; nơi thủ công: chỉ người tạo | – |
| SavedPlace, Want to visit/Visited, Collection | Bản đồ cá nhân | Thao tác người dùng | Máy → backend | Chỉ chủ (BR-S5) | Không |
| ExternalSource (URL TikTok/Instagram, thời điểm) | Lưu ý định từ Share Sheet | Share Extension / dán | App Group → backend | Chỉ chủ | Backend có thể đọc URL công khai theo DEC-21 |
| Báo cáo, chặn, quyết định kiểm duyệt | An toàn cộng đồng | Thao tác người dùng / moderator | Backend | Người báo cáo (trạng thái), OPS | Không |
| Log kỹ thuật, crash | Vận hành | App/backend | Backend / công cụ DEC-22 | TL, OPS | Theo DEC-22 |
| Token phiên | Xác thực | Backend | Keychain trên máy | – | Không |

Log và bằng chứng kiểm thử **không** chứa token, tọa độ thô, ảnh riêng tư hay dữ liệu cá nhân thật [ROADMAP G3, §2].

## 3. Quyền iOS

| Quyền | Khi xin | Nếu từ chối |
| --- | --- | --- |
| Camera | Lần đầu vào camera (sau đăng nhập), có màn giải thích trước | Màn thay thế: mở Cài đặt, chọn ảnh thư viện, vào Map (MVP-04 E1) |
| Vị trí khi dùng app | Lần chụp đầu tiên hoặc lần đầu dùng "gần tôi" | Không tự gắn; chọn thủ công (BR-L3) |
| Vị trí chính xác | Hệ thống cho người dùng chọn gần đúng; không ép | Không tự gắn, vẫn đề xuất danh sách xác nhận |
| Thư viện ảnh | [APPROVED A9] Picker hệ thống, không quyền toàn phần chỉ để lấy GPS. Metadata có được cung cấp hay không phải **kiểm chứng G2** trên máy thật; thiếu thì không nơi/chọn sau qua gate | Không áp dụng |
| Vị trí nền, Contacts, micro, ATT | **Không xin** trong 1.0 | – |

Purpose string bằng ngôn ngữ DEC-01, mô tả đúng mục đích (Apple 5.1.1, 5.1.5 – truy cập 30/10/2026).

## 4. Riêng tư / công khai và vòng đời nội dung

**1.0 (DEC-15 C, duyệt 30/10/2026):** chỉ có các trạng thái Nháp cục bộ, Riêng tư và Đã xóa. Server từ chối trạng thái Công khai (SAFE-10); không ai ngoài chủ tài khoản xem được ảnh, tiêu đề hay hồ sơ. Các dòng "Công khai", "Bị ẩn do kiểm duyệt" và quy tắc đổi quyền dưới đây áp dụng cho bản công khai sau. Mô hình dữ liệu vẫn giữ trường visibility (R-24).

| Trạng thái | Ai thấy | Điều kiện vào trạng thái | Ghi chú |
| --- | --- | --- | --- |
| Nháp cục bộ | Chủ, trên đúng thiết bị/tài khoản | Ngay khi chụp | Có thể chưa có địa điểm; chưa đồng bộ thì mất nếu mất máy/xóa app |
| Riêng tư (đã đồng bộ) | Chủ, mọi thiết bị đăng nhập | Upload thành công | Có thể chưa có địa điểm |
| Công khai (chỉ PUB) | Người có quyền xem ảnh theo chính sách bản chia sẻ | BR-M4/M5; không cần Place | Ảnh đã loại GPS; nơi hidden/null không được trả hoặc gắn marker; nơi hiển thị có ACL độc lập, không raw GPS |
| Bị ẩn do kiểm duyệt | Chủ (có nhãn) + OPS | Quyết định moderator | Không tính vào số đếm |
| Đã xóa | Không ai | Chủ xóa / xóa tài khoản / gỡ vi phạm | Xóa cứng theo §5 |

**Đổi quyền và xóa:** API/tìm kiếm/số đếm/ảnh bìa/thumbnail ngừng trả nội dung trong ≤60 giây [APPROVED A9]. URL ảnh riêng tư ký TTL ≤15 phút; PUB phải có phương án thu hồi/CDN chốt trước mở (B9), không tự coi cơ chế private đã xử lý mọi cache public. Không thể thu hồi bản người khác đã tải/chụp màn hình trước đó [ROADMAP G9].

**Hai trục ở bản chia sẻ sau (DEC-32):** thay quyền ảnh không tự cấp/thu hồi quyền của tài nguyên địa điểm độc lập; mọi quan hệ/ID/số đếm dẫn ngược tới ảnh vẫn phải theo quyền ảnh. Hide xóa liên kết hiển thị của ảnh, không xóa SavedPlace độc lập. Chưa thiết lập quyền → ảnh riêng tư/vị trí ẩn; không buộc chọn lại sau mỗi ảnh. Binary/API 1.0 vẫn từ chối friends/public trên cả hai trục.

**Ảnh riêng tư:** URL ký TTL ≤15 phút [APPROVED A9], chỉ cấp sau kiểm quyền server; không URL tĩnh đoán được. Bật/tắt bảo vệ zone không đổi quyền ảnh, hiện vị trí ảnh cũ hoặc replay job; sửa ảnh cũ phải qua gate hiện tại.

## 5. Lưu giữ và xóa [nguyên tắc APPROVED 31/10/2026 – DEC-12]

| Đối tượng | Sự kiện | Hành động | Thời hạn |
| --- | --- | --- | --- |
| Khoảnh khắc + ảnh + thumbnail | Người dùng xóa | Ẩn ngay; xóa cứng DB/storage; vô hiệu CDN | Ẩn ≤60 giây; xóa cứng ≤30 ngày |
| Tài khoản | Xóa trong app (SAFE-01) | Thu hồi phiên, chặn cấp URL mới ngay; ẩn nội dung; xóa cứng User/Moment/ảnh/SavedPlace/Collection/ExternalSource/Report (PUB); thu hồi token Apple | Ẩn ≤60 giây (A9); URL đã ký theo TTL §4; xóa cứng ≤30 ngày; thông báo hoàn tất |
| Place chung | Không còn ai tham chiếu | Giữ Doday Place ID + Google Place ID (được phép lưu lâu dài) hoặc xóa | Không giới hạn / dọn định kỳ |
| Nơi thủ công | Người tạo xóa hoặc xóa tài khoản | Xóa | ≤30 ngày |
| Backup | Xoay vòng | Dữ liệu đã xóa biến mất khỏi backup khi bản backup cũ hết hạn; không khôi phục dữ liệu đã xóa vào production | ≤35 ngày |
| Nhật ký kiểm duyệt (bản công khai) | Quyết định ẩn/gỡ/khóa | Dạng tối thiểu; B9 duyệt hướng, LEGAL xác minh trước PUB | Khởi điểm 12 tháng; chưa thu trong 1.0 |
| Bản ghi đồng ý của người đại diện | Tài khoản bị xóa hoặc người đại diện rút đồng ý | Xóa cùng tài khoản; [NEEDS_CONFIRMATION – LEGAL] có phải giữ bằng chứng đồng ý/rút đồng ý trong thời hạn luật định không | Theo LEGAL |
| Đăng ký dưới 13 tuổi bị từ chối | Ngay khi từ chối | Không lưu email/năm sinh đã nhập | Ngay |
| Log kỹ thuật | – | Không GPS nhạy cảm/ảnh/token; tối thiểu hóa | ≤30 ngày (A9) |
| Dữ liệu cục bộ | Chọn "Xóa khỏi máy" / thiết bị nhận xác nhận xóa tài khoản hoặc thu hồi phiên do xóa từ backend | Khóa truy cập, dừng/hủy hàng đợi; xóa token, DB, ảnh/gốc/thumbnail/nháp/cache do app quản lý, App Group và zone của đúng tài khoản | Ngay tại thiết bị nhận thao tác/xác nhận; không cam kết xóa từ xa máy offline |
| GPS đầu vào cho nhận diện | Hết tác vụ/TTL hoặc bị Hide/zone | APPROVED ZONE/DEC-31: bỏ mẫu RAM, không tạo hàng đợi tọa độ bền vững hoặc lưu backend, kể cả làm tròn; không gia hạn khi retry | Tối đa 60 s từ lúc nhận mẫu, có thể xóa sớm; không là tuổi mẫu Q-06/TTL tâm zone/cache Place Google hoặc thời hạn ảnh gốc |
| Home Privacy Zone/công tắc trên máy | Sửa/tắt/bật/xóa vùng; xóa dữ liệu máy/tài khoản | Sửa/toggle vô hiệu job/revision cũ; tắt giữ vùng, xóa mới bỏ; không mang cấu hình A sang B | Ngay tại máy nhận thao tác; không cam kết xóa từ xa máy offline; cấu hình mới mặc định bật |

**Thiết bị khác/offline (SAFE-01 S2/E3):** mốc xử lý trên B là khi B nhận xác nhận tài khoản đã xóa hoặc phiên bị thu hồi **do xóa tài khoản** từ backend, không phải lần mở app kế tiếp bất kể kết nối. Khi B có mạng trở lại, kiểm tra trạng thái tài khoản trước khi phát lại hàng đợi; chưa kiểm tra được thì không phát lại. Nhận xác nhận xóa thì khóa truy cập, dừng/hủy hàng đợi và dọn dữ liệu theo dòng trên, không upload lại nháp cũ hoặc chuyển sang tài khoản khác. Lỗi mạng hay mã 401 thông thường không được suy thành xác nhận xóa; nháp vẫn phân vùng đúng tài khoản theo BR-A3/A4 và MVP-01 E1. Các thời hạn ẩn ≤60 giây, xóa cứng ≤30 ngày/backup ≤35 ngày áp dụng phía backend/storage, không phải cam kết xóa dữ liệu trên máy chưa nhận được trạng thái backend; giới hạn thu hồi ở phụ lục §3.3 vẫn giữ nguyên.

**Backup ảnh:** 50 USD/tháng năm đầu/kịch bản cơ sở đã duyệt; gồm bản sao object/phiên bản cũ ≤35 ngày, không coi backup DB gồm bytes ảnh. A7 duyệt admission ngân sách tổng và backup object riêng DB; B4 chốt provider/region/cách sao lưu trước G3, chưa triển khai. G10 restore/đối soát DB–ảnh, áp dấu xóa, kiểm lifecycle cả thumbnail/bản sao. Không tự xóa ảnh synced để giảm tiền hoặc kéo dài retention. Ví dụ R2/Supabase không phải lựa chọn provider; ảnh vuông không chứng minh đã bỏ GPS/đủ ngân sách.

Apple yêu cầu xóa cả nội dung người dùng đã chia sẻ cho người khác khi xóa tài khoản và thông báo thời hạn nếu cần thêm thời gian (Offering account deletion in your app, truy cập 30/10/2026). Nghĩa vụ lưu giữ theo luật thị trường DEC-01: **chưa xác minh**, LEGAL xác nhận.

## 6. Ranh giới dữ liệu Google / Doday

**Kiểm lại chính thức 31/10/2026:** nguồn P1/P2 ở phụ lục §7. Place ID có ngoại lệ lưu lâu dài; tọa độ Places được cache tạm tối đa **30 ngày liên tiếp rồi xóa** (§14.3), không suy sang các trường khác. Attribution vẫn cần. Trang terms nay đọc được, thay ghi nhận không tải được ngày 30/10. LEGAL phải xác nhận hợp đồng/billing account áp dụng, TTL theo trường và cơ chế purge trước G2/G3; không coi mọi dữ liệu lấy từ Google là tài sản Doday hoặc lưu vô thời hạn.

| Trường Google | SKU Place Details (docs truy cập 30/10/2026) | Dùng ở màn | Lưu trên server Doday |
| --- | --- | --- | --- |
| id (Place ID) | Essentials IDs Only | Mọi nơi | Có, lâu dài |
| movedPlace, movedPlaceId, photos, attributions | Essentials IDs Only | Chi tiết | Không (Place ID mới chỉ lưu khi người dùng chọn chuyển) |
| formattedAddress, shortFormattedAddress, types | Essentials | Chi tiết, bottom sheet | Không; không suy ngoại lệ tọa độ sang tên/địa chỉ/loại |
| location (tọa độ Place, khác GPS thiết bị) | Essentials | Marker/chi tiết khi có quyền dữ liệu | Ngoại lệ tạm tối đa 30 ngày; TTL/purge và hợp đồng thực tế chờ LEGAL/DEC-29; không tự refresh theo mở/pan Map |
| displayName, googleMapsUri, businessStatus, primaryType, utcOffsetMinutes | Pro | Chi tiết, bottom sheet | Không |
| regularOpeningHours, currentOpeningHours, rating, userRatingCount, nationalPhoneNumber, websiteUri | Enterprise | Chi tiết | Không |
| reviews | Enterprise + Atmosphere | 1.0, chỉ khi yêu cầu xem từng review (DEC-14/28 đã thay hoãn cũ) | Không |

**DEC-29 APPROVED trải nghiệm qua OVERRIDE:** Map không gọi Places khi mở/đổi viewport; phương án Essentials theo viewport cũ bị thay thế. Giữ SavedPlace/ID, dữ liệu Doday thực sự do người dùng tạo và cache còn quyền dùng; thiếu tên dùng nhãn trung tính/nhãn người dùng, thiếu tọa độ xem danh sách, status thiếu là chưa xác định. Refresh Google chỉ qua lệnh chủ động, không cả viewport. **[NEEDS_CONFIRMATION – LEGAL/TL, B-G2]** hợp đồng áp dụng/TTL từng trường/cơ chế purge vẫn cần chốt; duyệt UX không cấp quyền lưu dữ liệu Google.

**Field mask theo khối [PROPOSED – TL duyệt trước G6]:** tác vụ thẻ/chi tiết được yêu cầu không rating = id, displayName, shortFormattedAddress, businessStatus, location khi cần (Details Pro); khi cần giờ/rating/liên hệ mới thêm đúng trường Enterprise của khối đang xem. Không gọi cho marker thụ động hoặc gom tất cả trường “để dành”. Nearby chỉ tác vụ gần đây/nhận diện hợp lệ, id/displayName/location/types (Pro); Text Search ứng viên không lấy rating/giờ. Dùng lại chỉ trong phạm vi chính sách cho phép, không coi cache bộ nhớ luôn hợp lệ. **Ảnh Google:** chỉ yêu cầu `photos`/attribution khi xem ảnh, không cache photo name, không lưu media vào kho ảnh Doday; có attribution tác giả khi nguồn cung cấp (P5). **Review:** chỉ thêm `reviews` khi mở khối review, không lấy vì đã có rating hoặc SKU phiên Atmosphere.

**Giá phiên khác field mask:** theo B2 kiểm tra 31/10/2026, Details kết thúc phiên Pro/Enterprise được tính Enterprise + Atmosphere; không vì vậy lấy `reviews` nếu người dùng chưa yêu cầu xem. Review 1.0 đã được duyệt qua OVERRIDE, nhưng việc mở review sau đó có thể phát sinh request riêng, không tính là đã trả tiền trong phiên trước. GGL-01 kiểm token, field mask và billing thực; dự toán mới cộng theo SKU chung, không trừ free tier lần nữa cho review/ảnh.

**Khóa API:** khóa iOS giới hạn theo bundle ID và API; Places Web Service và đọc URL ngoài đi qua backend, khóa server không nằm trong app (SRC §13.6, GGL-07).

## 7. Chính sách theo trạng thái tài khoản

| Tình huống | Quy tắc |
| --- | --- |
| Chưa đăng nhập | DEC-17 A: không dùng camera trước khi đăng nhập. Nếu B: nháp khách theo BR-A2b |
| Offline | BR-A5; trạng thái đồng bộ hiển thị trung thực |
| Đăng xuất | BR-A3; cảnh báo số mục chưa đồng bộ; xóa token Keychain; dữ liệu giữ lại bị khóa theo tài khoản |
| Đổi tài khoản | BR-A4; kiểm thử DATA-02 E1 và EXT-05 E1 |
| Nhiều thiết bị | BR-A6 / DEC-16 |
| Mất thiết bị | BR-A7; đăng xuất phiên khác từ máy mới (A8); nháp/zone/công tắc local không được hứa khôi phục – công bố trong Privacy Policy/Help |
| Xóa tài khoản | §5 |
| Tài khoản bị khóa | Không đăng công khai; vẫn có đường xác thực chủ để xem/xuất dữ liệu riêng và xóa (A8), không mở quyền cho tài khoản khác |
| 13–15 tuổi chờ đồng ý | BR-A10: chụp, nháp, Map dùng được; ảnh/tọa độ không rời thiết bị cho tới khi người đại diện xác nhận |
| Người đại diện rút đồng ý | Dừng upload; xử lý như xóa tài khoản (§5) |

## 7b. Khung pháp lý Việt Nam (DEC-01) – chưa đối chiếu văn bản gốc

Theo nguồn thứ cấp truy cập 30/10/2026 ([LuatVietnam](https://luatvietnam.vn/legal-updates/the-latest-law-on-personal-data-protection-and-the-guiding-documents-892-106778-article.html), [Vietnam Briefing](https://www.vietnam-briefing.com/news/vietnam-law-on-personal-data-protection-latest-developments-and-insights.html/)): Luật Bảo vệ dữ liệu cá nhân 91/2025/QH15 có hiệu lực từ 01/01/2026, hướng dẫn bởi Nghị định 356/2025/NĐ-CP. Các điểm ảnh hưởng tới Doday:

- Dữ liệu vị trí và dữ liệu trẻ em được coi là dữ liệu nhạy cảm. Cả hai đều có trong Doday (tọa độ lúc chụp; người dùng 13–15 tuổi).
- Xử lý dữ liệu trẻ em cần đồng ý của người đại diện theo pháp luật → BR-A10, DEC-24.
- Cần đánh giá tác động khi xử lý dữ liệu nhạy cảm và khi chuyển dữ liệu ra nước ngoài → ảnh hưởng chọn vùng lưu trữ (DEC-06) và các bên xử lý (Google Places nhận tọa độ; nhà cung cấp email/auth).
- Thông báo vi phạm cho Bộ Công an trong 72 giờ → runbook sự cố (SAFE-09).
- Doanh nghiệp nhỏ/khởi nghiệp có thể được miễn một số nghĩa vụ (DPO, đánh giá tác động) trong 5 năm. Việc Doday có thuộc diện này hay không phụ thuộc chủ thể pháp lý (DEC-19).

Đây **không** phải ý kiến pháp lý. LEGAL phải đối chiếu luật, nghị định và các văn bản liên quan (Luật Trẻ em 2016, quy định về dịch vụ mạng) trước G3 (R-14, R-26).

## 8. Báo cáo, chặn, kiểm duyệt, hỗ trợ

- Báo cáo: khoảnh khắc công khai và người dùng; lý do theo danh mục [PROPOSED: spam, khỏa thân/tình dục, bạo lực, quấy rối, thông tin cá nhân/vị trí người khác, vi phạm bản quyền, khác].
- Chặn: hai chiều ở mọi bề mặt và API (SAFE-04).
- Lọc: ảnh công khai qua lớp lọc tự động [PROPOSED; công nghệ chọn ở G3, chưa có ngưỡng] + báo cáo + hạn mức (SAFE-05).
- Kiểm duyệt: hàng đợi, ẩn/gỡ, khóa tài khoản, nhật ký; SLA Q-15 (khẩn cấp ≤4 giờ, thông thường ≤24 giờ – DEC-20 duyệt 31/10, chỉ áp dụng PUB).
- Hỗ trợ: email/URL, phản hồi ≤2 ngày làm việc [APPROVED A14]; kênh thật/phương án vắng mặt trước beta ngoài G11 (B8), công bố/kiểm lại Support URL trước G12A.
- **Kiểm duyệt: không có trong 1.0** (DEC-15 C, 30/10/2026). Báo cáo, chặn và lọc ở trên chỉ áp dụng cho bản công khai.
- **Hỗ trợ 1.0: Chủ dự án (DEC-23, duyệt 30/10/2026).** Chưa dự phòng/kênh thật; B8 yêu cầu có kênh và phương án vắng mặt trước beta ngoài G11, Support URL/chính sách công bố trước G12A (R-28).
