# Doday 1.0 – Chỉ số chất lượng, nghiệm thu và kế hoạch kiểm thử (G1)

Trạng thái: APPROVED (kế hoạch/ngưỡng G1, không phải kết quả đo) · Ngày lập: 30/10/2026 · Ngày duyệt: 31/10/2026, Chủ dự án kiêm PO/TL qua G1-SIGNOFF, approval-batch §6

Các ngưỡng roadmap **đã duyệt ngày 31/10/2026** (DEC-20, đợt C trước đây). **BATCH-AB B1/B2** duyệt kế hoạch đo/bộ mẫu và ngưỡng đầu vào thử; chưa chọn model máy/hồ sơ mạng cuối hoặc chứng minh hiệu quả. Q-06 tạm chốt, xác nhận khả thi G2; Q-08b chỉ báo cáo; Q-15 chỉ PUB. Mọi chỉ số 1.0 **chưa đo**; viết ca không phải chạy ca. Không hạ ngưỡng sau thử; thay đổi phải ghi §3 decisions trước phép đo nghiệm thu. **G1-SIGNOFF** đã duyệt cuối toàn bộ G1 (mục C mới), không thay các điều kiện đo/chốt ở cổng sau.

## 1. Định nghĩa chung

- **P95**: giá trị mà 95% phép đo không vượt quá; tính theo phương pháp nearest-rank trên toàn bộ mẫu hợp lệ, không loại ngoại lai trừ khi lỗi đo được ghi rõ.
- **Phép đo hợp lệ**: chạy trên build xác định (ghi mã build/commit), thiết bị thật, cấu hình ghi lại; không tính lần chạy dưới debugger.
- **Lưu cục bộ ≠ upload**: Q-03 đo đến khi nháp ghi bền vững trên máy; Q-09 đo upload. Không gộp.
- **Lưu URL ≠ tự trích xuất**: Q-08 đo việc giữ được ý định lưu; Q-08b đo tỷ lệ tự xác định địa điểm, chỉ báo cáo.
- **Precision ≠ coverage**: Q-05 = đúng/tự gắn; Q-06 = tự gắn/đủ điều kiện. Báo cả hai cùng nhau.
- **Build beta ≠ Release Candidate (RC)**: RC là một build cụ thể được đề cử phát hành; số liệu RC (Q-11) chỉ tính trên đúng build đó, không gộp build beta trước.
- **Thiết bị thấp nhất**: iPhone thật có cấu hình thấp nhất chạy được iOS tối thiểu DEC-04 mà đội chọn hỗ trợ; model cụ thể [NEEDS_CONFIRMATION] (TL, B-G2).

## 2. Bảng chỉ số

