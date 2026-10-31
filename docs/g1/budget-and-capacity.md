# Doday 1.0 – Dự toán ngân sách và tải

Ngày tính/kiểm tra nguồn: **31/10/2026**, Asia/Ho_Chi_Minh. Trạng thái: **APPROVED trần, chính sách ảnh và cơ chế/tham số A6/A7/A10/A11 qua BATCH-AB**, cùng COST/DEC-09; hệ số vẫn **[ASSUMPTION]**. B3/B4/B7 duyệt kế hoạch chọn codec/provider và forecast/quota theo bằng chứng, chưa có lựa chọn cuối hoặc cấu hình chạy. Không phải báo giá/hóa đơn, mở billing, kiểm chứng chặn tiền hoặc cam kết chi hết. Không tạo tài khoản/cấu hình quota/gọi API tính phí trong G1.

**G1-SIGNOFF:** toàn bộ G1 đã APPROVED ngày 31/10/2026 bởi Chủ dự án kiêm PO/TL, biên bản approval-batch §6. Không thay trần, forecast, giả định, lựa chọn/bằng chứng còn thiếu hoặc ngày kiểm tra nguồn giá; không coi phê duyệt là đã đo hóa đơn.

## 1. Căn cứ và giới hạn

- **Đã duyệt:** mục tiêu 5.000 người dùng; các lựa chọn B/C và chủ dự án kiêm mọi vai trò. Tin xác nhận lúc 00:04 ngày 31/10/2026 giờ Việt Nam (17:04 ngày 30/10 UTC), xem nhật ký `decisions.md` §3.
- **[ASSUMPTION]:** coi cả 5.000 là MAU (người hoạt động trong một tháng), không phải 5.000 người đồng thời. Nếu đây là tổng tài khoản, cần thay MAU thực vào công thức, không chia đơn giá bình quân vì có các mức miễn phí/bậc giá.
- Giá bằng **USD trước thuế**, theo bảng giá công khai, không áp dụng giá riêng cho Ấn Độ, credit thử nghiệm, ưu đãi startup hoặc hợp đồng thương lượng. Chưa quy đổi sang VND. Đây chỉ là Google và ảnh; **không phải tổng chi phí vận hành Doday**.
- **Đã duyệt bổ sung 31/10/2026:** trần Google theo §2.3, ảnh 50 USD/tháng năm đầu theo §3.2; CROP chốt 2048/400 px, cắt giữa tự động **không preview**, gốc ở máy. G1-SIGNOFF đã duyệt toàn G1; provider vẫn chưa chọn, giữ cổng B4.
- **COST, 31/10/2026:** duyệt proxy backend, giữ chỗ ngân sách nguyên tử và ngừng gọi Google trả phí khi hết trần hoặc bộ đếm lỗi. Chỉ ba nguyên tắc này được bổ sung vào phần đã duyệt; phân bổ SKU, quota và tham số kỹ thuật chưa mặc nhiên được duyệt, xem §2.3 và nhật ký `decisions.md` §3.
- **BATCH-AB sau COST:** A6/A7/A10/A11 đã duyệt quota ảnh/admission, reservation bảo thủ/ledger/reset/alerts và retry/breaker; không hỏi lại. B7 duyệt hướng tính forecast tối ưu/quota theo đo trước G6; phân bổ minh họa không phải quota production. B4 còn provider/region và ngân sách backend/email/compute/quan trắc/tài khoản developer.
- **ADD và OVERRIDE cùng ngày:** đã duyệt không Nearby theo ảnh/GPS tick, không Places vì mở app/camera/Map/pan/zoom, fallback khi cache hết quyền dùng; thêm Photos/review on-demand và nhật ký cá nhân, vẫn private-only. Bảng §2.2 là mô hình **trước thay đổi trigger/phạm vi**, chỉ tham chiếu, không lịch gọi được phép hay forecast tối ưu. Phải lập forecast theo tác vụ hợp lệ và số xem media/review ở G2/G6; chưa đo tiết kiệm, không tự giảm/tăng trần.
- Mức sử dụng, kích thước file, retry và tỷ lệ phiên tìm kiếm đều **chưa đo**. Giới hạn tiền đã duyệt; iOS/BE/QA đo lại ở G2/G4/G11 trước khi mở rộng. Phạm vi 1.0 chỉ riêng tư không tự làm Google rẻ hơn.
- Dự toán thay thế bảng dở ngày 30/10: sửa 4 × 5.000 lượt Nearby thành 20.000, sửa cách tính phiên Autocomplete và bổ sung lượt dữ liệu Map/backup. Không tự giảm chức năng MVP để vừa ngân sách.

