# Doday G2 – Sổ quyết định

Trạng thái: **APPROVED** (01/11/2026, G2-SIGNOFF) · Ngày lập: 31/10/2026 (Asia/Ho_Chi_Minh) · Người lập: Technical Lead iOS/UX/QA (trợ lý), chưa phải người duyệt

**Quy tắc.** Baseline G1 (`../g1/`, APPROVED 31/10/2026) giữ nguyên, không sửa tài liệu G1 trong G2. Quyết định mới chỉ ghi `APPROVED` khi có nguồn duyệt thật của Chủ dự án, kèm ngày và phạm vi. Đề xuất của người lập ghi `PROPOSED`. Việc thiếu bằng chứng hoặc thẩm quyền ghi `BLOCKED`. Không quyết định nào trong sổ này sửa quyết định G1. Nếu cần sửa, sẽ trình riêng ở §4.

## 1. Đối chiếu roadmap ban đầu với quyết định G1 đã duyệt

G2 áp dụng cột phải. Roadmap và lịch sử G1 không bị sửa.

| Nội dung roadmap/SRC ban đầu | Quyết định G1 áp dụng cho G2 | Nguồn |
| --- | --- | --- |
| J3 có khám phá cộng đồng, marker/ảnh của người khác | 1.0 private-only. J3 chỉ dùng tìm kiếm Google (fixture ở G2) và dữ liệu của chính chủ tài khoản; không có điều khiển public/friends | DEC-15/18/26 |
| Review từng người có thể hoãn sang 1.1 | Photos và từng review thuộc 1.0, chỉ tải khi người dùng bấm xem | DEC-14 → DEC-28 (OVERRIDE) |
| Nhận diện sau chụp dễ bị hiểu là lookup mỗi ảnh | 0 request mới do chụp/lưu. Chỉ tái dùng ngữ cảnh hợp lệ, hoặc lookup khi người dùng chủ động | DEC-27, addendum §4 |
| Map dựng marker từ dữ liệu Google theo viewport | Không gọi Places khi mở/pan/zoom. Thiếu dữ liệu hợp lệ thì dùng danh sách, không vẽ marker giả | DEC-29 |
| Pipeline ảnh chưa quy định | Ghi nguồn + nháp trước; chuẩn hóa hướng, cắt giữa 1:1, ≤2048/≤400 px, không phóng lớn, không bước duyệt crop | DEC-07/CROP, BR-M10/M11 |
| Có thể dùng app khi chưa đăng nhập | Đăng nhập trước lần chụp đầu. G2 dùng tài khoản mẫu; Q-17 đánh giá rào cản | DEC-17 |
| Project universal `1,2` | iPhone-first, iPad chạy chế độ tương thích. Target G2 dùng family `1`; target phát hành sửa ở G3 | DEC-03 |
| Zone (cách hiểu cũ: không tắt được trong 1.0) | Công tắc “Ẩn trong vùng riêng tư” mặc định bật, tắt được trong Cài đặt. Hide độc lập, mặc định bật | BATCH-AB §4, DEC-31 |
| Places gọi trực tiếp từ app | Places Web Service chỉ qua proxy, có reservation nguyên tử và fail-closed | DEC-09/COST, A10–A11 |
| Đọc metadata TikTok/Instagram | Chỉ URL/text do Share Sheet đưa vào; metadata chỉ khi LEGAL xác minh quyền theo từng nguồn | DEC-21, A13/B6 |

## 2. Quyết định và đề xuất G2

