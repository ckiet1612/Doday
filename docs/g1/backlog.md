# Doday 1.0 – Ma trận yêu cầu và backlog (G1)

Trạng thái: READY_FOR_REVIEW · Ngày lập: 30/10/2026 · Ưu tiên và phân giai đoạn bên dưới là [PROPOSED], chưa được duyệt.

## 1. Quy ước

**Nhóm ID**

- `DODAY-MVP-01…30`: ánh xạ một-một với danh sách 30 hạng mục tại SRC §15, đúng số thứ tự nguồn. Không đánh số lại, không thay thế.
- `DODAY-EXT-*`: Share Extension và dán liên kết (SRC §5.3, §7, §13.4). Đưa vào 1.0 phụ thuộc DEC-13.
- `DODAY-DATA-*`: dữ liệu bền vững, tài khoản, đồng bộ (ROADMAP G1, G3, G4, G7).
- `DODAY-SAFE-*`: an toàn phát hành, quyền riêng tư, kiểm duyệt, vận hành (SRC §17.8–17.9, ROADMAP §1, Apple A1/A2).
- `DODAY-GGL-*`: tuân thủ và chi phí Google Maps Platform (SRC §6.8, §13.6, §17.6–17.7).

**Ưu tiên** (không nhầm với mức lỗi P0/P1/P2 của roadmap)

- `M-CORE`: bắt buộc 1.0, cần cho alpha cá nhân (G4–G7).
- `M-1.0`: bắt buộc 1.0, cần trước Release Candidate (G8–G11).
- `OPT`: tùy chọn 1.0, có thể hoãn 1.1 theo quyết định.

**Vai trò** (tất cả **chờ chỉ định** – chưa có người cụ thể): PO chủ sản phẩm · TL trưởng kỹ thuật · iOS · BE backend · DES thiết kế · QA kiểm thử · SEC an toàn/bảo mật · OPS vận hành, hỗ trợ, kiểm duyệt · LEGAL pháp lý/chính sách. Cột "Phụ trách" ghi vai trò chính trước, vai trò phối hợp sau dấu "+".

**Ca nghiệm thu**: viết Given/When/Then; mỗi yêu cầu có ít nhất một nhánh thành công (S) và một nhánh lỗi/biên (E). Ngưỡng định lượng tham chiếu Q-xx trong `quality-and-acceptance.md` và đều đang ở trạng thái đề xuất. Mọi ca hiện **chưa kiểm thử**.

## 2. Ma trận truy vết