| ID | Chỉ số | Ngưỡng (trạng thái theo phần mở đầu) | Tử số / mẫu số và cách tính | Cỡ mẫu tối thiểu | Thiết bị / mạng | Bằng chứng | Giai đoạn đo | Hiện trạng |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Q-01 | Camera sẵn sàng khi mở mới | P95 ≤ 2 s | Từ chạm biểu tượng (app không chạy) đến preview hiển thị khung hình và nút chụp nhận thao tác; loại luồng đăng nhập/xin quyền lần đầu | ≥100 lần | Thiết bị thấp nhất + 1 máy phổ biến; mạng bất kỳ và chế độ máy bay | Log mốc thời gian (signpost) + video mẫu ≥10 lần | G4, G10 | chưa đo |
| Q-02 | Camera trở lại từ nền | P95 ≤ 1 s | Từ app vào foreground đến preview hoạt động; báo riêng ca phiên camera bị hệ điều hành hủy | ≥100 lần | Như Q-01 | Log + phân loại ca | G4, G10 | chưa đo |
| Q-03 | Chụp đến nháp lưu bền vững | P95 ≤ 1 s | Từ bấm chụp đến khi ảnh + bản ghi nháp đã ghi xuống bộ nhớ bền vững; không chờ GPS/Google/upload | ≥100 ảnh, đủ HEIC/JPEG, ảnh lớn, xoay | Thiết bị thấp nhất; chế độ máy bay | Log + kiểm tra tồn tại sau kill app | G4, G10 | chưa đo |
| Q-04 | Ảnh đã xác nhận lưu không mất, không trùng | 0 mất, 0 trùng | Đối soát nháp bền vững sau phục hồi và đúng 1 Moment/ảnh khi đồng bộ xong; không coi ảnh còn offline là đã upload. Không gồm xóa app/mất thiết bị trước đồng bộ theo ROADMAP §4 | ≥100 chu kỳ kết hợp kill app, timeout, retry, offline, đổi mạng | 2 thiết bị; mạng giả lập lỗi | Kịch bản + bảng đối soát | G4, G10, G11 | chưa đo |
| Q-05 | Precision tự gắn địa điểm | ≥ 95% | Số lần tự gắn đúng (khớp nhãn thực địa) / mọi lần tự gắn; không loại ca nào khỏi mẫu số | ≥200 lần tự gắn, ≥30 địa điểm đa dạng | Thiết bị thấp nhất + phổ biến; ngoài trời, trong nhà, phố đông, trung tâm thương mại nhiều tầng | Bộ mẫu có nhãn + báo cáo theo nhóm điều kiện | G2 (thử), G5, G11 | chưa đo |
| Q-06 | Coverage tự gắn | ≥30% đủ đầu vào; **cần xác nhận khả thi G2** | Tự gắn (đúng + sai) / ca đủ điều kiện; B1/B2 duyệt thiết kế mẫu số dưới đây, còn hiệu chỉnh/chốt trước đo G2. Không chỉ nhóm đã tìm/có response; gồm lỗi/quota/không kết quả | Cùng Q-05; đủ đầu vào để có ≥200 lần tự gắn, không dừng ở ca thuận lợi | Như Q-05 | Nhãn + mọi mẫu số/gate và phiên bản phương pháp trước đo | G2, G5, G11 | chưa đo |
| Q-07 | Truy vấn bản đồ cá nhân | P95 ≤ 2 s đến nội dung dùng được | Từ mở Map/đổi viewport đến marker/cluster hợp lệ và trạng thái danh sách thiếu tọa độ dùng được (DEC-29); không loại ca thiếu tọa độ hoặc tự gọi Places bù | ≥100 lần, bộ 1.000 nơi Doday có quyền dùng; thêm nhóm cache Google hết hạn để thử fallback | Thiết bị thấp nhất; mạng thử ghi băng thông/độ trễ (ví dụ hồ sơ "4G kém") | Log + hồ sơ mạng, đối soát SavedPlace không mất + trace 0 Places do viewport | G6, G10 | chưa đo |
| Q-08 | Lưu qua Share Sheet không mất yêu cầu | ≥ 98% | (Số ca tạo được SavedPlace hoặc ExternalSource PENDING) / số ca chia sẻ đủ định dạng | ≥100 ca, ma trận TikTok/Instagram/Safari | iPhone thật; có mạng/offline | Ma trận URL + phiên bản app nguồn | G8, G11 | chưa đo |
| Q-08b | Tỷ lệ tự xác định địa điểm từ link | Không có ngưỡng; chỉ báo cáo | Số ca có ứng viên đúng được đề xuất / số ca Q-08 | Cùng bộ Q-08 | Như Q-08 | Như Q-08 | G2, G8, G11 | chưa đo |
| Q-09 | Upload ảnh hoàn tất | ≥99% trong cửa sổ mạng ổn định | Hoàn tất sau retry hữu hạn / số yêu cầu; offline không tính lỗi backend. B2 duyệt cửa sổ 5 phút/yêu cầu, TL/QA ghi hồ sơ trước G4; báo size bản chính/thumbnail | ≥200 yêu cầu | Wi-Fi và 4G ổn định | Log server + client | G4, G10, G11 | chưa đo |
| Q-10 | API do Doday quản lý | ≥ 99,5% thành công; P95 ≤ 800 ms | Yêu cầu hợp lệ thành công / tổng yêu cầu hợp lệ; độ trễ đo phía server, không gồm upload file và thời gian nhà cung cấp ngoài; báo riêng Google và end-to-end | Toàn bộ lưu lượng beta | Production-like | Dashboard + truy vấn xuất | G10, G11 | chưa đo |
| Q-11 | Crash-free sessions của RC | ≥ 99,5% | Phiên không crash / tổng phiên trên đúng build RC; kèm số crash và không crash tái hiện được trong luồng cốt lõi | ≥500 phiên, ≥20 người, ≥7 ngày | Thiết bị người dùng thật | Báo cáo công cụ DEC-22 + phạm vi thiết bị | G11 | chưa đo |
| Q-12 | Khôi phục dữ liệu server | RPO ≤ 24 h, RTO ≤ 4 h (đề xuất) | Một lần khôi phục thật vào môi trường cách ly; kiểm quan hệ DB–ảnh | 1 lần đạt + ≥100 khoảnh khắc đối soát | Môi trường cách ly | Biên bản diễn tập | G10 | chưa đo |
| Q-13 | Quyền riêng tư | 0 truy cập trái phép | Số truy cập trái phép thành công trong bộ thử quyền: API, storage, thumbnail, tìm kiếm, số đếm, URL cũ, đổi tài khoản, xóa tài khoản; 1.0 thêm: mọi yêu cầu visibility = public bị từ chối (SAFE-10); bản công khai thêm: công khai → riêng tư | Toàn bộ bộ thử (≥2 tài khoản) | API trực tiếp, không chỉ UI | Báo cáo kiểm thử | G3, G9, G10 | chưa đo |
| Q-14 | Thử tải backend | Không vi phạm Q-10 ở ≥2× tải đỉnh DEC-10 trong 30 phút, không vượt trần chi phí DEC-09 | Tỷ lệ lỗi và P95 trong cửa sổ thử | 1 lần đạt | Staging production-like | Báo cáo thử tải | G10 | chưa đo; ngưỡng thử: 20 yêu cầu/giây trong 30 phút (2 × đỉnh 10 yêu cầu/giây từ DEC-10) |
| Q-15 | Kiểm duyệt | Ca khẩn cấp tiếp nhận ≤ 4 h; thông thường ≤ 24 h (SLA nội bộ đề xuất) | Thời điểm báo cáo → thời điểm moderator xử lý/ghi nhận, phân vị P95 | Diễn tập ≥20 báo cáo, gồm ≥5 khẩn cấp | Công cụ kiểm duyệt thật | Nhật ký diễn tập | G9, G11 của bản công khai | **Không áp dụng cho 1.0** (DEC-15 C); giữ cho bản công khai |
| Q-16 | Mẫu beta | ≥30 người nhóm mục tiêu, 14 ngày, 1.000 phiên trên nhánh 1.0; RC ≥7 ngày, 500 phiên, 20 người; mỗi luồng cốt lõi ≥20 lần thử thực địa hợp lệ gồm nhánh dự phòng | Đếm theo build | Như ngưỡng | Thiết bị người dùng | Báo cáo beta | G11 | chưa đo |
| Q-17 | Thử sử dụng prototype | ≥5 người nhóm mục tiêu; ≥4/5 hoàn thành từng luồng J1–J4 không cần hướng dẫn | Số người hoàn thành / số người thử, theo từng luồng | ≥5 người | Prototype trên iPhone | Biên bản thử | G2 | chưa đo |