| ID | Nội dung | Trạng thái | Nguồn / người / ngày | Phạm vi và giới hạn |
| --- | --- | --- | --- | --- |
| G2-DEC-01 | Phương án triển khai G2: app `DodayG2` + `G2Core` + `DodayG2ShareExtension` + test, tách khỏi target `Doday` qua `project-g2.yml`. Nháp dùng SwiftData + file. Adapter fixture/live tách riêng. Google Maps SDK 11.2.0 pin qua SPM. Proxy lab Node. Live Google khóa, chi phí 0 USD | **APPROVED** | Chủ dự án trả lời “Duyệt” cho phương án trình ngày 31/10/2026, sau đó “Tiếp tục công việc” | Chỉ duyệt phương án triển khai/thử. **Không** gồm duyệt UX cuối, chi live, xác minh LEGAL, kết quả đo hay nghiệm thu G2 |
| G2-DEC-02 | Kiến trúc lưu cục bộ: SwiftData cho bản ghi nháp, `autosave` tắt, lưu tường minh. Nguồn/phái sinh là file ghi nguyên tử. Policy/SavedIntent/Inbox là JSON nguyên tử. Thư mục theo SHA-256(accountID). Loại khỏi iCloud backup, `completeFileProtectionUnlessOpen` | **APPROVED** | Chủ dự án chọn trong hộp hỏi đáp của thread G2, 01/11/2026; đề xuất của người lập 31/10/2026, so sánh ở technical-spikes §S2 | Duyệt trên bằng chứng Simulator/unit theo G2-DEC-14. DEV-04 (kill app trên iPhone thật) chưa chạy, chuyển G4; lỗi phát hiện ở đó được mở lại quyết định. Không phải sync G3 |
| G2-DEC-03 | Metadata ảnh: dùng PhotosPicker + `FileRepresentation` + ImageIO. Không xin quyền thư viện. Ảnh không có GPS thì để không nơi, không thay bằng GPS hiện tại. Đọc `DateTimeOriginal` để hiện “Chụp lúc”, nếu không có thì hiện “Thời điểm thêm” | **APPROVED** | Chủ dự án chọn trong hộp hỏi đáp của thread G2, 01/11/2026; khớp A9, J1b, WWDC23 10107 | Duyệt theo G2-DEC-14. Việc metadata có thực sự đi qua picker hay không (kể cả khi người dùng tắt Location trong Options) chưa kiểm trên máy thật (DEV-02, chuyển G4) |
| G2-DEC-04 | **B3 – cảnh báo ảnh thư viện lệch >1 km:** so GPS **của chính ảnh** với tọa độ Place đang gắn, chạy trên máy. Chỉ dùng khi ảnh không Hide **và** (zone tắt, hoặc ảnh chắc chắn ngoài mọi vùng đã xác nhận, với biên = sai số EXIF hoặc 50 m nếu thiếu). Lệch → hộp thoại “Vẫn gắn / Lưu không nơi / Hủy”. Không bao giờ dùng GPS hiện tại | **APPROVED** | Chủ dự án chọn trong hộp hỏi đáp của thread G2, 01/11/2026; backlog MVP-06 E1, B3 | Ngưỡng 1 km theo B3, biên 50 m. “Vẫn gắn” vẫn qua gate vùng (G2-DEC-13). Q-17 chưa chạy (G2-DEC-14) |
| G2-DEC-05 | **movedPlace tùy chọn:** khi Details trả `movedPlaceId`, khối thông tin hiện “Địa điểm này đã chuyển”, cho mở nơi mới. Không tự đổi Place ID, Moment, bộ sưu tập hay Đã ghé. `CLOSED_PERMANENTLY` không có `movedPlaceId` thì chỉ báo đóng cửa, không gợi ý thay thế | **APPROVED** | Chủ dự án chọn trong hộp hỏi đáp của thread G2, 01/11/2026; backlog GGL-05 S1/E1 | Trường thuộc Essentials IDs Only (docs 30/10/2026). Mới thử bằng fixture; dữ liệu live thuộc G6 |
| G2-DEC-06 | Ba phạm vi Hide: chip một chạm trên Camera = **ảnh sắp chụp**; công tắc ở màn xem lại = **ảnh này**; Cài đặt = **mặc định ảnh mới**. Chip không đổi mặc định | **APPROVED** | Chủ dự án chọn trong hộp hỏi đáp của thread G2, 01/11/2026; addendum §3.1 | Q-17 chưa chạy (G2-DEC-14), nên chưa có số liệu người dùng hiểu đúng ba phạm vi |
| G2-DEC-07 | “Gần tôi” trên Map: yêu cầu mẫu vị trí mới. Qua cùng gate với nhận diện (Hide mặc định ảnh mới, consent, zone, ≤50 m, ≤60 s). Bị chặn thì giải thích và gợi ý tìm theo tên/khu vực | **APPROVED** | Chủ dự án chọn trong hộp hỏi đáp của thread G2, 01/11/2026. Addendum §4 ghi “kiểm Hide…” trước Nearby nhưng không nói Hide nào; Chủ dự án chọn hướng chặt hơn (Hide mặc định ảnh mới) | Là cách hiểu addendum §4, không sửa G1. Với mặc định (Hide ảnh mới bật), “Gần tôi” bị chặn cho tới khi người dùng tắt Hide mặc định |
| G2-DEC-08 | B1 – T_auto/T_confirm/TTL ngữ cảnh: phương pháp hiệu chỉnh và khóa ngưỡng ở measurement-plan §3 | PROPOSED · giá trị **hoãn sang đầu G5** (G2-DEC-15) | Người lập | Chưa có dữ liệu hiệu chỉnh thực địa nên **không** chọn giá trị. Giá trị `0.95/0.6/20 s` trong mã là fixture minh họa, không phải ngưỡng. Phải khóa trước phép đo G5 |
| G2-DEC-09 | B2 – thiết bị/iOS/hồ sơ mạng: đề xuất ở measurement-plan §2 | PROPOSED · **hoãn sang đầu G5** (G2-DEC-15) | Người lập | Chủ dự án xác nhận model đang có trước phép đo G5 |
| G2-DEC-10 | Trần thử Google live nhỏ, đề xuất tối đa 5 USD cho một đợt smoke | **NOT APPROVED** | Người lập đề xuất 31/10/2026 | Chưa ai duyệt. Live vẫn khóa trong mã (`PlacesLab.liveAuthorized = false`, proxy `/live` trả 423). Duyệt trần thử **chưa đủ** để chạy spike: đường live chưa được tích hợp (technical-spikes §S5, điều kiện 6), và việc viết đường này cũng phải được duyệt riêng. Trần tháng 6.000 USD không phải quyền chi thử. Theo G2-DEC-15, G2 không chạy live; trần thử, đường live và khóa xét lại ở đầu G5 |
| G2-DEC-11 | B6 – bảng nguồn–trường–quyền–TTL–attribution–fallback, metadata TikTok/Instagram, lọc business status | **APPROVED** (LEGAL) | Chủ dự án (kiêm LEGAL), thread G2, 01/11/2026: “Xác nhận B6: L-1 -> L-9”. Danh sách L-1…L-9 ở technical-spikes §B6 | Xác nhận đúng chín mục đã liệt kê, không rộng hơn. Không suy một ngoại lệ (Place ID, tọa độ) sang trường khác. Không mở Google live (G2-DEC-10/15) và không cho đọc metadata TikTok/Instagram (L-6). Đây là xác nhận quyền; purge ≤30 ngày, attribution, chỉ dùng bản đồ Google với dữ liệu live và Terms/Privacy công khai (L-8) vẫn phải được làm và kiểm ở cổng sau (G3 schema, G6, trước phát hành). Người lập không ký thay LEGAL |
| G2-DEC-12 | Codec/chất lượng/byte cuối | Ngoài G2 (B-G4) | DEC-07/B3 | G2 chỉ thăm dò bằng JPEG 0,85, không chốt |
| G2-DEC-13 | **Vùng riêng tư thắng việc gắn Place**, theo addendum §3.2 / DEC-31. Khi bảo vệ vùng bật, ảnh `inside` hoặc `uncertain` không được gắn Place, kể cả chọn thủ công. Bằng chứng duy nhất được dùng: ảnh thư viện xét GPS của chính ảnh; ảnh chụp xét mẫu vị trí tin cậy lấy trong 60 giây sau khi chụp, ở đúng revision policy. Thiếu bằng chứng thì là `uncertain`. Hệ quả: với mặc định (bảo vệ bật, danh sách vùng chưa xác nhận), ảnh không gắn được nơi cho tới khi người dùng xác nhận vùng và kiểm vị trí kịp lúc, hoặc chủ động tắt bảo vệ trong Cài đặt | **APPROVED** | Người lập đề xuất 01/11/2026 sau review P1; Chủ dự án chọn trong hộp hỏi đáp của thread G2, 01/11/2026 (“Chặn, giữ đề xuất”). Quy tắc gốc đã APPROVED ở G1 | Duyệt cả hai điểm: (a) mốc 60 giây sau khi chụp; (b) ảnh thư viện không có GPS bị chặn gắn Place khi bảo vệ bật. J1b (“không có dữ liệu thì để không nơi, cho chọn thủ công sau”) được hiểu là chỉ áp dụng khi bảo vệ tắt hoặc ảnh chắc chắn ở ngoài vùng; không sửa G1. Chi phí UX chưa đo vì Q-17 chưa chạy |
| G2-DEC-14 | **Miễn iPhone thật và Q-17 khỏi điều kiện duyệt G2.** G2 được trình duyệt dù chưa có DEV-01…14 trên máy thật và chưa có phiên Q-17 với 5 người | **APPROVED** (ngoại lệ) | Chủ dự án, thread “G2 Review”, 01/11/2026: “Chấp nhận duyệt kể cả khi không kiểm thử trên iPhone thật và với 5 người.” | Chỉ bỏ hai mục này khỏi điều kiện chặn G2. Các ca vẫn là NOT_RUN/BLOCKED, **không** ghi đạt. Không mở Google live, không thay B6. Cổng nhận lại, Chủ dự án chấp nhận 01/11/2026 (“Chấp nhận cổng đề xuất. Duyệt G2.”): DEV-01…06 và DEV-14 → G4; DEV-07/08 → đầu G5 (G2-DEC-15); DEV-09 → G6; DEV-10…13 → G8; Q-17 → trước khi khóa UI Camera/nháp ở G4 |
| G2-DEC-15 | **Hoãn Google live, Q-05/06 sơ bộ và B1/B2 sang đầu G5.** Trước phép đo thực địa đầu tiên của G5 phải có: đường live được duyệt riêng và viết xong (technical-spikes §S5 điều kiện 1–6), trần thử được duyệt, B2 chọn thiết bị, một đợt đo nhỏ cho số liệu khả thi Q-06 (tỷ lệ ảnh có ngữ cảnh hợp lệ, coverage trên D_allowed), rồi B1 khóa T_auto/T_confirm/TTL | **APPROVED** (hoãn) | Chủ dự án chọn trong hộp hỏi đáp của thread G2, 01/11/2026 (“Hoãn sang đầu G5”) | Q-06 vẫn “tạm chốt” (G1 DEC-20, R-04) tới đợt đo đó. Nếu Q-06 không khả thi, quyết định đổi trigger phải ghi trước phép đo nghiệm thu G5, không hạ ngưỡng Q-05 ≥95%/Q-06 ≥30%. G3/G4 làm tiếp với rủi ro này; phần backend/camera ít phụ thuộc. Live vẫn khóa, chi 0 USD |
| G2-SIGNOFF | **Nghiệm thu G2** với các ngoại lệ G2-DEC-14 và các mục hoãn G2-DEC-15 | **APPROVED** | Chủ dự án, thread G2, 01/11/2026: “Chấp nhận cổng đề xuất. Duyệt G2.” | Duyệt prototype, spike, bằng chứng Simulator/unit/proxy và các quyết định G2-DEC-01…07, 11, 13–15. **Không** gồm: kết quả máy thật/Q-17 (vẫn NOT_RUN, nhận lại theo cổng ở G2-DEC-14), Google live/Q-05/06/B1/B2 (đầu G5), trần thử G2-DEC-10 (NOT APPROVED), hay quyền bắt đầu G3 (điều kiện riêng ở README §5) |