| ID | Yêu cầu | Nguồn | Ưu tiên | Giai đoạn (xây → nghiệm thu cuối) | Phụ thuộc | Phụ trách |
| --- | --- | --- | --- | --- | --- | --- |
| DODAY-MVP-01 | Đăng ký và đăng nhập | SRC §15.1, §10 | M-CORE | G3 → G10–G11 | DEC-05, DEC-06, DEC-17 | BE + iOS, QA |
| DODAY-MVP-02 | Hồ sơ cơ bản | SRC §15.2, §10 | M-CORE | G3 → G10–G11 | MVP-01 | iOS + BE |
| DODAY-MVP-03 | Thiết lập quyền riêng tư | SRC §15.3, §4.5, §10 | M-CORE | G3, G9 → G10–G11 | MVP-01, DEC-11 | iOS + BE, SEC |
| DODAY-MVP-04 | Camera-first | SRC §15.4, §4.1 | M-CORE | G4 → G10–G11 | MVP-01, DEC-04 | iOS + DES |
| DODAY-MVP-05 | Chụp ảnh và chọn ảnh thư viện | SRC §15.5, §4.1, §4.4 | M-CORE | G4 → G10–G11 | MVP-04, DATA-01 | iOS |
| DODAY-MVP-06 | Tự lấy vị trí và nhận diện địa điểm | SRC §15.6, §4.4, §17.1 | M-CORE | G2 thử, G5 → G10–G11 thực địa | MVP-05, MVP-18, GGL-01 | iOS + BE, QA |
| DODAY-MVP-07 | Xác nhận hoặc sửa địa điểm | SRC §15.7, §4.2 | M-CORE | G5 → G10–G11 | MVP-06, MVP-14 | iOS + DES |
| DODAY-MVP-08 | Tiêu đề ngắn tùy chọn | SRC §15.8, §4.3 | M-CORE | G4 → G10–G11 | MVP-05 | iOS |
| DODAY-MVP-09 | Lưu ảnh và chia sẻ khoảnh khắc | SRC §15.9, §4.2 | M-CORE | G4, G9 → G10–G11 | DATA-01, SAFE-02, DEC-06 | iOS + BE |
| DODAY-MVP-10 | Chế độ công khai và riêng tư | SRC §15.10, §4.5 | M-1.0 | G4 (riêng tư), G9 (công khai) → G10–G11 | MVP-03, SAFE-02, SAFE-06, DEC-11 | BE + iOS, SEC |
| DODAY-MVP-11 | Map kết hợp Save và Discover | SRC §15.11, §5.1, §5.3 | M-CORE | G6, G9 → G10–G11 | DEC-08 | iOS + DES |
| DODAY-MVP-12 | Tag ghim địa điểm | SRC §15.12, §5.2, §5.4 | M-CORE | G6 → G10–G11 | MVP-11 | iOS + DES |
| DODAY-MVP-13 | Phân biệt địa điểm cá nhân và khám phá | SRC §15.13, §5.2 | M-CORE | G6, G9 → G10–G11 | MVP-12, MVP-30 | iOS + DES |
| DODAY-MVP-14 | Tìm kiếm địa điểm | SRC §15.14, §5.5 | M-CORE | G6 → G10–G11 | GGL-01, DEC-07 | iOS + BE |
| DODAY-MVP-15 | Lọc địa điểm | SRC §15.15, §5.5 | M-CORE | G6 → G10–G11 | MVP-20, MVP-30, GGL-03 | iOS + BE |
| DODAY-MVP-16 | Gom nhóm marker | SRC §15.16, §5.2, §17.5 | M-CORE | G6 → G10 | MVP-12 | iOS |
| DODAY-MVP-17 | Lưu vào bản đồ cá nhân | SRC §15.17, §5.3 | M-CORE | G7 → G10–G11 | MVP-18, DATA-03 | iOS + BE |
| DODAY-MVP-18 | Liên kết Google Place ID | SRC §15.18, §6.2 | M-CORE | G3, G5 → G10 | DEC-06 | BE |
| DODAY-MVP-19 | Tên và địa chỉ địa điểm | SRC §15.19, §6.3 | M-CORE | G6 → G10–G11 | MVP-18, GGL-01, GGL-02 | iOS + BE |
| DODAY-MVP-20 | Trạng thái hoạt động | SRC §15.20, §6.4 | M-CORE | G6 → G10–G11 | MVP-19 | iOS + BE, QA |
| DODAY-MVP-21 | Giờ mở cửa khi có dữ liệu | SRC §15.21, §6.5 | M-CORE | G6 → G10–G11 | MVP-19 | iOS + BE, QA |
| DODAY-MVP-22 | Điểm đánh giá và tổng lượt đánh giá | SRC §15.22, §6.6 | M-CORE | G6 → G10–G11 | MVP-19, GGL-02 | iOS + BE |
| DODAY-MVP-23 | Mở địa điểm trên Google Maps | SRC §15.23, §6.7 | M-CORE | G6 → G10–G11 | MVP-18 | iOS |
| DODAY-MVP-24 | Chỉ đường bằng Google Maps | SRC §15.24, §6.7 | M-CORE | G6 → G10–G11 | MVP-18 | iOS |
| DODAY-MVP-25 | Trang chi tiết địa điểm | SRC §15.25, §8.1 | M-CORE | G6, G9 → G10–G11 | MVP-19…24, GGL-02 | iOS + DES |
| DODAY-MVP-26 | Xem ảnh và trải nghiệm công khai | SRC §15.26, §8.2 | M-1.0 | G9 → G10–G11 | MVP-10, SAFE-03…06 | iOS + BE |
| DODAY-MVP-27 | Chia sẻ khoảnh khắc tại địa điểm | SRC §15.27, §8.3 | M-1.0 | G9 → G10–G11 | MVP-05, MVP-10, MVP-25 | iOS + BE |
| DODAY-MVP-28 | Quản lý danh sách đã lưu | SRC §15.28, §9.1 | M-CORE | G7 → G10–G11 | MVP-17 | iOS + BE |
| DODAY-MVP-29 | Tạo và quản lý bộ sưu tập | SRC §15.29, §9.2 | M-CORE | G7 → G10–G11 | MVP-17, DATA-03 | iOS + BE |
| DODAY-MVP-30 | Want to visit và Visited | SRC §15.30, §9.3 | M-CORE | G7 → G10–G11 | MVP-17 | iOS + BE |
| DODAY-EXT-01 | Share Extension nhận URL/text | SRC §7.1, §13.4; ROADMAP §1 | M-1.0 (nếu DEC-13 duyệt) | G2 thử, G8 → G10–G11 máy thật | DATA-02, DEC-13 | iOS, QA |
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
| DODAY-SAFE-03 | Báo cáo nội dung và người dùng | SRC §17.9; Apple 1.2 | M-1.0 | G9 → G10–G11 | SAFE-07 | iOS + BE, OPS |
| DODAY-SAFE-04 | Chặn người dùng | Apple 1.2; ROADMAP G9 | M-1.0 | G9 → G10 | MVP-01 | BE + iOS |
| DODAY-SAFE-05 | Lọc nội dung, hạn mức, chống spam | SRC §17.9; Apple 1.2 | M-1.0 | G9 → G10 | DEC-06, DEC-15 | BE, SEC, OPS |
| DODAY-SAFE-06 | Loại metadata vị trí khỏi ảnh công khai | ROADMAP G9 | M-1.0 | G9 → G10 | DATA-01 | BE + iOS, SEC |
| DODAY-SAFE-07 | Công cụ kiểm duyệt, quy trình hỗ trợ, người trực | SRC §17.9; ROADMAP G1, G9 | M-1.0 | G9 → G11 | DEC-15 | OPS + BE |
| DODAY-SAFE-08 | Privacy Policy, Terms, Support công khai | SRC §17.7; Apple A1 | M-1.0 | G1 bắt đầu → G12A | DEC-01, DEC-12 | LEGAL + PO |
| DODAY-SAFE-09 | Giám sát, cảnh báo, backup/khôi phục | ROADMAP G10, §4 | M-1.0 | G3, G10 → G10 | DEC-06, DEC-10 | BE + OPS |
| DODAY-SAFE-10 | Cờ tắt tính năng công khai phía server | ROADMAP G1, G10 | M-1.0 | G3, G9 → G10 | DEC-15 | BE |
| DODAY-SAFE-11 | Giới hạn độ tuổi theo quyết định | Apple 1.2.1(a), A1 | M-1.0 | G3 → G12A | DEC-02 | PO + LEGAL, iOS |
| DODAY-GGL-01 | Field mask theo màn hình, quota, theo dõi chi phí | SRC §6.8, §13.6, §17.6 | M-CORE | G2, G6 → G10 | DEC-09 | BE + iOS |
| DODAY-GGL-02 | Ghi nguồn, attribution, tách nội dung Google/Doday | SRC §6.6, §6.9, §12, §17.7 | M-CORE | G6 → G12A | DEC-08 | iOS + DES, LEGAL |
| DODAY-GGL-03 | Chính sách lưu/cache theo từng trường Places | SRC §6.8, §14; GG1 | M-CORE | G3, G6 → G12A | LEGAL | BE, LEGAL |
| DODAY-GGL-04 | Nội dung từng review Google | SRC §6.6, §15 đoạn cuối | OPT (DEC-14) | G6 → G10 nếu làm | DEC-14, GGL-02 | iOS + BE, LEGAL |
| DODAY-GGL-05 | Thông báo địa điểm đã di chuyển | SRC §6.4 | OPT | G6 → G10 | MVP-20 | iOS + BE |
| DODAY-GGL-06 | Đối soát Place ID không hợp lệ / nơi thủ công liên kết sau | SRC §6.2; ROADMAP G5 | M-1.0 | G5 → G10 | MVP-18 | BE |
| DODAY-GGL-07 | Bảo vệ API key | SRC §13.6; GG3 | M-CORE | G3 → G10 | DEC-06 | BE + iOS, SEC |