Không một ngưỡng hay mẫu hữu hạn nào chứng minh không có lỗi. Sự cố quyền riêng tư/mất dữ liệu và lỗi cốt lõi đã biết vẫn chặn phát hành dù thống kê đạt (ROADMAP §4, §7). Chỉ số hành vi SRC §18 (retention, xem → lưu, tỷ lệ sửa địa điểm, chi phí Google/người dùng hoạt động…) được theo dõi từ G11 để ra quyết định sản phẩm, **không** là điều kiện phát hành vì chưa có baseline.

**Ngân sách/tải:** [ASSUMPTION] 20 request Doday/giây ×30 phút =36.000, không 5.000 đồng thời hoặc tải Google thật. Q-14 dùng stub provider; integration/chi phí thật có mẫu/trần riêng. **COST + A10/A11** duyệt proxy/reservation/fail-closed, định giá bảo thủ/reset/alerts/retry/breaker; B7 còn forecast/quota thực. G10 trace không bypass và GGL-01 E2/E3, GGL-09 E3: ≥50 request/retry cùng SKU tranh ngân sách đủ đúng 1 cuộc gọi thì tối đa 1 được gửi; lỗi bộ đếm/hết trần 0 cuộc gọi trả phí kể cả khi alert không gửi. Đối soát attempt/reservation/billing không GPS nhạy cảm. SAFE-12 ngân sách upload riêng đã duyệt A6/A7; mọi cơ chế **chưa cấu hình/chưa kiểm thử**.

**Ảnh 1:1:** DEC-07/CROP đã duyệt cắt giữa tự động sau EXIF, bản chính ≤2048 × 2048, thumbnail ≤400 × 400, không phóng lớn và **không bước preview/xác nhận crop**. Đối chiếu file giải mã với ảnh chuẩn S-IMG, không chỉ UI; thử lỗi xử lý/client gửi ảnh chữ nhật. Chất lượng/codec nén còn PROPOSED; đo byte trung bình/P95/max riêng để xác nhận giả định 0,8/0,04 MB. Q-03 vẫn từ bấm chụp tới nguồn + nháp bền vững, không dời mốc sau crop hoặc chờ Google. Màn xem lại tiêu đề/Hide có sẵn không phải bước duyệt crop mới.