## 3. Câu hỏi cần Chủ dự án trả lời trước khi trình nghiệm thu

Tình trạng ngày 01/11/2026:

1. ~~Duyệt UX prototype sau Q-17, gồm G2-DEC-04/05/06~~ → G2-DEC-04…07 APPROVED; Q-17 được miễn cho G2 (G2-DEC-14).
2. ~~Chốt G2-DEC-07~~ → APPROVED, hướng chặt hơn.
3. ~~Chốt G2-DEC-02 sau DEV-04~~ → APPROVED trên bằng chứng Simulator; DEV-04 chuyển G4.
4. ~~Thiết bị B2 (G2-DEC-09)~~ → hoãn sang đầu G5 (G2-DEC-15).
5. ~~Live Google (G2-DEC-10)~~ → hoãn sang đầu G5 (G2-DEC-15). G2-DEC-10 vẫn NOT APPROVED; live giữ khóa.
6. ~~LEGAL xác nhận B6~~ → G2-DEC-11 APPROVED, L-1…L-9 (Chủ dự án kiêm LEGAL).
7. ~~Xác nhận G2-DEC-13~~ → APPROVED cả hai điểm.
8. ~~Chốt cổng nhận lại các ca đã miễn~~ → chấp nhận theo đề xuất ở G2-DEC-14.