## 2. Google Maps Platform

### 2.1 Giá và quy tắc tính

Nguồn B1/B2/B3 bên dưới. Giá trên **1.000 yêu cầu**, hai bậc đầu tính trên tổng lượng của từng SKU/tháng:

| SKU | Miễn phí/tháng | Đến 100.000 | 100.001–500.000 |
| --- | ---: | ---: | ---: |
| Nearby Search Pro | 5.000 | 32,00 | 25,60 |
| Text Search Pro | 5.000 | 32,00 | 25,60 |
| Place Details Pro | 5.000 | 17,00 | 13,60 |
| Place Details Enterprise | 1.000 | 20,00 | 16,00 |
| Place Details Enterprise + Atmosphere | 1.000 | 25,00 | 20,00 |
| Autocomplete Requests | 10.000 | 2,83 | 2,27 |
| Places API Place Details Photos (Photo media, 1.0 sau OVERRIDE) | 1.000 | 7,00 | 5,60 |

Maps SDK bản đồ native thông thường và Autocomplete Session Usage không có phí usage trong B1; không suy rộng sang Street View/3D. Với `N ≤ 500.000`, `F` là mức miễn phí, `p1/p2` là giá trong bảng:

`C(N) = max(0, min(N, 100000) − F) × p1 / 1000 + max(0, N − 100000) × p2 / 1000`.

Không trừ F thêm lần nữa ở bậc hai. Hạn mức miễn phí không nhân lên theo số project; phải đối soát toàn billing account, gồm môi trường thử.

**Autocomplete không mặc nhiên miễn phí:** ở luồng kết thúc bằng Pro/Enterprise, các yêu cầu có token phiên hợp lệ ghi Session Usage, nhưng Details kết thúc tính **Enterprise + Atmosphere** dù không yêu cầu `reviews` (B2). Phiên bỏ dở/không hợp lệ tính Requests; kết thúc IDs Only không miễn phí cả phiên. Dự toán dưới chọn Pro/Enterprise, không suy sang Essentials. DEC-14 nay có review 1.0 on-demand; mức tính tiền của phiên không cấp quyền tải review khi chưa được yêu cầu.

### 2.2 Mức dùng và kết quả

Mọi hệ số trong bảng là **[ASSUMPTION] mỗi MAU/tháng**; số lượt là yêu cầu thực gửi, gồm các lần mở lại. Retry phát sinh ngoài mẫu phải ăn vào cùng hạn mức, không có ngân sách riêng.

| Hoạt động | Thấp | Cơ sở | Cao |
| --- | ---: | ---: | ---: |
| Nearby trong mô hình trước ADD (không còn là lịch gọi được phép theo DEC-27) | 4 | 7 | 14 |
| Tổng Details có rating/giờ (gồm lần kết thúc tìm kiếm) | 10 | 20 | 40 |
| Trong số trên: phiên Autocomplete hoàn tất | 3 | 6 | 12 |
| Text Search cho kết quả Map / ứng viên từ link hợp lệ | 3 | 6 | 12 |
| Autocomplete Requests tính tiền (bỏ dở/không hợp lệ) | 12 | 24 | 48 |
| Details Pro dự phòng trước ADD; không được dùng để gọi tự động theo Map | 5 | 10 | 20 |

