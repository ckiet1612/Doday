# Doday 1.0 – Ma trận yêu cầu và backlog (G1)

Trạng thái: APPROVED (backlog/ca nghiệm thu G1) · Ngày lập: 30/10/2026 · Ngày duyệt: 31/10/2026. **G1-SIGNOFF:** Chủ dự án kiêm PO/TL duyệt toàn G1 sau A1–A14/kế hoạch B1–B9, nguồn `approval-batch.md` §6. Công tắc zone mặc định bật/có thể tắt tại Cài đặt, 1.0 vẫn riêng tư; chưa chọn provider/codec cuối hoặc kiểm thử, các việc đó giữ cổng B.

## 1. Quy ước

**Nhóm ID**

- `DODAY-MVP-01…30`: ánh xạ một-một với danh sách 30 hạng mục tại SRC §15, đúng số thứ tự nguồn. Không đánh số lại, không thay thế.
- `DODAY-EXT-*`: Share Extension và dán liên kết (SRC §5.3, §7, §13.4), đã đưa vào 1.0 theo DEC-13 duyệt 31/10/2026.
- `DODAY-DATA-*`: dữ liệu bền vững, tài khoản, đồng bộ (ROADMAP G1, G3, G4, G7).
- `DODAY-SAFE-*`: an toàn phát hành, quyền riêng tư, kiểm duyệt, vận hành (SRC §17.8–17.9, ROADMAP §1, Apple A1/A2).
- `DODAY-GGL-*`: tuân thủ và chi phí Google Maps Platform (SRC §6.8, §13.6, §17.6–17.7).
- `DODAY-L10N-*`: ngôn ngữ và bản địa hóa (DEC-01).
- `DODAY-PRIV-*`, DATA-05/06 và GGL-08/09: nguồn **ADD §1…9** trong `privacy-api-addendum.md`, yêu cầu bổ sung 31/10/2026; không thuộc 30 mục SRC. P0/P1/P2 kèm các dòng này là ưu tiên sản phẩm, không phải mức nghiêm trọng lỗi.

**Ưu tiên** (không nhầm với mức lỗi P0/P1/P2 của roadmap)

- `M-CORE`: bắt buộc 1.0, cần cho alpha cá nhân (G4–G7).
- `M-1.0`: bắt buộc 1.0, cần trước Release Candidate (G8–G11).
- `OPT`: tùy chọn 1.0, có thể hoãn 1.1 theo quyết định.
- `PUB`: **không có trong binary 1.0**, chuyển sang bản phát hành mở công khai. Lý do: chủ dự án duyệt DEC-15 phương án C ngày 30/10/2026 (ra mắt chỉ riêng tư). Muốn mở công khai phải có người kiểm duyệt (DEC-15 A/B), một bản app mới qua App Review và qua lại cổng G9. Mục PUB giữ nguyên ID và ca nghiệm thu để dùng khi đó; ở 1.0 chúng được ghi "không áp dụng", không tính là "đạt".

**Ghi chú phạm vi 1.0:** phần công khai của MVP-03/09/10/11/13/15/25/26/27 là PUB theo DEC-15 C. Không được gọi chức năng xem cộng đồng MVP-26 là đã giao ở 1.0 chỉ vì có khối xem ảnh của mình. Đây là thay đổi phạm vi đã duyệt, không phải cắt âm thầm; giữ đủ ID và ca PUB, ghi không áp dụng thay vì đạt.

**Vai trò** (xác nhận **31/10/2026, giờ Việt Nam: chủ dự án kiêm toàn bộ**; cột "Phụ trách" giữ chuyên môn – xem R-22): PO chủ sản phẩm · TL trưởng kỹ thuật · iOS · BE backend · DES thiết kế · QA kiểm thử · SEC an toàn/bảo mật · OPS vận hành/hỗ trợ · LEGAL pháp lý/chính sách. Kiêm OPS không tự mở công khai hoặc có moderator/dự phòng; DEC-15 C còn hiệu lực. Vai trò chính trước, phối hợp sau dấu "+".

**Ca nghiệm thu**: Given/When/Then, mỗi yêu cầu có nhánh S và E. Ngưỡng Q-xx theo DEC-20 duyệt 31/10 (Q-06 tạm chốt, Q-15 chỉ PUB); thông số ghi PROPOSED chưa được duyệt chỉ vì có trong ca. PO duyệt hành vi, TL/QA chốt phép đo trước cổng xây/đo trong ma trận, LEGAL chốt dữ liệu/điều khoản. Mọi ca hiện **chưa kiểm thử**.

**OVERRIDE ngày 31/10/2026:** thay ca PUB bắt buộc Place/public từng lần bằng ảnh không nơi/mặc định hai trục; lookup theo nhu cầu và fallback Map. GGL-04/10 và DATA-07 thuộc 1.0. Giữ private-only, ca PUB không áp dụng. **BATCH-AB** sau đó chốt DEC-31 và các tham số A; B1/B2 duyệt phương pháp thử/ngưỡng khởi điểm Q-06, còn phải hiệu chỉnh/chốt theo bằng chứng trước đo G2, không hạ ngưỡng sau kết quả.

**Gate zone:** các ca “zone/uncertain chặn” áp dụng khi công tắc bảo vệ bật; công tắc mặc định bật/có thể tắt chủ động ở Cài đặt. Zone-off không bỏ Hide/consent/độ tin cậy/trigger; không tự hiện Place/replay ảnh cũ. PRIV-02 thử cả hai trạng thái, cấu hình mới và đổi tài khoản.

## 2. Ma trận truy vết

