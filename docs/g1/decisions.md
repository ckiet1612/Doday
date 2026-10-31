# Doday 1.0 – Sổ quyết định (G1)

Trạng thái: APPROVED (đặc tả G1, G1-SIGNOFF) · Ngày lập: 30/10/2026 · Ngày duyệt toàn G1: 31/10/2026 (giờ Việt Nam), Chủ dự án kiêm PO/TL

**Quy tắc:** khuyến nghị không tự thành quyết định; chỉ phần ghi `APPROVED` có nguồn xác nhận ở §3 mới được duyệt. Chủ dự án kiêm mọi vai trò từ 31/10/2026. BATCH-AB duyệt A1–A14/kế hoạch B1–B9, công tắc zone mặc định bật/có thể tắt tại Cài đặt; giữ private-only. **G1-SIGNOFF ngày 31/10/2026** xác nhận toàn bộ G1 với tư cách PO/TL (mục C), nguồn tại `approval-batch.md` §6. Không suy thành đã chọn provider/codec, xác minh pháp lý hoặc đo đạt; các trạng thái/lựa chọn theo cổng B vẫn giữ. Ngày theo Asia/Ho_Chi_Minh; tin B/C/D lúc 17:04 UTC ngày 30/10 là 00:04 ngày 31/10. Nhật ký giữ trạng thái của từng thời điểm, không thay lịch sử bằng trạng thái hiện hành.

**Mức chặn:** `B-G1` chặn APPROVED của G1 · `B-G2` trước kết thúc G2 (phương pháp chốt trước đo) · `B-G3` trước G3 · `B-G4` trước xây pipeline ảnh G4 · `B-G6`/`B-G7` trước nghiệm thu G6/G7 · `B-G11` trước beta ngoài · `B-PUB` trước mở nội dung công khai · `B-G12` trước nộp App Store.

## 1. Tổng hợp

| ID | Chủ đề | Khuyến nghị (tóm tắt) | Mức chặn | Trạng thái | Người duyệt (vai trò) | Ngày duyệt |
| --- | --- | --- | --- | --- | --- | --- |
| DEC-01 | Thị trường và ngôn ngữ | Đã chọn: Việt Nam; tiếng Việt (trọng tâm) + tiếng Anh | B-G1 | APPROVED | Chủ dự án | 30/10/2026 |
| DEC-02 | Nhóm tuổi tối thiểu | Đã chọn: 13+ (khuyến nghị trước đó là 18+); 13–15 cần đồng ý của người đại diện | B-G1 | APPROVED | Chủ dự án (như DEC-01) | 30/10/2026 |
| DEC-03 | iPhone / iPad | iPhone-first; iPad chế độ tương thích, không universal tối ưu riêng | B-G1 | APPROVED | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-04 | iOS tối thiểu (deployment target) | iOS 17.0 | B-G1 | APPROVED – iOS 17.0 | Chủ dự án | 30/10/2026 |
| DEC-05 | Phương thức đăng nhập | Sign in with Apple + email OTP | B-G1 | APPROVED | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-06 | Kiến trúc backend/storage | Managed Postgres có RLS + object storage riêng tư + URL ký; nhà cung cấp/vùng chọn ở G3 | B-G1 (kiểu) · B-G3 (nhà cung cấp) | APPROVED (kiểu); nhà cung cấp: chờ G3 | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-07 | Chính sách lưu ảnh và ngân sách storage | 1:1 cắt giữa, 2048/400 px, gốc tại máy; trần 50 USD/tháng năm đầu; BR-M11, quota/admission A5–7 | B-G1 (chính sách) · B-G4 (codec/byte) | APPROVED A; codec/chất lượng chọn theo đo B3 | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-08 | Nền bản đồ | Google Maps SDK for iOS (theo SRC §13.3) | B-G1 | APPROVED | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-09 | Ngân sách Google Maps Platform | Trần tối đa 6.000 USD/tháng; COST và reservation/reset/alerts/retry/breaker A10–11 | B-G1 (chính sách) · B-G6 (forecast/quota) | APPROVED chính sách/tham số A; forecast/quota thực chốt theo B7 | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-10 | Tải dự kiến | Mục tiêu 5.000 người dùng; giả định là MAU; đỉnh 10, thử tải 20 request Doday/giây | B-G1 | APPROVED (5.000); MAU và hệ số tính: ASSUMPTION | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-11 | Mặc định hiển thị khoảnh khắc mới | 1.0 luôn riêng tư; bản chia sẻ dùng mặc định hai trục do người dùng đặt, khởi tạo an toàn, không hỏi lại mỗi ảnh (DEC-32) | B-PUB (triển khai bản chia sẻ) | APPROVED nguyên tắc; thay yêu cầu public từng lần | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-12 | Lưu giữ và xóa dữ liệu | Ẩn ≤60 s, xóa cứng ≤30 ngày, backup ≤35 ngày; URL ký ≤15 phút, log kỹ thuật ≤30 ngày (A9) | B-G1 · B-G3 (retention pháp lý) | APPROVED A; retention người đại diện cần LEGAL theo B5 | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-13 | Share Extension trong 1.0 | Có | B-G1 | APPROVED | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-14 | Nội dung từng review Google | Có trong 1.0, chỉ tải khi yêu cầu xem review; rating/tổng lượt vẫn độc lập | B-G1 | APPROVED qua OVERRIDE/DEC-28; thay quyết định hoãn 1.1 | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-15 | Nhân sự hỗ trợ/kiểm duyệt | Chưa có người kiểm duyệt → 1.0 chỉ riêng tư (phương án C) | B-G1 | APPROVED – phương án C | Chủ dự án | 30/10/2026 |
| DEC-16 | Quy tắc xung đột đồng bộ | Theo BR-A6 | B-G1 | APPROVED | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-17 | Dùng app khi chưa đăng nhập | Đăng nhập trước lần chụp đầu tiên | B-G1 | APPROVED | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-18 | Phạm vi cộng đồng công khai lúc ra mắt | 1.0: không có cộng đồng công khai (theo DEC-15 C). Phạm vi bản công khai sau quyết định lại | B-PUB | APPROVED cho 1.0 (hệ quả của DEC-15) | Chủ dự án (như DEC-15) | 30/10/2026 |
| DEC-23 | Người hỗ trợ 1.0 (không kiểm duyệt) | Chủ dự án; chưa dự phòng. A14/B8: SLA/kênh/phương án vắng mặt trước beta ngoài, Support URL trước G12A | B-G1 (người) · B-G11/B-G12 (vận hành) | APPROVED người/SLA/kế hoạch; kênh thật chưa tạo | Chủ dự án | 30/10/2026 (người); 31/10/2026 (A/B) |
| DEC-24 | Cơ chế đồng ý của người đại diện cho người dùng 13–15 tuổi | Hướng email/liên kết; dữ liệu chỉ tại máy tới xác nhận; B5 | B-G3 (xác minh luật/cơ chế trước xây đăng ký) | APPROVED hướng có điều kiện; pháp lý/bằng chứng/retention chưa xác minh | Chủ dự án (LEGAL cần đối chiếu) | 31/10/2026 (hướng) |
| DEC-19 | Pháp nhân / tài khoản Apple Developer và Google Cloud | PO quyết định; bắt đầu chuẩn bị từ G1 | B-G3 | NEEDS_CONFIRMATION | Chủ dự án | – |
| DEC-20 | Duyệt ngưỡng chất lượng mục 4 | Ngưỡng roadmap Q-01…Q-17; Q-06 tạm chốt, xác nhận lại sau G2 | B-G1 | APPROVED (Q-06 tạm chốt; Q-15 cho PUB) | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-21 | Nguồn dữ liệu trích xuất từ link TikTok/Instagram | Share Sheet URL/text trước; metadata chỉ sau xác minh quyền (A13/B6) | B-G2 | APPROVED A; quyền bên thứ ba chưa xác minh | Chủ dự án (LEGAL/TL) | 31/10/2026 |
| DEC-22 | Công cụ crash/analytics | Không tracking quảng cáo; chọn công cụ theo khả năng đo Q-11 ở G3 (A9/B4) | B-G3 | APPROVED kế hoạch; chưa chọn công cụ | Chủ dự án (TL/SEC) | 31/10/2026 (kế hoạch) |
| DEC-25 | Đăng công khai không có/ẩn Place | Ảnh không bắt buộc Place; PUB cho null/hidden, không hiện trên trang địa điểm | B-PUB (kiểm triển khai) | APPROVED qua OVERRIDE; 1.0 vẫn riêng tư | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-26 | Phạm vi 1.0: riêng tư, bạn bè, cộng đồng | Giữ private-only, áp dụng Hide/zone; không friends/community trong binary/API 1.0 | B-G1 | APPROVED, xác nhận lại DEC-15/18 | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-27 | Trigger nhận diện và mẫu số coverage | Không Nearby theo ảnh/GPS; giữ Q-05/06; B1/B2 duyệt mẫu số và ngưỡng thử khởi điểm | B-G2 (hiệu chỉnh trước đo) | APPROVED kế hoạch; T_auto/T_confirm/TTL ngữ cảnh chờ đo/chốt | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-28 | Photos/reviews theo nhu cầu xem trong 1.0 | Có Photos và từng review on-demand; không Routes/Geocoding dư thừa; không tăng trần tiền | B-G1; B-G6 (nghiệm thu) | APPROVED phạm vi qua OVERRIDE | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-29 | Map khi cache Google hết hạn | Giữ SavedPlace/ID/nhãn/pin Doday hợp lệ; thiếu marker dùng danh sách; refresh Google chủ động | B-G2 (kiểm hợp đồng) | APPROVED trải nghiệm; TTL theo trường chờ LEGAL | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-30 | Nhật ký cá nhân trong 1.0 | Moment đã lưu trong Profile/Khoảnh khắc của tôi, không tab mới/tracking; A12 | B-G1; B-G2 (UI chi tiết), B-G7 (nghiệm thu) | APPROVED phạm vi/vị trí UI; chi tiết hoàn thiện theo B3 | Chủ dự án (PO/TL) | 31/10/2026 |
| DEC-31 | Home Zone, Hide, retention và hàng đợi | Zone local-only, công tắc mặc định bật/tắt tại Cài đặt; Hide độc lập mặc định bật; heuristic/consent/revision/strip-all A1–4 | B-G1 (chính sách) · G3–G10 (kiểm chứng) | APPROVED ZONE + BATCH-AB; chưa triển khai/kiểm thử | Chủ dự án (PO/TL/SEC) | 31/10/2026 |
| DEC-32 | Audience độc lập và mặc định chia sẻ | Hai trục độc lập, mặc định cấu hình an toàn; không công khai liên kết ảnh hạn chế; 1.0 owner/hidden | B-PUB (triển khai quyền chia sẻ) | APPROVED nguyên tắc qua OVERRIDE | Chủ dự án (PO/TL/SEC) | 31/10/2026 |