Lần Details kết thúc phiên được **tách khỏi**, không cộng chồng vào tổng Details: cơ sở 100.000 lần = 70.000 Enterprise + 30.000 Enterprise + Atmosphere. Dòng Pro là lượt bổ sung ngoài tổng này, dự phòng cho dữ liệu Map/thẻ nhẹ. Không lấy rating/giờ từ Nearby/Text Search (sẽ đổi SKU). Không lấy ảnh Google.

| SKU | Lượt thấp | USD thấp | Lượt cơ sở | USD cơ sở | Lượt cao | USD cao |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Nearby Search Pro | 20.000 | 480,00 | 35.000 | 960,00 | 70.000 | 2.080,00 |
| Text Search Pro | 15.000 | 320,00 | 30.000 | 800,00 | 60.000 | 1.760,00 |
| Place Details Pro | 25.000 | 340,00 | 50.000 | 765,00 | 100.000 | 1.615,00 |
| Place Details Enterprise | 35.000 | 680,00 | 70.000 | 1.380,00 | 140.000 | 2.620,00 |
| Enterprise + Atmosphere (kết thúc phiên) | 15.000 | 350,00 | 30.000 | 725,00 | 60.000 | 1.475,00 |
| Autocomplete Requests | 60.000 | 141,50 | 120.000 | 300,10 | 240.000 | 572,50 |
| **Tổng Google/tháng** | | **2.311,50** | | **4.930,10** | | **10.122,50** |

**Đã trừ miễn phí:** cả ba tổng trên đã trừ allowance hàng tháng của từng SKU trong §2.1 và áp bậc giá; không trừ lần hai. Ví dụ cơ sở: Nearby `(35.000 − 5.000) / 1.000 × 32 = 960 USD`; Autocomplete Requests `(100.000 − 10.000) / 1.000 × 2,83 + 20.000 / 1.000 × 2,27 = 300,10 USD`. Đây là lượt miễn phí theo SKU/billing account, không phải một khoản credit chung để tiếp tục trừ khỏi 4.930,10 USD. Xác minh lại B1 ngày 31/10/2026 khi trả lời câu hỏi của chủ dự án.

Mức cơ sở khoảng **0,99 USD/MAU/tháng**. Lượt Pro bổ sung là khoản dự phòng hữu hạn, **không chứng minh** đủ để dựng lại 1.000 marker khi không được lưu tên/trạng thái. TL/LEGAL phải chốt chính sách theo trường ở G2, đo call amplification và tính lại nếu quá 10 lượt Pro/MAU/tháng; không gọi Places trên mỗi lần kéo Map (BR-P7). Chưa có bằng chứng đáp ứng chi phí hoặc Q-07.

**Phần tăng thêm sau OVERRIDE/DEC-28 – [ASSUMPTION, chưa đo], không phải forecast thay thế:**

| Thành phần | Cách tính không trừ free tier hai lần | Ví dụ độ nhạy |
| --- | --- | --- |
| Photo media, SKU riêng ở §2.1 | Gọi `C_Photos(P)` theo tổng media thực sự yêu cầu/tháng, gồm retry/tải lại có tính phí; dùng mức miễn phí SKU này đúng một lần trên billing account | P = 5.000 / 20.000 / 50.000 → 28 / 133 / 343 USD; không phải số ảnh Doday upload |
| Details có `reviews` khi mở khối | Nếu A là tổng Atmosphere hiện có và R là request review **bổ sung thực sự**, phần tăng = `C_Atmosphere(A+R) − C_Atmosphere(A)`; không trừ thêm 1.000 free cho R | A = 30.000, R = 10.000 → tăng 250 USD; không tính request phiên trước như đã trả thay cho lần mở review mới |
| Metadata `photos`/attribution | Field tối thiểu có thể thuộc IDs Only (B3), media vẫn là SKU khác; không biến thành bước kết thúc phiên Autocomplete miễn phí | Theo field mask thực và B2; không nhân số media với mọi lần mở Map/chi tiết |

