# G1 - Biên bản duyệt gộp A/B và phê duyệt cuối G1

Ngày ghi nhận: **31/10/2026, Asia/Ho_Chi_Minh**. Người xác nhận: **Chủ dự án, kiêm PO/TL và các vai trò đã nhận**. Đây là phê duyệt đặc tả và kế hoạch, không phải bằng chứng triển khai, kiểm thử hoặc tuân thủ pháp luật.

**Trạng thái hiện hành: APPROVED toàn bộ G1** qua G1-SIGNOFF ngày 31/10/2026 (§6). Phạm vi từng tin A/B và lịch sử trước khi ký cuối vẫn giữ dưới đây.

## 1. Nguồn và phạm vi

Nguồn **BATCH-AB** là tin xác nhận trực tiếp sau danh sách tổng hợp A1–A14/B1–B9 trong phiên G1:

> Duyệt toàn bộ mục A và mục B.
> Mặc định sẽ là ẩn vùng riêng tư (người dùng có thể chọn các vùng trong cài đặt) và có thể tắt ẩn vùng riênh tư trong cài đặt (mặc định là ẩn)

- **A:** duyệt chính sách/thông số đã trình, không yêu cầu duyệt lại từng mục này.
- **B:** duyệt hướng xử lý, bộ mẫu/tham số khởi điểm và thời điểm chốt theo bằng chứng. Không suy thành đã chọn nhà cung cấp/vùng, xác minh pháp lý, cấu hình quota hoặc đạt chỉ số.
- **C của danh sách tổng hợp:** tin BATCH-AB chưa bao gồm xác nhận toàn G1; tại thời điểm đó G1 giữ READY_FOR_REVIEW. Tin **G1-SIGNOFF** sau đó đã xác nhận mục C, xem §6; không diễn giải lại phạm vi tin A/B cũ.
- Đợt A/B này khác đợt B/C/D trước đó ở decisions §3. Không thay lịch sử hoặc diễn giải ngày duyệt cũ.
- Giữ **private-only 1.0**, trần Google/ảnh và 30 ID MVP. Không cho phép triển khai tính năng hoặc chuyển sang G2 trong lượt tài liệu này.

## 2. Mục A - Chính sách đã duyệt