Tổng: 30 MVP + 5 EXT + 4 DATA + 11 SAFE + 7 GGL = 57 yêu cầu.

## 3. Ca nghiệm thu – 30 hạng mục MVP

**DODAY-MVP-01 – Đăng ký và đăng nhập.** Tạo tài khoản và đăng nhập theo phương thức DEC-05; phiên lưu an toàn; hết phiên/đăng xuất/thu hồi phiên hoạt động.
- S1 Given người dùng mới, When hoàn tất đăng ký bằng phương thức đã duyệt, Then đúng 1 bản ghi User được tạo, token lưu trong Keychain và mở lại app không cần đăng nhập lại cho đến khi phiên hết hạn.
- S2 Given người dùng đã có tài khoản trên thiết bị khác, When đăng nhập, Then thấy đúng dữ liệu đã đồng bộ của tài khoản đó và không thấy dữ liệu tài khoản khác.
- E1 Given phiên đã hết hạn hoặc bị thu hồi, When app gọi API, Then API trả 401, app chuyển về màn đăng nhập trong ≤1 lần thao tác và các nháp cục bộ của tài khoản vẫn còn (đếm trước/sau bằng nhau).
- E2 Given người dùng hủy hoặc nhà cung cấp đăng nhập lỗi, When quay lại app, Then hiển thị thông báo lỗi có nút thử lại và không có bản ghi User nào được tạo.