| ID | Yêu cầu | Nguồn | Ưu tiên | Giai đoạn (xây → nghiệm thu cuối) | Phụ thuộc | Phụ trách |
| --- | --- | --- | --- | --- | --- | --- |
| DODAY-MVP-01 | Đăng ký và đăng nhập | SRC §15.1, §10 | M-CORE | G3 → G10–G11 | DEC-05, DEC-06, DEC-17 | BE + iOS, QA |
| DODAY-MVP-02 | Hồ sơ cơ bản | SRC §15.2, §10 | M-CORE | G3 → G10–G11 | MVP-01 | iOS + BE |
| DODAY-MVP-03 | Thiết lập quyền riêng tư | SRC §15.3, §4.5, §10 | 1.0 (màn quyền riêng tư cá nhân): M-CORE · Mặc định công khai/riêng tư, danh sách chặn: PUB | G3 → G10–G11; phần PUB: G9 ở bản công khai | MVP-01, SAFE-01; phần PUB: DEC-11 | iOS + BE, SEC |
| DODAY-MVP-04 | Camera-first | SRC §15.4, §4.1 | M-CORE | G4 → G10–G11 | MVP-01, DEC-04 | iOS + DES |
| DODAY-MVP-05 | Chụp ảnh và chọn ảnh thư viện | SRC §15.5, §4.1, §4.4; DEC-07 (1:1, chủ dự án 31/10/2026) | M-CORE | G4 → G10–G11 | MVP-04, DATA-01, DEC-07 | iOS |
| DODAY-MVP-06 | Tự lấy vị trí và nhận diện địa điểm | SRC §15.6, §4.4, §17.1; ADD §1/2, OVERRIDE | M-CORE | G2 thử, G5 → G10–G11 thực địa | MVP-05/18, GGL-01/08, PRIV-01/02, DEC-27 | iOS + BE, QA |
| DODAY-MVP-07 | Xác nhận hoặc sửa địa điểm | SRC §15.7, §4.2 | M-CORE | G5 → G10–G11 | MVP-06, MVP-14 | iOS + DES |
| DODAY-MVP-08 | Tiêu đề ngắn tùy chọn | SRC §15.8, §4.3 | M-CORE | G4 → G10–G11 | MVP-05 | iOS |
| DODAY-MVP-09 | Lưu ảnh và chia sẻ khoảnh khắc | SRC §15.9, §4.2 | Lưu riêng tư: M-CORE · Chia sẻ công khai: PUB | G4 → G10–G11; công khai: G9 ở bản công khai | DATA-01, SAFE-02, SAFE-12, DEC-06, DEC-07 | iOS + BE |
| DODAY-MVP-10 | Chế độ công khai và riêng tư | SRC §15.10, §4.5 | Riêng tư: M-CORE · Công khai: PUB | G4 (riêng tư) → G10–G11; công khai: G9 ở bản công khai | MVP-03, SAFE-02, SAFE-10; phần công khai: SAFE-06, DEC-11, DEC-15 | BE + iOS, SEC |
| DODAY-MVP-11 | Map kết hợp Save và Discover | SRC §15.11, §5.1, §5.3 | Save + Discover qua tìm kiếm: M-CORE · Lớp cộng đồng: PUB | G6 → G10–G11; lớp cộng đồng: G9 ở bản công khai | DEC-08, MVP-14 | iOS + DES |
| DODAY-MVP-12 | Tag ghim địa điểm | SRC §15.12, §5.2, §5.4 | M-CORE | G6 → G10–G11 | MVP-11 | iOS + DES |
| DODAY-MVP-13 | Phân biệt địa điểm cá nhân và khám phá | SRC §15.13, §5.2 | Cá nhân + kết quả tìm kiếm: M-CORE · Lớp cộng đồng: PUB | G6 → G10–G11; lớp cộng đồng: G9 ở bản công khai | MVP-12, MVP-30 | iOS + DES |
| DODAY-MVP-14 | Tìm kiếm địa điểm | SRC §15.14, §5.5 | M-CORE | G6 → G10–G11 | GGL-01, DEC-09 | iOS + BE |
| DODAY-MVP-15 | Lọc địa điểm | SRC §15.15, §5.5 | Cá nhân/trạng thái: M-CORE · Cộng đồng: PUB | G6 → G10–G11; cộng đồng: G9 ở bản công khai | MVP-20, MVP-30, GGL-03 | iOS + BE |
| DODAY-MVP-16 | Gom nhóm marker | SRC §15.16, §5.2, §17.5 | M-CORE | G6 → G10 | MVP-12 | iOS |
| DODAY-MVP-17 | Lưu vào bản đồ cá nhân | SRC §15.17, §5.3 | M-CORE | G7 → G10–G11 | MVP-18, DATA-03 | iOS + BE |
| DODAY-MVP-18 | Liên kết Google Place ID | SRC §15.18, §6.2 | M-CORE | G3, G5 → G10 | DEC-06 | BE |
| DODAY-MVP-19 | Tên và địa chỉ địa điểm | SRC §15.19, §6.3 | M-CORE | G6 → G10–G11 | MVP-18, GGL-01, GGL-02 | iOS + BE |
| DODAY-MVP-20 | Trạng thái hoạt động | SRC §15.20, §6.4 | M-CORE | G6 → G10–G11 | MVP-19 | iOS + BE, QA |
| DODAY-MVP-21 | Giờ mở cửa khi có dữ liệu | SRC §15.21, §6.5 | M-CORE | G6 → G10–G11 | MVP-19 | iOS + BE, QA |
| DODAY-MVP-22 | Điểm đánh giá và tổng lượt đánh giá | SRC §15.22, §6.6 | M-CORE | G6 → G10–G11 | MVP-19, GGL-02 | iOS + BE |
| DODAY-MVP-23 | Mở địa điểm trên Google Maps | SRC §15.23, §6.7 | M-CORE | G6 → G10–G11 | MVP-18 | iOS |
| DODAY-MVP-24 | Chỉ đường bằng Google Maps | SRC §15.24, §6.7 | M-CORE | G6 → G10–G11 | MVP-18 | iOS |
| DODAY-MVP-25 | Trang chi tiết địa điểm | SRC §15.25, §8.1 | Google + dữ liệu của mình: M-CORE · Cộng đồng: PUB | G6 → G10–G11; cộng đồng: G9 ở bản công khai | MVP-19…24, GGL-02 | iOS + DES |
| DODAY-MVP-26 | Xem ảnh và trải nghiệm công khai | SRC §15.26, §8.2 | PUB (1.0: chỉ khoảnh khắc của chính người dùng) | G6 (khối "của bạn") → G10; công khai: G9 ở bản công khai | MVP-10, SAFE-03…07 | iOS + BE |
| DODAY-MVP-27 | Chia sẻ khoảnh khắc tại địa điểm | SRC §15.27, §8.3 | Lưu riêng tư tại nơi: M-CORE · Chia sẻ công khai: PUB | G6 → G10–G11; công khai: G9 ở bản công khai | MVP-05, MVP-10, MVP-25 | iOS + BE |
| DODAY-MVP-28 | Quản lý danh sách đã lưu | SRC §15.28, §9.1 | M-CORE | G7 → G10–G11 | MVP-17 | iOS + BE |
| DODAY-MVP-29 | Tạo và quản lý bộ sưu tập | SRC §15.29, §9.2 | M-CORE | G7 → G10–G11 | MVP-17, DATA-03 | iOS + BE |
| DODAY-MVP-30 | Want to visit và Visited | SRC §15.30, §9.3 | M-CORE | G7 → G10–G11 | MVP-17 | iOS + BE |
| DODAY-EXT-01 | Share Extension nhận URL/text | SRC §7.1, §13.4; ROADMAP §1; DEC-13 | M-1.0 | G2 thử, G8 → G10–G11 máy thật | DATA-02, DEC-13 | iOS, QA |
| DODAY-EXT-02 | Lưu URL nguồn vào mục chờ xử lý | SRC §7.2, §6.9, §14 | M-1.0 | G8 → G10–G11 | EXT-01 | iOS + BE |
| DODAY-EXT-03 | Thử xác định địa điểm từ dữ liệu được phép | SRC §7.2, §17.3 | M-1.0 | G2, G8 → G11 | EXT-02, GGL-01, LEGAL | BE + iOS, LEGAL |
| DODAY-EXT-04 | Dán liên kết trong app | SRC §5.3 | M-1.0 | G8 → G10–G11 | EXT-02 | iOS |
| DODAY-EXT-05 | Chống trùng và gắn đúng chủ sở hữu | SRC §7.3; ROADMAP G8 | M-1.0 | G8 → G10 | EXT-02, DATA-02 | iOS + BE, SEC |
| DODAY-DATA-01 | Nháp bền vững và hàng đợi upload idempotent | ROADMAP G4, §4 | M-CORE | G3, G4 → G10 | DEC-06 | iOS + BE, QA |
| DODAY-DATA-02 | Phân vùng dữ liệu theo tài khoản; đăng xuất/đổi tài khoản | ROADMAP G1, G7 | M-CORE | G3 → G10 | MVP-01 | iOS, SEC |
| DODAY-DATA-03 | Đồng bộ nhiều thiết bị và quy tắc xung đột | ROADMAP G7 | M-CORE | G3, G7 → G10 | DEC-16 | BE + iOS, QA |
| DODAY-DATA-04 | Chính sách nháp khi chưa đăng nhập | ROADMAP G1 | M-CORE | G3, G4 → G10 | DEC-17 | PO + iOS |
| DODAY-SAFE-01 | Xóa tài khoản trong app | Apple A2; ROADMAP G3 | M-1.0 | G3 → G10–G12A | DEC-05, DEC-12 | BE + iOS, LEGAL |
| DODAY-SAFE-02 | Phân quyền đối tượng cho API và ảnh | SRC §17.8; ROADMAP G3 | M-CORE | G3 → G10 | DEC-06 | BE, SEC |
| DODAY-SAFE-03 | Báo cáo nội dung và người dùng | SRC §17.9; Apple 1.2 | PUB | G9 ở bản công khai | SAFE-07 | iOS + BE, OPS |
| DODAY-SAFE-04 | Chặn người dùng | Apple 1.2; ROADMAP G9 | PUB | G9 ở bản công khai | MVP-01 | BE + iOS |
| DODAY-SAFE-05 | Lọc nội dung, hạn mức đăng công khai, chống spam | SRC §17.9; Apple 1.2 | PUB (hạn mức upload riêng tư tách sang SAFE-12) | G9 ở bản công khai | DEC-06, DEC-15 | BE, SEC, OPS |
| DODAY-SAFE-06 | Loại metadata vị trí khỏi ảnh công khai | ROADMAP G9 | PUB | G9 ở bản công khai | DATA-01 | BE + iOS, SEC |
| DODAY-SAFE-07 | Công cụ kiểm duyệt, quy trình hỗ trợ, người trực | SRC §17.9; ROADMAP G1, G9 | Kiểm duyệt: PUB · Người nhận hỗ trợ: M-1.0 | Hỗ trợ: G11; kiểm duyệt: G9 ở bản công khai | DEC-15 | OPS + BE |
| DODAY-SAFE-08 | Privacy Policy, Terms, Support công khai | SRC §17.7; Apple A1 | M-1.0 | G1 bắt đầu → G12A | DEC-01, DEC-12 | LEGAL + PO |
| DODAY-SAFE-09 | Giám sát, cảnh báo, backup/khôi phục | ROADMAP G10, §4 | M-1.0 | G3, G10 → G10 | DEC-06, DEC-10 | BE + OPS |
| DODAY-SAFE-10 | Server chặn mọi nội dung công khai trong 1.0 (thay cho cờ tắt) | ROADMAP G1, G10; DEC-15 | M-1.0 | G3 → G10 | DEC-15 | BE, SEC |
| DODAY-SAFE-11 | Tuổi tối thiểu 13; đồng ý của người đại diện cho 13–15 tuổi | DEC-02; Luật BVDLCN 91/2025/QH15 (nguồn thứ cấp, chưa đối chiếu văn bản gốc) | M-CORE | G3 → G10–G12A | DEC-02, DEC-24, DEC-05 | BE + iOS, LEGAL |
| DODAY-SAFE-12 | Hạn mức upload và dung lượng cho nội dung riêng tư | Review G1 30/10/2026; ROADMAP G10 (quota/rate limit) | M-1.0 | G3, G4 → G10 | DEC-07, DATA-01 | BE + iOS |
| DODAY-L10N-01 | Giao diện tiếng Việt (mặc định) và tiếng Anh | DEC-01 | M-CORE | G2 thiết kế, G3 → G10 | DEC-01 | iOS + DES, PO |
| DODAY-GGL-01 | Field mask theo màn hình, quota, theo dõi chi phí | SRC §6.8, §13.6, §17.6 | M-CORE | G2, G6 → G10 | DEC-09 | BE + iOS |
| DODAY-GGL-02 | Ghi nguồn, attribution, tách nội dung Google/Doday | SRC §6.6, §6.9, §12, §17.7 | M-CORE | G6 → G12A | DEC-08 | iOS + DES, LEGAL |
| DODAY-GGL-03 | Chính sách lưu/cache theo từng trường Places | SRC §6.8, §14; GG1 | M-CORE | G3, G6 → G12A | LEGAL | BE, LEGAL |
| DODAY-GGL-04 | Nội dung từng review Google theo yêu cầu xem | SRC §6.6, §15 đoạn cuối; ADD §1, OVERRIDE | M-1.0 (DEC-14/28 thay hoãn 1.1) | G6 → G10–G11 | DEC-09/14/28, GGL-01/02/03/08 | iOS + BE, LEGAL/QA |
| DODAY-GGL-05 | Thông báo địa điểm đã di chuyển | SRC §6.4 | OPT | G6 → G10 | MVP-20 | iOS + BE |
| DODAY-GGL-06 | Đối soát Place ID không hợp lệ / nơi thủ công liên kết sau | SRC §6.2; ROADMAP G5 | M-1.0 | G5 → G10 | MVP-18 | BE |
| DODAY-GGL-07 | Bảo vệ API key | SRC §13.6; GG3 | M-CORE | G3 → G10 | DEC-06 | BE + iOS, SEC |
| DODAY-DATA-05 | Dữ liệu Doday và suy giảm riêng khối Google | ADD §2/7/8 | M-CORE · P1 | G3, G4, G6–G7 → G10 | DATA-01/03, MVP-18, DEC-26/29/30 | BE + iOS, QA |
| DODAY-DATA-06 | Privacy revision, hủy lookup/retry và đổi tài khoản | ADD §3/5; phụ lục §3.3 | M-CORE · P0 | G3–G5, G7 → G10 | PRIV-01/02, DATA-02/03, DEC-31 | iOS + BE, SEC |
| DODAY-PRIV-01 | Hide ảnh hiện tại và ảnh mới trong một thao tác | ADD §3/4/9; OVERRIDE | M-CORE · P0; audience chia sẻ chỉ PUB | G2 thiết kế, G3–G5 → G10 | MVP-03/05/09, DEC-25/26/31/32 | iOS + BE, DES/SEC |
| DODAY-PRIV-02 | Home Privacy Zone và GPS không chắc chắn | ADD §3/5/9 | M-CORE · P0 | G2 thử, G3–G5 → G10 | PRIV-01, DEC-31, DATA-02 | iOS, SEC/QA |
| DODAY-PRIV-03 | ACL ảnh/vị trí độc lập, không rò qua API/marker | ADD §3/5/9; OVERRIDE | M-CORE · P0; friends/public chỉ bản chia sẻ sau | G3, G6, G9 nếu PUB → G10 | SAFE-02/10, DEC-25/26/32 | BE + iOS, SEC |
| DODAY-PRIV-04 | Tối thiểu GPS, EXIF, telemetry và retention | ADD §5/8/9 | M-CORE · P0 | G3–G5 → G10 | DATA-01/06, DEC-12/31, SAFE-06 | iOS + BE, SEC/LEGAL |
| DODAY-GGL-08 | Ma trận gọi API theo nhu cầu, gate trước provider | ADD §1/2/3/8 | M-CORE · P2; gate privacy P0 | G2, G3, G5–G6 → G10 | PRIV-01/02, GGL-01/03, DEC-27/28/29 | BE + iOS, QA |
| DODAY-GGL-09 | Rate limit/quota, dedup, retry, circuit breaker | ADD §6/7 | M-CORE · P2 | G3, G6 → G10 | GGL-01/08, DEC-09, DATA-06 | BE + iOS, OPS/QA |
| DODAY-GGL-10 | Ảnh Google Places chỉ tải khi yêu cầu xem | ADD §1/6/8; OVERRIDE, DEC-28 | M-1.0 · P2 | G6 → G10–G11 | GGL-01/02/03/08/09, DEC-09/28 | iOS + BE, LEGAL/QA |
| DODAY-DATA-07 | Nhật ký cá nhân từ Moment đã lưu | ADD §7/8; OVERRIDE, DEC-30 | M-1.0 · P1 | G2 thiết kế, G7 → G10–G11 | DATA-01/02/03/05/06, PRIV-01/03, DEC-30 | iOS + BE, DES/QA |

Tổng: 30 MVP + 5 EXT + 7 DATA + 12 SAFE + 10 GGL + 1 L10N + 4 PRIV = **69 yêu cầu**. Không bỏ hoặc đánh số lại MVP khi thêm privacy/API/nhật ký.

## 3. Ca nghiệm thu – 30 hạng mục MVP

**DODAY-MVP-01 – Đăng ký và đăng nhập.** Tạo tài khoản và đăng nhập theo phương thức DEC-05; phiên lưu an toàn; hết phiên/đăng xuất/thu hồi phiên hoạt động.
- S1 Given người dùng mới, When hoàn tất đăng ký bằng phương thức đã duyệt, Then đúng 1 bản ghi User được tạo, token lưu trong Keychain và mở lại app không cần đăng nhập lại cho đến khi phiên hết hạn.
- S2 Given người dùng đã có tài khoản trên thiết bị khác, When đăng nhập, Then thấy đúng dữ liệu đã đồng bộ của tài khoản đó và không thấy dữ liệu tài khoản khác.
- E1 Given phiên đã hết hạn hoặc bị thu hồi nhưng chưa có xác nhận xóa tài khoản từ backend, When app gọi API, Then API trả 401, app chuyển về màn đăng nhập trong ≤1 lần thao tác và các nháp cục bộ của tài khoản vẫn còn (đếm trước/sau bằng nhau); mã 401 đơn thuần không kích hoạt xóa dữ liệu theo SAFE-01 S2/E3.
- E2 Given người dùng hủy hoặc nhà cung cấp đăng nhập lỗi, When quay lại app, Then hiển thị thông báo lỗi có nút thử lại và không có bản ghi User nào được tạo.
- E3 (email OTP, DEC-05/A8) Given cùng email đã yêu cầu 5 mã/giờ hoặc mã đã nhập sai 5 lần, When yêu cầu/nhập tiếp, Then bị từ chối/429 có thời điểm thử lại phù hợp và không gửi thêm email; mã chỉ dùng một lần, hết hạn sau 10 phút, thử mã đã dùng/hết hạn bị từ chối.

**DODAY-MVP-02 – Hồ sơ cơ bản.** Ảnh đại diện, tên hiển thị, tên người dùng, giới thiệu ngắn [SRC §10].
- S1 Given đã đăng nhập, When sửa tên hiển thị và lưu, Then giá trị mới hiển thị trên thiết bị thứ hai sau khi làm mới.
- E1 Given tên người dùng đã tồn tại, When lưu, Then bị từ chối với thông báo "đã được dùng" và hồ sơ cũ không đổi.
- E2 Given ảnh đại diện vượt 10 MB (A6) hoặc định dạng không hỗ trợ, When chọn, Then báo lỗi, không upload.
- 1.0-E3 Given tài khoản B gọi API hồ sơ của A, When gửi yêu cầu, Then nhận 403/404 (1.0 không hiển thị hồ sơ cho người khác).
- [PUB, NEEDS_CONFIRMATION] Trường nào hiển thị công khai cạnh khoảnh khắc công khai (đề xuất: ảnh đại diện + tên hiển thị). Người quyết định: PO, khi làm bản công khai.