Ví dụ **tham chiếu cũ 4.930,10 + 133 + 250 = 5.313,10 USD/tháng** chỉ minh họa nếu giữ nguyên workload cũ rồi thêm 20.000 media/10.000 review requests; không là dự báo đã tối ưu/được đo hoặc quyền gọi theo ảnh/Map. Forecast mới phải bỏ request thụ động không hợp lệ, cộng request hợp lệ theo SKU và dùng chung free tier/các bậc. Không cam kết có đủ ngân sách cho mọi mức xem ảnh; chạm trần thì fallback riêng Google. Nhật ký chỉ truy vấn Doday, không thêm Google calls; chi phí DB/compute của nó nằm ngoài hai trần hiện có.

### 2.3 Trần và chặn sử dụng

**APPROVED – chủ dự án (PO/TL), 31/10/2026:**

| Phạm vi | Trần Google/tháng trước thuế |
| --- | ---: |
| G2–G10 phát triển/nội bộ | 50 USD |
| G11 beta khoảng 30 người [ASSUMPTION] | 100 USD |
| Ra mắt, đến 1.000 MAU | 1.000 USD |
| 1.001–5.000 MAU | 1,20 USD × MAU; tối đa **6.000 USD** |

Ở 5.000 MAU, mức cơ sở × 1,20 = 5.916,12 USD, làm tròn trần thành 6.000 USD. Kịch bản cao **vượt trần**, phải giới hạn sử dụng/mở rộng hoặc xin duyệt lại; không tự nâng trần. Mỗi lần tăng giai đoạn do PO xác nhận, không tăng tự động chỉ vì có thêm tài khoản.

Thiết kế chặn: **APPROVED COST + BATCH-AB A10/A11**. B7 chốt forecast/quota thực theo bằng chứng trước G6. TL/BE triển khai về sau, nghiệm thu G10, **chưa cấu hình/chưa kiểm thử**:

1. **APPROVED (COST):** chỉ proxy backend được gọi Places Web Service, không mở đường gọi bỏ qua proxy. **[PROPOSED – TL/BE]:** danh sách API/field mask cho phép, rate limit theo tài khoản và toàn hệ thống; vô hiệu API tính phí không dùng. Native Maps key chỉ được dùng đúng SDK/bundle, không cấp đường gọi Places trả phí ngoài proxy.
2. **APPROVED A11:** alerts 50/80/100% chỉ báo tin, **không chặn tiền**. Không lấy USD/tháng chia 30 nhập vào quota yêu cầu/phút/ngày; cấu hình/kiểm chứng cảnh báo còn phải làm.
3. **APPROVED COST + A11:** reservation nguyên tử trước mỗi call trả phí/retry, ledger chung mọi môi trường/instance; hết trần/bộ đếm lỗi thì fail-closed. Định giá SKU đắt nhất có thể tính theo phiên/field mask/giá bậc đầu, không dựa free tier/volume discount để chặn; reset đúng kỳ billing thực, không reset sớm/đếm đúp. Cấu hình múi giờ/chu kỳ thực theo account chọn B4, không tự đặt lại đầu tháng theo giờ máy. Forecast §2.1/2.2 vẫn trừ miễn phí đúng một lần/SKU, không lẫn với reservation bảo thủ.
4. **B7 duyệt kế hoạch và bao minh họa, chưa quota production:** Nearby 1.000; Text 900; Pro 900; Enterprise 1.400; Atmosphere (gồm review) 1.100; Autocomplete 400; Photo media 300 USD/tháng. Tổng 6.000, không tăng trần/cam kết đủ dùng. TL/BE đo/chốt forecast và quota thực trước G6; API có thể không tách quota theo SKU. Media URL/redirect không được bypass ledger.
5. **APPROVED (COST), cùng fallback ADD/OVERRIDE:** hết trần hoặc bộ đếm lỗi thì dừng tìm/nhận diện/làm mới Google có phí, báo trạng thái BR-P6; vẫn chụp, lưu nháp, giữ URL PENDING và xem dữ liệu Doday. Nút mở/chỉ đường bằng Google Maps URL vẫn được giữ. Không dùng dữ liệu Google cũ làm thông tin hiện tại. Không tự tăng trần hoặc mở probe/retry trả phí khi đang bị chặn.
6. G10 phải thử đồng thời/retry/vượt hạn mức, đối soát log SKU với billing export, đo chi phí thử; chỉ sau kiểm chứng mới được gọi là cơ chế chặn hoạt động. Thay đổi giá/thuế, API lọt qua, telemetry trễ vẫn là rủi ro; không bảo đảm hóa đơn tuyệt đối bằng cảnh báo/quota.
7. **APPROVED A10:** search ≥2 ký tự/debounce 400 ms; tối đa 2 retry tạm thời/tác vụ, backoff/Retry-After; breaker 5 lỗi liên tiếp/60 s, nghỉ 60 s rồi 1 probe. Không retry lỗi quyền vĩnh viễn hoặc probe trả phí lúc hết trần; mọi attempt vẫn reservation. Chưa kiểm thử.