**DODAY-MVP-02 – Hồ sơ cơ bản.** Ảnh đại diện, tên hiển thị, tên người dùng, giới thiệu ngắn [SRC §10].
- S1 Given đã đăng nhập, When sửa tên hiển thị và lưu, Then giá trị mới hiển thị trên thiết bị thứ hai sau khi làm mới.
- E1 Given tên người dùng đã tồn tại, When lưu, Then bị từ chối với thông báo "đã được dùng" và hồ sơ cũ không đổi.
- E2 Given ảnh đại diện vượt [PROPOSED] 10 MB hoặc định dạng không hỗ trợ, When chọn, Then báo lỗi, không upload.
- [NEEDS_CONFIRMATION] Trường nào hiển thị công khai cạnh khoảnh khắc công khai (đề xuất: ảnh đại diện + tên hiển thị). Người quyết định: PO.

**DODAY-MVP-03 – Thiết lập quyền riêng tư.** Mặc định hiển thị cho khoảnh khắc mới, danh sách người đã chặn, quản lý nội dung đã chia sẻ.
- S1 Given mặc định là Riêng tư (nếu DEC-11 duyệt), When chụp khoảnh khắc mới, Then lựa chọn hiển thị ban đầu là Riêng tư.
- S2 Given người dùng đổi mặc định, When chụp lần tiếp theo, Then lựa chọn ban đầu theo thiết lập mới; các khoảnh khắc cũ không đổi quyền.
- E1 Given offline, When đổi thiết lập, Then thay đổi được xếp hàng và áp dụng khi có mạng; không khoảnh khắc nào bị công khai do lỗi đồng bộ.

**DODAY-MVP-04 – Camera-first.** Sau xác thực/quyền lần đầu, mở app vào camera; không Home/Feed trung gian; một chạm sang Map.
- S1 Given đã đăng nhập và đã cấp quyền camera, When mở app từ trạng thái tắt hẳn, Then màn đầu tiên là camera với preview và nút chụp hoạt động, đạt Q-01.
- S2 Given đang ở camera, When chạm lối vào Map, Then Map hiển thị mà không cần chụp ảnh (1 chạm).
- E1 Given quyền camera bị từ chối, When mở app, Then hiện giải thích + nút mở Cài đặt + nút chọn ảnh thư viện + nút vào Map; không crash, không màn trắng.
- E2 Given không có mạng, When mở app, Then camera vẫn sẵn sàng trong ngưỡng Q-01 (không chờ backend).

**DODAY-MVP-05 – Chụp ảnh và chọn ảnh thư viện.** Camera trước/sau, flash khi phần cứng hỗ trợ, chọn ảnh qua trình chọn hệ thống.
- S1 Given camera sẵn sàng, When chụp, Then nháp được ghi bền vững đạt Q-03 và ảnh đúng hướng xoay.
- S2 Given chọn 1 ảnh HEIC hoặc JPEG từ thư viện, When xác nhận, Then nháp được tạo với ảnh hiển thị đúng; quyền thư viện toàn phần không bị yêu cầu chỉ để chọn ảnh.
- E1 Given thiết bị không hỗ trợ flash ở camera đang dùng, When mở camera, Then nút flash ẩn hoặc vô hiệu.
- E2 Given bộ nhớ thiết bị không đủ ghi ảnh, When chụp, Then báo lỗi "Không đủ dung lượng" và **không** hiển thị đã lưu.
- E3 Given cuộc gọi đến khi đang ở camera, When quay lại app, Then phiên camera khôi phục đạt Q-02.

**DODAY-MVP-06 – Tự lấy vị trí và nhận diện địa điểm.** Ba nhánh tự gắn/xác nhận/chưa gắn theo BR-L1…L6.
- S1 Given vị trí chính xác và một ứng viên vượt T_auto, When chụp, Then địa điểm được tự gắn; trên bộ thực địa, precision đạt Q-05 và coverage được báo theo Q-06.
- S2 Given ≥2 ứng viên trong bán kính độ chính xác, When chụp, Then không tự gắn mà hiện danh sách xác nhận.
- E1 Given quyền vị trí gần đúng hoặc từ chối, When chụp, Then không tự gắn (0 lần tự gắn trong bộ ca này) và ảnh vẫn lưu được.
- E2 Given ảnh thư viện không có GPS trong metadata, When chọn, Then không dùng vị trí hiện tại; chuyển sang chọn thủ công.
- E3 Given Places lỗi hoặc timeout [PROPOSED 5 s], When chụp, Then chip "Chưa xác định địa điểm" hiện và nút Xong vẫn hoạt động.