**DODAY-MVP-03 – Thiết lập quyền riêng tư.** 1.0: owner-only, Hide cho ảnh mới; Cài đặt có nhiều Home Privacy Zone và công tắc bảo vệ mặc định bật/có thể tắt (PRIV-01/02); consent nhận diện bên ngoài riêng/rút được (A3); quyền iOS/quản lý/xóa dữ liệu/Privacy Policy. Tắt zone không tắt Hide hoặc cấp consent. **Không có** public/friends/danh sách chặn trong 1.0.
- 1.0-S1 Given tắt tự gắn hoặc bật Hide cho ảnh mới, When chụp, Then không Places do chụp và ảnh chưa gắn/hidden; bật tự gắn lại chỉ cho xử lý ngữ cảnh hợp lệ qua gate, không tạo request mỗi ảnh hoặc tắt Hide ngầm.
- 1.0-S2 Given quyền Vị trí bị từ chối, When mở màn Quyền riêng tư, Then trạng thái hiện "Đã tắt" và nút mở Cài đặt iOS hoạt động.
- 1.0-E1 Given offline, When đổi "tự gắn địa điểm", Then thiết lập áp dụng ngay trên máy và đồng bộ khi có mạng; không có lựa chọn nào làm nội dung thành công khai.
- 1.0-E2 Given rà soát màn Quyền riêng tư 1.0, When kiểm, Then không có điều khiển public/friends, mặc định quyền ảnh công khai hay danh sách chặn; Hide/zone và mặc định ẩn vị trí cá nhân vẫn có.

Các ca dưới đây thuộc bản công khai (PUB):
- S1 Given chưa cấu hình mặc định hai trục, When chụp khoảnh khắc mới, Then ảnh Riêng tư và vị trí ẩn; không suy quyền GPS thành public (DEC-11/32).
- S2 Given người dùng đổi mặc định, When chụp lần tiếp theo, Then lựa chọn ban đầu theo thiết lập mới; các khoảnh khắc cũ không đổi quyền.
- E1 Given offline, When đổi thiết lập, Then thay đổi được xếp hàng và áp dụng khi có mạng; không khoảnh khắc nào bị công khai do lỗi đồng bộ.

**DODAY-MVP-04 – Camera-first.** Sau xác thực/quyền lần đầu, mở app vào camera; không Home/Feed trung gian; một chạm sang Map.
- S1 Given đã đăng nhập và đã cấp quyền camera, When mở app từ trạng thái tắt hẳn, Then màn đầu tiên là camera với preview và nút chụp hoạt động, đạt Q-01.
- S2 Given đang ở camera, When chạm lối vào Map, Then Map hiển thị mà không cần chụp ảnh (1 chạm).
- E1 Given quyền camera bị từ chối, When mở app, Then hiện giải thích + nút mở Cài đặt + nút chọn ảnh thư viện + nút vào Map; không crash, không màn trắng.
- E2 Given không có mạng, When mở app, Then camera vẫn sẵn sàng trong ngưỡng Q-01 (không chờ backend).

**DODAY-MVP-05 – Chụp ảnh và chọn ảnh thư viện.** Camera trước/sau, flash khi phần cứng hỗ trợ, picker hệ thống. DEC-07/CROP: 1:1, 2048/400 px, cắt giữa **không preview/xác nhận crop**, gốc tại máy; BR-M11 phục hồi lỗi đã APPROVED A5, chưa kiểm thử.
- S1 Given camera sẵn sàng, When chụp, Then nháp được ghi bền vững đạt Q-03 và ảnh đúng hướng xoay; bản chính/thumbnail sau xử lý đều có chiều rộng = chiều cao (đọc file giải mã, không chỉ nhìn UI).
- S2 Given chọn 1 ảnh HEIC hoặc JPEG từ thư viện, When xác nhận, Then nháp được tạo với ảnh đầu ra 1:1; quyền thư viện toàn phần không bị yêu cầu chỉ để chọn ảnh.
- S3 Given ảnh vuông với từng giá trị EXIF orientation 1–8 trong S-IMG, When tạo bản chính/thumbnail, Then ảnh đúng hướng theo ảnh chuẩn, chiều rộng = chiều cao và không mất thêm vùng nội dung vì cắt lại.
- S4 Given ảnh ngang/dọc có lưới chuẩn và chủ thể sát mép trong S-IMG, When xử lý theo BR-M10, Then cắt vuông ở giữa (phần bỏ hai phía đối xứng sai khác tối đa 1 pixel do làm tròn), hướng đúng, chiều rộng = chiều cao và hệ số resize ngang = dọc; không kéo giãn hoặc chỉ che mép bằng UI.
- S5 Given chụp/chọn ảnh hợp lệ, When đi qua luồng lưu, Then không có màn/nút xác nhận vùng crop hoặc bước preview crop bổ sung; ảnh tự cắt, số thao tác lưu không tăng so với J1 trước khi thêm crop. Màn xem lại tiêu đề/Hide có sẵn không bị biến thành bước duyệt crop.
- E1 Given thiết bị không hỗ trợ flash ở camera đang dùng, When mở camera, Then nút flash ẩn hoặc vô hiệu.
- E2 Given bộ nhớ thiết bị không đủ ghi ảnh, When chụp, Then báo lỗi "Không đủ dung lượng" và **không** hiển thị đã lưu.
- E3 Given cuộc gọi đến khi đang ở camera, When quay lại app, Then phiên camera khôi phục đạt Q-02.

**DODAY-MVP-06 – Tự lấy vị trí và nhận diện địa điểm.** Ba nhánh theo BR-L1…L9, DEC-27 đã duyệt bỏ lookup theo ảnh. S1/S2 có ngữ cảnh còn quyền dùng từ tác vụ hợp lệ, gate cho phép; TTL/thông số và phương pháp Q-06 chốt trước G2. Không Places mới vì chụp.
- S1 Given vị trí đúng thời điểm/đủ chính xác, ngữ cảnh hợp lệ và một ứng viên vượt T_auto, When xử lý ảnh sau ghi nháp, Then tự gắn không request Places mới; bộ thực địa đo Q-05 và báo Q-06 cùng các mẫu số.
- S2 Given ngữ cảnh hợp lệ có ≥2 ứng viên trong bán kính độ chính xác, When xử lý ảnh, Then không tự gắn mà cho xác nhận một chạm, không chặn lưu và không lookup mới do chụp.
- E1 Given quyền vị trí gần đúng hoặc từ chối, When chụp, Then không tự gắn (0 lần tự gắn trong bộ ca này) và ảnh vẫn lưu được.
- E2 Given ảnh thư viện không có GPS trong metadata, When chọn, Then không dùng vị trí hiện tại; chuyển sang chọn thủ công.
- E3 Given Places lỗi hoặc timeout [PROPOSED 5 s], When chụp, Then chip "Chưa xác định địa điểm" hiện và nút Xong vẫn hoạt động.
- E4 Given không có ngữ cảnh, ngữ cảnh hết quyền dùng hoặc vị trí đã thay đổi ngoài điều kiện đã chốt, When chụp ≥10 ảnh/mở lại camera, Then 0 request Nearby tự phát, không dùng lại Place cũ; mọi ảnh vẫn lưu không nơi được, có lối chọn/nhận diện chủ động sau.

**DODAY-MVP-07 – Xác nhận hoặc sửa địa điểm.**
- S1 Given danh sách xác nhận có ứng viên đúng, When chạm ứng viên, Then gắn trong 1 chạm.
- S2 Given khoảnh khắc đã lưu gắn sai nơi, When sửa sang nơi khác, Then khoảnh khắc chỉ xuất hiện ở nơi mới (kiểm tra cả trang chi tiết nơi cũ và số đếm).
- E1 Given không có ứng viên đúng, When người dùng tìm theo tên, chọn trên bản đồ hoặc thêm thủ công, Then lưu được; nơi thủ công không có Google Place ID (BR-P3).

**DODAY-MVP-08 – Tiêu đề ngắn tùy chọn.**
- S1 Given màn xem lại, When chạm Xong mà không nhập tiêu đề, Then khoảnh khắc được lưu với tiêu đề rỗng.
- S2 Given nhập tiêu đề có dấu tiếng Việt và emoji, When lưu, Then hiển thị nguyên văn trên thiết bị thứ hai.
- E1 Given nhập vượt giới hạn BR-M1, When gõ thêm, Then không nhận ký tự vượt và hiện bộ đếm.

**DODAY-MVP-09 – Lưu ảnh và chia sẻ khoảnh khắc.** Lưu cục bộ trước, upload sau; trạng thái đồng bộ rõ ràng. Phạm vi 1.0: "chia sẻ" chỉ là lưu riêng tư vào tài khoản; chia sẻ công khai là PUB (MVP-10). Hạn mức upload theo SAFE-12.
- S1 Given có mạng, When Xong, Then trạng thái đi qua "Đã lưu trên máy" → "Đang tải lên" → "Đã đồng bộ"; tỷ lệ hoàn tất upload đạt Q-09.
- S2 Given offline, When Xong, Then hiển thị "Đã lưu trên máy" (không phải "Đã đồng bộ"); khi có mạng tự upload.
- S3 Given ảnh nguồn lớn hơn/nhỏ hơn giới hạn pixel BR-M10, When đồng bộ thành công, Then bản chính ≤2048 × 2048 và thumbnail ≤400 × 400, đều vuông, ảnh nhỏ không bị phóng lớn. Ghi riêng byte của mỗi file, không coi 1:1 là 0,8 MB mặc định.
- E1 Given bộ thử phục hồi (đóng app, timeout, retry, đổi mạng), When chạy ≥100 chu kỳ, Then 0 mất và 0 trùng (Q-04).
- E2 Given upload thất bại vĩnh viễn (ví dụ ảnh hỏng), When hết lượt retry, Then hiện "Lỗi, thử lại/xóa" và ảnh gốc trên máy không bị xóa.
- E3 Given đã ghi nguồn bền vững nhưng tạo ảnh vuông hoặc nén bị lỗi, When quay lại nháp rồi thử lại, Then nguồn vẫn đọc được, trạng thái là "Đã lưu trên máy – cần xử lý ảnh", chưa đồng bộ; thành công sau thử lại chỉ có 1 Moment ID (BR-M11).
- E4 Given client gửi bản chính hoặc thumbnail chữ nhật, kể cả khai báo metadata là vuông, When BE giải mã và kiểm tra, Then trả lỗi 4xx riêng cho ảnh không hợp lệ, không xác nhận đã đồng bộ và không phân phối file đó; nguồn cục bộ vẫn còn (BR-M11).

**DODAY-MVP-10 – Chế độ công khai và riêng tư.** Phạm vi 1.0: chỉ riêng tư (DEC-15 C).
- 1.0-S1 Given bất kỳ khoảnh khắc nào, When lưu, Then nó là Riêng tư; màn xem lại ghi "Chỉ mình bạn xem được" và không có lựa chọn Công khai.
- 1.0-E1 Given gọi API trực tiếp yêu cầu visibility = public, When gửi, Then server trả 4xx và bản ghi vẫn Riêng tư (SAFE-10).
- 1.0-E2 Given tài khoản B gọi API trực tiếp với ID khoảnh khắc của A, When gửi yêu cầu, Then nhận 403/404 và không có dữ liệu ảnh (Q-13).

Các ca dưới đây thuộc bản công khai (PUB), chưa áp dụng cho 1.0:
- S1 Given khoảnh khắc có địa điểm được phép hiển thị, mặc định quyền ảnh/vị trí cho phép công khai và tài khoản hợp lệ, When Xong, Then B thấy nội dung được cấp quyền ở địa điểm đó; không bắt chọn public lại sau từng ảnh.
- S2 Given khoảnh khắc công khai ở bản PUB, When chuyển Riêng tư, Then trong ≤60 giây B không thấy qua API/tìm kiếm/số đếm/ảnh bìa; URL riêng tư ký TTL ≤15 phút (A9), phương án thu hồi CDN public được chốt trước PUB theo B9.
- S3 Given mặc định ảnh Public/vị trí Hidden hoặc chưa có Place, When Xong, Then ảnh được đăng không cần chọn nơi; B có quyền xem ảnh nhưng không nhận Place/tọa độ/địa chỉ/quan hệ địa điểm từ ảnh, trang địa điểm không có ảnh hoặc số đếm phát sinh từ nó.
- E1 Given trạng thái quyền chưa thiết lập/không hợp lệ hoặc GPS được cấp nhưng chưa cho hiển thị nơi, When lưu, Then mặc định ảnh riêng tư/vị trí ẩn, không tự nâng quyền hoặc yêu cầu thêm Place để lưu.
- E2 Given tài khoản bị khóa, When chọn Công khai, Then lựa chọn bị vô hiệu kèm thông báo.

**DODAY-MVP-11 – Map kết hợp Save và Discover.** Phạm vi 1.0: Save (bản đồ cá nhân) + Discover qua tìm kiếm Google, trên cùng một bản đồ. Lớp cộng đồng là PUB.
- 1.0-S1 Given người dùng có nơi đã lưu và vừa tìm kiếm, When mở Map, Then nơi đã lưu và kết quả tìm kiếm hiện trên cùng bản đồ, không có tab Save/Discover riêng.
- 1.0-S2 Given chạm marker kết quả tìm kiếm chưa lưu, When chạm Lưu trên bottom sheet, Then lưu trong 1 chạm mà không rời Map.
- 1.0-E1 Given offline, When mở Map, Then nơi đã đồng bộ vẫn có trong danh sách, marker chỉ với tọa độ còn quyền dùng; thiếu tọa độ theo BR-P8, 0 Places call; tìm Google báo cần mạng, không có lớp cộng đồng.
- 1.0-E2 Given người dùng mới chưa có dữ liệu, When mở Map, Then trạng thái trống hướng dẫn chụp, tìm hoặc lưu đầu tiên.