**Lựa chọn nếu không chấp nhận trần:** (A) khuyến nghị giữ đầy đủ chức năng, trần 6.000 và giới hạn sử dụng; (B) trần nhỏ hơn, đóng đăng ký/tăng MAU theo chi phí đo được, chưa hứa phục vụ đủ 5.000 MAU; (C) tối ưu Text Search/phiên/field mask sau G2 nhưng vẫn chứng minh tìm tên/khu vực/loại đạt MVP-14. Không tự bỏ tự nhận diện, rating, giờ, hay đổi Maps provider để giảm tiền.

## 3. Ảnh, tải về và backup

### 3.1 Dung lượng

**APPROVED – DEC-07, 31/10/2026:** đầu ra ảnh chụp và ảnh chọn để upload có tỉ lệ **1:1**. Tỉ lệ hình vuông không phải mức nén hoặc kích thước file; không tự giảm dự toán chỉ vì ảnh vuông.

**APPROVED – DEC-07, tin CROP 31/10/2026:** chuẩn hóa hướng EXIF, cắt vuông ở giữa tự động (không kéo giãn), **không bước preview/xác nhận crop**; bản chính tối đa 2048 × 2048 px, thumbnail tối đa 400 × 400 px, không phóng lớn ảnh nhỏ; không upload ảnh gốc đầy đủ, chỉ giữ gốc tại máy. **[ASSUMPTION]:** ảnh 0,8 MB + thumbnail 0,04 MB, 10 ảnh/MAU/tháng, 50.000 ảnh/tháng. Kích thước không được suy ra chỉ từ độ phân giải; đo phân phối HEIC/JPEG ở G4. Dung lượng dưới đây xấp xỉ GB thập phân (1.000 MB); hóa đơn theo đơn vị/làm tròn của nhà cung cấp, cần đối soát ở G3.

- Tăng ảnh production: `5000 × 10 × 0,84 / 1000 = 42 GB/tháng`.
- Tải lại: 100 thumbnail + 10 ảnh lớn/MAU/tháng → `5000 × (100 × 0,04 + 10 × 0,8) / 1000 = 60 GB/tháng`; chưa có CDN công khai. Nhân lượt xem với lần tải thực/cache miss, không tính mọi lần mở là 1 GB.
- **Backup ảnh không mặc nhiên nằm trong backup database** (B6). Dự phòng một bản sao ảnh hiện hành độc lập + tối đa 35 ngày phiên bản đã xóa/thay thế; giả định phát sinh ≤42 GB/30 ngày → giữ thêm tối đa 49 GB. Đây là mô hình incremental theo object, **không** phải 35 bản full snapshot.
- Không trừ ảnh bị xóa khỏi production khi tính tích lũy; backup vẫn cộng 49 GB dự phòng. Nếu tần suất sửa/xóa hoặc bản backup nhiều hơn, phải tính lại. Chính sách hết backup ≤35 ngày (DEC-12) không tự có chỉ vì thêm một bản sao.