| Mục | Nội dung APPROVED | Truy vết / bằng chứng phải có về sau |
| --- | --- | --- |
| A1 | Loại EXIF GPS khỏi mọi ảnh/thumbnail upload, kể cả riêng tư. Giữ ảnh gốc tại máy và liên kết Place riêng | DEC-07/31; BR-M8/10; PRIV-04, SAFE-06 (PUB). Kiểm bytes/metadata, không chỉ UI |
| A2 | Khi bảo vệ vùng bật: vùng sai số giao zone hoặc GPS thiếu/cũ/không đáng tin thì ẩn, không gửi tọa độ nhận diện; chọn Place không âm thầm bỏ bảo vệ. Cho tắt bảo vệ chủ động trong Cài đặt theo §4 | DEC-31; BR-L8; PRIV-02, QP-01. Không hứa GPS chính xác tuyệt đối |
| A3 | Consent nhận diện bên ngoài riêng, một lần và rút lại được; GPS iOS hoặc Hide-off không thay consent | DEC-31; PRIV-01/02, GGL-08. Chưa consent vẫn chụp/lưu |
| A4 | Kiểm policy trước gửi/retry/nhận kết quả, vô hiệu job/revision cũ, hidden thắng xung đột; không hứa thu hồi tọa độ đã gửi | DEC-31; DATA-06, PRIV-02, QP-01 |
| A5 | Ghi nguồn + nháp bền vững trước crop/nén; lỗi vẫn giữ nguồn, không báo synced/upload sai tỉ lệ/tạo Moment trùng khi retry | DEC-07; BR-M11; MVP-05/09, DATA-01, Q-03/04 |
| A6 | Chống lạm dụng: 200 ảnh/ngày/tài khoản, nguồn ≤20 MB, avatar ≤10 MB, storage ≤5 GB/tài khoản; ngày reset 00:00 giờ Việt Nam. Không chặn camera | DEC-07; SAFE-12, MVP-01/02. Không cam kết đã cấp 25 TB cho 5.000 tài khoản |
| A7 | Admission upload giữ chỗ byte/chi phí gồm thumbnail, truyền tải, backup; trần tổng ưu tiên hơn quota cá nhân; vượt giữ tại máy, không tự xóa ảnh synced. Backup object độc lập DB | DEC-07; SAFE-12/08, Q-12; ngân sách §3.3. Chi phí ảnh cũ vẫn tiếp tục |
| A8 | OTP 10 phút, dùng một lần, tối đa 5 yêu cầu/giờ, 5 lần nhập sai; đăng xuất phiên từ xa. Tài khoản khóa vẫn có đường xem/xuất dữ liệu chính chủ và xóa | DEC-05/12; MVP-01, BR-A7; privacy §7 |
| A9 | URL ảnh riêng tư ký TTL ≤15 phút; nội dung bị xóa ẩn ≤60 giây; log kỹ thuật ≤30 ngày, không GPS/ảnh/token nhạy cảm. Không tracking quảng cáo 1.0; picker hệ thống, không xin quyền rộng để lấy GPS | DEC-12/22/31; SAFE-01, PRIV-04; privacy §3–5 |
| A10 | Search ≥2 ký tự, debounce 400 ms; tối đa 2 retry cho lỗi tạm thời. Breaker 5 lỗi liên tiếp/60 giây, nghỉ 60 giây rồi 1 probe; không retry lỗi quyền vĩnh viễn/probe trả phí khi hết trần | DEC-09; GGL-01/09; phụ lục §4. Đây chưa là cấu hình chạy |
| A11 | Reservation bảo thủ theo SKU đắt nhất có thể tính; ledger chung, kỳ reset theo billing thực, không reset sớm/đếm đúp; alerts 50/80/100%. Forecast vẫn trừ miễn phí đúng một lần/SKU | DEC-09; GGL-01/09; ngân sách §2.3. Alert chỉ cảnh báo, không chặn tiền |
| A12 | Một ảnh/Moment; title tùy chọn ≤120 ký tự; collection riêng tư; URL chờ không tự hết hạn, vào từ Map/list có badge. Nhật ký trong Profile/Khoảnh khắc của tôi; bỏ lưu không xóa ảnh; Visited chỉ gợi ý, không tự đặt | DEC-30; BR-M1/9, S3–5, X2; MVP-17/28/29/30, DATA-07 |
| A13 | Share Sheet URL/text trước; metadata chỉ sau khi có quyền hợp lệ. Chưa đăng nhập yêu cầu đăng nhập, không dữ liệu vô chủ. Fetch URL tối đa 3 redirect/5 giây/1 MB và chống SSRF | DEC-21; BR-X4; EXT-01…05, Q-08. Không cam kết trích xuất mọi link |
| A14 | Hỗ trợ phản hồi ≤2 ngày làm việc; alert vận hành đến người trực ≤15 phút; kênh thật và phương án vắng mặt phải có ở cổng tương ứng | DEC-23; SAFE-07/09, R-28. Chưa tạo kênh hoặc có người dự phòng |

## 3. Mục B - Hướng xử lý và cổng đã duyệt