**OVERRIDE/DEC-27/B1–B2 và mẫu số:** **không hạ Q-05 ≥95% hoặc Q-06 ≥30%**. Kế hoạch duyệt: `D_all` = mọi ảnh thực địa; `D_input` = có quyền chính xác, ngang ≤50 m, mẫu ≤60 s đúng thời điểm và Google Place thực địa; `D_allowed` = D_input có Hide tắt, consent/quyền hợp lệ, bảo vệ zone tắt chủ động **hoặc** đang bật và chắc chắn ngoài vùng. Báo riêng zone-on/off, không tắt bảo vệ để làm đẹp coverage. Q-06 = tự gắn trong D_allowed / D_allowed; **không** loại ca chưa tìm/không ngữ cảnh/response/lỗi/quota. Báo thêm tự gắn/D_input, tự gắn/D_all, blocked/uncertain/không Place/request mỗi ảnh. TL/QA chốt lấy mẫu/T_auto/T_confirm/TTL ngữ cảnh trước đo G2; ngưỡng đầu vào chỉ khởi điểm, không license cache Google. D_allowed=0/thiếu mẫu ghi “không đủ mẫu”, không “đạt”; Q-05 gồm mọi tự gắn. Q-07 giữ fallback; dự toán cũ chưa là forecast tối ưu/tiết kiệm đã đo.

### 2.1 Chỉ số bổ sung privacy/API (không thay Q-01…17)

Mục tiêu 0 theo ADD; **B2 duyệt cách đo/cỡ mẫu**, TL/QA/SEC ghi thiết bị/harness cụ thể trước G3. Không chứng nhận bảo vệ tuyệt đối; mọi mục **chưa đo**.

**ZONE + BATCH-AB/DEC-31:** zone/công tắc local-only; bảo vệ mặc định bật/có thể tắt tại Cài đặt; Hide độc lập mặc định bật; radius 200 m (100–1.000); GPS RAM ≤60 s. Kiểm PRIV-01 S4, PRIV-02 S3–S5/E4–E7, PRIV-04 E1 trên 2 máy/tài khoản, storage/backup/telemetry và mốc 59/60/61 s. Thử zone-on/off/Hide/consent, manual Place không bypass khi bật, revision/toggle không hiện ảnh cũ/replay job. A2 duyệt heuristic; B1 duyệt thử tuổi mẫu/accuracy nhưng chưa đo hiệu quả. Không nhầm tuổi mẫu với retention RAM.

| ID | Mục tiêu / mẫu số | Cỡ mẫu, môi trường | Bằng chứng / giai đoạn |
| --- | --- | --- | --- |
| QP-01 | 0 lần gửi tọa độ bị bảo vệ; 0 rò Place/GPS/zone/quan hệ trái quyền trong toàn bộ ca Hide/zone/uncertain và bộ thử quyền. Báo số job đã gửi trước khi bật Hide riêng, không gian lận coi là đã thu hồi | ≥100 tình huống S-PRIVLOC; 2 tài khoản, 2 iPhone thật; offline/kill/retry/đổi tài khoản/đua bật Hide; kiểm media và API trực tiếp, telemetry | Trace ở harness dùng canary giả, thống kê request/body bị chặn, schema/EXIF và kiểm logs/crash; không lưu raw GPS thật. G3–G5/G7/G10 |
| QP-02 | 0 Places/Photos/Reviews/Routes/Geocoding calls do mở app/camera/chụp/pan/zoom Map không có tác vụ hợp lệ; báo Maps SDK traffic riêng. Tỷ lệ lệnh hợp lệ gọi đúng API/field mask = 100% bộ thử | ≥100 chuỗi sự kiện thụ động + ≥50 tác vụ chủ động; iPhone thấp nhất/phổ biến; stub Google lỗi/429/hết quota, Wi-Fi/4G/offline | App/proxy outbound trace, request context/field mask, bộ đếm attempt/circuit breaker và reservation; G2 thử, G3/G5/G6/G10 |

Q-13 mở rộng theo PRIV-03/DATA-06/07: ảnh/vị trí độc lập, nhật ký, reverse lookup, số đếm, policy revision và tọa độ payload. Nguyên tắc DEC-25/26/32 đã duyệt; tổ hợp friends/public vẫn **không áp dụng binary 1.0**, chỉ thử bản chia sẻ được duyệt phát hành riêng. Không ghi đã giao quyền friends/public vì 1.0 từ chối public.