**DODAY-MVP-07 – Xác nhận hoặc sửa địa điểm.**
- S1 Given danh sách xác nhận có ứng viên đúng, When chạm ứng viên, Then gắn trong 1 chạm.
- S2 Given khoảnh khắc đã lưu gắn sai nơi, When sửa sang nơi khác, Then khoảnh khắc chỉ xuất hiện ở nơi mới (kiểm tra cả trang chi tiết nơi cũ và số đếm).
- E1 Given không có ứng viên đúng, When người dùng tìm theo tên, chọn trên bản đồ hoặc thêm thủ công, Then lưu được; nơi thủ công không có Google Place ID (BR-P3).

**DODAY-MVP-08 – Tiêu đề ngắn tùy chọn.**
- S1 Given màn xem lại, When chạm Xong mà không nhập tiêu đề, Then khoảnh khắc được lưu với tiêu đề rỗng.
- S2 Given nhập tiêu đề có dấu tiếng Việt và emoji, When lưu, Then hiển thị nguyên văn trên thiết bị thứ hai.
- E1 Given nhập vượt giới hạn BR-M1, When gõ thêm, Then không nhận ký tự vượt và hiện bộ đếm.

**DODAY-MVP-09 – Lưu ảnh và chia sẻ khoảnh khắc.** Lưu cục bộ trước, upload sau; trạng thái đồng bộ rõ ràng.
- S1 Given có mạng, When Xong, Then trạng thái đi qua "Đã lưu trên máy" → "Đang tải lên" → "Đã đồng bộ"; tỷ lệ hoàn tất upload đạt Q-09.
- S2 Given offline, When Xong, Then hiển thị "Đã lưu trên máy" (không phải "Đã đồng bộ"); khi có mạng tự upload.
- E1 Given bộ thử phục hồi (đóng app, timeout, retry, đổi mạng), When chạy ≥100 chu kỳ, Then 0 mất và 0 trùng (Q-04).
- E2 Given upload thất bại vĩnh viễn (ví dụ ảnh hỏng), When hết lượt retry, Then hiện "Lỗi, thử lại/xóa" và ảnh gốc trên máy không bị xóa.

**DODAY-MVP-10 – Chế độ công khai và riêng tư.**
- S1 Given khoảnh khắc có địa điểm, When chủ động chọn Công khai và Xong, Then tài khoản B thấy khoảnh khắc ở chi tiết địa điểm đó.
- S2 Given khoảnh khắc công khai, When chuyển Riêng tư, Then trong ≤[PROPOSED] 60 giây tài khoản B không thấy nó qua API, tìm kiếm, số đếm, ảnh bìa; URL ảnh cũ trả lỗi truy cập sau khi URL ký hết hạn ([PROPOSED] TTL ≤15 phút).
- E1 Given nháp chưa có địa điểm, When mở lựa chọn hiển thị, Then Công khai bị vô hiệu kèm lý do "Cần có địa điểm".
- E2 Given tài khoản B gọi API trực tiếp với ID khoảnh khắc riêng tư của A, When gửi yêu cầu, Then nhận 403/404 và không có dữ liệu ảnh (Q-13).
- E3 Given cờ công khai đang tắt (SAFE-10), When người dùng chọn Công khai, Then lựa chọn bị vô hiệu kèm thông báo.

**DODAY-MVP-11 – Map kết hợp Save và Discover.**
- S1 Given người dùng có nơi đã lưu và vùng có nơi công khai, When mở Map, Then cả hai lớp hiện trên cùng bản đồ, không có tab Save/Discover riêng.
- S2 Given chạm marker cộng đồng chưa lưu, When chạm Lưu trên bottom sheet, Then lưu trong 1 chạm mà không rời Map.
- E1 Given offline, When mở Map, Then nơi đã lưu đã đồng bộ vẫn hiện; lớp cộng đồng hiện thông báo không tải được.
- E2 Given người dùng mới chưa có dữ liệu, When mở Map, Then trạng thái trống hướng dẫn chụp hoặc lưu đầu tiên.

**DODAY-MVP-12 – Tag ghim địa điểm.**
- S1 Given một địa điểm có ảnh đại diện, When hiển thị, Then marker gồm tên (cắt ngắn) và ảnh/biểu tượng, không thêm thông tin khác [SRC §5.2].
- S2 Given chạm marker, When thả tay, Then bottom sheet hiện đúng các trường SRC §5.4 có dữ liệu.
- E1 Given địa điểm không có ảnh, When hiển thị, Then dùng biểu tượng mặc định, không để trống.