| Cuối tháng | Production | Bản sao hiện hành + dự phòng phiên bản cũ | Tổng dung lượng lập ngân sách |
| --- | ---: | ---: | ---: |
| 1 | 42 GB | 91 GB | 133 GB |
| 6 | 252 GB | 301 GB | 553 GB |
| 12 | 504 GB | 553 GB | 1.057 GB |

### 3.2 Hai mốc so sánh, chưa chọn nhà cung cấp

Nguồn B4/B5/B6. Giả định giá không đổi, cùng tài khoản chỉ hưởng mức miễn phí **một lần**:

Chi phí trong bảng là mức cho **một tháng giữ nguyên dung lượng ở mốc cuối tháng đó**, có dự phòng phiên bản cũ, không phải hóa đơn chính xác của tháng đang tăng dữ liệu. R2 tính trung bình mức lưu đỉnh từng ngày; Supabase tính GB-giờ (B4/B5), nên phải lấy usage thực để đối soát.

- **R2 Standard cho production và backup:** 0,015 USD/GB-tháng sau 10 GB miễn phí; Class A 4,50 USD/triệu sau 1 triệu, Class B 0,36 USD/triệu sau 10 triệu; egress từ R2 không tính phí. Cơ sở khoảng 200.000 write (2 object × production/backup × 50.000 ảnh) + 50.000 thao tác dự phòng; ≤1,1 triệu lượt đọc/HEAD/tháng. Cả hai nhóm dưới free tier; không dựa vào Infrequent Access. Phí Workers/compute, xử lý ảnh, backup DB không nằm trong mức này.
- **Ví dụ gói Supabase Pro + backup ảnh R2:** gói từ 25 USD/tháng gồm 100 GB storage, 250 GB egress; storage vượt 0,0213 USD/GB-tháng. Cơ sở tải lại 60 GB + chuyển 42 GB ảnh mới sang backup R2 = khoảng **102 GB egress/tháng**, dưới allowance nếu dịch vụ khác chưa dùng hết. Restore/full-copy có thể vượt allowance, cần tính riêng trước diễn tập hoặc phục hồi; không bảo đảm 50 USD cho tháng có sự cố. Backup DB không chứa bytes của object Storage (B6). Gói gồm cả thành phần backend nên 25 USD **không được cộng lại** khi lập tổng ngân sách backend. Compute thêm/project/PITR/thuế không được giả định đã bao gồm.

| Thời điểm | R2: production + backup | Gói ví dụ 25 USD + storage vượt + backup R2 |
| --- | ---: | ---: |
| Tháng 1 | ~1,85 USD | ~26,22 USD |
| Tháng 6 | ~8,15 USD | ~32,60 USD |
| Tháng 12 | ~15,71 USD | ~41,75 USD |
| Tháng 12, gấp đôi số ảnh (20/MAU/tháng) | ~31,56 USD | ~60,78 USD |

Công thức R2: `max(0, ceil(GB) − 10) × 0,015` (usage/operations thực và cách làm tròn cần đối soát). Ví dụ tháng 12 kiểu trọn bộ: `25 + (504 − 100) × 0,0213 + (553 − 10) × 0,015 ≈ 41,75`. Giữ tất cả ảnh ở mức sử dụng này qua năm hai tiếp tục tăng storage; 50 USD không phải mức vĩnh viễn.

**APPROVED – chủ dự án (PO/TL), 31/10/2026: 50 USD/tháng cho ảnh Doday trong năm đầu ở kịch bản cơ sở**, gồm production/thumbnail, reads, truyền tải và bản sao trong các mô hình trên; không gồm backend riêng, email, xử lý ảnh/compute, PITR/backup DB, pháp lý, nhân công, tài khoản developer, thuế. Provider/vùng chọn ở G3, không mặc nhiên R2/Supabase. CROP đã duyệt 2048/400 px/gốc chỉ máy; mất máy/xóa app có thể mất gốc. **OVERRIDE đã thêm ảnh/review Google trong 1.0 nhưng chi phí chúng thuộc trần Google DEC-09**, không phải storage ảnh Doday, không có ngân sách tăng thêm hoặc quyền sao chép media Google. Không mở friends/community hoặc chọn provider mới.