Các ca dưới đây thuộc bản công khai (PUB):
- S1 Given người dùng có nơi đã lưu và vùng có nơi công khai, When mở Map, Then cả hai lớp hiện trên cùng bản đồ, không có tab Save/Discover riêng.
- S2 Given chạm marker cộng đồng chưa lưu, When chạm Lưu trên bottom sheet, Then lưu trong 1 chạm mà không rời Map.
- E1 Given offline, When mở Map, Then nơi đã lưu đã đồng bộ vẫn hiện; lớp cộng đồng hiện thông báo không tải được.

**DODAY-MVP-12 – Tag ghim địa điểm.**
- S1 Given một địa điểm có ảnh đại diện, When hiển thị, Then marker gồm tên (cắt ngắn) và ảnh/biểu tượng, không thêm thông tin khác [SRC §5.2].
- S2 Given chạm marker, When thả tay, Then bottom sheet hiện đúng các trường SRC §5.4 có dữ liệu, trừ "ảnh trải nghiệm nổi bật" và "số khoảnh khắc công khai" (PUB, không có trong 1.0).
- E1 Given địa điểm không có ảnh, When hiển thị, Then dùng biểu tượng mặc định, không để trống.
- E2 Given nhãn/tọa độ Google không còn quyền dùng và không có pin Doday, When mở/pan/zoom Map, Then 0 Places call, không vẽ marker giả; danh sách vẫn có SavedPlace/ID với nhãn trung tính/nhãn người dùng và lệnh làm mới chủ động (DEC-29).

**DODAY-MVP-13 – Phân biệt địa điểm cá nhân và khám phá.** Bốn kiểu: đã lưu, đã ghé, cộng đồng chưa lưu, cộng đồng mới chia sẻ (B9 duyệt hướng ≤7 ngày, chốt trước PUB). 1.0: đã lưu, đã ghé, tìm kiếm chưa lưu; hai kiểu cộng đồng chỉ PUB.
- 1.0-S1 Given Map có nơi đã lưu, nơi đã ghé và kết quả tìm kiếm chưa lưu, When hiển thị, Then ba kiểu phân biệt được bằng ký hiệu, không chỉ dựa vào màu.
- 1.0-E1 Given 1.0, When rà soát Map, Then không có bộ lọc, marker hay chú thích "cộng đồng" (tránh tính năng không hoạt động trước reviewer).

Các ca dưới đây thuộc bản công khai (PUB):
- S1 Given bộ dữ liệu thử có đủ 4 kiểu, When hiển thị, Then mỗi kiểu có ký hiệu khác nhau không chỉ dựa vào màu (đạt kiểm tra mù màu và VoiceOver đọc đúng nhãn).
- S2 Given một nơi vừa đã lưu vừa có nội dung cộng đồng, When hiển thị, Then chỉ có 1 marker, thể hiện cả hai thuộc tính.
- E1 Given khoảnh khắc chuyển Riêng tư, When làm mới Map của tài khoản khác, Then nơi đó không còn kiểu "cộng đồng" nếu không còn khoảnh khắc công khai nào.

**DODAY-MVP-14 – Tìm kiếm địa điểm.** Theo tên, khu vực, loại; tìm trong nơi đã lưu; kết quả hiện thành marker [SRC §5.5]. Không cần AI (ROADMAP §1).
- S1 Given bộ chuẩn ≥50 truy vấn có nhãn đúng (B2: tên quán, khu vực, loại), When tìm, Then nơi đúng trong top 5 ở ≥90% truy vấn và kết quả hiện trên Map; chọn hồ sơ thử trước đo, chưa kiểm thử.
- S2 Given bộ lọc "Đã lưu" bật, When tìm "Hà Nội", Then chỉ trả nơi đã lưu thuộc khu vực đó.
- E1 Given không có kết quả, When tìm, Then hiện trạng thái trống với lối thêm thủ công.
- E2 Given Places lỗi, When tìm, Then tìm trong nơi đã lưu vẫn hoạt động và hiện thông báo lỗi tìm kiếm Google.

**DODAY-MVP-15 – Lọc địa điểm.** Tất cả / đã lưu / đã ghé / cộng đồng / đang hoạt động / tạm đóng hoặc đã đóng [SRC §5.5]. 1.0: không có bộ lọc "cộng đồng" (PUB, DEC-15 C).
- S1 Given bộ dữ liệu thử có nhãn, When bật từng bộ lọc, Then 100% marker hiển thị khớp điều kiện bộ lọc.
- S2 Given bộ lọc trạng thái kinh doanh, When áp dụng, Then chỉ dùng business status hợp lệ theo chính sách lưu trữ (GGL-03); nơi chưa có trạng thái hợp lệ được gom vào nhóm "Chưa xác định" và **không** bị ẩn âm thầm.
- E1 Given bộ lọc không có kết quả, When áp dụng, Then hiện "Không có địa điểm phù hợp" và nút bỏ lọc.
- [NEEDS_CONFIRMATION] Cách lấy business status cho bộ lọc mà không gọi Places hàng loạt và không cache trái chính sách. Người quyết định: TL + LEGAL. Tác động: nếu không có cách hợp lệ, bộ lọc trạng thái chỉ áp dụng cho nơi vừa được xem.

**DODAY-MVP-16 – Gom nhóm marker.**
- S1 Given 1.000 địa điểm thử trong một thành phố, When mở Map ở mức thu phóng thành phố, Then marker được gom nhóm có số đếm và đạt Q-07.
- S2 Given chạm một cụm, When thả tay, Then bản đồ phóng to để tách cụm.
- E1 Given kéo bản đồ liên tục 30 giây, When đo, Then số lần gọi Places do kéo bản đồ = 0 (BR-P7).

**DODAY-MVP-17 – Lưu vào bản đồ cá nhân.**
- S1 Given xem một địa điểm chưa lưu, When chạm Lưu, Then SavedPlace (Want to visit) được tạo, marker đổi kiểu ngay, không hỏi bộ sưu tập.
- S2 Given offline, When chạm Lưu, Then hiển thị đã lưu trên máy và đồng bộ khi có mạng.
- E1 Given đã lưu rồi, When chạm Lưu lần nữa hoặc retry mạng, Then vẫn chỉ có 1 SavedPlace.

**DODAY-MVP-18 – Liên kết Google Place ID.**
- S1 Given hai tài khoản lưu cùng Google Place ID (≥50 cặp yêu cầu song song theo B2), When hoàn tất, Then chỉ có 1 Place với Place ID đó.
- S2 Given nơi thủ công, When tạo, Then Place có Doday Place ID và Google Place ID rỗng.
- E1 Given Place ID trả lỗi NOT_FOUND khi làm mới, When mở chi tiết, Then đánh dấu cần đối soát (GGL-06), khoảnh khắc và SavedPlace vẫn còn.

**DODAY-MVP-19 – Tên và địa chỉ.**
- S1 Given Place có Google Place ID, When mở chi tiết, Then tên và địa chỉ là dữ liệu truy xuất trong phiên xem, có ghi nguồn Google.
- E1 Given nơi thủ công, When mở chi tiết, Then hiện tên do người dùng nhập với nhãn "Địa điểm do bạn thêm", không có nhãn Google.
- E2 Given Places lỗi, When mở chi tiết, Then hiện "Không cập nhật được thông tin" và không hiển thị địa chỉ cũ như dữ liệu hiện hành.

**DODAY-MVP-20 – Trạng thái hoạt động.**
- S1 Given dữ liệu thử cho 5 trường hợp (OPERATIONAL, CLOSED_TEMPORARILY, CLOSED_PERMANENTLY, FUTURE_OPENING, không có giá trị), When hiển thị, Then lần lượt: bình thường / "Tạm thời đóng cửa" / "Đã đóng cửa" / "Sắp khai trương" / không hiển thị trạng thái.
- S2 Given nơi đã lưu chuyển CLOSED_PERMANENTLY, When mở, Then cảnh báo nổi bật và nơi đó vẫn ở bản đồ cá nhân.
- E1 Given OPERATIONAL nhưng ngoài giờ mở cửa, When hiển thị, Then business status vẫn bình thường và giờ hiện "Đang đóng cửa" (không trộn hai khái niệm).

**DODAY-MVP-21 – Giờ mở cửa khi có dữ liệu.**
- S1 Given có regularOpeningHours và currentOpeningHours, When mở chi tiết, Then hiện giờ theo từng ngày, trạng thái đang mở/đóng và giờ mở tiếp theo nếu xác định được.
- S2 Given người dùng ở múi giờ khác địa điểm, When xem, Then "đang mở/đóng" tính theo giờ địa phương của địa điểm.
- E1 Given không có dữ liệu giờ, When xem, Then hiện "Chưa có thông tin giờ mở cửa", không hiện "Đang đóng cửa".
- E2 Given có giờ đặc biệt trong currentOpeningHours khác lịch thường, When xem ngày đó, Then hiện giờ đặc biệt kèm ghi chú.

**DODAY-MVP-22 – Điểm đánh giá và tổng lượt đánh giá.**
- S1 Given rating 4.6 và 2.350 lượt, When hiển thị, Then "Google Maps · 4,6/5 · 2.350 lượt đánh giá" trong khối Google, tách khỏi "Doday Experiences".
- E1 Given không có rating, When hiển thị, Then ẩn khối rating hoặc ghi "Chưa có đánh giá trên Google"; không hiển thị 0 sao.
- E2 Given kiểm tra giao diện, When rà soát mọi màn có rating, Then không màn nào gọi rating Google là đánh giá của Doday.

**DODAY-MVP-23 – Mở địa điểm trên Google Maps.** Dùng Maps URL `search/?api=1&query=…&query_place_id=…` (GG2, truy cập 30/10/2026: không cần API key; mở app Google Maps nếu có, nếu không mở trình duyệt).
- S1 Given có Google Maps app, When chạm "Xem trên Google Maps", Then Google Maps mở đúng địa điểm (đối chiếu Place ID) ở ≥20/20 địa điểm thử, gồm ≥5 cặp trùng tên.
- E1 Given không có Google Maps app, When chạm, Then mở trình duyệt với cùng địa điểm.
- E2 Given nơi thủ công, When chạm, Then dùng tọa độ người dùng nhập và ghi rõ không phải dữ liệu Google.

**DODAY-MVP-24 – Chỉ đường bằng Google Maps.** Maps URL `dir/?api=1&destination=…&destination_place_id=…`.
- S1 Given địa điểm có Place ID, When chạm "Chỉ đường", Then Google Maps mở chế độ chỉ đường với đúng đích ở ≥20/20 địa điểm thử; Doday không tự chỉ đường.
- E1 Given việc mở liên kết ngoài thất bại, When chạm, Then hiện thông báo và nút sao chép địa chỉ.
- E2 Given Places đang lỗi, When chạm, Then nút vẫn hoạt động bằng Place ID đã lưu.

**DODAY-MVP-25 – Trang chi tiết địa điểm.** Năm phần theo SRC §8.1, khối Google và Doday tách riêng; có "Chia sẻ địa điểm" qua Share Sheet iOS [SRC §8.1 phần 5].
- S1 Given địa điểm đủ dữ liệu, When mở, Then có đủ 5 phần với attribution GGL-02; phần 3 là khoảnh khắc của chủ, nút phần 1 lưu riêng tư; phần 4 có rating/tổng lượt và lối xem từng review, nhưng chỉ tải review/ảnh Google khi yêu cầu xem (GGL-04/10).
- S2 Given chạm "Chia sẻ địa điểm", When chọn ứng dụng nhận, Then nội dung chia sẻ là tên + liên kết Google Maps của địa điểm, không chứa tọa độ chụp của người dùng.
- E1 Given trường nào thiếu, When mở, Then trường đó ẩn hoặc ghi "Chưa có thông tin"; không hiển thị dữ liệu phỏng đoán.

**DODAY-MVP-26 – Xem ảnh và trải nghiệm công khai.** Phạm vi 1.0: khối "Khoảnh khắc của bạn tại đây".
- 1.0-S1 Given người dùng có khoảnh khắc tại địa điểm X, When mở chi tiết X, Then khối Doday chỉ hiện khoảnh khắc của chính họ, có nhãn "Chỉ mình bạn".
- 1.0-E1 Given tài khoản B mở chi tiết X, When xem, Then không thấy khoảnh khắc nào của A và API không có endpoint trả khoảnh khắc của người khác.

Các ca dưới đây thuộc bản công khai (PUB):
- S1 Given địa điểm có khoảnh khắc công khai của nhiều tài khoản, When mở chi tiết, Then thấy ảnh, tiêu đề, thời gian, người chia sẻ; số đếm bằng số khoảnh khắc công khai hợp lệ.
- E1 Given chưa có khoảnh khắc công khai, When mở, Then trạng thái trống mời "chia sẻ đầu tiên".
- E2 Given khoảnh khắc bị ẩn do kiểm duyệt hoặc người đăng bị chặn, When mở, Then khoảnh khắc không xuất hiện và số đếm không tính nó.