**DODAY-MVP-13 – Phân biệt địa điểm cá nhân và khám phá.** Bốn kiểu: đã lưu, đã ghé, cộng đồng chưa lưu, cộng đồng mới chia sẻ ([PROPOSED] ≤7 ngày).
- S1 Given bộ dữ liệu thử có đủ 4 kiểu, When hiển thị, Then mỗi kiểu có ký hiệu khác nhau không chỉ dựa vào màu (đạt kiểm tra mù màu và VoiceOver đọc đúng nhãn).
- S2 Given một nơi vừa đã lưu vừa có nội dung cộng đồng, When hiển thị, Then chỉ có 1 marker, thể hiện cả hai thuộc tính.
- E1 Given khoảnh khắc chuyển Riêng tư, When làm mới Map của tài khoản khác, Then nơi đó không còn kiểu "cộng đồng" nếu không còn khoảnh khắc công khai nào.

**DODAY-MVP-14 – Tìm kiếm địa điểm.** Theo tên, khu vực, loại; tìm trong nơi đã lưu; kết quả hiện thành marker [SRC §5.5]. Không cần AI (ROADMAP §1).
- S1 Given bộ truy vấn chuẩn [PROPOSED] 50 truy vấn (tên quán, "cà phê Đà Lạt", "nhà hàng Nhật"), When tìm, Then địa điểm đúng nằm trong top 5 ở ≥[PROPOSED] 90% truy vấn; kết quả hiện trên bản đồ.
- S2 Given bộ lọc "Đã lưu" bật, When tìm "Hà Nội", Then chỉ trả nơi đã lưu thuộc khu vực đó.
- E1 Given không có kết quả, When tìm, Then hiện trạng thái trống với lối thêm thủ công.
- E2 Given Places lỗi, When tìm, Then tìm trong nơi đã lưu vẫn hoạt động và hiện thông báo lỗi tìm kiếm Google.

**DODAY-MVP-15 – Lọc địa điểm.** Tất cả / đã lưu / đã ghé / cộng đồng / đang hoạt động / tạm đóng hoặc đã đóng [SRC §5.5].
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
- S1 Given hai tài khoản lưu cùng Google Place ID gần như đồng thời (≥[PROPOSED] 50 cặp yêu cầu song song), When hoàn tất, Then chỉ có 1 Place với Place ID đó.
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
- S1 Given địa điểm đủ dữ liệu, When mở, Then có đủ 5 phần, mỗi trường Google nằm trong khối có attribution theo GGL-02.
- S2 Given chạm "Chia sẻ địa điểm", When chọn ứng dụng nhận, Then nội dung chia sẻ là tên + liên kết Google Maps của địa điểm, không chứa tọa độ chụp của người dùng.
- E1 Given trường nào thiếu, When mở, Then trường đó ẩn hoặc ghi "Chưa có thông tin"; không hiển thị dữ liệu phỏng đoán.

**DODAY-MVP-26 – Xem ảnh và trải nghiệm công khai.**
- S1 Given địa điểm có khoảnh khắc công khai của nhiều tài khoản, When mở chi tiết, Then thấy ảnh, tiêu đề, thời gian, người chia sẻ; số đếm bằng số khoảnh khắc công khai hợp lệ.
- E1 Given chưa có khoảnh khắc công khai, When mở, Then trạng thái trống mời "chia sẻ đầu tiên".
- E2 Given khoảnh khắc bị ẩn do kiểm duyệt hoặc người đăng bị chặn, When mở, Then khoảnh khắc không xuất hiện và số đếm không tính nó.

**DODAY-MVP-27 – Chia sẻ khoảnh khắc tại địa điểm.** Từ trang chi tiết, chụp hoặc chọn ảnh với địa điểm đã điền sẵn.
- S1 Given đang ở chi tiết địa điểm X, When chạm "Chia sẻ trải nghiệm" và chụp, Then khoảnh khắc gắn X mà không chạy nhận diện GPS; lựa chọn hiển thị ban đầu theo MVP-03.
- E1 Given ảnh thư viện có GPS cách X > [PROPOSED] 1 km, When gắn vào X, Then hiện cảnh báo xác nhận nhưng vẫn cho lưu.
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

**DODAY-DATA-04 – Nháp khi chưa đăng nhập.**
- S1 (phương án A của DEC-17) Given chưa đăng nhập, When mở app, Then màn đăng nhập hiện trước camera, giải thích lý do.
- S1' (phương án B) Given chưa đăng nhập có 2 nháp, When đăng nhập tài khoản A và đồng ý chuyển, Then 2 nháp thuộc A; nếu không đồng ý, nháp vẫn ở vùng khách và không tự chuyển sang tài khoản nào sau đó.
- E1 Given nháp khách đã chuyển cho A, When B đăng nhập trên cùng máy, Then B không thấy các nháp đó.

## 6. Ca nghiệm thu – An toàn phát hành (SAFE)