**Photos/review/nhật ký:** GGL-04/10, DATA-07 thuộc 1.0; B2 duyệt ≥20 xem ảnh + ≥20 xem review, đủ không dữ liệu/name hết hạn/429/5xx/quota; trace không prefetch, attribution đủ/cache đúng quyền. Nhật ký ≥30 Moment giả/ngày/múi giờ/không nơi/Hide, 2 tài khoản/2 máy, xóa/outage; kiểm API/storage. Chưa kiểm thử; Q-15 PUB không phải kiểm duyệt review Google của Doday.

## 3. Bộ mẫu

| Bộ | Nội dung | Yêu cầu nguồn/đồng ý | Dùng cho |
| --- | --- | --- | --- |
| S-IMG | B2 duyệt ≥200 ảnh hợp lệ; phân bố [PROPOSED – TL/QA chốt trước G4] 100 camera trước/sau + 100 thư viện HEIC/JPEG; vuông/ngang/dọc, EXIF orientation 1–8, lớn/nhỏ hơn pixel đã duyệt, chủ thể sát mép/lưới chuẩn; file hỏng thành bộ lỗi riêng, ghi phân bố nhóm | Ảnh thử tự tạo/có quyền, không dữ liệu cá nhân thật; có ảnh chuẩn đúng hướng/vùng giữ lại | MVP-05/09, Q-03/04/09; hình học mọi ảnh hợp lệ, ca hỏng ghi riêng |
| S-LOC | ≥30 địa điểm, ≥200 lần chụp tự gắn, nhãn đúng do người thử ghi tại chỗ (Google Place ID) | Người thử nội bộ đồng ý; ảnh không chứa người lạ nhận diện được | Q-05, Q-06, MVP-06 |
| S-MAP | 1.000 địa điểm do Doday tạo hoặc có quyền dùng; không sao chép Places về DB | Không dùng dữ liệu Google lưu trái chính sách | Q-07, MVP-15/16 |
| S-SHARE | ≥100 link TikTok/Instagram/Safari công khai, gồm rút gọn, hết hạn, riêng tư, không có địa điểm | Chỉ link công khai; ghi phiên bản app nguồn | Q-08, Q-08b, EXT-* |
| S-STATUS | Dữ liệu giả lập 5 business status + thiếu dữ liệu + đã di chuyển + lỗi API | Dữ liệu thử, gắn nhãn "test" | MVP-20/21/22, GGL-05/06 |
| S-PRIV | ≥2 tài khoản thử với nội dung riêng tư (bản công khai: thêm nội dung công khai), URL ảnh, thumbnail | Tài khoản thử, không dữ liệu cá nhân thật | Q-13, SAFE-02 |
| S-PRIVLOC | ≥100 tình huống canary giả, ≥2 zone chồng/không chồng, trong/ngoài/mép/vòng sai số; GPS thiếu/cũ/gần đúng, EXIF có/không, 2 tài khoản/2 máy, Hide hiện tại/tương lai, consent/rút consent, công tắc zone bật/tắt/bật lại và queue/revision cũ | Không tọa độ nhà/dữ liệu thật; nhãn trong/ngoài/uncertain trước đo; raw canary chỉ harness, không production logs | QP-01/02, PRIV-01…04, DATA-06, GGL-08/09 |
| S-AGE | Tài khoản thử ở các nhóm tuổi <13, 13, 15, 16, 30; email người đại diện thử | Chỉ dữ liệu giả, không dùng thông tin trẻ em thật | SAFE-11 |
| S-UGC | Bộ ảnh thử vi phạm có nhãn cho lọc nội dung | Nguồn hợp pháp, không lưu nội dung bất hợp pháp | SAFE-05 |

## 4. Môi trường

- **Thiết bị:** thiết bị thấp nhất (DEC-04), một iPhone phổ biến, iPhone màn nhỏ và màn lớn, iOS thấp nhất và mới nhất được hỗ trợ; iPad ở chế độ tương thích nếu DEC-03 = A. Simulator **không** là bằng chứng cho camera, vị trí thực địa hay extension (ROADMAP G2).
- **Mạng:** Wi-Fi ổn định, 4G, hồ sơ mạng chậm/mất gói, chế độ máy bay, chuyển mạng giữa chừng.
- **Backend:** development / staging / production tách biệt (ROADMAP G3); dữ liệu thử không lẫn production.
- **Tài khoản dịch vụ:** Google Cloud project có quota thấp cho thử nghiệm; không dùng khóa production khi thử.