## 2. Chi tiết

### DEC-01 – Thị trường và ngôn ngữ

- **Bối cảnh:** nguồn không nêu thị trường; mọi ví dụ là Việt Nam (Đà Lạt, Hà Nội) và tiếng Việt [SRC §4.3, §5.5]. Thị trường quyết định luật dữ liệu áp dụng, ngôn ngữ kiểm duyệt, mật độ dữ liệu Google và danh sách quốc gia trên App Store.
- **Phương án:**
  - A. Chỉ Việt Nam, giao diện tiếng Việt. Ít chi phí bản địa hóa/kiểm duyệt; mật độ nội dung cộng đồng tập trung. Hạn chế: người dùng nước ngoài tại Việt Nam.
  - B. Việt Nam, giao diện Việt + Anh. Thêm chi phí dịch, QA và kiểm duyệt song ngữ.
  - C. Toàn cầu. Phải xử lý nhiều luật dữ liệu (ví dụ GDPR), kiểm duyệt đa ngôn ngữ; nội dung cộng đồng loãng.
- **Khuyến nghị:** A, tách chuỗi bằng String Catalog ngay từ đầu để mở B không phải viết lại.
- **Tác động pháp lý:** Việt Nam có quy định riêng về bảo vệ dữ liệu cá nhân. Bộ tài liệu này **chưa xác minh** văn bản và hiệu lực hiện hành; LEGAL phải xác nhận trước G3 (R-14).
- **Quyết định (30/10/2026): thị trường Việt Nam; giao diện tiếng Việt (trọng tâm, mặc định) + tiếng Anh.** Đây là phương án B. Yêu cầu tương ứng: DODAY-L10N-01.
  - Danh sách quốc gia phát hành trên App Store: [ASSUMPTION] chỉ Việt Nam; tiếng Anh phục vụ người dùng tại Việt Nam dùng máy tiếng Anh. Nếu muốn phát hành thêm quốc gia khác, cần quyết định riêng vì kéo theo luật dữ liệu khác.
  - Luật áp dụng chính: Luật Bảo vệ dữ liệu cá nhân số 91/2025/QH15, hiệu lực 01/01/2026, và văn bản hướng dẫn (nguồn thứ cấp nêu Nghị định 356/2025/NĐ-CP). Điểm có tác động thiết kế theo nguồn thứ cấp (truy cập 30/10/2026, **chưa đối chiếu văn bản gốc**): dữ liệu vị trí và dữ liệu trẻ em là dữ liệu nhạy cảm; đánh giá tác động khi xử lý dữ liệu nhạy cảm và khi chuyển dữ liệu ra nước ngoài; thông báo vi phạm cho Bộ Công an trong 72 giờ; doanh nghiệp nhỏ/khởi nghiệp có thể được miễn một số nghĩa vụ (DPO, đánh giá tác động) trong 5 năm. Ảnh hưởng: vùng lưu trữ ở DEC-06, quy trình sự cố ở SAFE-09, Privacy Policy ở SAFE-08. LEGAL xác nhận trước G3.
  - Chi phí: dịch và QA hai ngôn ngữ cho mọi chuỗi, email, chính sách và metadata store.

### DEC-02 – Nhóm tuổi tối thiểu

- **Bối cảnh:** ứng dụng có UGC công khai gắn địa điểm thật. Apple 1.2.1(a) yêu cầu ứng dụng creator có cách giới hạn nội dung vượt độ tuổi (truy cập 30/10/2026). Hệ thống age rating mới của Apple áp dụng từ 31/01/2026 (Upcoming Requirements, truy cập 30/10/2026).
- **Phương án:** A. 18+ – rủi ro thấp nhất về trẻ vị thành niên chia sẻ vị trí; thu hẹp người dùng. B. 16+ – cân bằng; cần chính sách nội dung và kiểm duyệt chặt hơn. C. 13+ – thị trường rộng nhất; cần cơ chế đồng ý của phụ huynh theo luật thị trường, kiểm duyệt thiên về an toàn trẻ em.
- **Khuyến nghị:** A cho 1.0 vì chưa có đội vận hành an toàn trẻ em; xem xét hạ ở bản sau. Ảnh hưởng: SAFE-11, age rating App Store, Terms.
- **Đánh giá trước khi PO chọn:** bản riêng tư giảm rủi ro phân phối UGC nhưng vẫn xử lý ảnh/vị trí; đã nêu phương án 16+. Tuổi đã chốt 13+ bên dưới; chỉ cơ chế/pháp lý DEC-24 còn chờ, không yêu cầu PO chọn lại tuổi ở G1.
- **Quyết định (30/10/2026): phương án C – tối thiểu 13 tuổi.** Hệ quả bắt buộc:
  - **Người 13–15 tuổi là trẻ em theo pháp luật Việt Nam** (Luật Trẻ em 2016: trẻ em là người dưới 16 tuổi – kiến thức nền, chưa truy cập văn bản gốc trong G1). Theo nguồn thứ cấp truy cập 30/10/2026, Luật BVDLCN 91/2025/QH15 (hiệu lực 01/01/2026) yêu cầu xử lý dữ liệu cá nhân của trẻ em phải có sự đồng ý của người đại diện theo pháp luật, và coi dữ liệu trẻ em và dữ liệu vị trí là dữ liệu nhạy cảm. Chi tiết (có cần cả đồng ý của trẻ từ 7 tuổi hay không, cách xác minh) **chưa đối chiếu văn bản gốc** – LEGAL phải xác nhận.
  - Doday 1.0 vì vậy phải có cổng tuổi khi đăng ký và cơ chế đồng ý của người đại diện cho 13–15 tuổi trước khi đưa ảnh/vị trí lên server (SAFE-11, BR-A9, BR-A10). Cơ chế cụ thể: DEC-24.
  - Mức App Store age rating là kết quả của bảng hỏi nội dung, không phải "tuổi tối thiểu" do Doday chọn. Bản 1.0 chỉ riêng tư khai báo theo tính năng thực tế; tuổi 13+ được thực thi trong app. Đối chiếu bảng hỏi tại G12A.
  - Khi mở bản công khai, nội dung của người 13–15 tuổi cần quy tắc riêng (ví dụ không công khai mặc định, kiểm duyệt ưu tiên) – ghi cho lần duyệt lại DEC-11/DEC-15.

### DEC-03 – iPhone / iPad

- **Hiện trạng mã:** `project.yml` đặt `TARGETED_DEVICE_FAMILY: "1,2"` (iPhone + iPad), iPad hỗ trợ xoay 4 hướng.
- **Phương án:** A. Chỉ iPhone (family 1). App vẫn có thể chạy ở chế độ tương thích trên iPad; Apple 2.4.1 khuyến khích "iPhone apps should run on iPad whenever possible" (truy cập 30/10/2026). B. Universal tối ưu iPad – thêm thiết kế, ảnh chụp store iPad, ma trận thử.
- **Quyết định 31/10/2026 (mục C):** chọn A, iPhone-first, iPad chế độ tương thích. Cần thử iPad ở G10. `TARGETED_DEVICE_FAMILY` hiện vẫn “1,2”; TL điều chỉnh ở G3, **không** sửa trong lượt G1 này. Đây là khác biệt giữa đặc tả đã chọn và cấu hình đang quan sát, không phải đã triển khai.