**DODAY-MVP-27 – Chia sẻ khoảnh khắc tại địa điểm.** Từ trang chi tiết, chụp hoặc chọn ảnh với địa điểm đã điền sẵn. 1.0: S1 và E1 áp dụng, khoảnh khắc luôn Riêng tư. E2 chỉ áp dụng ở bản công khai (PUB).
- S1 Given đang ở chi tiết X, Hide tắt và gate cho hiển thị X, When chạm "Lưu khoảnh khắc tại đây" và chụp, Then gắn X không lookup GPS, ảnh vẫn owner-only; bản PUB dùng quyền MVP-03/10.
- S2 Given chụp từ chi tiết X nhưng Hide bật hoặc zone/uncertain, When Xong, Then vẫn lưu ảnh với địa điểm hiển thị null, không ép giữ X hoặc xác nhận nơi, không đổi SavedPlace X độc lập; không chạy nhận diện.
- E1 Given Hide tắt/gate cho phép và ảnh thư viện có GPS cách X >1 km (hướng B3, chốt UX trước G2), When gắn X, Then cảnh báo xác nhận, vẫn cho lưu không nơi; không dùng GPS bị zone/Hide chặn để ép xác nhận/gửi nhận diện.
- E2 Given cờ công khai tắt hoặc tài khoản bị khóa, When chia sẻ, Then chỉ lưu được riêng tư, có thông báo.

**DODAY-MVP-28 – Quản lý danh sách đã lưu.** Tìm kiếm, sắp xếp theo thời gian lưu, xem trạng thái, mở chi tiết, xóa [SRC §9.1].
- S1 Given 200 nơi đã lưu, When sắp xếp theo thời gian lưu mới nhất, Then thứ tự đúng 100% so với dữ liệu thử.
- S2 Given xóa một nơi khỏi danh sách, When làm mới trên thiết bị thứ hai, Then nơi đó không còn trong danh sách; Place chung và khoảnh khắc của người khác không đổi.
- E1 Given danh sách mở, When đo số lần gọi Places, Then = 0 cho tới khi mở chi tiết (SRC §6.8).

**DODAY-MVP-29 – Tạo và quản lý bộ sưu tập.**
- S1 Given 1 địa điểm, When thêm vào 3 bộ sưu tập, Then nó xuất hiện trong cả 3; tạo/đổi tên/xóa bộ hoạt động.
- S2 Given xóa một bộ sưu tập, When kiểm tra, Then các SavedPlace và ảnh trong bộ vẫn còn.
- E1 Given thiết bị A xóa bộ, thiết bị B offline thêm nơi vào bộ đó, When B đồng bộ, Then áp dụng BR-A6 (xóa thắng), B được thông báo, không sinh bộ "ma".

**DODAY-MVP-30 – Want to visit và Visited.**
- S1 Given nơi vừa lưu, When xem, Then trạng thái là Want to visit; người dùng đổi sang Visited bằng 1 chạm.
- S2 Given nơi Want to visit có business status CLOSED_PERMANENTLY, When xem, Then hiện cả hai thông tin riêng biệt.
- E1 Given người dùng đi ngang địa điểm với GPS bật, When không có thao tác người dùng, Then trạng thái không đổi (0 lần tự đổi trong bộ thử).
- E2 Given lưu một khoảnh khắc đã xác nhận tại nơi Want to visit, When hoàn tất, Then chỉ hiện gợi ý "Đánh dấu đã ghé?" (BR-S3), không tự đổi.

## 4. Ca nghiệm thu – Share Extension (EXT)

**DODAY-EXT-01 – Nhận URL/text.**
- S1 Given ma trận nguồn (TikTok, Instagram, Safari – phiên bản ứng dụng ghi lại ở G2), When chia sẻ sang Doday trên iPhone thật, Then extension nhận được URL hoặc text ở 100% kiểu dữ liệu đã ghi nhận ở G2.
- E1 Given nguồn chỉ cung cấp kiểu dữ liệu không hỗ trợ, When chia sẻ, Then extension báo "Doday chưa nhận được nội dung này" và đóng, không treo.
- E2 Given extension bị hệ điều hành đóng giữa chừng, When mở lại app, Then mục đã ghi còn nguyên; mục chưa ghi không được báo đã lưu.

**DODAY-EXT-02 – Lưu URL nguồn vào mục chờ xử lý.**
- S1 Given ≥100 ca chia sẻ đủ định dạng, When chia sẻ, Then ≥98% tạo được SavedPlace hoặc mục PENDING (Q-08).
- S2 Given mục PENDING, When người dùng chọn địa điểm trong app, Then mục chuyển RESOLVED và SavedPlace giữ liên kết URL nguồn.
- E1 Given offline, When chia sẻ, Then mục PENDING lưu cục bộ và đồng bộ khi app chính có mạng.

**DODAY-EXT-03 – Thử xác định địa điểm từ dữ liệu được phép (BR-X3, BR-X4).**
- S1 Given URL/text có tên hoặc địa chỉ địa điểm nhận diện được, When xử lý, Then đề xuất ứng viên để người dùng xác nhận; không lưu Place khi chưa xác nhận. Tỷ lệ tự xác định báo riêng (Q-08b), **không có ngưỡng đạt** cho 1.0.
- E1 Given URL trỏ tới địa chỉ mạng nội bộ, redirect vượt giới hạn hoặc phản hồi vượt dung lượng, When backend đọc, Then dừng xử lý, mục giữ PENDING, không có yêu cầu nào tới mạng nội bộ (kiểm thử SSRF).
- E2 Given nội dung yêu cầu đăng nhập/riêng tư, When xử lý, Then không cố truy cập, mục giữ PENDING với lý do.
- [NEEDS_CONFIRMATION] Nguồn dữ liệu được phép đọc từ TikTok/Instagram (metadata công khai hay chỉ dữ liệu Share Sheet). Người quyết định: LEGAL + TL. Tác động: nếu chỉ dùng dữ liệu Share Sheet, tỷ lệ tự xác định có thể rất thấp; luồng PENDING vẫn đáp ứng 1.0.

**DODAY-EXT-04 – Dán liên kết trong app.**
- S1 Given clipboard có URL, When người dùng chủ động chạm "Dán liên kết" trên Map, Then xử lý như EXT-02. App không tự đọc clipboard khi chưa có thao tác người dùng.
- E1 Given nội dung dán không phải URL hợp lệ, When xác nhận, Then báo "Liên kết không hợp lệ".

**DODAY-EXT-05 – Chống trùng và gắn đúng chủ sở hữu.**
- S1 Given cùng URL (sau chuẩn hóa BR-X5) chia sẻ 2 lần, When xử lý, Then chỉ 1 ExternalSource và tối đa 1 SavedPlace cho tài khoản đó.
- E1 Given tài khoản A chia sẻ khi offline rồi đăng xuất, B đăng nhập, When đồng bộ, Then mục của A không xuất hiện và không upload dưới B.
- E2 Given app chính chưa đăng nhập, When chia sẻ, Then extension không lưu vào tài khoản nào và hướng dẫn mở Doday để đăng nhập.

## 5. Ca nghiệm thu – Dữ liệu (DATA)

**DODAY-DATA-01 – Nháp bền vững, upload idempotent.**
- S1 Given ≥100 chu kỳ đóng app/timeout/retry/offline/đổi mạng, When chạy, Then 0 mất, 0 trùng (Q-04); mỗi upload có khóa idempotency phía client.
- E1 Given server nhận cùng khóa idempotency 2 lần, When xử lý, Then trả cùng kết quả và chỉ 1 Moment.

**DODAY-DATA-02 – Phân vùng theo tài khoản.**
- S1 Given A có 3 mục chưa đồng bộ, When A đăng xuất chọn "giữ trên máy" và A đăng nhập lại, Then 3 mục hiện lại và upload dưới A.
- E1 Given như trên nhưng B đăng nhập, When B dùng app, Then B không thấy, không upload, không gộp 3 mục của A (kiểm tra cả DB cục bộ, hàng đợi upload, App Group).
- E2 Given A đăng xuất chọn "xóa khỏi máy", When kiểm tra bộ nhớ app, Then không còn ảnh/nháp của A.

**DODAY-DATA-03 – Đồng bộ nhiều thiết bị.**
- S1 Given 2 thiết bị cùng tài khoản, When thêm/bỏ lưu, đổi Visited, sửa bộ sưu tập trên A, Then B phản ánh sau khi làm mới, không mất/nhân đôi quan hệ.
- E1 Given ma trận xung đột BR-A6 (≥10 kịch bản), When chạy, Then kết quả khớp 100% quy tắc đã công bố; xung đột hiển thị luôn ra Riêng tư.

**DODAY-DATA-04 – Nháp khi chưa đăng nhập.** DEC-17 duyệt phương án A ngày 31/10/2026: không có nháp khách trong 1.0.
- S1 Given chưa đăng nhập, When mở app, Then màn đăng nhập hiện trước camera, giải thích lý do; không có nút chụp nào hoạt động trước khi đăng nhập.
- E1 Given A đã đăng xuất và chọn "giữ trên máy", When mở app ở trạng thái chưa đăng nhập, Then không thấy nháp nào của A trước khi đăng nhập lại.
- E2 Given phiên hết hạn đúng lúc đang ở màn xem lại ảnh vừa chụp, When chạm Xong, Then nháp vẫn lưu trên máy cho đúng tài khoản đó và app yêu cầu đăng nhập lại trước khi upload.

## 6. Ca nghiệm thu – An toàn phát hành (SAFE)

**DODAY-SAFE-01 – Xóa tài khoản trong app.**
- S1 Given đã đăng nhập, When Profile → Xóa tài khoản và xác nhận, Then thu hồi phiên/ngừng cấp URL mới ngay, ẩn nội dung ≤60 giây (A9); URL ký bị từ chối sau TTL ≤15 phút; xóa cứng ≤30 ngày/backup ≤35 ngày, thông báo hoàn tất. PUB thêm: không còn ở API public trong cùng cửa sổ ẩn.
- S2 Given backend đã xác nhận xóa tài khoản trên thiết bị A và B cùng tài khoản đang có mạng, When B mở app và nhận xác nhận tài khoản đã xóa hoặc phiên bị thu hồi do xóa tài khoản từ backend, Then B khóa truy cập tài khoản đó và dừng/hủy hàng đợi ngay khi xử lý xác nhận, trước khi phát lại; đăng xuất, xóa token và dữ liệu cục bộ theo `privacy-and-data.md` §5, kiểm tra còn 0 mục của tài khoản đã xóa trong DB, ảnh/thumbnail/nháp/cache do app quản lý, App Group, hàng đợi và zone; không xóa dữ liệu của tài khoản khác.
- E1 Given thao tác xóa không truy cập được mạng, When xác nhận, Then báo lỗi, không báo đã xóa.
- E2 Given dùng Sign in with Apple (nếu DEC-05 chọn), When xóa, Then token được thu hồi qua REST API của Apple [A2].
- E3 Given B đang offline với nháp chưa đồng bộ khi tài khoản bị xóa trên A, When B mở app offline rồi kết nối lại và backend trả xác nhận xóa tài khoản hoặc thu hồi phiên do xóa, Then khi còn offline dữ liệu có thể vẫn ở trên B và không báo đã thu hồi/xóa từ xa; khi có mạng phải kiểm tra trạng thái tài khoản trước khi phát lại hàng đợi, sau xác nhận thực hiện S2 với 0 upload từ hàng đợi cũ và 0 dữ liệu của tài khoản đã xóa còn cục bộ sau khi dọn; đăng nhập tài khoản khác không thấy hoặc nhận nháp cũ.

**DODAY-SAFE-02 – Phân quyền đối tượng.**
- S1 Given 2 tài khoản và bộ thử quyền (API đọc/sửa/xóa theo ID, URL ảnh/thumbnail trực tiếp, tìm kiếm, số đếm), When B truy cập tài nguyên riêng tư của A, Then 0 truy cập thành công (Q-13).
- E1 Given URL ảnh riêng tư bị lộ, When truy cập sau khi hết TTL URL ký, Then bị từ chối.

> SAFE-03, SAFE-04, SAFE-06 và phần kiểm duyệt của SAFE-05/SAFE-07 là **PUB**: không xây trong 1.0. Ca nghiệm thu dưới đây giữ lại cho bản công khai.

**DODAY-SAFE-03 – Báo cáo (PUB).**
- S1 Given khoảnh khắc công khai, When báo cáo với lý do, Then báo cáo vào hàng đợi kiểm duyệt có mã theo dõi; người báo cáo không còn thấy nội dung đó [PROPOSED].
- E1 Given báo cáo trùng từ cùng tài khoản, When gửi lại, Then không tạo báo cáo thứ hai.

**DODAY-SAFE-04 – Chặn người dùng (PUB).**
- S1 Given A chặn B, When A xem Map/chi tiết/Profile, Then không thấy nội dung của B, và ngược lại B không thấy nội dung của A, kiểm tra ở cả API.
- E1 Given A bỏ chặn, When làm mới, Then nội dung công khai hiển thị lại.