**DODAY-SAFE-01 – Xóa tài khoản trong app.**
- S1 Given đã đăng nhập, When vào Profile → Xóa tài khoản và xác nhận, Then tài khoản không đăng nhập được nữa, khoảnh khắc công khai biến mất khỏi API công khai trong ≤[PROPOSED] 24 giờ và dữ liệu được xử lý theo `privacy-and-data.md` §5; người dùng nhận thông báo hoàn tất.
- E1 Given thao tác xóa không truy cập được mạng, When xác nhận, Then báo lỗi, không báo đã xóa.
- E2 Given dùng Sign in with Apple (nếu DEC-05 chọn), When xóa, Then token được thu hồi qua REST API của Apple [A2].

**DODAY-SAFE-02 – Phân quyền đối tượng.**
- S1 Given 2 tài khoản và bộ thử quyền (API đọc/sửa/xóa theo ID, URL ảnh/thumbnail trực tiếp, tìm kiếm, số đếm), When B truy cập tài nguyên riêng tư của A, Then 0 truy cập thành công (Q-13).
- E1 Given URL ảnh riêng tư bị lộ, When truy cập sau khi hết TTL URL ký, Then bị từ chối.

**DODAY-SAFE-03 – Báo cáo.**
- S1 Given khoảnh khắc công khai, When báo cáo với lý do, Then báo cáo vào hàng đợi kiểm duyệt có mã theo dõi; người báo cáo không còn thấy nội dung đó [PROPOSED].
- E1 Given báo cáo trùng từ cùng tài khoản, When gửi lại, Then không tạo báo cáo thứ hai.

**DODAY-SAFE-04 – Chặn người dùng.**
- S1 Given A chặn B, When A xem Map/chi tiết/Profile, Then không thấy nội dung của B, và ngược lại B không thấy nội dung của A, kiểm tra ở cả API.
- E1 Given A bỏ chặn, When làm mới, Then nội dung công khai hiển thị lại.

**DODAY-SAFE-05 – Lọc, hạn mức, chống spam.**
- S1 Given vượt hạn mức BR-C4, When đăng, Then bị từ chối với thông báo và thời điểm thử lại.
- E1 Given ảnh trong bộ thử nội dung vi phạm có nhãn, When đăng công khai, Then bị chặn hoặc vào hàng chờ duyệt theo chính sách DEC-15 (tỷ lệ phát hiện được báo cáo; ngưỡng [NEEDS_CONFIRMATION]).

**DODAY-SAFE-06 – Loại metadata vị trí khỏi ảnh công khai.**
- S1 Given ảnh có EXIF GPS được công khai, When tải ảnh qua URL công khai, Then không còn trường GPS (kiểm tra bằng công cụ đọc EXIF trên ≥20 ảnh).
- E1 Given ảnh định dạng HEIC/JPEG/PNG, When xử lý, Then cả ba đều không còn GPS.

**DODAY-SAFE-07 – Kiểm duyệt, hỗ trợ, người trực.**
- S1 Given diễn tập với moderator thật, When có báo cáo khẩn cấp và thông thường, Then tiếp nhận trong SLA Q-15; ẩn/gỡ nội dung, khóa tài khoản và nhật ký quyết định hoạt động.
- E1 Given chưa có người trực được chỉ định, When chuẩn bị beta ngoài, Then cờ công khai giữ tắt (BR-C3) – đây là điều kiện chặn, không phải lỗi.

**DODAY-SAFE-08 – Chính sách công khai.**
- S1 Given URL Privacy Policy, Terms, Support, When mở từ trình duyệt không đăng nhập và từ trong app, Then truy cập được và nội dung khớp dữ liệu/SDK thực tế.
- E1 Given thay đổi thu thập dữ liệu, When phát hành build mới, Then chính sách được cập nhật trước khi gửi review (kiểm tra trong checklist G12A).

**DODAY-SAFE-09 – Giám sát và khôi phục.**
- S1 Given môi trường cách ly, When khôi phục từ backup, Then đạt RPO/RTO Q-12 và quan hệ DB–ảnh còn toàn vẹn (đếm mẫu ≥100 khoảnh khắc).
- E1 Given lỗi upload/auth/Places/chi phí vượt ngưỡng cảnh báo, When mô phỏng, Then cảnh báo tới người trực trong ≤[PROPOSED] 15 phút.

**DODAY-SAFE-10 – Cờ tắt tính năng công khai.**
- S1 Given bật cờ tắt, When người dùng mở app phiên bản đã phát hành, Then không thể đăng công khai mới; nội dung công khai hiện có xử lý theo chế độ đã chọn (ẩn hoặc chỉ đọc) trong ≤[PROPOSED] 5 phút.
- E1 Given app không kết nối được cấu hình server, When mở, Then mặc định an toàn là không cho đăng công khai.