## 4. Đề xuất sửa quyết định G1

Không có. G2 không đề xuất sửa quyết định G1 nào. G2-DEC-07 (Hide nào áp cho “Gần tôi”) và G2-DEC-13 (J1b “chọn thủ công sau” khi bảo vệ vùng bật) là cách hiểu G1 đã được Chủ dự án chọn, không phải thay đổi. Tài liệu G1 giữ nguyên.

## 5. Nhật ký

| Ngày | ID | Thay đổi | Người xác nhận |
| --- | --- | --- | --- |
| 31/10/2026 | G2-DEC-01 | Trình phương án G2 → APPROVED | Chủ dự án, tin “Duyệt” |
| 31/10/2026 | – | Lượt triển khai đầu dừng giữa chừng do lỗi provider; tiếp tục theo “Tiếp tục công việc”, không đổi phạm vi đã duyệt | Chủ dự án |
| 31/10/2026 | G2-DEC-02…12 | Ghi đề xuất/chặn sau khi triển khai prototype và spike | Người lập; chưa được duyệt |
| 01/11/2026 | – | Hoãn thử iPhone thật (DEV-01…14) vì chưa có cáp kết nối. Chủ dự án tự chạy `DodayG2` trên Simulator và nhận xét “đã ổn”. Đây là nhận xét không chính thức, **không** phải duyệt UX, Q-17 hay bằng chứng thực địa. G2 vẫn IN_PROGRESS | Chủ dự án |
| 01/11/2026 | G2-DEC-13 | Sửa hai lỗi P1 do review phát hiện: chọn Place thủ công vượt bảo vệ vùng, và ảnh đang nhập lưu nhầm tài khoản. Ghi cách áp dụng quy tắc vùng ở dạng PROPOSED. Sửa tài liệu Google live (đường live chưa tích hợp) và điều kiện Q-06 sơ bộ | Người lập; chưa được duyệt |
| 01/11/2026 | G2-DEC-14 | Ghi ngoại lệ: duyệt G2 không cần iPhone thật và Q-17 với 5 người. Các ca vẫn NOT_RUN | Chủ dự án, thread “G2 Review” |
| 01/11/2026 | G2-DEC-02…07, 13, 15 | Duyệt G2-DEC-02/03/04/05/06/07 đúng như prototype; duyệt G2-DEC-13 (“Chặn, giữ đề xuất”); hoãn Google live/Q-05/06/B1/B2 sang đầu G5. B6: Chủ dự án chọn tự xác minh với vai trò LEGAL | Chủ dự án, hộp hỏi đáp thread G2 |
| 01/11/2026 | G2-DEC-11 | B6 → APPROVED cho L-1…L-9. Mọi điều kiện README §4 đã đạt, được miễn hoặc được hoãn có duyệt → G2 chuyển **READY_FOR_REVIEW**. Chưa APPROVED | Chủ dự án (kiêm LEGAL), tin “Xác nhận B6: L-1 -> L-9” |
| 01/11/2026 | G2-SIGNOFF | G2 → **APPROVED**; chấp nhận cổng nhận lại ở G2-DEC-14. Không tự bắt đầu G3 | Chủ dự án, tin “Chấp nhận cổng đề xuất. Duyệt G2.” |