**DODAY-SAFE-05 – Lọc, hạn mức đăng công khai, chống spam (PUB).** Hạn mức upload riêng tư của 1.0 tách sang SAFE-12.
- S1 Given vượt hạn mức BR-C4, When đăng, Then bị từ chối với thông báo và thời điểm thử lại.
- E1 Given ảnh trong bộ thử nội dung vi phạm có nhãn, When đăng công khai, Then bị chặn hoặc vào hàng chờ duyệt theo chính sách DEC-15 (tỷ lệ phát hiện được báo cáo; ngưỡng [NEEDS_CONFIRMATION]).

**DODAY-SAFE-06 – Loại metadata vị trí khỏi ảnh công khai (PUB).**
- S1 Given ảnh có EXIF GPS được công khai, When tải ảnh qua URL công khai, Then không còn trường GPS (kiểm tra bằng công cụ đọc EXIF trên ≥20 ảnh).
- E1 Given ảnh định dạng HEIC/JPEG/PNG, When xử lý, Then cả ba đều không còn GPS.

**DODAY-SAFE-07 – Kiểm duyệt, hỗ trợ, người trực.** 1.0 chỉ cần phần hỗ trợ:
- 1.0-S1 Given yêu cầu hỗ trợ tới kênh đã tạo trước beta ngoài, When diễn tập ≥5 yêu cầu ở G11 gồm ca chủ dự án vắng, Then có người/phương án đã duyệt ghi nhận và trả lời ≤2 ngày làm việc (A14/B8); Support URL công bố/kiểm lại trước G12A.
- 1.0-E1 Given yêu cầu xóa dữ liệu qua kênh hỗ trợ, When nhận, Then được hướng dẫn tới chức năng xóa trong app (SAFE-01), không thay thế nó.

Ca kiểm duyệt (PUB):
- S1 Given diễn tập với moderator thật, When có báo cáo khẩn cấp và thông thường, Then tiếp nhận trong SLA Q-15; ẩn/gỡ nội dung, khóa tài khoản và nhật ký quyết định hoạt động.
- E1 Given chưa có moderator được chỉ định, When chuẩn bị bản công khai, Then không phát hành bản có tính năng công khai (BR-C3) – đây là điều kiện chặn, không phải lỗi.

**DODAY-SAFE-08 – Chính sách công khai.**
- S1 Given URL Privacy Policy, Terms, Support, When mở từ trình duyệt không đăng nhập và từ trong app, Then truy cập được và nội dung khớp dữ liệu/SDK thực tế.
- E1 Given thay đổi thu thập dữ liệu, When phát hành build mới, Then chính sách được cập nhật trước khi gửi review (kiểm tra trong checklist G12A).

**DODAY-SAFE-09 – Giám sát và khôi phục.**
- S1 Given môi trường cách ly, When khôi phục từ backup, Then đạt RPO/RTO Q-12 và quan hệ DB–ảnh còn toàn vẹn (đếm mẫu ≥100 khoảnh khắc).
- E1 Given lỗi upload/auth/Places/chi phí vượt ngưỡng cảnh báo, When mô phỏng, Then cảnh báo tới người trực trong ≤15 phút (A14).

**DODAY-SAFE-10 – Server chặn nội dung công khai trong 1.0.** Binary 1.0 không chứa giao diện công khai; server là lớp chặn thứ hai. **Không** dùng cờ server để bật tính năng công khai ẩn sẵn trong binary 1.0. Apple yêu cầu tính năng phải rõ ràng với người dùng và App Review, cấm tính năng ẩn/không tài liệu hóa (App Review Guidelines, truy cập 30/10/2026, đoạn "hidden, dormant, or undocumented features").
- S1 Given bộ thử API (tạo, sửa, đổi quyền Moment), When gửi visibility = public, Then 100% yêu cầu bị từ chối và không có bản ghi công khai nào trong DB.
- E1 Given rà soát binary và chuỗi giao diện 1.0, When kiểm, Then không có màn, nút hay chuỗi cho đăng công khai, báo cáo hay chặn.

**DODAY-SAFE-11 – Giới hạn độ tuổi (DEC-02 = 13+) và đồng ý của người đại diện cho 13–15 tuổi.** Đăng ký hỏi năm sinh (BR-A9). Dưới 13: không tạo tài khoản. 13–15: cần xác nhận của cha mẹ/người giám hộ theo cơ chế DEC-24 trước khi lưu ảnh hoặc vị trí lên server (BR-A10). 16+: đăng ký bình thường.
- S1 Given năm sinh cho thấy người dùng ≥16 tuổi, When đăng ký, Then tài khoản tạo bình thường; server chỉ lưu năm sinh hoặc nhóm tuổi, không lưu ngày sinh đầy đủ [PROPOSED].
- S2 Given người dùng 13–15 tuổi và người đại diện xác nhận theo DEC-24, When xác nhận hoàn tất, Then tài khoản chuyển "đã đồng ý", có bản ghi đồng ý (thời điểm, phương thức, phiên bản chính sách) và upload được bật.
- E1 Given năm sinh cho thấy dưới 13 tuổi, When đăng ký, Then không tạo tài khoản, không lưu email/năm sinh đã nhập, hiện thông báo trung tính.
- E2 Given tài khoản 13–15 chưa có xác nhận của người đại diện, When chụp, Then ảnh chỉ lưu trên máy, không có yêu cầu upload hay Places có tọa độ nào rời thiết bị (kiểm bằng log mạng).
- E3 Given người đại diện rút lại đồng ý, When hệ thống nhận yêu cầu, Then upload dừng và dữ liệu của tài khoản đó được xử lý như xóa tài khoản (privacy-and-data.md §5) trong thời hạn đã công bố.
- E4 Given bảng hỏi age rating App Store hiện hành, When khai báo cho bản 1.0 chỉ riêng tư, Then câu trả lời khớp tính năng thực tế của binary (không có UGC chia sẻ) và tuổi tối thiểu 13 được thực thi trong app.

**DODAY-SAFE-12 – Hạn mức upload và dung lượng riêng tư.** **APPROVED A6/A7:** ≤200 ảnh/ngày/tài khoản, nguồn ≤20 MB, avatar ≤10 MB, storage ≤5 GB/tài khoản; reset ngày 00:00 Việt Nam. Đây là chống lạm dụng, không cấp sẵn 25 TB hoặc hạn chế chụp. Admission tổng xét thumbnail/truyền tải/backup và trần tiền, ưu tiên hơn quota cá nhân; chưa triển khai.
- S1 Given tài khoản, nguồn và ngân sách tổng còn hợp lệ, When upload ảnh thứ 200 trong ngày, Then thành công; nguồn >20 MB bị từ chối upload, vẫn giữ nháp/nguồn local.
- S2 Given reset 00:00 Việt Nam và mọi gate tài khoản/byte/ngân sách/privacy còn cho phép, When hàng đợi ảnh chờ chạy, Then tiếp tục upload bản đã bỏ GPS không thao tác thêm, không replay lookup cũ.
- E1 Given đã đạt hạn mức ngày, When chụp thêm, Then ảnh vẫn lưu trên máy (Q-03 không đổi), trạng thái là "Đã lưu trên máy – chờ tải lên (đạt giới hạn hôm nay)", không hiển thị lỗi mất ảnh, không retry dồn dập (≤1 lần thử/giờ).
- E2 Given đạt dung lượng tối đa, When upload, Then server trả mã lỗi riêng, app báo rõ số dung lượng đã dùng và hướng xóa bớt; không xóa tự động ảnh nào.
- E3 Given client gửi trực tiếp vượt hạn mức (bỏ qua app), When server nhận, Then trả 429 có thời điểm thử lại và không ghi đối tượng storage nào.
- S3 Given ngân sách ảnh DEC-07 đã duyệt và còn đủ dung lượng dự báo cả backup, When server cấp quyền upload, Then ghi giữ chỗ byte cho đúng tài khoản và tổng hệ thống trước khi cấp URL ký; đối soát usage bỏ giữ chỗ thất bại, không đếm trùng retry.
- E4 Given hạn mức tài khoản còn nhưng ngân sách tổng sắp hết, When ≥50 yêu cầu upload đồng thời, Then không cấp vượt phần byte/chi phí đã giữ chỗ; ảnh dư vẫn ở nháp, ảnh đã đồng bộ không bị tự xóa. Không coi dừng upload là ngừng chi phí storage cũ (`budget-and-capacity.md` §3.3).
- E5 Given bản sao ảnh hết cửa sổ lưu 35 ngày, When chạy lifecycle và thử restore ở G10, Then object/thumbnail đã xóa không còn trong backup quá hạn và dấu xóa được áp lại, không tái hiển thị nội dung đã xóa.

**DODAY-L10N-01 – Giao diện tiếng Việt và tiếng Anh (DEC-01).** Tiếng Việt là ngôn ngữ phát triển và mặc định; tiếng Anh là bản dịch đầy đủ. App theo ngôn ngữ thiết bị/ngôn ngữ riêng của app trong Cài đặt iOS; ngôn ngữ không hỗ trợ → tiếng Việt. Bao gồm chuỗi giao diện, purpose string quyền, thông báo lỗi, email (OTP/xác nhận người đại diện), Privacy Policy/Terms/Support (bản tiếng Việt là bản gốc [PROPOSED]), metadata App Store hai ngôn ngữ. Yêu cầu Places dùng tham số ngôn ngữ theo ngôn ngữ giao diện.
- S1 Given thiết bị đặt tiếng Anh, When mở mọi màn J1–J4, Then 100% chuỗi do Doday quản lý hiển thị tiếng Anh (kiểm bằng rà soát String Catalog: 0 khóa thiếu bản dịch).
- S2 Given thiết bị đặt tiếng Việt, When mở mọi màn, Then 100% chuỗi tiếng Việt có dấu đầy đủ, ngày giờ và số theo định dạng vi-VN (ví dụ 4,6/5; 2.350).
- E1 Given thiết bị đặt ngôn ngữ khác (ví dụ tiếng Nhật), When mở app, Then giao diện tiếng Việt.
- E2 Given Dynamic Type cỡ lớn nhất ở cả hai ngôn ngữ, When mở camera, Map và chi tiết địa điểm, Then không có chữ bị cắt làm mất nút thao tác chính.
- E3 Given dữ liệu Google trả về bằng ngôn ngữ khác ngôn ngữ giao diện, When hiển thị, Then giữ nguyên dữ liệu Google (không tự dịch) và nhãn nguồn vẫn đúng ngôn ngữ giao diện.

## 7. Ca nghiệm thu – Google Maps Platform (GGL)

**DODAY-GGL-01 – Field mask, quota, chi phí.** COST + A10/A11 đã duyệt proxy/reservation/fail-closed, định giá bảo thủ, ledger/reset/alerts/retry/breaker; quota/forecast thực theo B7 trước G6. Các ca chưa kiểm thử.
- S1 Given bảng field mask theo màn hình (`privacy-and-data.md` §6), When kiểm tra mọi yêu cầu Places trong 1 phiên thử, Then 100% yêu cầu có field mask khớp bảng, không dùng `*`.
- S2 Given quota/ngân sách DEC-09, When mô phỏng vượt quota, Then app hiển thị dự phòng (BR-P6) và cảnh báo chi phí kích hoạt.
- E1 Given Places trả 429/5xx, When mở chi tiết, Then tối đa 2 retry có backoff/Retry-After trong ngân sách/quyền còn cho phép (A10), sau đó hiện lỗi, không vòng lặp.
- S3 Given các phiên Autocomplete hoàn tất, bỏ dở và không hợp lệ, When đối soát token, field mask và billing export ở G6/G10, Then phân biệt Session Usage/Requests và SKU Details kết thúc theo B2, sai lệch số lượt do app gửi = 0; không thêm `reviews` nếu chưa có lệnh xem review dù SKU kết thúc là Atmosphere.
- E2 Given ngân sách tháng còn đủ đúng 1 cuộc gọi và ≥50 request/retry **cùng SKU** đến đồng thời, When proxy giữ chỗ theo giá SKU tối đa, Then chỉ tối đa 1 cuộc gọi trả phí được gửi; phần còn lại đi dự phòng BR-P6, không mất nháp/URL. Khi bộ đếm lỗi thì 0 cuộc gọi trả phí đi qua; không có khóa/endpoint bỏ qua proxy.
- E3 Given mất cảnh báo billing hoặc API chỉ hỗ trợ quota theo phút, When thử hết ngân sách tháng, Then bộ đếm tháng vẫn dừng cuộc gọi trả phí; không coi cảnh báo 100% hay USD/tháng chia 30 là quota request đúng. Lưu bảng phân bổ và bằng chứng đối soát (`budget-and-capacity.md` §2.3).

**DODAY-GGL-02 – Ghi nguồn, tách nội dung (BR-P9).**
- S1 Given mọi màn hiển thị nội dung Places, When rà soát theo checklist attribution hiện hành, Then 100% màn đạt (logo Google Maps hoặc text attribution khi không nằm trên Google Map; attribution tác giả ảnh/review khi có).
- E1 Given màn có cả dữ liệu Google và Doday, When rà soát, Then hai khối có nhãn nguồn riêng.

