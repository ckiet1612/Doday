# Doday G2 – Kế hoạch đo (B1/B2, Q-05/06, QP-01/02, Q-17)

Trạng thái: **PROPOSED · hoãn chốt sang đầu G5** (G2-DEC-15, 01/11/2026) · 31/10/2026. Chưa chạy phép đo nghiệm thu nào. Mọi số liệu trong G2 cho tới khi chốt đều ghi **sơ bộ**.

Nguyên tắc G1 giữ nguyên: Q-05 ≥95%, Q-06 ≥30% (tạm chốt, xác nhận khả thi ở G2). Mẫu số gồm cả ca không lookup/không kết quả/lỗi/quota. Không tắt bảo vệ để tăng coverage. Không đổi ngưỡng/phương pháp sau khi nhìn dữ liệu đánh giá (DEC-20/27, B1/B2).

## 1. Khóa phương pháp

1. Chủ dự án duyệt tài liệu này (§2–§5), kèm thiết bị cụ thể. Ghi vào [decisions.md](decisions.md) với phiên bản `method-g2-v1`.
2. Thu **dữ liệu hiệu chỉnh** (tập C), chọn T_auto/T_confirm/TTL theo §3, ghi `cal-<ngày>-v1` vào decisions **trước** khi thu tập đánh giá.
3. Thu **dữ liệu đánh giá** (tập E) bằng build cố định (commit + trạng thái dirty) và cấu hình đã khóa.
4. Báo cáo theo §4. Sửa phương pháp sau bước 2 thì phải tạo phiên bản mới và **thu lại E từ đầu**.

## 2. Thiết bị, iOS, mạng (B2) – đề xuất

| Vai trò | Đề xuất | Lý do | Chủ dự án xác nhận |
| --- | --- | --- | --- |
| Thiết bị thấp nhất | iPhone thấp nhất đang có chạy được iOS 17 (ví dụ iPhone XR/XS hoặc SE thế hệ 2), iOS 17.x, giữ nguyên bản trong suốt đợt đo | DEC-04: thấp nhất là iPhone chạy iOS 17 | ☐ model ☐ iOS build |
| Thiết bị phổ biến | Một iPhone đời 15–17 chạy iOS mới nhất tại ngày đo | Q-01…Q-07 cần thêm một máy phổ biến | ☐ |
| Màn nhỏ / lớn (UX) | SE 4,7″ (hoặc 17e) và một máy Pro Max | ux-spec §7 | ☐ |
| iPad (tương thích) | Bất kỳ iPad iOS 17+ | DEC-03, chỉ smoke | ☐ |

**Hồ sơ mạng:** Wi‑Fi ổn định; 4G thật ngoài trời; Network Link Conditioner “3G” và “Very Bad Network”; chế độ máy bay; chuyển Wi‑Fi→4G giữa thao tác. Mỗi ca ghi hồ sơ, pin >50%, Low Power tắt, Precise Location bật/tắt, build/commit.

**Bộ mẫu B2 tối thiểu (G1):** ≥200 ảnh S-IMG; ≥100 ca privacy (S-PRIVLOC); ≥100 chuỗi thụ động + ≥50 tác vụ API; ≥20 lần xem ảnh + ≥20 lần xem review; ≥30 Moment nhật ký; top-5 đúng ≥90% trên ≥50 lần tìm. Q-05/06 cần mẫu lớn hơn: **≥200 lần tự gắn trên ≥30 địa điểm**.

## 3. B1 – hiệu chỉnh T_auto, T_confirm, TTL ngữ cảnh

**Đầu vào đã duyệt (B1):** precise, sai số ngang ≤50 m, tuổi mẫu ≤60 s, tối đa 5 ứng viên. RAM ≤60 s là quy tắc giữ dữ liệu riêng, không phải TTL ngữ cảnh.

**Định nghĩa.** *Ngữ cảnh* là kết quả hợp lệ của một lệnh “Gần tôi/Nhận diện” chủ động (DEC-27), gồm ứng viên, điểm số và thời điểm, gắn với tài khoản + privacy revision. *Score* ∈ [0,1] của ứng viên do thuật toán G5 định nghĩa. G2 chỉ khóa cách chọn ngưỡng, không khóa thuật toán.

**Tách dữ liệu.** Tập C và E **không chung địa điểm**, không chung ngày. Đề xuất C ≥10 địa điểm/≥80 ảnh, E ≥30 địa điểm khác/≥200 lần tự gắn. Nhóm điều kiện như Q-05: ngoài trời, trong nhà, phố đông, TTTM nhiều tầng.

**Ground truth.** Người thử chọn Google Place ID đúng tại chỗ trên Google Maps **trước** khi xem kết quả Doday. Nơi nhập nhằng (hai quán chung cửa…) gắn nhãn `multi` và báo riêng. 10% mẫu do người thứ hai gắn lại; bất đồng >5% thì dừng để sửa hướng dẫn.