**DODAY-SAFE-11 – Giới hạn độ tuổi.**
- S1 Given ngưỡng tuổi DEC-02, When người dùng khai báo tuổi dưới ngưỡng ở đăng ký, Then không tạo được tài khoản (hoặc áp dụng chế độ hạn chế nếu DEC-02 chọn).
- E1 Given age rating khai báo trên App Store, When đối chiếu tính năng UGC, Then khớp câu trả lời bảng hỏi age rating hiện hành.

## 7. Ca nghiệm thu – Google Maps Platform (GGL)

**DODAY-GGL-01 – Field mask, quota, chi phí.**
- S1 Given bảng field mask theo màn hình (`privacy-and-data.md` §6), When kiểm tra mọi yêu cầu Places trong 1 phiên thử, Then 100% yêu cầu có field mask khớp bảng, không dùng `*`.
- S2 Given quota/ngân sách DEC-09, When mô phỏng vượt quota, Then app hiển thị dự phòng (BR-P6) và cảnh báo chi phí kích hoạt.
- E1 Given Places trả 429/5xx, When mở chi tiết, Then thử lại có giới hạn ([PROPOSED] tối đa 2 lần, backoff) rồi hiện thông báo; không vòng lặp gọi.

**DODAY-GGL-02 – Ghi nguồn, tách nội dung.**
- S1 Given mọi màn hiển thị nội dung Places, When rà soát theo checklist attribution hiện hành, Then 100% màn đạt (logo Google Maps hoặc text attribution khi không nằm trên Google Map; attribution tác giả ảnh/review khi có).
- E1 Given màn có cả dữ liệu Google và Doday, When rà soát, Then hai khối có nhãn nguồn riêng.

**DODAY-GGL-03 – Chính sách lưu theo từng trường.**
- S1 Given bảng lưu trữ trong `privacy-and-data.md` §6 đã được LEGAL duyệt, When rà soát schema và cache, Then không có trường Places nào lưu ngoài phạm vi bảng.
- E1 Given chính sách Google thay đổi, When phát hiện, Then cập nhật bảng và tạo việc sửa trước lần phát hành kế tiếp.

**DODAY-GGL-04 – Nội dung từng review Google (OPT, DEC-14).**
- S1 (nếu làm) Given địa điểm có reviews, When hiển thị, Then mỗi review có tác giả (ít nhất avatar), thời gian, liên kết gốc, thông báo cách sắp xếp ("Sắp xếp theo mức độ liên quan của Google") và nút "Xem thêm trên Google Maps".
- E1 (nếu hoãn) Given 1.0, When mở chi tiết, Then không có nội dung review riêng lẻ; vẫn có rating + tổng lượt (MVP-22) và nút xem trên Google Maps.

**DODAY-GGL-05 – Địa điểm đã di chuyển (OPT).**
- S1 Given dữ liệu thử có movedPlaceId, When mở nơi cũ, Then hiện "Địa điểm đã chuyển" và lối mở nơi mới; SavedPlace cũ không bị tự đổi.

**DODAY-GGL-06 – Đối soát Place ID.**
- S1 Given Place ID trả NOT_FOUND hoặc hết hiệu lực, When làm mới theo hướng dẫn Google, Then Place được đánh dấu, thử làm mới ID; khoảnh khắc không mất.
- E1 Given nơi thủ công liên kết sau với Google Place đã có trong Doday, When xác nhận, Then dữ liệu của người dùng chuyển sang Place đó, không tạo bản trùng, không gộp khoảnh khắc của người khác.

**DODAY-GGL-07 – Bảo vệ API key.**
- S1 Given bản build, When kiểm tra binary/bundle, Then chỉ có key iOS bị giới hạn theo bundle ID và API; không có khóa backend.
- E1 Given dùng key iOS từ bundle ID khác, When gọi, Then bị Google từ chối.

## 8. Tự rà soát backlog

- 30/30 ID MVP có mặt, đúng thứ tự SRC §15, không trùng (kiểm bằng lệnh đếm khi lập; xem `README.md` §6).
- 57/57 yêu cầu có nguồn, ưu tiên, phụ thuộc, vai trò phụ trách và ≥1 ca S + ≥1 ca E (trừ GGL-05 là OPT chỉ có S; nhánh lỗi của nó thuộc MVP-20 E1/MVP-18 E1).
- Không có yêu cầu nào thuộc danh mục ngoài phạm vi (`product-spec.md` §4.3).
- Mọi người phụ trách: **chờ chỉ định**.