**DODAY-GGL-03 – Chính sách lưu theo từng trường.**
- S1 Given bảng lưu trữ trong `privacy-and-data.md` §6 đã được LEGAL duyệt, When rà soát schema và cache, Then không có trường Places nào lưu ngoài phạm vi bảng.
- E1 Given chính sách Google thay đổi, When phát hiện, Then cập nhật bảng và tạo việc sửa trước lần phát hành kế tiếp.

**DODAY-GGL-04 – Từng review Google on-demand (M-1.0, DEC-14/28 thay hoãn cũ).**
- S1 Given địa điểm có review và quota còn, When người dùng yêu cầu xem review, Then Details chỉ thêm trường cần `reviews`/attribution; mỗi review hiển thị tác giả/attribution được cung cấp, thời gian, liên kết gốc và cách sắp xếp theo Google, không review tự tạo Doday.
- S2 Given chỉ mở Map/chi tiết hoặc xem rating/tổng lượt, When trace request, Then 0 yêu cầu trường `reviews`; có lối xem thêm trên Google Maps, không biến việc kết thúc Autocomplete thành tải review.
- E1 Given Google lỗi/429/quota hết, When mở review, Then khối review báo không tải được, retry hữu hạn; ảnh riêng tư/SavedPlace/nhật ký vẫn đọc được, rating/tổng lượt hiện riêng nếu có dữ liệu hợp lệ.
- E2 Given Google không trả review hoặc thiếu trường attribution tùy chọn, When mở khối, Then trạng thái trống hoặc chỉ dữ liệu thực có; không bịa tác giả/avatar hoặc scrape review để bù, không lưu review vào kho nội dung Doday.

**DODAY-GGL-05 – Địa điểm đã di chuyển (OPT).**
- S1 Given dữ liệu thử có movedPlaceId, When mở nơi cũ, Then hiện "Địa điểm đã chuyển" và lối mở nơi mới; SavedPlace cũ không bị tự đổi.
- E1 Given CLOSED_PERMANENTLY không có movedPlaceId, When mở, Then chỉ hiện "Đã đóng cửa", không gợi ý địa điểm thay thế phỏng đoán.

**DODAY-GGL-06 – Đối soát Place ID.**
- S1 Given Place ID trả NOT_FOUND hoặc hết hiệu lực, When làm mới theo hướng dẫn Google, Then Place được đánh dấu, thử làm mới ID; khoảnh khắc không mất.
- E1 Given nơi thủ công liên kết sau với Google Place đã có trong Doday, When xác nhận, Then dữ liệu của người dùng chuyển sang Place đó, không tạo bản trùng, không gộp khoảnh khắc của người khác.

**DODAY-GGL-07 – Bảo vệ API key.**
- S1 Given bản build, When kiểm tra binary/bundle, Then chỉ có key iOS bị giới hạn theo bundle ID và API; không có khóa backend.
- E1 Given dùng key iOS từ bundle ID khác, When gọi, Then bị Google từ chối.

## 8. Ca nghiệm thu – Bổ sung ADD

**DODAY-DATA-05 – Dữ liệu Doday và khả năng hoạt động khi Google lỗi.** Nguồn trường độc lập, Place ID nội bộ; nhật ký cá nhân thuộc 1.0 theo DATA-07, friends/community vẫn ngoài binary.
- S1 Given mạng và Doday hoạt động, mọi provider Google trả 503/hết quota, When chụp, lưu nháp rồi đồng bộ ảnh riêng tư, Then Q-01/03 không đổi, upload tới Doday không đợi Google, SavedPlace/Collection/Moment của chủ vẫn đọc được.
- S2 Given Google lỗi và có ảnh/địa điểm Doday đã lưu cục bộ, When thiết bị offline, Then xem được dữ liệu đã có và lưu nháp; trạng thái không nhận là đã đồng bộ hoặc đã chia sẻ qua mạng.
- S3 Given Google lỗi nhưng Doday/mạng hoạt động, When mở nhật ký cá nhân, Then đọc được Moment/thời điểm đã đồng bộ của chủ, gồm ảnh hidden/không nơi; không gọi Google để dựng lại nhật ký.
- E1 Given tọa độ Google cache quá TTL, When mở/pan Map, Then 0 Places call, không dùng tọa độ quá hạn; SavedPlace/ID giữ trong danh sách theo BR-P8/DEC-29, không lấy GPS hiện tại bù.
- E2 Given 1.0 private-only, When kiểm fallback, Then không public/friends/tracking; nhật ký vẫn là dữ liệu riêng của chủ. Ca cộng đồng chỉ áp dụng bản PUB được duyệt riêng, không tính từ chối public là giao cộng đồng.
- E3 Given Doday backend cũng lỗi, When upload/xem ảnh chưa tải, Then báo đúng chờ/lỗi Doday, không hứa Google độc lập nghĩa mọi chức năng mạng vẫn dùng; nguồn nháp vẫn còn theo Q-04.

**DODAY-DATA-06 – Privacy revision và tác vụ cũ.** APPROVED A4/DEC-31 theo phụ lục §3.3; đổi Hide/zone/công tắc bảo vệ vô hiệu job cũ, không tái gửi bằng quyền cũ.
- S1 Given lookup mới nằm trong queue chưa gửi, When bật Hide hoặc thêm zone bao vùng ảnh, Then trước dequeue kiểm revision mới, 0 request chứa tọa độ bảo vệ rời máy và ảnh vẫn lưu/upload không GPS.
- S2 Given lookup đã gửi trước khi Hide được bật, When response đến muộn, Then không gắn/hiển thị Place hoặc tự retry; ghi rõ không thể thu hồi tọa độ đã gửi, không báo là chưa từng gửi.
- E1 Given offline rồi đổi Hide/zone, When có mạng và hàng đợi cũ được khôi phục sau kill app, Then mọi job xét lại quyền hiện hành; không có payload/retry chứa GPS bị ẩn, không dùng vị trí lúc upload thay nguồn ảnh.
- E2 Given job của tài khoản A và đăng nhập B, When resume background/extension, Then 0 lookup/upload/zone của A chạy dưới B; policy của A không bị coi là của B.
- E3 Given 2 thiết bị gửi revision cũ hoặc visible/hidden xung đột, When server áp dụng mutation, Then hidden thắng, response không trả Place/GPS ngoài quyền, yêu cầu cũ không ghi đè; báo giới hạn cập nhật tới thiết bị đang offline.

**DODAY-PRIV-01 – Hide Location hiện tại và tương lai.** ADD §3/4, OVERRIDE/DEC-25/26: ảnh không Place hợp lệ, 1.0 riêng tư; quy tắc public không nơi chỉ PUB. Hide bật mặc định đã APPROVED qua ZONE/DEC-31 ngày 31/10/2026.
- S1 Given ảnh hiện tại có Place, When bật Hide bằng 1 thao tác, Then `display_place_id` hiển thị là null, ảnh vẫn lưu riêng tư được, 0 tọa độ ảnh gửi nhận diện từ thời điểm bật.
- S2 Given bật Hide cho ảnh mới, When chụp/chọn ≥10 ảnh và mở lại app cùng tài khoản, Then mọi ảnh mới hidden, không cần chọn lại sau mỗi ảnh, không lookup bằng GPS/EXIF của chúng.
- S3 Given ảnh ẩn từng có liên kết địa điểm, When xem qua API, Map, trang địa điểm và số đếm, Then không lộ Place/địa chỉ/tọa độ hoặc quan hệ từ ảnh đó; SavedPlace độc lập không bị xóa. Với người khác, chỉ áp dụng ở bản chia sẻ được duyệt và vẫn đòi quyền ảnh riêng.
- S4 Given thiết bị/cấu hình mới chưa có lựa chọn Hide được người dùng xác nhận, When mở camera và chụp/chọn ≥10 ảnh, Then Hide mặc định bật, ảnh không có địa điểm hiển thị và 0 tọa độ ảnh gửi nhận diện; không hỏi quyền riêng tư sau từng ảnh, không tự tắt Hide vì đã cấp GPS.
- E1 Given đang lookup, When bật Hide, Then hủy phần chưa gửi, bỏ kết quả đến muộn theo DATA-06, không nhận diện qua retry hoặc dịch vụ khác.
- E2 Given Google lỗi/hết quota và ảnh không Place, When lưu, Then không buộc chọn nơi, Q-03 vẫn áp dụng; việc chia sẻ nếu được duyệt không cần Google, nhưng không tự bật public trong 1.0.
- E3 Given tắt Hide cho ảnh mới, When xem ảnh cũ đã hidden, Then chúng không tự hiện lại vị trí và không có request “bù” cho ảnh cũ; không suy Hide-off thành consent công khai.

**DODAY-PRIV-02 – Home Privacy Zone.** APPROVED ZONE + BATCH-AB/DEC-31: local-only, radius 200 m (100–1.000 m); quản lý vùng/công tắc mặc định bật, có thể tắt tại Cài đặt. Heuristic/consent/revision đã duyệt, không sync/cloud backup, không hứa GPS bảo vệ tuyệt đối. Tắt zone không tắt Hide (độc lập/mặc định bật) hoặc bỏ gate khác.
- S1 Given bảo vệ vùng bật và tọa độ ảnh trong 1 trong ≥2 zone, When chụp/chọn/xử lý, Then hidden, 0 tọa độ/địa chỉ/marker zone gửi nhận diện/phân phối, vẫn lưu ảnh; chọn Place thủ công không tự bỏ bảo vệ.
- S2 Given mẫu GPS hợp lệ chắc chắn ngoài mọi zone, Hide tắt và có consent/trigger hợp lệ, When yêu cầu nhận diện, Then được xét qua gate; kết quả không tự public hoặc Visited.
- S3 Given tài khoản thử tạo zone trên máy A, When giữ mặc định rồi lần lượt chỉnh radius 100 m/1.000 m và mở lại app, Then giá trị lưu đúng 200/100/1.000 m theo từng bước; zone chỉ trong kho cục bộ của tài khoản, không có tâm/radius trong backend, queue đồng bộ, cloud backup hoặc máy B đăng nhập cùng tài khoản.
- S4 Given cấu hình mới hoặc cùng tài khoản đã đặt vùng và mở lại app, When vào Cài đặt → Vùng riêng tư, Then công tắc mặc định bật ở cấu hình mới, vùng/thay đổi cùng tài khoản được giữ local; thêm/sửa/xóa không cần bước xác nhận sau từng ảnh, không có tâm/radius/trạng thái tắt trong cloud backup/sync.
- S5 Given vùng đã tạo và người dùng tắt bảo vệ tại Cài đặt, When chụp ảnh mới rồi mở lại app, Then trạng thái tắt giữ đúng tài khoản/máy và danh sách vùng không mất; Hide còn bật hoặc consent chưa có thì 0 tọa độ gửi; chỉ khi Hide đã tắt riêng, consent/input/trigger còn hợp lệ mới được lookup, ảnh vẫn owner-only.
- E1 Given bảo vệ bật và vòng sai số GPS giao mép zone, When phân loại, Then `UNCERTAIN` hoặc `INSIDE`, 0 lookup ngoài máy, không chọn gần nhất để đoán.
- E2 Given bảo vệ bật và GPS thiếu/cũ/gần đúng/accuracy không hợp lệ, When chụp, Then ẩn/no outbound, không thêm bước bắt buộc để lưu; zone-off không làm GPS đó đủ điều kiện tự gắn BR-L3.
- E3 Given bảo vệ bật và ảnh thư viện không GPS, When thiết bị đang ngoài zone, Then không dùng GPS hiện tại kết luận an toàn, ảnh hidden/no lookup và vẫn lưu được.
- E4 Given máy mới/cấu hình zone chưa xác minh hoặc A đổi sang B chưa có cấu hình riêng đã xác nhận, When chụp, Then không coi thiếu cấu hình là ngoài vùng; bảo vệ và Hide mặc định bật, không lộ zone tài khoản khác/tự nhận đã khôi phục từ cloud. Cấu hình riêng hợp lệ của B không bị thay bằng của A.
- E5 Given nhập radius 99 m/1.001 m, giá trị rỗng hoặc không phải số, When lưu zone, Then không lưu giá trị ngoài 100–1.000 m/không hợp lệ; thông báo lỗi và giữ cấu hình hợp lệ trước đó, không tự tắt Hide hay gửi tọa độ để sửa lỗi.
- E6 Given job chưa gửi/response đang bay và ảnh cũ hidden, When tắt rồi bật công tắc hoặc sửa vùng trước send/retry/receive, Then revision tăng/job cũ vô hiệu, 0 phát lại tọa độ hoặc hiện Place ảnh cũ; bật lại đánh giá gate trước mọi tác vụ mới, tọa độ đã gửi không được báo đã thu hồi.
- E7 Given A đã tắt bảo vệ và B chưa có cấu hình riêng đã xác nhận, When đăng xuất/đăng nhập B, mở extension hoặc B dùng máy mới/cấu hình chưa xác minh, Then B mặc định bật bảo vệ và Hide, không kế thừa cờ tắt/zone/job của A; 0 tọa độ nhận diện trước lựa chọn/gate hợp lệ của B.