### 3.3 Hạn mức và nghiệm thu

- **APPROVED A6:** SAFE-12 tối đa 200 ảnh/ngày (reset 00:00 Việt Nam), nguồn 20 MB/ảnh, avatar 10 MB, storage 5 GB/tài khoản; **chống lạm dụng**, không mức dùng cơ sở. 5.000 ×5 GB =**25 TB production** chưa backup; 50 USD không đủ mọi tài khoản dùng hết. Quota không phải đã cấp đủ dung lượng.
- **APPROVED A7/A11, TL/BE G3/G10:** admission giữ chỗ byte/chi phí trước cấp upload, tính thumbnail/storage/backup/read/truyền tải đến kỳ kế; alerts 50/80/100%. Server kiểm cả tài khoản và trần tổng, tổng ưu tiên. Chạm trần dừng cấp upload mới, ảnh giữ local, không tự xóa ảnh synced. Chi phí ảnh cũ tiếp tục; dừng upload không bảo đảm ngừng hóa đơn. Backup object tách DB; B4 chọn cách thực hiện trước G3, chưa triển khai.
- G4 đo ≥200 ảnh theo Q-09, bao gồm size bản chính/thumbnail; G10 thử vượt quota đồng thời, URL ký và rò read traffic, restore DB + bytes ảnh độc lập, kiểm xóa backup hết hạn. G11 đo ảnh/MAU, cache miss, reads, byte lưu/xóa. Ngưỡng/chi phí **chưa đo**, cơ chế chặn **chưa kiểm thử**.

## 4. Tải và điều kiện tính lại

DEC-10: **[ASSUMPTION]** DAU/MAU 20% → 1.000 DAU; 60 request Doday/DAU/ngày → 60.000/ngày; 15% vào giờ cao điểm → 2,5 request/giây trung bình; burst ×4 → đỉnh 10 request/giây. Q-14 thử **20 request/giây trong 30 phút = 36.000 request**. Đây không phải 5.000 người đồng thời và không phải 60 request Google/người/ngày. Dùng stub cho load test nhà cung cấp ngoài; chạy kiểm chứng integration thật riêng có trần và bằng chứng, không suy kết quả stub thành SLA Google.

Tính lại trước khi tăng người dùng hoặc khi lượng gọi/MAU, tỷ lệ phiên bỏ dở, số ảnh, kích thước, số bản backup, provider/vùng, field mask hay giá thay đổi. Chưa có ngân sách cho compute/DB/auth/email/quan trắc; PO/TL phải lập phần còn lại ở G3. Không dùng tổng **trần đã duyệt 6.050 USD/tháng** của hai nhóm ở quy mô 5.000 MAU/năm đầu làm tổng ngân sách dự án. Phê duyệt tiền không phải bằng chứng cơ chế chặn đã hoạt động hoặc ứng dụng đạt chất lượng.

## 5. Nguồn chính thức

Đều truy cập **31/10/2026**. Ngày truy cập không phải ngày giá có hiệu lực; chốt lại tại G3/G10/ngày mở billing. URL giữ dạng mã để đối chiếu:

| Mã | Tài liệu | URL |
| --- | --- | --- |
| B1 | Google Maps Platform, Main pricing list | `https://developers.google.com/maps/billing-and-pricing/pricing` |
| B2 | Places API (New), Autocomplete session pricing | `https://developers.google.com/maps/documentation/places/web-service/session-pricing` |
| B3 | Places API (New), Place Details field masks/SKU | `https://developers.google.com/maps/documentation/places/web-service/place-details` |
| B4 | Cloudflare R2, Pricing | `https://developers.cloudflare.com/r2/pricing/` |
| B5 | Supabase, Pricing và storage overage | `https://supabase.com/pricing` ; `https://supabase.com/docs/guides/platform/manage-your-usage/storage-size` |
| B6 | Supabase, Database Backups (không gồm object Storage) | `https://supabase.com/docs/guides/platform/backups` |