### DEC-04 – iOS tối thiểu (deployment target), tách khỏi SDK build

- **Quyết định (30/10/2026):** iOS 17.0 cho app và test target. Đã áp dụng vào `project.yml` (`options.deploymentTarget.iOS: "17.0"`, bỏ override riêng của test target) và sinh lại `Doday.xcodeproj` bằng `xcodegen generate`; mọi `IPHONEOS_DEPLOYMENT_TARGET` trong project đã sinh là 17.0. Chưa build/chạy test để kiểm chứng.
- **Hiện trạng mã trước quyết định:** app target iOS 15.0; test target 17.0; Xcode cục bộ 27.1 (chỉ quan sát `xcodebuild -version`, chưa build).
- **Ràng buộc đã kiểm (30/10/2026):**
  - Apple: upload phải dùng Xcode 26+ với iOS 26 SDK+ từ 28/04/2026; deployment target phải ≥ iOS 13 từ 09/09/2026 (developer.apple.com/news/upcoming-requirements). Đây là **SDK build**, không phải mức tối thiểu người dùng.
  - Google Maps SDK for iOS và Places SDK for iOS từ v10.0.0 yêu cầu tối thiểu **iOS 16**; bản mới nhất 11.2.0 (release notes truy cập 30/10/2026). → iOS 15 hiện tại **không tương thích** với DEC-08.
  - Roadmap nhắc "từ tháng 04/2027 cần iOS 27 SDK"; trang Upcoming Requirements tại lần truy cập này **không hiển thị** mục đó → chưa xác minh, kiểm lại trước G12.
- **Phương án:** A. iOS 16 – mức thấp nhất Google SDK cho phép; không có SwiftData/Observation, phải dùng Core Data. B. iOS 17 – có SwiftData, Observation, khớp test target; loại thiết bị chỉ chạy iOS 16. C. iOS 18 – API mới hơn, loại thêm thiết bị.
- **Khuyến nghị đã nêu:** B. Đã được chọn. Tỷ lệ người dùng iOS 16 tại thị trường mục tiêu vẫn **chưa đo**; quyết định chấp nhận loại thiết bị chỉ chạy iOS 16.
- **Hệ quả:** SwiftData/Observation dùng được; tương thích Google Maps/Places SDK 11.x (tối thiểu iOS 16). SDK build vẫn theo yêu cầu Apple tại ngày nộp (hiện Xcode 26+ / iOS 26 SDK+), không liên quan tới mức tối thiểu này. Thiết bị thấp nhất cho Q-01…Q-07 phải là iPhone chạy iOS 17 (model cụ thể vẫn chờ TL chọn).

### DEC-05 – Phương thức đăng nhập

- **Ràng buộc:** Apple 4.8 – nếu dùng đăng nhập bên thứ ba/mạng xã hội làm phương thức chính, phải có thêm ít nhất một phương thức tương đương giới hạn dữ liệu ở tên/email, cho phép ẩn email, không thu dữ liệu quảng cáo khi chưa đồng ý. Apple 5.1.1(v) và trang Offering account deletion – phải xóa tài khoản trong app; nếu dùng Sign in with Apple phải thu hồi token qua REST API (truy cập 30/10/2026). Apple 2.1(a) – cung cấp tài khoản demo cho review.
- **Phương án:** A. Chỉ Sign in with Apple – đơn giản; người review cần tài khoản demo riêng hoặc dùng Apple ID của họ; khó cho người không muốn dùng Apple ID. B. Sign in with Apple + email OTP – có tài khoản demo dễ cấp; chi phí gửi email; cần chống lạm dụng OTP. C. A + Google + email – phủ rộng nhất; thêm SDK, khai báo quyền riêng tư và bề mặt bảo mật.
- **Khuyến nghị:** B. Không dùng mật khẩu để giảm rủi ro lộ mật khẩu.

### DEC-06 – Kiến trúc backend/storage

- **Ràng buộc từ yêu cầu:** quan hệ nhiều-nhiều (bộ sưu tập), ràng buộc duy nhất Google Place ID và idempotency (BR-P2), phân quyền đối tượng kiểm được bằng API (SAFE-02), URL ảnh riêng tư có TTL, proxy Places/URL phía server để không lộ khóa và chống SSRF (BR-X4, GGL-07), xóa dữ liệu bao trùm DB + ảnh + backup.
- **Phương án (kiểu, không phải nhà cung cấp):**
  - A. BaaS dạng tài liệu (document DB + auth + storage có rules). Nhanh khởi đầu; ràng buộc duy nhất và nhiều-nhiều phải tự đảm bảo; rules dễ sai khi mô hình lớn.
  - B. BaaS/managed Postgres có auth + row-level security + object storage. Có ràng buộc quan hệ thật, RLS kiểm được; vẫn cần một lớp function/server cho Places proxy và URL fetch.
  - C. API tự xây + managed DB + object storage. Kiểm soát tối đa; tốn công vận hành nhất cho đội nhỏ.
- **Khuyến nghị:** B. Nhà cung cấp cụ thể, vùng lưu trữ và chi phí do TL + PO chọn ở G3 sau DEC-01 (vị trí lưu dữ liệu) và DEC-10.

### DEC-07 – Chính sách lưu ảnh và ngân sách storage