## 5. Kế hoạch kiểm thử theo giai đoạn

| Giai đoạn | Kiểm thử | Chỉ số/ca | Bằng chứng cần nộp |
| --- | --- | --- | --- |
| G1 | Rà soát tài liệu: 30 MVP, ca nghiệm thu, quyết định, rủi ro | – | Bộ docs/g1 + biên bản duyệt |
| G2 | Prototype và thử sử dụng; thử kỹ thuật trên iPhone thật (camera, ảnh, vị trí, Google Map, Place Details, Share Sheet); ghi kiểu dữ liệu TikTok/Instagram; xác nhận khả thi Q-06; xác minh metadata ảnh từ trình chọn | Q-17, Q-05/06 sơ bộ, Q-08b sơ bộ | Biên bản thử, báo cáo kỹ thuật |
| G3 | Unit/integration test backend; kiểm thử phân quyền 2 tài khoản; xóa dữ liệu; cổng tuổi và đồng ý của người đại diện; hạn mức upload; CI build/lint/test từ checkout sạch | Q-13 (phần API), SAFE-01/02/10/11/12, DATA-02 | Hợp đồng API/schema, báo cáo |
| G4 | Camera/nháp/vòng đời; crop giữa 1:1 không bước preview, hướng EXIF, byte, lỗi nén/cắt; Hide một thao tác, zone và không Google trên đường chụp/lưu | Q-01…Q-04, Q-09, QP-01/02, MVP-05/09, PRIV-01/02/04 | Video máy thật, ảnh chuẩn/đầu ra, bảng kích thước/byte và trace canary; chưa có bằng chứng ở G1 |
| G5 | Thực địa nhận diện, chống trùng Place đồng thời | Q-05, Q-06, MVP-06/07/18 | Bộ S-LOC có nhãn, báo cáo theo nhóm |
| G6 | Trạng thái địa điểm, deep link, field mask, cache/attribution, Map thiếu dữ liệu; ảnh/review on-demand, quota/circuit breaker | Q-07, QP-02, MVP-11…25, GGL-01/02/03/04/08/09/10, DATA-05 | S-STATUS, profile + trace trigger, attribution/media/review, đối soát chi phí |
| G7 | Đồng bộ đa thiết bị, xung đột, nhật ký từ Moment riêng tư | DATA-03/06/07, MVP-17/28/29/30 | Báo cáo 2 thiết bị/tài khoản, xóa/Hide/offline/Google lỗi |
| G8 | Ma trận Share Sheet, vòng đời extension, SSRF | Q-08, Q-08b, EXT-* | Ma trận URL, video |
| G9 | **1.0:** xác nhận không có bề mặt công khai (SAFE-10, MVP-10/26 ca `1.0-`), không có xem chéo giữa tài khoản. **Bản công khai:** quyền công khai đa tài khoản, diễn tập kiểm duyệt | 1.0: Q-13. Bản công khai: Q-13, Q-15, MVP-10/26/27, SAFE-03…07 | 1.0: báo cáo kiểm thử quyền. Bản công khai: nhật ký diễn tập |
| G10 | Regression ở cả tiếng Việt và tiếng Anh, thử tải, an toàn, backup/restore, accessibility (Dynamic Type, VoiceOver, tương phản) | Tất cả trừ Q-11, Q-16; L10N-01 | Báo cáo regression/tải/an toàn; báo cáo khóa thiếu bản dịch = 0 |
| G11 | TestFlight, thực địa, RC | Q-11, Q-16, lặp lại Q-04/05/08 | Báo cáo beta có mẫu số |

Mỗi biên bản ghi: mã build/commit, phiên bản backend/schema, thiết bị/iOS, ca kiểm thử, kết quả, lỗi mở (P0/P1/P2), người duyệt, ngày duyệt (ROADMAP §2). Bằng chứng không chứa bí mật hoặc dữ liệu cá nhân thật không cần thiết.

## 6. Hiện trạng kiểm thử tại G1

- Dự án hiện có 1 unit test (`Tests/DodayTests/DodayTests.swift`: dựng `ContentView`). Bộ G1 **không chạy** test này (ngoài phạm vi công việc). Trạng thái: **chưa kiểm thử** trong G1.
- Không có ca nghiệm thu nào trong `backlog.md` đã được thực hiện: tất cả **chưa kiểm thử**.