**DODAY-PRIV-03 – ACL ảnh và địa điểm độc lập.** DEC-26/32 đã chốt 1.0 owner/hidden; nguyên tắc friends/public chỉ áp dụng bản chia sẻ được duyệt riêng. Rào backend không thay bằng ẩn UI.
- S1 Given 2 tài khoản và ảnh riêng tư có/ẩn Place của A, When B gọi API trực tiếp, URL ảnh/thumbnail, reverse place lookup, tìm kiếm hoặc số đếm, Then 0 dữ liệu ảnh/Place/GPS/quan hệ riêng của A được trả (Q-13).
- S2 (PUB) Given bản chia sẻ đã được duyệt phát hành riêng và có nhóm thử bạn bè, When thử 4 tổ hợp ADD §3 với mặc định hai trục, Then quyền ảnh/địa điểm kiểm riêng; public ảnh/hidden nơi không lộ nơi; friends ảnh/public nơi không lộ ID/nội dung/quan hệ tới ảnh cho người ngoài friends. Không áp dụng 1.0, không tính đã giao friends.
- E1 Given server nhận hidden hoặc privacy state không hợp lệ/không xác định, When tạo/sửa và đọc khoảnh khắc, Then không trả tọa độ/Place/địa chỉ/marker cho người khác, không tự nâng audience.
- E2 Given binary/API 1.0 nhận `photo_visibility` hoặc `location_visibility` là friends/public, When tạo/sửa, Then 4xx, dữ liệu vẫn owner/hidden; không có endpoint social hoặc quyền công khai GPS nguồn (SAFE-10).
- E3 Given client khai báo hidden/zone-blocked nhưng chèn tọa độ vào request nhận diện hoặc payload Moment, When backend kiểm hợp đồng, Then từ chối 4xx trước provider và không persist/log GPS; cờ không được tự override bởi field do client gửi.
- E4 Given ảnh vẫn chỉ owner trong 1.0, When gửi trực tiếp audience friends/public ở một trong hai trục, Then bị 4xx/403 và không có tài nguyên public được tạo.

**DODAY-PRIV-04 – GPS, EXIF, logs và retention.** APPROVED ZONE + A1/A9/DEC-31: GPS RAM ≤60 s; mọi ảnh/thumbnail upload bỏ GPS; log ≤30 ngày/no dữ liệu nhạy cảm. TTL RAM khác ảnh gốc/zone/cache Google.
- S1 Given ≥20 ảnh có GPS/EXIF và thumbnail từ S-PRIVLOC, When xử lý/upload mọi trạng thái Hide/zone bật hoặc tắt, Then 0 file upload kể cả riêng tư chứa EXIF GPS; gốc local không bị ghi đè, Place hợp lệ liên kết riêng không bị xóa chỉ vì bỏ metadata.
- S2 Given dùng tọa độ canary giả đã biết trong thử nghiệm, When chạy camera/zone/lookup bị chặn, lỗi backend và crash giả lập, Then logs, analytics, proxy request logs, breadcrumbs và crash reports có 0 tọa độ canary/zone, không có request body hoặc URL chứa chúng (QP-01).
- E1 Given mẫu GPS canary được nhận tại t0, When thử ở t0+59 s, t0+60 s, t0+61 s và khôi phục app/retry sau hết hạn, Then mẫu chỉ được giữ trong RAM trước hạn khi tác vụ còn cần, không còn dùng/giữ sau tối đa 60 s; không DB/queue/backup/log hoặc bản làm tròn, không reset TTL khi retry. Xóa zone/tài khoản hủy mẫu liên quan; cache Place/tâm zone/EXIF nguồn theo chính sách riêng, không là kho mẫu để nạp lại bỏ qua TTL.
- E2 Given GPS lúc chụp khác GPS khi upload và nguồn thư viện thiếu EXIF, When retry upload, Then không bổ sung GPS hiện tại, không gửi ảnh gốc có metadata thay bản xử lý để “cứu” lỗi.

**DODAY-GGL-08 – Trigger API và gate nhu cầu.** Ma trận phụ lục §4/DEC-27 đã thay trigger theo ảnh; thông số ngữ cảnh/phép đo còn chốt trước G2.
- S1 Given ≥100 chuỗi mở app/camera, chụp nhiều ảnh, mở/pan/zoom Map nhưng không tìm/chọn chi tiết, When trace outbound qua app và proxy, Then 0 Places/Photos/Reviews/Geocoding/Routes call (QP-02); network tải bản đồ SDK được báo riêng, không gọi là Places.
- S2 Given người dùng chủ động nhập/tìm hoặc yêu cầu gần đây và gate riêng tư cho phép, When thực hiện tác vụ hợp lệ, Then chỉ API được phép gọi, Autocomplete có token đúng; không gửi GPS bị Hide làm bias. Mỗi lookup Nearby gắn request context hợp lệ, không gắn tự động vào mọi ảnh.
- S3 Given mở một khối thông tin chi tiết hoặc chạm chỉ đường, When xử lý, Then Details chỉ trường cần khối đó, không `*`/ảnh/reviews không dùng; chỉ đường là Maps URL không chứa origin GPS nguồn/zone, 0 Routes call.
- E1 Given Hide/zone/uncertain hoặc quyền nhận diện thiếu, When chụp/tìm và thử queue/retry, Then 0 tọa độ bảo vệ tới bất kỳ dịch vụ nhận diện; tìm theo tên người dùng nhập không lén thêm location bias.
- E2 Given binary 1.0 có Photos/từng review nhưng người dùng chưa yêu cầu xem các khối này, When chạy J1–J4, Then 0 Photo media/`reviews` requests; 0 Routes/Geocoding trong các luồng đó, rating/tổng lượt tách riêng. Mở ảnh/review chủ động được thử ở GGL-04/10, không lấy request thụ động làm ca hợp lệ.

**DODAY-GGL-09 – Quota, đồng thời, retry và circuit breaker.** COST + A10/A11 duyệt proxy/reservation/fail-closed và tham số phụ lục §4; B7 chốt quota/forecast thực trước G6, chưa cấu hình/kiểm thử. Search ≥2 ký tự/400 ms; tối đa 2 retry tạm thời/tác vụ; breaker 5 lỗi/60 s, nghỉ 60 s, 1 probe.
- S1 Given cùng tài khoản/policy revision/field mask có ≥50 request trùng đồng thời, When tới proxy, Then chỉ 1 request provider đang bay cho cùng thao tác, kết quả không gửi chéo quyền/tài khoản; retry không đếm miễn phí hoặc bypass reservation.
- S2 Given bộ đếm người dùng/dịch vụ còn hạn mức, When đạt đúng quota đã chốt, Then request tiếp theo bị chặn trước provider với thời điểm thử lại; camera/lưu nháp không bị chặn theo quota Google.
- E1 Given lỗi liên tiếp đạt 5 trong 60 s (thử biên 4/5/6), When request mới tới, Then OPEN không gọi provider; sau 60 s HALF_OPEN tối đa 1 probe, chỉ đóng khi thành công; không probe tính phí khi hết trần/bộ đếm lỗi.
- E2 Given 429/5xx/timeout hoặc 4xx cố định, When client/proxy retry, Then số lần ≤giới hạn đã chốt, có backoff/Retry-After, không client và server nhân retry vượt giới hạn tác vụ; 4xx cố định không retry. Bộ đếm gồm mọi attempt gửi.
- E3 Given alert ngân sách không gửi hoặc quota phút vẫn còn nhưng trần tháng hết, When gọi, Then cơ chế ngân sách độc lập từ chối cuộc gọi trả phí, không coi alert là công tắc; không tự nâng ngân sách.
- E4 Given cache Google hết TTL/không có giấy phép lưu trường hoặc privacy revision đã đổi, When tìm cache/gom request, Then không trả payload quá hạn/trái quyền, không tự refresh vì Map mở; không ghi kết quả đồng thời thành cache lâu dài trái chính sách.

**DODAY-GGL-10 – Ảnh Google Places theo nhu cầu xem.** M-1.0 theo ADD §1/OVERRIDE/DEC-28; ảnh bên ngoài, không phải ảnh upload của người dùng Doday và không áp crop BR-M10 lên dữ liệu Google.
- S1 Given người dùng yêu cầu xem ảnh Google của nơi X và quota còn, When tải, Then chỉ lấy metadata `photos`/attribution cần thiết rồi media cho ảnh thực sự yêu cầu, kích thước phù hợp; attribution Google/tác giả khi nguồn cung cấp hiển thị cùng ảnh (P5).
- S2 Given chỉ mở app/Map/bottom sheet/chi tiết, When trace, Then 0 Photo media request và không lấy `photos` chỉ để prefetch; ảnh bìa dùng ảnh Doday có quyền hoặc biểu tượng, không tải ngầm Google.
- E1 Given media trả lỗi/name hết hạn/không có ảnh, When mở ảnh, Then khối ảnh có lỗi/trống, không retry vô hạn, không chặn lưu nơi/xem Doday; chỉ tác vụ xem còn hiệu lực mới được thử metadata mới trong hạn mức chung.
- E2 Given kiểm DB/object store/backup/CDN Doday sau phiên xem, When đối chiếu nguồn, Then không có bytes ảnh Google hoặc photo name được cache bền vững; không đổi nhãn thành ảnh Doday để giữ lâu. Cache SDK/HTTP chỉ theo chính sách được LEGAL duyệt, không suy TTL tọa độ sang ảnh.
- E3 Given hạn mức Photo media riêng hoặc ngân sách Google chung hết, When yêu cầu xem nhiều ảnh đồng thời, Then proxy chặn trước provider, fallback riêng khối ảnh; không tăng trần DEC-09 hoặc dùng URL/media đi vòng bộ đếm.

**DODAY-DATA-07 – Nhật ký cá nhân từ Moment đã lưu.** APPROVED A12/DEC-30: trong Khoảnh khắc của tôi ở Profile, không tab mới; B3 hoàn thiện UI ở G2. Chỉ nội dung chủ động lưu, không thu đường đi.
- S1 Given chủ có ≥30 Moment khác ngày/múi giờ, gồm không nơi/hidden, When mở nhật ký, Then mỗi Moment chưa xóa xuất hiện đúng 1 lần, thứ tự theo thời điểm chụp/nguồn ảnh đã lưu, không theo lúc upload; ảnh thiếu thời gian nguồn dùng thời gian tạo nháp có nhãn tương ứng, không bịa ngày.
- S2 Given Google lỗi/hết quota, Doday còn hoạt động hoặc dữ liệu nhật ký đã tải cục bộ, When mở lại, Then đọc được nội dung đã có không gọi Places; offline không hứa tải ảnh chưa có, hiển thị trạng thái chờ tương ứng.
- E1 Given B đăng nhập sau A hoặc gọi API nhật ký A trực tiếp, When truy cập cả ảnh/thumbnail/quan hệ, Then không có dữ liệu A trả về; queue/cached view không chuyển A sang B (DATA-02).
- E2 Given Moment hidden/zone/không nơi, When xem nhật ký/nhóm theo ngày, Then không suy ra Place/tọa độ từ EXIF, GPS hiện tại hoặc reverse lookup; 0 quyền vị trí nền và không dựng tuyến đường, không tự đặt Visited.
- E3 Given xóa Moment/xóa tài khoản hoặc sửa trên thiết bị khác, When đồng bộ/xem nhật ký, Then áp BR-A6/DEC-12: không bản trùng, xóa thắng, không khôi phục ảnh đã xóa từ backup; không tạo bản sao nhật ký có retention riêng.

## 9. Tự rà soát backlog

- 30/30 ID MVP có mặt, đúng thứ tự SRC §15, không trùng (kiểm bằng lệnh đếm khi lập; xem `README.md` §6).
- 69/69 yêu cầu có nguồn, ưu tiên, phụ thuộc, vai trò phụ trách và ≥1 ca S + ≥1 ca E; ADD/OVERRIDE truy vết riêng, không đổi 30 ID MVP.
- Mọi yêu cầu có phần PUB đều có ca riêng cho 1.0 (tiền tố `1.0-` hoặc ghi chú phạm vi), để không ca nào của 1.0 đòi hỏi giao diện công khai. Đã rà lại MVP-02, 03, 09, 10, 11, 12, 13, 15, 25, 26, 27 và SAFE-01, 05, 07, 10 sau review G1 ngày 30/10/2026.
- Không có yêu cầu nào thuộc danh mục ngoài phạm vi (`product-spec.md` §4.3).
- Sau DEC-15 C (30/10/2026): SAFE-03/04/05/06 là PUB toàn phần; phần công khai MVP-03/09/10/11/13/15/25/26/27 và SAFE-07 tách rõ. Ca kiểm quyền riêng tư của MVP-26 trong 1.0 không tính là đã giao chức năng cộng đồng.
- Mọi vai trò phụ trách: **chủ dự án kiêm nhiệm** (31/10/2026, giờ Việt Nam).