| Mục | Phạm vi phê duyệt | Chưa xác định / người phụ trách / hạn chót |
| --- | --- | --- |
| B1 | Duyệt thử khởi điểm accuracy ≤50 m, tuổi mẫu ≤60 giây, tối đa 5 ứng viên; coverage gồm cả không kết quả/lỗi/quota, không chỉ người đã tìm | TL/QA chốt T_auto/T_confirm, TTL ngữ cảnh và phương pháp trước đo G2; hiệu quả chưa đo. Retention RAM ≤60 giây là quy tắc khác |
| B2 | Duyệt kế hoạch máy thật/mạng và mẫu: ≥200 ảnh, ≥100 ca privacy, ≥100 chuỗi thụ động + ≥50 tác vụ API, ≥20 xem ảnh + ≥20 xem review, ≥30 Moment nhật ký; upload quan sát 5 phút; top 5 đúng ≥90%/≥50 search; thử chống trùng đồng thời | TL/QA chọn model máy/hồ sơ mạng cụ thể trước đo tương ứng; giữ các mẫu tối thiểu lớn hơn ở Q-05/06. Không hạ ngưỡng sau kết quả, chưa kiểm thử |
| B3 | Giữ 2048/400 px, quyết codec HEIC/JPEG, chất lượng nén/giới hạn byte theo đo; hoàn thiện UI và cảnh báo ảnh thư viện lệch >1 km; quyết movedPlace tùy chọn | TL/iOS trước G4 (codec/byte), PO/DES/TL trước kết thúc G2 (UI/movedPlace). Chưa chọn codec hoặc cam kết giao tùy chọn |
| B4 | Chốt backend/storage/email, region, telemetry, backup trước G3; PO quyết pháp nhân/chủ tài khoản | PO/TL/LEGAL; nhà cung cấp và chủ thể chưa chọn. DB/compute/email/quan trắc/tài khoản developer **chưa có trong hai trần Google/ảnh** |
| B5 | Duyệt hướng email xác nhận người đại diện có điều kiện pháp lý | LEGAL kiểm luật trước G3; còn trường tuổi, bằng chứng đồng ý/rút và retention, bản pháp lý tiếng Việt gốc. Không tự đổi tuổi 13+ hoặc coi email đã đáp ứng luật |
| B6 | Xác minh hợp đồng, quyền metadata TikTok/Instagram, TTL/attribution từng trường và cách lọc business status hợp lệ | TL/LEGAL trước G2/G3 tương ứng. PO không thể cấp quyền dữ liệu của bên thứ ba |
| B7 | Tính forecast tối ưu và quota/media limit thực trước G6; thử bao minh họa Nearby 1.000, Text 900, Pro 900, Enterprise 1.400, Atmosphere 1.100, Autocomplete 400, Photos 300 USD/tháng | PO/TL/BE; tổng 6.000, **chỉ minh họa**, không quota production hoặc tăng trần. 5.000 MAU/hệ số cần đo |
| B8 | Kênh hỗ trợ thật, phương án dự phòng/vắng mặt trước beta/phát hành; rà soát pháp lý/bảo mật độc lập hoặc ngoại lệ có ghi nhận | PO/OPS/SEC/LEGAL, G11/G12A theo risks. Ngoại lệ không bỏ qua luật hoặc lỗi nghiêm trọng |
| B9 | Duyệt hướng thiết kế cho bản công khai sau: chốt trường profile/nơi thủ công/lọc-kiểm duyệt; khởi điểm recent 7 ngày, 30 bài/ngày, 20 report/ngày, log kiểm duyệt 12 tháng | PO/SEC/LEGAL, B-PUB. Còn phải duyệt bản phát hành/ACL/người vận hành; **không** mở friends/public trong 1.0 |

## 4. Làm rõ mặc định vùng riêng tư

**APPROVED - BATCH-AB/DEC-31:**

1. Có mục **Vùng riêng tư** trong Cài đặt để thêm/sửa/xóa nhiều vùng và công tắc **Ẩn trong vùng riêng tư**, mặc định **bật**. Người dùng có thể chủ động tắt tại đây. Không thêm bước xác nhận sau mỗi ảnh.
2. Công tắc, danh sách vùng và revision lưu cục bộ theo đúng tài khoản, không sync/backup cloud. Tắt công tắc không tự xóa danh sách vùng; xóa vùng là lệnh riêng. Cấu hình mới/chưa xác minh không được kế thừa trạng thái tắt của tài khoản khác.
3. Khi công tắc bật, `INSIDE`/`UNCERTAIN` ưu tiên ẩn và chặn gửi tọa độ; chọn Place thủ công không tự bỏ bảo vệ. Tắt chủ động trong Cài đặt bỏ gate zone cho tác vụ mới, **không** bỏ các gate khác.
4. **Hide Location hiện tại/ảnh mới vẫn độc lập và mặc định bật theo ZONE đã duyệt.** Tin mới không yêu cầu đổi mặc định Hide thành tắt. Tắt bảo vệ zone không tự tắt Hide, cấp consent nhận diện, đặt Visited hoặc làm ảnh/vị trí công khai. GPS không đáng tin vẫn không đủ điều kiện tự gắn.
5. Đổi công tắc/zone tăng revision và vô hiệu job/kết quả cũ; không phát lại tọa độ, hiện lại Place ảnh cũ hoặc xử lý lại ảnh đã hidden chỉ vì sau đó tắt bảo vệ. Muốn sửa ảnh cũ phải có thao tác riêng và qua các gate hiện tại.
6. Tắt rồi bật lại áp dụng bảo vệ cho tác vụ mới/đang chờ sau đánh giá lại; không thể thu hồi tọa độ đã gửi. Chưa kiểm thử; PRIV-02 có ca riêng cho mặc định/tắt/bật/đổi tài khoản và race.