- **Quyết định mới nhất 31/10/2026 (CROP): APPROVED** phương án B: ảnh vuông, bản chính tối đa 2048 × 2048 px, thumbnail tối đa 400 × 400 px, không phóng lớn ảnh nhỏ; gốc chỉ tại máy. Chuẩn hóa hướng rồi **cắt giữa tự động, không bước preview/xác nhận crop**, không kéo giãn. Người duyệt: Chủ dự án (PO/TL), trả lời “Duyệt, nhưng không cần xem trước chỉ cần cắt giữa”.
- **Phương án đã đối chiếu:** A giữ cả gốc cloud – nhiều dung lượng; B chỉ bản xử lý – đã chọn; C thêm tùy chọn upload gốc – thêm UI/quota, không chọn. Trước tin CROP, phê duyệt tiền/1:1 chưa bao gồm lựa chọn này; giữ lịch sử ở §3.
- **Đánh đổi đã chấp nhận:** crop giữa có thể bỏ chủ thể ở mép; không thêm thao tác chỉnh crop/đệm. Gốc chỉ tại máy có thể mất khi xóa app/mất thiết bị. BATCH-AB A5 duyệt BR-M11 (nguồn/nháp bền vững trước xử lý, giữ nguồn khi lỗi, retry idempotent). B3 duyệt chọn codec/chất lượng/giới hạn byte theo đo trước G4, **chưa chọn giá trị cuối**; không biến duyệt chính sách thành đã thử tốc độ/dung lượng.
- **Dự toán và nguồn chính thức:** [budget-and-capacity.md §3](budget-and-capacity.md#3-ảnh-tải-về-và-backup), kiểm tra 31/10/2026. Cơ sở 50.000 ảnh/tháng, 42 GB tăng/tháng; cuối tháng 12: 504 GB production + 553 GB bản sao/phiên bản cũ, khoảng **15,71–41,75 USD/tháng** theo hai mô hình nhà cung cấp, không phải đã chọn provider.
- **Trần đã duyệt:** **50 USD/tháng** năm đầu cho kịch bản cơ sở, gồm ảnh/thumbnail, tải lại và backup ảnh; không phải tổng backend. Tỉ lệ 1:1 không bảo đảm số byte, nên chưa giảm giả định 0,8 MB + 0,04 MB/ảnh. Kịch bản gấp đôi ảnh có thể vượt 50 USD ở gói trọn bộ. SAFE-12 cần thêm hạn mức tổng, không chỉ 5 GB/tài khoản; 5.000 tài khoản dùng đủ có thể tới 25 TB production.
- **APPROVED bổ sung BATCH-AB A1/A5–7:** mọi ảnh/thumbnail upload bỏ GPS; SAFE-12 tối đa 200 ảnh/ngày/tài khoản (reset 00:00 Việt Nam), nguồn 20 MB, avatar 10 MB, storage 5 GB; admission nguyên tử xét cả byte/thumbnail/truyền tải/backup và trần tổng, không tự xóa ảnh synced. Đây là giới hạn chống lạm dụng, không cấp sẵn 25 TB. Provider/vùng chọn trước G3 theo B4; cơ chế chặn chưa triển khai/kiểm thử.

### DEC-08 – Nền bản đồ

- **Bối cảnh:** SRC §13.3 chọn Google Maps SDK vì hiển thị nội dung Places trên bản đồ; SRC §17.7 nêu nội dung Places hiển thị trên bản đồ phải ở trên Google Map.
- **Kiểm tra chính sách (30/10/2026):** trang Places API Policies (cập nhật 28/10/2026) nêu: Place ID được lưu không giới hạn; nội dung khác không được pre-fetch/cache/store ngoài ngoại lệ; khi hiển thị không có Google Map phải có logo/text attribution Google Maps. Điều khoản Service Specific Terms về dùng nội dung Places với bản đồ không phải Google **không tải được** nội dung ở lần truy cập này → **chưa xác minh**; LEGAL đối chiếu trước G2.
- **Phương án:** A. Google Maps SDK – đúng định hướng nguồn, marker tùy biến; thêm SDK và khai báo quyền riêng tư; iOS ≥16. B. MapKit + nguồn địa điểm độc lập – không phụ thuộc Google cho bản đồ; mất khả năng hiển thị nội dung Places trên bản đồ, đi ngược định hướng nguồn.
- **Cập nhật 31/10/2026:** Service Specific Terms §14.2/14.3 nay đọc được (P2): không dùng Places với bản đồ không Google; ngoại lệ tọa độ tối đa 30 ngày rồi xóa. “Không tải được” trên là lịch sử 30/10. DEC-29/OVERRIDE đã chốt fallback ID/dữ liệu Doday/danh sách; hợp đồng/TTL theo trường vẫn chờ LEGAL.
- **Khuyến nghị:** A.

### DEC-09 – Ngân sách Google Maps Platform

- **Quyết định 31/10/2026:** **APPROVED trần ngân sách** theo §2.3 của tài liệu ngân sách: phát triển/nội bộ 50 USD/tháng, beta 100 USD, ra mắt ≤1.000 MAU 1.000 USD; 1.001–5.000 MAU theo 1,20 USD × MAU, tối đa **6.000 USD/tháng**, trước thuế. Mỗi lần tăng giai đoạn vẫn cần PO xác nhận. Tin duyệt ngân sách không tự duyệt thiết kế chặn phía dưới hoặc cấp tiền không giới hạn.
- **Mô hình tham chiếu trước ADD:** [budget-and-capacity.md §2](budget-and-capacity.md#2-google-maps-platform), nguồn kiểm tra **31/10/2026**. Ba kịch bản **2.311,50 / 4.930,10 / 10.122,50 USD/tháng** chưa thuế đã trừ free tier/bậc giá, không trùng Details, không gồm media/review mới. OVERRIDE đã chốt đổi trigger/fallback và thêm Photos/review on-demand; forecast phải tính lại theo tác vụ hợp lệ/SKU chung, không dùng hệ số cũ hợp thức hóa gọi theo ảnh/Map. Bảng độ nhạy mới không là số tiết kiệm đã đo, trần giữ nguyên.
- **Phương án:** A. Giữ chức năng 1.0, trần tăng theo MAU, tối đa **6.000 USD/tháng** ở 5.000 MAU (cơ sở ×1,20, làm tròn). B. Trần thấp hơn và giới hạn số người/thời điểm mở rộng, chấp nhận dự phòng khi hết lượt. C. Tối ưu truy vấn sau G2, giữ nguyên ca MVP; chưa coi mức tiết kiệm giả định là đã có.
- **Đã chọn về tiền:** A. Tổng cơ sở **4.930,10 USD/tháng đã trừ miễn phí theo từng SKU và bậc giá**, không tiếp tục trừ credit chung; ví dụ Nearby `(35.000 − 5.000) / 1.000 × 32 = 960 USD`. Không tự bỏ tự nhận diện, rating hay giờ mở cửa, đổi provider hay làm sai chính sách cache.
- **APPROVED bổ sung 31/10/2026 (COST):** Places Web Service chỉ qua proxy backend, không có đường gọi bỏ qua; giữ chỗ ngân sách nguyên tử trước cuộc gọi trả phí, kể cả retry; ngừng gọi Google trả phí khi hết trần hoặc bộ đếm lỗi (fail-closed). Camera/lưu và dữ liệu Doday không bị chặn theo Google. Đây là duyệt nguyên tắc thiết kế, **chưa cấu hình, chưa kiểm thử**.
- **APPROVED BATCH-AB A10–11:** định giá giữ chỗ bảo thủ theo SKU đắt nhất có thể tính/giá bậc đầu, không dựa miễn phí để chặn; ledger chung mọi môi trường, reset kỳ billing thực, không reset sớm/đếm đúp; alerts 50/80/100%. Search ≥2 ký tự/400 ms, retry tạm thời ≤2; breaker 5 lỗi liên tiếp/60 s, nghỉ 60 s rồi 1 probe; không retry lỗi quyền vĩnh viễn/probe trả phí lúc hết trần. Alert không tự chặn tiền; forecast vẫn trừ free tier một lần/SKU.
- **Kế hoạch B7 đã duyệt:** quota/rate limit nhà cung cấp, phân bổ SKU/media và forecast tối ưu chốt theo đo trước G6; bao 6.000 USD minh họa không là cấu hình production. TL/LEGAL chốt dữ liệu Map ở G2. Kịch bản cao vượt trần; không hứa phục vụ vô hạn. Không hỏi duyệt lại A10–11; cần bằng chứng G10 cho cơ chế thực.

### DEC-10 – Tải dự kiến

- **Quyết định (31/10/2026, giờ Việt Nam):** chủ dự án đặt mục tiêu **5.000 người dùng**.
- **Cách hiểu dùng để tính [ASSUMPTION]:** 5.000 người dùng hoạt động mỗi tháng (MAU). Đây là cách hiểu thận trọng nhất. Nếu 5.000 là tổng số tài khoản thì số người hoạt động thực tế thấp hơn, và chi phí ở DEC-07/DEC-09 cũng thấp hơn.
- **Hệ số giả định [ASSUMPTION]**, đo lại ở beta G11:
  - DAU/MAU = 20%, tức khoảng 1.000 người dùng mỗi ngày.
  - Mỗi người dùng trong ngày gọi khoảng 60 yêu cầu API.
  - 15% lưu lượng ngày dồn vào giờ cao điểm.
  - Đỉnh tức thời gấp 4 lần trung bình giờ cao điểm.
- **Tải tính ra:**
  - Khoảng 60.000 yêu cầu API/ngày.
  - Trung bình giờ cao điểm khoảng 2,5 yêu cầu/giây; **đỉnh dùng để thiết kế: 10 yêu cầu/giây**.
  - **Ngưỡng thử tải Q-14: 20 yêu cầu/giây trong 30 phút**, tức 2 lần đỉnh, theo ROADMAP G10.
  - Ảnh tải lên khoảng 50.000/tháng, tức khoảng 1.700/ngày.
- **Beta [ASSUMPTION]:** 30 người, mức tối thiểu của Q-16. Ở quy mô này chi phí Google gần như nằm trong hạn mức miễn phí.
- Đây là tải **API Doday**, không phải số người đồng thời hay số request Google; 20 × 30 × 60 = 36.000 yêu cầu thử. Mô hình Places/ảnh tách riêng ở `budget-and-capacity.md`. Không chạy thử tải trong G1.

### DEC-11 – Mặc định hiển thị khoảnh khắc mới

- **Nguồn:** SRC §4.5 yêu cầu hai chế độ và quyền kiểm soát, **không** chọn mặc định. ROADMAP G1 đề xuất mặc định riêng tư.
- **Phương án:** A. Riêng tư mặc định, công khai chủ động từng lần – an toàn nhất; ít nội dung cộng đồng hơn. B. Nhớ lựa chọn lần trước – thuận tiện; rủi ro công khai nhầm. C. Công khai mặc định – nhiều nội dung nhất; trái tinh thần SRC §4.5 "tự động gắn địa điểm không đồng nghĩa tự động công khai".
- **Khuyến nghị ban đầu:** A. **Quyết định thay thế 31/10/2026 (OVERRIDE, DEC-32):** 1.0 luôn riêng tư; khi bản chia sẻ được phép phát hành, người dùng cấu hình độc lập quyền ảnh và địa điểm một lần, nhãn trạng thái luôn rõ, không bắt chọn public hoặc địa điểm sau mỗi ảnh. Chưa thiết lập/không xác định → ảnh riêng tư, vị trí ẩn; quyền GPS/Hide-off không phải đồng ý công khai. Không bật friends/public trong 1.0.

### DEC-12 – Lưu giữ và xóa dữ liệu

Chi tiết thời hạn ở `privacy-and-data.md` §5. **Khuyến nghị:** xóa khỏi hiển thị ngay; xóa cứng trong ≤30 ngày; backup xoay vòng hết trong ≤35 ngày; nhật ký kiểm duyệt giữ tối đa [PROPOSED] 12 tháng ở dạng tối thiểu hóa. Cần LEGAL xác nhận nghĩa vụ lưu giữ bắt buộc theo DEC-01.

**Quyết định (31/10/2026):** duyệt ẩn ngay, xóa cứng ≤30 ngày, hết backup ≤35 ngày. BATCH-AB A8–9 chốt ẩn kỹ thuật ≤60 giây, URL riêng tư ký ≤15 phút, log kỹ thuật ≤30 ngày, quyền truy cập/xuất/xóa chính chủ khi bị khóa và đăng xuất phiên từ xa. B9 duyệt hướng log kiểm duyệt 12 tháng **chỉ PUB**, cần LEGAL xác minh. Bằng chứng đồng ý/rút đồng ý người đại diện chưa chốt; DEC-24/B5 cần đối chiếu luật trước G3, không tự coi phê duyệt là đáp ứng luật.

### DEC-13 – Share Extension trong 1.0

- **Bối cảnh:** SRC §7 gọi đây là "một trong những chức năng quan trọng để thu hút người dùng mới", có TH2 trong §11, nhưng không đánh số trong 30 hạng mục §15. ROADMAP §1 đề xuất đưa vào 1.0. Quyết định này **tách riêng** khỏi 30 hạng mục, không thay thế hạng mục nào.
- **Phương án:** A. Có trong 1.0 (EXT-01…05) – thêm target extension, App Group, ký ứng dụng, kiểm thử máy thật. B. Chỉ dán liên kết trong app (EXT-04) ở 1.0, extension ở 1.1 – ít rủi ro kỹ thuật, nhưng mất luồng TH2 "không rời TikTok".
- **Khuyến nghị:** A, với tiêu chí thành công là lưu được URL (Q-08), không phải tự trích xuất được địa điểm.

### DEC-14 – Nội dung từng review Google

- **Bối cảnh:** SRC §15 cho phép ưu tiên review sau thông tin cơ bản; điểm rating và tổng lượt đánh giá (MVP-22) **không** thuộc phạm vi hoãn. Reviews thuộc SKU Enterprise + Atmosphere; hiển thị phải có attribution tác giả và thông báo cách sắp xếp (Places API Policies, truy cập 30/10/2026).
- **Phương án:** A. Hoãn sang 1.1, có nút "Xem thêm trên Google Maps". B. Đưa vào 1.0 với đầy đủ attribution – chi phí mỗi lần mở chi tiết tăng lên nhóm Atmosphere, thêm ca kiểm thử chính sách.
- **Khuyến nghị ban đầu:** A. **Quyết định thay thế 31/10/2026 (OVERRIDE, DEC-28):** từng review vào 1.0, chỉ gọi Details có `reviews` khi người dùng yêu cầu xem khối review. Không tự tải khi mở chi tiết/rating; không coi SKU Atmosphere của kết thúc Autocomplete là lý do lấy reviews. Attribution, cache và chi phí phải nghiệm thu ở G6/G10; trần DEC-09 giữ nguyên.

### DEC-15 – Nhân sự hỗ trợ và kiểm duyệt

- **Ràng buộc:** Apple 1.2 yêu cầu lọc, báo cáo với phản hồi kịp thời, chặn người dùng và thông tin liên hệ công khai (truy cập 30/10/2026). ROADMAP G1: không có người vận hành thì chưa mở cộng đồng công khai.
- **Phương án:** A. Chủ sản phẩm kiêm moderator + một người dự phòng, SLA Q-15, giờ trực công bố. B. Thuê/đối tác kiểm duyệt bên ngoài – chi phí, cần hợp đồng xử lý dữ liệu. C. Chưa có người – 1.0 ra mắt ở chế độ chỉ riêng tư (cờ SAFE-10). Phương án C làm MVP-26/27 không có giá trị thực tế cho đến khi mở; **đây là thay đổi phạm vi**, PO phải quyết định tường minh.
- **Khuyến nghị đã nêu:** A tối thiểu trước beta ngoài; C chỉ là dự phòng tạm thời.
- **Quyết định (30/10/2026): phương án C**, chủ dự án chấp nhận 1.0 chỉ riêng tư. Hệ quả:
  - Binary 1.0 **không** chứa giao diện đăng công khai, xem khoảnh khắc người khác, báo cáo hay chặn. Không ẩn sẵn các tính năng này sau cờ server, vì Apple cấm tính năng ẩn/không tài liệu hóa (App Review Guidelines, truy cập 30/10/2026). Server vẫn từ chối mọi yêu cầu công khai (SAFE-10).
  - MVP-10/13/26/27 được giao một phần; SAFE-03/04/06 và phần kiểm duyệt của SAFE-05/07 chuyển sang bản công khai (mức ưu tiên `PUB` trong backlog.md).
  - Giá trị Discover ở 1.0 chỉ còn tìm kiếm Google và nội dung của chính người dùng; khác biệt "ảnh thực tế từ cộng đồng" (SRC §19) chưa có ở 1.0 (R-19).
  - Mô hình dữ liệu vẫn giữ trường visibility và Place dùng chung để mở công khai sau mà không phải migrate lớn (R-24).
  - Mở công khai về sau cần: người kiểm duyệt (A hoặc B), bản app mới qua App Review, qua lại cổng G9, và duyệt lại DEC-11/DEC-18.
  - Phương án C chỉ giải quyết nhu cầu **kiểm duyệt**, không giải quyết nhu cầu **hỗ trợ**. ROADMAP G1 yêu cầu có người chịu trách nhiệm hỗ trợ ngay ở G1, nên DEC-23 là điều kiện chặn G1. Nếu PO muốn dời việc chỉ định người, phải duyệt một ngoại lệ ghi rõ lý do và hạn chót; ngoại lệ đó cũng phải được ghi vào nhật ký §3.

### DEC-16 – Quy tắc xung đột đồng bộ

- **Phương án:** A. Quy tắc theo loại trường như BR-A6 (set idempotent, LWW cho trường đơn, xóa thắng, riêng tư thắng). B. LWW toàn bộ bản ghi – đơn giản nhưng có thể mất thao tác và công khai nhầm. C. Hiển thị xung đột cho người dùng chọn – chính xác nhưng tăng thao tác, trái "Minimal interaction".
- **Khuyến nghị:** A.

### DEC-17 – Dùng app khi chưa đăng nhập

- **Bối cảnh:** ROADMAP G4 "sau bước xác thực/quyền ban đầu, mở app vào camera". Nguồn không yêu cầu dùng ẩn danh.
- **Phương án:** A. Đăng nhập trước lần chụp đầu tiên – loại bỏ toàn bộ rủi ro chuyển nháp nhầm tài khoản; thêm ma sát lần đầu. B. Cho chụp/lưu nháp khách, hỏi chuyển khi đăng nhập (BR-A2b) – ít ma sát; thêm vùng dữ liệu khách, ca kiểm thử, rủi ro mất nháp khi xóa app.
- **Khuyến nghị:** A cho 1.0; đánh giá B ở G2 nếu thử sử dụng cho thấy đăng nhập là rào cản lớn.

### DEC-18 – Phạm vi cộng đồng công khai lúc ra mắt

- **Phương án:** A. Công khai toàn thị trường DEC-01 khi DEC-15 đạt. B. Công khai giới hạn theo thành phố/nhóm mời trong beta, mở rộng sau. C. Chỉ riêng tư (xem DEC-15 C).
- **Khuyến nghị:** B trong TestFlight, A khi ra mắt nếu SLA Q-15 đạt trong beta.

### DEC-19 – Pháp nhân và tài khoản dịch vụ

- **Hiện trạng:** bundle ID `com.ckiet1612.doday` trong `project.yml`; không có thông tin team ký ứng dụng trong project. Chưa biết ứng dụng phát hành dưới cá nhân hay tổ chức.
- **Cần PO quyết định:** chủ tài khoản Apple Developer (cá nhân/tổ chức – ảnh hưởng tên người bán, DSA nếu phát hành EU), chủ tài khoản Google Cloud và thanh toán, chủ thể trong Privacy Policy. Bộ G1 **không** tạo tài khoản nào.

### DEC-20 – Duyệt ngưỡng chất lượng

- Ngưỡng ở `quality-and-acceptance.md` §2 giữ nguyên mức roadmap, chưa hạ. Q-06 (coverage ≥30%) cần xác nhận khả thi ở G2 trước khi chốt; nếu điều chỉnh phải ghi lý do và ngày, **trước** khi đo nghiệm thu G5, không sau.
- **Khuyến nghị:** duyệt Q-01…Q-17 (Q-08b chỉ báo cáo, không có ngưỡng); riêng Q-06 ở trạng thái "tạm chốt, xác nhận lại sau G2".

### DEC-21 – Nguồn dữ liệu trích xuất từ link

- **Phương án:** A. Chỉ dữ liệu Share Sheet đưa vào (URL, text) + người dùng chọn – an toàn pháp lý nhất; tỷ lệ tự xác định thấp. B. A + đọc metadata công khai của trang (ví dụ thẻ tiêu đề) nếu điều khoản nguồn cho phép – tăng tỷ lệ; cần LEGAL xác nhận từng nguồn. C. API chính thức của nền tảng nguồn – cần thỏa thuận, chưa xác minh khả dụng.
- **APPROVED BATCH-AB A13/B6:** chọn A cho 1.0 ban đầu; B chỉ khi LEGAL xác minh quyền theo từng nguồn. Không scraping trái điều khoản hoặc hứa đọc mọi link; URL vẫn lưu PENDING. Giới hạn fetch 3 redirect/5 s/1 MB và SSRF đã duyệt.

### DEC-22 – Công cụ crash/analytics

- **Phương án:** A. Chỉ công cụ của Apple (Xcode Organizer, MetricKit, TestFlight feedback) + log/metric backend tự quản – ít khai báo quyền riêng tư; số liệu crash-free có thể trễ và chỉ từ người đồng ý chia sẻ. B. SDK crash reporting bên thứ ba – số liệu nhanh, chi tiết; thêm SDK vào App Privacy và privacy manifest.
- **APPROVED kế hoạch BATCH-AB B4:** quyết định trước G3 dựa trên việc A có đo được Q-11 (mẫu số phiên) hay không; nếu không, xem B. Chưa chọn công cụ/SDK; A9 duyệt không tracking quảng cáo và không dữ liệu nhạy cảm trong log.

### DEC-23 – Người chịu trách nhiệm hỗ trợ cho 1.0

- **Bối cảnh:** ROADMAP G1 yêu cầu có người chịu trách nhiệm hỗ trợ và kiểm duyệt. DEC-15 C đã loại nhu cầu kiểm duyệt khỏi 1.0, nhưng vẫn cần hỗ trợ: Support URL khi nộp (ROADMAP G12A), yêu cầu xóa/truy cập dữ liệu, yêu cầu của cha mẹ/người giám hộ cho tài khoản 13–15 tuổi (DEC-02), thông báo vi phạm dữ liệu (DEC-01).
- **Phương án:** A. PO kiêm người hỗ trợ chính + 1 người dự phòng – không phát sinh chi phí; phải công bố giờ phản hồi. B. Một người hỗ trợ riêng (bán thời gian) – chi phí nhân sự. C. Duyệt ngoại lệ: chỉ định trước G11, G1 vẫn APPROVED – trái điều kiện roadmap hiện hành, cần PO + TL ký ngoại lệ có hạn chót.
- **Khuyến nghị:** A. Cần tên người (hoặc vai trò được giao cụ thể), kênh liên hệ và người dự phòng.
- **APPROVED BATCH-AB A14/B8:** phản hồi hỗ trợ ≤2 ngày làm việc, alert đến người trực ≤15 phút; kênh thật và phương án vắng mặt trước beta/phát hành theo SAFE-07/09, R-28. Duyệt kế hoạch không tạo ra địa chỉ hỗ trợ hoặc người dự phòng.
- **Quyết định (30/10/2026):** Chủ dự án tự đảm nhận toàn bộ việc hỗ trợ. Đây là phương án A nhưng **chưa có người dự phòng**.
  - Điều kiện G1 "có người chịu trách nhiệm hỗ trợ" được đáp ứng.
  - Email/Support URL chưa có. B8 chốt tạo kênh thật/kiểm nhận thư **trước beta ngoài G11**, công bố/kiểm lại Support URL và chính sách trước G12A (SAFE-07 1.0-S1, SAFE-08).
  - Không có dự phòng nên khi chủ dự án vắng mặt sẽ không có ai phản hồi. Ảnh hưởng nặng nhất là thông báo vi phạm dữ liệu trong 72 giờ và yêu cầu của cha mẹ/người giám hộ. Xem R-28. Khuyến nghị bổ sung dự phòng trước beta bên ngoài (G11); việc này không chặn G1.

### DEC-24 – Cơ chế đồng ý của người đại diện cho người dùng 13–15 tuổi

- **Bối cảnh:** hệ quả của DEC-02 = 13+ (xem DEC-02). Yêu cầu pháp lý chi tiết chưa đối chiếu văn bản gốc.
- **Phương án:**
  - A. Người dùng tự xác nhận "đã có sự đồng ý của cha mẹ" bằng một ô chọn – rẻ nhất; bằng chứng yếu, khả năng không đáp ứng luật cao.
  - B. Người dùng nhập email người đại diện; người đại diện mở liên kết, đọc tóm tắt dữ liệu thu thập và xác nhận; hệ thống lưu bằng chứng (thời điểm, phiên bản chính sách, email đã băm). Trước khi xác nhận, dữ liệu chỉ ở trên máy (SAFE-11 E2). Chi phí: email hai ngôn ngữ, trang xác nhận, quy trình rút lại đồng ý, kiểm thử.
  - C. Dựa vào tín hiệu tuổi và kiểm soát gia đình của Apple (Declared Age Range API, Family Sharing). Trang age rating của Apple có nhắc API này (truy cập 30/10/2026), nhưng việc nó có đủ làm bằng chứng đồng ý theo luật Việt Nam **chưa xác minh**; phụ thuộc phiên bản iOS và cấu hình của gia đình.
- **APPROVED hướng B có điều kiện (BATCH-AB B5):** cần LEGAL đối chiếu luật, trường tuổi, bằng chứng/retention đồng ý và rút đồng ý trước G3. Chưa xác minh tính đủ của email hoặc băm email; không thu dữ liệu trước khi chốt. Có thể bổ sung C sau xác minh. Nếu cần đổi tuổi 13+ thì phải có quyết định mới, không tự nâng lên 16.

### Các quyết định ADD và xác nhận thay thế (DEC-25…32)

**Nguồn OVERRIDE, 31/10/2026:** Chủ dự án: “Xác nhận vẫn riêng tư. Cho phép ghi đè các điểm đó trừ điểm đầu tiên”. Đối tượng là năm điểm xung đột đã trình: giữ private-only; cho thay điều kiện Place/mặc định chia sẻ, trigger/coverage, fallback Map và giới hạn Photos/review/nhật ký. Phạm vi từng đợt duyệt giữ ở §3; **BATCH-AB** sau đó chốt chính sách A và kế hoạch B theo `approval-batch.md`. Không chờ thiết kế để cho phép rò dữ liệu.

**DEC-25 – Ảnh không Place.** A giữ bắt buộc: ít đổi nhưng trái ADD. B bỏ bắt buộc: thêm ca ảnh không nơi. C chỉ bỏ ở bản bạn bè: chưa đáp ứng ảnh public/hidden. **APPROVED qua OVERRIDE: B về quy tắc**, sửa BR-M4 và ca PUB; 1.0 mọi ảnh vẫn riêng tư. Bản chia sẻ sau cho phép `display_place_id = null`; không chèn ảnh hidden/không nơi vào trang địa điểm, marker hay số đếm địa điểm. Roadmap/SRC không sửa; đây là thay thế có nguồn, không xóa dấu vết quy tắc cũ.

**DEC-26 – Phạm vi 1.0.** A private-only + Hide/zone: giữ phạm vi vận hành. B thêm bạn bè: thêm social graph/ACL/abuse. C cộng đồng: thêm moderator và G9. **APPROVED A, xác nhận trực tiếp trong OVERRIDE**; không thay DEC-15/18. Lưu riêng tư/đồng bộ Doday vẫn chạy khi Google lỗi; “chia sẻ/cộng đồng” trong ADD không mở B/C. Chia sẻ liên kết địa điểm qua hệ thống (MVP-25) không phải quyền xem ảnh của người khác.

**DEC-27 – Nhận diện không theo từng ảnh.** A Nearby khi chủ động yêu cầu gần đây/nhận diện: dễ kiểm soát, ít tự động hơn. B lookup theo ngữ cảnh: thêm thiết kế trigger/consent/TTL. C chỉ dữ liệu Doday: coverage có thể thấp. **APPROVED OVERRIDE + BATCH-AB B1/B2:** dùng A cho lookup Google; tái dùng ngữ cảnh hợp lệ sau gate, không một request/ảnh. Không mở app/camera/chụp/GPS tick/pan Map để gọi Places. Ngưỡng thử ban đầu accuracy ≤50 m, tuổi mẫu ≤60 s, tối đa 5 ứng viên đã duyệt cho kế hoạch G2, chưa chứng minh hiệu quả. T_auto/T_confirm/TTL ngữ cảnh còn phải hiệu chỉnh và chốt trước dùng. Q-05 ≥95%, Q-06 ≥30% không hạ; mẫu số quality §2 gồm không lookup/không response/lỗi/quota, không chỉ nhóm đã tìm. Báo nhóm toàn bộ/đầu vào/gate; không sửa mẫu sau kết quả.

**DEC-28 – Photos/reviews.** A không thêm: ít công, không áp dụng đầy đủ ADD. B chỉ Photos: giữ hoãn review. C cả hai on-demand: thêm SKU ảnh, Details Atmosphere và ca attribution/cache. **APPROVED phạm vi C qua OVERRIDE** thay giới hạn không Photos/hoãn review cũ; không có nghĩa được gọi API thụ động. GGL-04 và GGL-10 là M-1.0; rating/tổng lượt độc lập. Thiết kế UI/giới hạn lượt ảnh còn PROPOSED. Tất cả dùng chung trần DEC-09, tính lại dự báo/quota trước G6; không tự nâng trần. Routes không cần khi chỉ mở Maps URL; không thêm Geocoding dư thừa.

**DEC-29 – Saved Map không tự gọi Places.** A giữ ID, nhãn/pin Doday thực sự do người dùng tạo và dữ liệu còn quyền dùng; thiếu tọa độ xem danh sách, refresh Google chủ động. B buộc tự tạo nhãn/pin: thêm thao tác, không được đổi nhãn dữ liệu sao chép Google. C provider độc lập: thêm hợp đồng/chi phí. **APPROVED fallback A qua OVERRIDE**, đáp ứng ADD không gọi theo Map. Không tự gọi Essentials theo viewport; Google payload hết quyền dùng phải purge, SavedPlace/ID không mất. Thiếu tên dùng nhãn trung tính/nhãn người dùng, thiếu tọa độ không vẽ marker giả. Q-07 đo dữ liệu hợp lệ; LEGAL vẫn phải chốt bảng TTL/hợp đồng ở G2, không coi duyệt UX là cấp license dữ liệu.

**DEC-30 – Nhật ký cá nhân.** A đọc Moment/thời điểm đã lưu: không dữ liệu đường đi mới. B timeline/ghi chú riêng: thêm UI/schema. C tracking nền: ngoài phạm vi. **APPROVED OVERRIDE + BATCH-AB A12:** nhật ký 1.0 theo A trong “Khoảnh khắc của tôi” ở Profile, theo thời gian, không tab chính mới; B3 hoàn thiện UI ở G2. DATA-07 quy định offline/Hide/xóa/đồng bộ; không dựng tuyến đường hoặc suy Visited từ GPS.

**DEC-31 – Chính sách kỹ thuật privacy.** A zone chỉ máy: ít dữ liệu server nhưng có thể mất khi mất máy. B sync mã hóa đầu cuối: thêm quản lý khóa. C zone backend: giữ tọa độ nhà trên server. **APPROVED ZONE + BATCH-AB A1–4 và lời bổ sung:** chọn A, radius 200 m chỉnh 100–1.000 m; GPS đầu vào RAM ≤60 s, không DB/queue/backup/bản làm tròn để giữ lâu. Công tắc **Ẩn trong vùng riêng tư** trong Cài đặt mặc định bật, cho thêm/sửa/xóa vùng và chủ động tắt; lưu trạng thái local theo tài khoản, tắt không xóa vùng. Khi bật, vùng sai số giao zone hoặc dữ liệu không chắc chắn → hidden/no outbound; Place thủ công không âm thầm bypass. Tắt trong Cài đặt chỉ bỏ gate zone cho tác vụ mới, không tắt Hide, cấp consent, mở public, hiện ảnh cũ hoặc replay job. **Hide Location vẫn độc lập, mặc định bật**. Consent nhận diện riêng/rút được; revision kiểm trước gửi/retry/nhận, hidden thắng; strip GPS mọi ảnh/thumbnail upload, giữ gốc cục bộ và liên kết Place riêng. B1 duyệt ngưỡng thử đầu vào, không phải kết quả đạt. TTL RAM khác tuổi mẫu, TTL zone/cache Google/ảnh gốc. Chi tiết phụ lục §3/5 và approval-batch §4; tất cả chưa kiểm thử.

**DEC-32 – Mặc định chia sẻ và audience.** A public chủ động từng lần: trái UX mới. B mặc định hai trục độc lập/an toàn: đáp ứng ADD, thêm ma trận quyền. C vị trí không rộng hơn ảnh: đơn giản nhưng không đủ ví dụ ADD. **APPROVED nguyên tắc B qua OVERRIDE**, thay DEC-11/BR-M4/M5; không cần chọn lại sau từng ảnh. Mọi audience public/friends chỉ cho bản chia sẻ được duyệt riêng; binary/API 1.0 chỉ ảnh owner, vị trí owner/hidden. Vị trí public không được trả quan hệ/ID/số đếm của ảnh hạn chế. Raw GPS không trở thành tài nguyên public; Hide-off/quyền iOS không tự cấp quyền công khai. Thiết kế ACL bản PUB phải qua G9/SEC trước phát hành, không chặn G1 chỉ vì chưa có friends.

## 3. Nhật ký thay đổi quyết định

| Ngày | ID | Thay đổi | Người xác nhận |
| --- | --- | --- | --- |
| 30/10/2026 | Tất cả | Tạo bản nháp, trạng thái PROPOSED/NEEDS_CONFIRMATION | Chưa có – chờ chủ sản phẩm/trưởng kỹ thuật |
| 30/10/2026 | DEC-04 | PROPOSED → APPROVED: iOS tối thiểu 17.0; áp dụng vào `project.yml` | Chủ dự án, qua chỉ đạo trực tiếp trong phiên làm việc (chưa ghi tên/vai trò chính thức) |
| 30/10/2026 | DEC-15, DEC-18 | NEEDS_CONFIRMATION/PROPOSED → APPROVED: 1.0 chỉ riêng tư; DEC-11 thành đã giải quyết cho 1.0; thêm DEC-23 | Chủ dự án, qua câu trả lời "Chấp nhận riêng tư" trong phiên làm việc |
| 30/10/2026 | DEC-01, DEC-02 | NEEDS_CONFIRMATION → APPROVED: Việt Nam, tiếng Việt trọng tâm + tiếng Anh; tối thiểu 13 tuổi. Thêm DEC-24, DODAY-L10N-01, SAFE-11 cập nhật | Chủ dự án, trong phiên làm việc |
| 30/10/2026 | DEC-23 | Mức chặn B-G12 → B-G1 theo phát hiện review G1 (roadmap yêu cầu người hỗ trợ tại G1) | Người lập tài liệu; chờ PO xác nhận người cụ thể |
| 30/10/2026 | DEC-23 | NEEDS_CONFIRMATION → APPROVED: chủ dự án tự làm hỗ trợ; chưa có dự phòng; email tạo trước khi nộp App Store | Chủ dự án, trong phiên làm việc |
| 31/10/2026 | DEC-03, 05, 06 (kiểu), 08, 12, 13, 14, 16, 17, 20 | APPROVED theo đúng phần B (05/17/06), C (03/08/12/13/14/16/20). Q-06 tạm chốt, xác nhận sau G2 | Chủ dự án, tin 00:04 giờ Việt Nam |
| 31/10/2026 | DEC-10 | APPROVED: mục tiêu 5.000 người dùng; cách hiểu MAU và hệ số tải là ASSUMPTION | Chủ dự án, cùng tin |
| 31/10/2026 | DEC-07, DEC-09 | Giao tự tính ngân sách; không có phê duyệt trước phương án ảnh hay trần tiền. Sửa diễn giải “phương án được duyệt” trong bản dở. Dự toán mới ở `budget-and-capacity.md`, vẫn PROPOSED | Người lập sửa theo phạm vi tin xác nhận; chờ PO/TL duyệt chi tiêu |
| 31/10/2026 | Vai trò | Chủ dự án kiêm PO, TL, iOS, BE, DES, QA, SEC, OPS, LEGAL; nhận vai trò không phải đã duyệt toàn bộ cổng | Chủ dự án, cùng tin |
| 30/10/2026 | – | Theo chỉ đạo của chủ dự án: xóa `Doday 2.xcodeproj` khỏi máy; `ContentView` chuyển sang `NavigationStack` (iOS 17) | Chủ dự án, cùng phiên |
| 30/10/2026 | – | Ghi nhận: workspace đã kết nối Git (`origin` GitHub, nhánh `main`); `Doday 2.xcodeproj` là bản lỗi do gõ nhầm bundle ID, không dùng | Chủ dự án, cùng phiên |
| 31/10/2026 | Dự toán / ngày duyệt | Kiểm giá chính thức, sửa Nearby thấp và SKU kết thúc Autocomplete, bổ sung Pro cho Map/backup ảnh. Google cơ sở ~4.930 USD, trần đề xuất 6.000; ảnh cơ sở cuối năm ~16–42 USD, trần 50. Sửa ngày B/C/D từ UTC sang giờ Việt Nam | Người lập tài liệu; không phải xác nhận ngân sách của PO |
| 31/10/2026 | DEC-07, DEC-09 | APPROVED về tiền: chủ dự án xác nhận “Duyệt trần và ngân sách”, nhắc lại “Duyệt ngân sách”; áp dụng trần Google §2.3 tối đa 6.000 USD/tháng ở 5.000 MAU và ảnh 50 USD/tháng năm đầu ở kịch bản cơ sở. Giải đáp miễn phí đã trừ theo SKU; không giảm lần nữa | Chủ dự án (kiêm PO/TL), xác nhận trực tiếp trong phiên G1 |
| 31/10/2026 | DEC-07 / BR-M10 | APPROVED đầu ra ảnh chụp/chọn upload 1:1 theo tin “Ảnh được chụp hay upload lên sẽ có tỉ lệ 1:1”. Chuẩn hóa yêu cầu, thêm ca nghiệm thu; 2048/400 px, cách cắt, gốc chỉ ở máy và thiết kế chặn vẫn PROPOSED; không phải duyệt toàn G1 | Chủ dự án (kiêm PO/TL), cùng tin |
| 31/10/2026 | DEC-07 / CROP | APPROVED bản chính ≤2048 × 2048, thumbnail ≤400 × 400, cắt giữa tự động, không phóng lớn, gốc chỉ tại máy; ngoại lệ rõ là **không cần preview crop**. Thay trạng thái PROPOSED của chính sách ảnh, không duyệt codec hoặc quota cụ thể | Chủ dự án (PO/TL), tin “Duyệt, nhưng không cần xem trước chỉ cần cắt giữa” |
| 31/10/2026 | ADD §1…9 / DEC-25…32 | Tiếp nhận yêu cầu mới privacy/API, thêm phụ lục và backlog; ghi rõ xung đột, không tự sửa private-only, điều kiện public, nhóm bạn bè, review, trigger/Q-06 hoặc phạm vi nhật ký. Các lựa chọn xung đột còn NEEDS_CONFIRMATION/PROPOSED | Nguồn: yêu cầu Chủ dự án; phương án/khuyến nghị do người lập, chưa được duyệt |
| 31/10/2026 | OVERRIDE / DEC-26 | APPROVED, tái xác nhận 1.0 vẫn private-only; giữ DEC-15/18 và SAFE-10, không thêm friends/community | Chủ dự án (PO/TL), tin “Xác nhận vẫn riêng tư” |
| 31/10/2026 | OVERRIDE / DEC-11/14/25/27/28/29/30/32 | Cho phép thay các điểm xung đột còn lại theo ADD: ảnh không Place, mặc định hai trục không hỏi từng ảnh (PUB); trigger không theo ảnh/Map; fallback dữ liệu hết hạn; Photos/từng review on-demand và nhật ký cá nhân trong 1.0. Quyết định hoãn review cũ bị thay thế. Không nâng trần tiền hoặc mở tracking | Chủ dự án (PO/TL), cùng tin “Cho phép ghi đè các điểm đó trừ điểm đầu tiên”; đối chiếu năm điểm đã trình |
| 31/10/2026 | Phạm vi xác nhận OVERRIDE | DEC-31, codec/quota/radius/TTL/retry, thiết kế reservation và phương pháp đo Q-06 còn ghi PROPOSED; không diễn giải quyền sửa xung đột thành duyệt mọi thông số hoặc toàn G1 | Người lập ghi ranh giới phê duyệt; chờ xác nhận riêng theo cổng |
| 31/10/2026 | ZONE / DEC-31 | PROPOSED → APPROVED đúng 4 điểm: zone chỉ tại máy; Hide bật mặc định; radius mặc định 200 m, chỉnh 100–1.000 m; mẫu GPS đầu vào chỉ RAM ≤60 s. Thay trạng thái chờ duyệt của các điểm này, không duyệt toàn DEC-31/G1 | Chủ dự án (kiêm PO/TL/SEC), trả lời “Duyệt” cho câu hỏi liệt kê đúng bốn điểm ngay trước đó |
| 31/10/2026 | Ranh giới ZONE | Giữ PROPOSED cho heuristic/ghi đè thủ công, consent, revision, strip-all GPS, codec/quota/retry/reservation và cách đo Q-06; không đổi private-only hoặc trần ngân sách | Người lập ghi phạm vi xác nhận, không ký duyệt phần chưa được hỏi |
| 31/10/2026 | COST / DEC-09 | PROPOSED → APPROVED đúng ba nguyên tắc: proxy backend; giữ chỗ ngân sách nguyên tử; ngừng gọi Google trả phí khi hết trần hoặc bộ đếm lỗi. Thay trạng thái chờ duyệt của các nguyên tắc này, không thay trần tiền | Chủ dự án (kiêm PO/TL), trả lời “Duyệt” cho câu hỏi “Bạn duyệt tiếp cơ chế proxy, giữ chỗ ngân sách nguyên tử và ngừng gọi Google trả phí khi hết trần hoặc bộ đếm lỗi chứ?” |
| 31/10/2026 | Ranh giới COST | Phân bổ/định giá theo SKU, quota/rate limit, múi giờ/reset và thông số retry/circuit breaker vẫn PROPOSED; không duyệt SAFE-12, phần DEC-31 còn lại hoặc toàn G1. Không có bằng chứng triển khai/kiểm thử qua tin duyệt này | Người lập ghi phạm vi xác nhận; không mở billing, sửa cấu hình hoặc chạy ứng dụng |
| 31/10/2026 | BATCH-AB A1–A14 | APPROVED các chính sách/thông số đã trình, gồm strip-all GPS, heuristic/consent/revision, BR-M11/quota/admission, OTP/URL/log/support, retry/breaker/reservation/reset và quy tắc Moment/Share Sheet. Thay trạng thái PROPOSED tương ứng, không hỏi lại | Chủ dự án (kiêm PO/TL), tin “Duyệt toàn bộ mục A và mục B”; truy vết từng mục ở approval-batch §2 |
| 31/10/2026 | BATCH-AB B1–B9 | APPROVED kế hoạch/chọn theo bằng chứng: mẫu thử và ngưỡng khởi điểm, codec/UI, provider/region/telemetry/backup, pháp lý/consent, quyền metadata/TTL, forecast/quota, hỗ trợ và PUB tương lai. Không xác nhận lựa chọn chưa có hoặc kiểm chứng đã đạt | Cùng tin; ranh giới/cổng/phụ trách ở approval-batch §3 |
| 31/10/2026 | BATCH-AB / DEC-31 | APPROVED bổ sung công tắc vùng riêng tư mặc định bật, cấu hình vùng và cho tắt tại Cài đặt. Thay cách hiểu không thể tắt zone ở 1.0; không cho Place thủ công tự bypass khi bật. Hide vẫn độc lập/mặc định bật, tắt zone không cấp consent/public hoặc hiện ảnh/replay job cũ | Chủ dự án, cùng tin bổ sung về mặc định ẩn vùng riêng tư; approval-batch §4 |
| 31/10/2026 | Ranh giới BATCH-AB | Mục C (ký duyệt toàn G1) chưa được xác nhận; giữ READY_FOR_REVIEW. Chưa chọn provider/pháp nhân/codec cuối, chưa xác minh pháp lý, triển khai, đo hoặc kiểm thử | Người lập ghi đúng phạm vi A/B, không tự ký thay PO/TL |
| 31/10/2026 | G1-SIGNOFF / mục C | READY_FOR_REVIEW → APPROVED toàn bộ G1: đặc tả, backlog/ca, quyết định, dữ liệu/quyền riêng tư, ngân sách, rủi ro và kế hoạch/ngưỡng nghiệm thu. Giữ các lựa chọn/bằng chứng B theo cổng, không coi chưa đo/chưa kiểm thử là đạt; không tự bắt đầu G2 | Chủ dự án (kiêm PO/TL), trả lời “Duyệt” cho câu hỏi xác nhận toàn bộ đặc tả G1 với tư cách PO/TL để chuyển APPROVED; biên bản approval-batch §6, README §8 |
| 31/10/2026 | G1-ACCEPTANCE / chấp nhận chính thức sau review | Chủ dự án chính thức chấp nhận hoàn toàn G1 sau hai sửa review offline và BR-P8/BR-P9; giữ APPROVED, 69 yêu cầu/277 ca và cổng B. Cho phép chia commit/push tài liệu G1 lên main, không thêm Co-Author; không bao gồm thay đổi mã nguồn/cấu hình hoặc triển khai G2 | Tin xác nhận trực tiếp “Tôi chính thức chấp nhận hoàn toàn G1”; biên bản approval-batch §7 |

**Dấu vết phê duyệt B/C/D:** đối chiếu câu hỏi gốc phần A–D (tin trợ lý `3992639a-fb1a-4663-8331-3acb9da6e094`) và câu trả lời chủ dự án (tin `9aee622b-f503-4102-9c91-28a80348f6a1`) trong cùng phiên G1. A yêu cầu ngân sách và phương án ảnh; B có 3 lựa chọn, C có 7 đề xuất, D là kiêm nhiệm vai trò. Chỉ ghi trạng thái đúng phạm vi trả lời, không thêm tên/chữ ký bịa.