**Chọn ngưỡng trên C (ghi lại, không sửa sau E):**
- `T_auto`: điểm nhỏ nhất mà trên C **cận dưới Wilson 95% của precision ≥95%**, đồng thời ứng viên thứ hai < `T_confirm`. Nếu không đạt thì tắt tự gắn (mọi ca thành xác nhận/chưa gắn) và báo Q-06 = 0, không hạ Q-05.
- `T_confirm`: điểm nhỏ nhất sao cho nơi đúng nằm trong danh sách xác nhận (≤5) ở ≥90% ca trên C.
- `TTL ngữ cảnh`: chọn trong {10, 20, 30, 60} s; giá trị lớn nhất mà precision trên C không giảm quá 1 điểm so với 10 s. Không vượt 60 s. Mẫu GPS mới khi chụp phải cách mẫu của ngữ cảnh ≤ max(sai số, 25 m), nếu không thì bỏ ngữ cảnh.
- Giá trị `0.95 / 0.6 / 20 s` trong prototype là **fixture minh họa**, không phải đề xuất ngưỡng.

## 4. Q-05 / Q-06 – mẫu số và báo cáo

Theo quality §2 G1:

- `D_all` = mọi ảnh thực địa trong E.
- `D_input` = có quyền vị trí chính xác, sai số ngang ≤50 m, mẫu ≤60 s đúng thời điểm, và nơi thực địa là Google Place.
- `D_allowed` = D_input có Hide tắt, consent hợp lệ, và (bảo vệ zone tắt chủ động **hoặc** bật và chắc chắn ngoài vùng).
- **Q-06** = tự gắn trong D_allowed / D_allowed. Không loại ca chưa tìm, không ngữ cảnh, không response, lỗi, quota.
- **Q-05** = tự gắn đúng / mọi lần tự gắn (không loại ca nào).

| Báo cáo bắt buộc | Zone bật | Zone tắt chủ động |
| --- | --- | --- |
| \|D_all\|, \|D_input\|, \|D_allowed\| | | |
| Tự gắn / D_allowed (Q-06), tự gắn / D_input, tự gắn / D_all | | |
| Precision (Q-05) + cận Wilson 95% | | |
| Bị chặn: hidden / noConsent / inside / uncertain / unreliable / expired | | |
| Không Place / không ngữ cảnh / lỗi / quota | | |
| Request Places trên mỗi ảnh (trung bình, P95, max) | | |
| Thiếu mẫu (\<200 tự gắn hoặc \<30 nơi) hoặc D_allowed = 0 → ghi “không đủ mẫu”, **không phải đạt** | | |

**Rủi ro khả thi Q-06 (phát hiện G2, cần PO biết):** DEC-27 không cho Nearby theo ảnh. Ảnh chỉ được tự gắn khi có ngữ cảnh từ một lệnh chủ động gần thời điểm chụp (≤TTL). Nếu người dùng ít khi bấm “Gần tôi/Nhận diện” trước khi chụp, phần lớn D_allowed sẽ không có ngữ cảnh, và coverage có thể **thấp hơn 30% về cấu trúc**, dù precision tốt. G2 chưa có dữ liệu để kết luận. Phép đo sơ bộ cần ghi riêng tỷ lệ “ảnh có ngữ cảnh hợp lệ” để PO quyết định (giữ Q-06, đổi thiết kế trigger, hoặc điều chỉnh có ghi lý do **trước** G5) mà không hạ ngưỡng sau khi nhìn kết quả.

## 5. Các phép đo G2 khác

| Mục | Phương pháp | Cỡ mẫu | Môi trường | Trạng thái |
| --- | --- | --- | --- | --- |
| QP-01 canary | Harness tọa độ giả: unit 192 tổ hợp + mẫu giả trong Lab; trên máy kiểm log/console/crash không chứa canary | ≥100 tình huống S-PRIVLOC | 2 iPhone, 2 tài khoản | Unit PASS (simulator); máy thật NOT_RUN |
| QP-02 thụ động | Chuỗi mở app/camera/chụp/mở Map/pan/zoom; đếm bằng Lab + trace proxy/mạng | ≥100 chuỗi + ≥50 lệnh chủ động | Máy thật, Wi‑Fi/4G/offline | Unit PASS; máy thật NOT_RUN |
| Q-01/Q-03 sơ bộ | Lab đo “bật camera → preview” và “chụp → nháp bền vững” trong RAM; không phải định nghĩa Q-01 (từ biểu tượng) | ghi n | Máy thấp nhất | NOT_RUN trên máy |
| Q-08b sơ bộ | Ma trận Share; Q-08b chỉ báo cáo; G2 không có trích xuất nên = 0/n theo thiết kế | ≥10 link mỗi nguồn | Máy thật | BLOCKED (signing) |
| Photos/review | ≥20 + ≥20 lần xem, gồm lỗi/quota | – | Live | BLOCKED (live khóa) |
| Q-17 | [usability-report.md](usability-report.md) | ≥5 người, mỗi J ≥4/5 | iPhone thật | NOT_RUN |

## 6. Xử lý dữ liệu đo

- Không đưa tọa độ thật, tâm vùng, URL đầy đủ, ảnh có người, ID thiết bị hay bí mật vào evidence. Chỉ ghi lớp (inside/uncertain/…), khoảng cách đã làm tròn 50 m khi cần, host link và kiểu dữ liệu.
- Nhãn ground truth lưu Place ID và mã địa điểm nội bộ (L01…L40), không lưu tọa độ người thử.
- Dữ liệu thô chưa làm sạch chỉ để trong `docs/g2/evidence-local/` (git-ignored) và xóa sau khi tổng hợp.