## 5. Trạng thái sau phê duyệt

- Chính sách A và kế hoạch B đã APPROVED đúng phạm vi trên; DEC-07/09/31 không còn chờ duyệt lại các chi tiết A.
- Các lựa chọn/bằng chứng còn thiếu ở B theo đúng cổng, không biến thành câu hỏi lặp lại về việc có đồng ý kế hoạch hay không.
- **G1: APPROVED** sau G1-SIGNOFF (§6); không còn chờ xác nhận mục C. Chưa build, chạy test ứng dụng, đo chỉ số hoặc thực hiện G2 trong lượt này.

## 6. Phê duyệt cuối G1 (mục C)

**Nguồn G1-SIGNOFF, ngày 31/10/2026, Asia/Ho_Chi_Minh:** Chủ dự án trả lời trực tiếp câu hỏi:

> Bạn xác nhận duyệt toàn bộ đặc tả G1 với tư cách PO/TL để chuyển sang APPROVED chứ?

Trả lời của Chủ dự án:

> Duyệt

| Vai trò xác nhận | Người duyệt | Quyết định | Ngày thực tế |
| --- | --- | --- | --- |
| Chủ sản phẩm | Chủ dự án | APPROVED toàn bộ bộ tài liệu G1, gồm A/B và kế hoạch chốt lựa chọn/bằng chứng theo cổng | 31/10/2026 |
| Trưởng kỹ thuật | Chủ dự án (cùng người kiêm nhiệm) | APPROVED cùng phạm vi, không thay bằng chứng triển khai/kiểm thử ở cổng sau | 31/10/2026 |

Phạm vi gồm README, product-spec, backlog, decisions, privacy-and-data, quality-and-acceptance, risks, budget-and-capacity, privacy-api-addendum và biên bản này. Đây là nguồn duyệt thật trong phiên, không phải người lập tự ký hoặc bịa tên riêng.

**Hệ quả:** G1 chuyển READY_FOR_REVIEW → **APPROVED**. Giữ private-only 1.0, trần/crop, công tắc zone mặc định bật/có thể tắt tại Cài đặt và Hide độc lập mặc định bật. Provider/pháp nhân/codec cuối, xác minh luật/quyền dữ liệu, forecast/quota, kết quả đo và hỗ trợ thực tế vẫn theo cổng B1–B9; không ghi các lựa chọn/ca/chỉ số chưa làm là đã đạt. Không mở cộng đồng, bắt đầu G2, build/test ứng dụng, commit hoặc push trong lượt ghi nhận này.

## 7. Chấp nhận chính thức sau review

**Nguồn G1-ACCEPTANCE, ngày 31/10/2026, Asia/Ho_Chi_Minh:** Chủ dự án xác nhận trực tiếp:

> Tôi chính thức chấp nhận hoàn toàn G1. Chia commit và push G1 lên main (Không thêm Co-Author).

Chấp nhận bộ G1 sau khi sửa SAFE-01 S2, bổ sung E3 cho offline → online, đồng bộ chính sách xóa dữ liệu và tách BR-P8 purge/fallback khỏi BR-P9 attribution. Baseline gồm 10 tài liệu, 69 yêu cầu và 277 ca đặc tả Given/When/Then; các ca chưa chạy.

Giữ trạng thái **APPROVED** và toàn bộ điều kiện cổng B1–B9. Tin mới cho phép chia commit và push tài liệu trong `docs/g1/` lên `main`, không thêm Co-Author; thay giới hạn không commit/push của lượt ghi nhận trước, không cho phép đưa thay đổi mã nguồn/cấu hình có sẵn vào commit G1. Không bắt đầu G2, build/test ứng dụng hoặc coi phê duyệt tài liệu là bằng chứng đạt chất lượng ứng dụng.
