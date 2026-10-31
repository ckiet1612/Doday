# G1 – Đặc tả phát hành Doday 1.0

**Trạng thái G1: APPROVED**. Chủ dự án xác nhận với tư cách Chủ sản phẩm và Trưởng kỹ thuật ngày **31/10/2026, giờ Việt Nam**. Đây là duyệt đặc tả/kế hoạch, không phải nghiệm thu ứng dụng.

Thang trạng thái: `DRAFT` đang soạn · `READY_FOR_REVIEW` đủ nội dung, chờ chủ sản phẩm + trưởng kỹ thuật duyệt · `APPROVED` mọi quyết định mức B-G1 và ngưỡng chất lượng đã được xác nhận, có tên người duyệt và ngày thực tế. Người lập bộ tài liệu không tự ký duyệt.

Ngày lập: 30/10/2026 · Cập nhật: **31/10/2026, giờ Việt Nam** · Người duyệt: Chủ dự án (kiêm PO/TL). **G1-SIGNOFF:** tin “Duyệt” trả lời câu hỏi duyệt toàn bộ đặc tả G1 với tư cách PO/TL, hoàn tất mục C sau BATCH-AB. Giữ công tắc **Ẩn trong vùng riêng tư** mặc định bật/có thể tắt trong Cài đặt, Hide Location độc lập mặc định bật và private-only 1.0. Các lựa chọn/bằng chứng B vẫn theo cổng đã duyệt; không tự bắt đầu G2.

**G1-ACCEPTANCE (31/10/2026):** Chủ dự án chính thức chấp nhận hoàn toàn G1 sau khi sửa hai phát hiện review về thiết bị offline và mã BR-P8/BR-P9; cho phép chia commit và push tài liệu G1 lên `main`, không thêm Co-Author. Biên bản tại `approval-batch.md` §7. Giữ APPROVED và các điều kiện cổng B, không coi đây là nghiệm thu ứng dụng hoặc cho phép triển khai G2.

## 1. Mục tiêu G1

Chuyển tài liệu định hướng Doday thành phạm vi 1.0 có thể kiểm thử: backlog có truy vết, hành trình người dùng, quy tắc nghiệp vụ, mô hình quyền riêng tư, định nghĩa chỉ số, sổ quyết định và sổ rủi ro (DODAY_IOS_ROADMAP.md §3 G1).

## 2. Danh mục tài liệu

| File | Nội dung |
| --- | --- |
| [product-spec.md](product-spec.md) | Mục tiêu 1.0, persona giả thuyết, phạm vi trong/ngoài, 4 hành trình J1–J4, quy tắc nghiệp vụ BR-*, trạng thái/lỗi |
| [backlog.md](backlog.md) | Ma trận 69 yêu cầu (30 MVP + 39 bổ sung), ca Given/When/Then tách 1.0/PUB, phụ thuộc, giai đoạn, vai trò |
| [decisions.md](decisions.md) | 32 quyết định DEC-01…32; OVERRIDE/ZONE/COST/BATCH-AB, ranh giới phê duyệt và nhật ký thay thế |
| [privacy-and-data.md](privacy-and-data.md) | Kiểm kê dữ liệu, quyền iOS, riêng tư/công khai, lưu giữ/xóa, ranh giới Google/Doday, chính sách tài khoản |
| [quality-and-acceptance.md](quality-and-acceptance.md) | Chỉ số Q-01…Q-17, cách tính, cỡ mẫu, môi trường, bộ mẫu, kế hoạch kiểm thử G1–G11 |
| [risks.md](risks.md) | 32 rủi ro, gồm zone/GPS không chắc chắn, queue/retry và quyền vị trí, phụ trách/điều kiện chặn |
| [budget-and-capacity.md](budget-and-capacity.md) | Dự toán 5.000 MAU đã trừ free tier; trần/COST/A đã duyệt, forecast/quota thực chốt theo B7 |
| [privacy-api-addendum.md](privacy-api-addendum.md) | Nguồn ADD §1…9, Hide Location/Home Zone, mô hình quyền, trigger API, minimization/outage, xung đột và nguồn chính thức |
| [approval-batch.md](approval-batch.md) | Duyệt gộp A1–A14/B1–B9, công tắc vùng riêng tư, lựa chọn/bằng chứng còn thiếu và ký duyệt toàn G1 |

## 3. Nguồn đã đọc

| Nguồn | Trạng thái |
| --- | --- |
| Tài liệu định hướng gốc (`/Users/macbook/.t3/userdata/attachments/70b9df6b-0d67-4e86-8363-688cfb2e27e4-daf9c869-4f38-48c8-8987-5cacc559d702-txt.txt`, 1.334 dòng, mục 1–20) – ký hiệu **SRC §x** | Nguồn đọc được; đối chiếu lại mục 15 ngày 31/10 |
| `DODAY_IOS_ROADMAP.md` (ngày lập 30/10/2026) – ký hiệu **ROADMAP** | Đọc toàn bộ |
| **ADD §1…9 / CROP / OVERRIDE:** yêu cầu bổ sung, duyệt cắt giữa và tin “Xác nhận vẫn riêng tư. Cho phép ghi đè các điểm đó trừ điểm đầu tiên” ngày 31/10/2026 | Đối chiếu 9 mục và năm điểm xung đột đã trình; nguồn quyết định mới, không giả làm SRC/roadmap; lịch sử ở decisions §3 |
| **ZONE:** tin “Duyệt” ngày 31/10/2026 trả lời câu hỏi liệt kê 4 điểm về zone/Hide/radius/GPS RAM | APPROVED đúng 4 điểm ở DEC-31; không suy thành duyệt toàn bộ privacy, thiết kế chặn chi phí hoặc G1 |
| **COST:** tin “Duyệt” ngày 31/10/2026 trả lời câu hỏi về proxy, giữ chỗ ngân sách nguyên tử và ngừng gọi Google trả phí khi hết trần hoặc bộ đếm lỗi | APPROVED đúng 3 nguyên tắc ở DEC-09; không duyệt phân bổ SKU/quota/tham số, phần privacy còn mở hoặc toàn G1 |
| **BATCH-AB:** tin “Duyệt toàn bộ mục A và mục B” ngày 31/10/2026, kèm mặc định bật/có thể tắt ẩn vùng riêng tư tại Cài đặt | APPROVED A1–A14 và kế hoạch B1–B9; thay trạng thái chờ duyệt tương ứng trước đây, không xác nhận mục C ký toàn G1, provider/pháp lý/kết quả đo; nguồn và truy vết ở approval-batch |
| **G1-SIGNOFF:** tin “Duyệt” ngày 31/10/2026 trả lời câu hỏi xác nhận toàn bộ đặc tả G1 với tư cách PO/TL để chuyển APPROVED | APPROVED toàn bộ G1 (mục C); biên bản ở §8 và approval-batch §6. Không thay lựa chọn/bằng chứng ở các cổng B hoặc cho phép triển khai ngoài phạm vi tài liệu |
| AGENTS.md / CLAUDE.md | Không tồn tại trong workspace |
| Apple App Review Guidelines (1.2, 1.2.1(a), 2.1(a), 2.4.1, 4.8, 5.1.1, 5.1.1(v), 5.1.2, 5.1.5) – developer.apple.com/app-store/review/guidelines | Truy cập 30/10/2026; trang không ghi ngày cập nhật |
| Apple Upcoming Requirements – developer.apple.com/news/upcoming-requirements | Truy cập 30/10/2026: Xcode 26 + SDK iOS 26 từ 28/04/2026; target ≥ iOS 13 từ 09/09/2026; age rating mới từ 31/01/2026. **Không thấy** mục "iOS 27 SDK từ 04/2027" mà roadmap nêu → chưa xác minh |
| Apple Offering account deletion in your app | Truy cập 30/10/2026 |
| Google Places API Policies and attributions | Truy cập 30/10/2026, trang cập nhật 28/10/2026 |
| Google Place Details (New) – SKU/field mask | Truy cập 30/10/2026, cập nhật 28/10/2026 |
| Google Maps URLs Get Started | Truy cập 30/10/2026, cập nhật 28/10/2026 |
| Google Maps Platform pricing, Autocomplete session pricing, Place Details | **Kiểm tra lại 31/10/2026**; URL B1/B2/B3 trong tài liệu ngân sách; sửa dự toán phiên Autocomplete |
| Cloudflare R2 Pricing; Supabase Pricing, storage overage và Database Backups | **Kiểm tra 31/10/2026**, nguồn B4/B5/B6; chỉ là phương án so sánh, chưa chọn provider |
| Maps SDK for iOS / Places SDK for iOS release notes | Truy cập 30/10/2026: bản 11.2.0, tối thiểu iOS 16 |
| Google Maps Platform Service Specific Terms §14.2/14.3 | **Đọc được 31/10/2026**, thay trạng thái lỗi truy cập 30/10; ngoại lệ tọa độ Places tối đa 30 ngày rồi xóa, không suy sang trường khác; áp dụng hợp đồng/TTL cụ thể chờ LEGAL |
| Apple User privacy and data use (ATT), App privacy details, TestFlight, phased release | **Không truy cập lại** trong G1; chỉ dẫn lại theo roadmap, cần đối chiếu ở G12A |
| Place Photos (New), Place Details và Google pricing | Tải lại read-only **31/10/2026**, HTTP 200; P5/P3/B1, đối chiếu media/attribution/không cache photo name và SKU review; không gọi Places API tính phí |

Các dòng truy cập 30/10 là lịch sử đối chiếu của bản nháp trước, không coi là xác minh mới ngày 31/10. Apple App Review Guidelines được mở lại 31/10 tại `https://developer.apple.com/app-store/review/guidelines/`; các điều kiện policy vẫn phải kiểm ở G12A. Văn bản pháp luật Việt Nam ở `privacy-and-data.md` §7b mới là nguồn thứ cấp, **chưa đối chiếu văn bản gốc**. Không coi rủi ro pháp lý đã được xử lý vì có tiêu chí hoặc vì chủ dự án nhận vai trò LEGAL.

## 4. Hiện trạng khảo sát workspace (chỉ đọc, kiểm tra lại 31/10/2026)

Quan sát trong file, **không** build/chạy:

- Git: đã kết nối (cập nhật 30/10/2026), `origin` = GitHub `ckiet1612/Doday`, nhánh `main`, commit đầu `84e883b`. Khảo sát ban đầu trong phiên chưa thấy repo.
- `project.yml` (XcodeGen): app `Doday`, bundle `com.ckiet1612.doday`, **deployment target iOS 17.0 cho app và test** (đổi từ 15.0 theo DEC-04, 30/10/2026), `TARGETED_DEVICE_FAMILY "1,2"`, Swift 5.0, MARKETING_VERSION 1.0.0; bước SwiftLint trước build.
- Project Xcode: chỉ còn `Doday.xcodeproj`, sinh lại từ `project.yml` bằng XcodeGen. `Doday 2.xcodeproj` (bản lỗi gõ nhầm bundle ID `com.ckiet1612.com`) đã bị xóa khỏi máy theo chỉ đạo của chủ dự án ngày 30/10/2026. `.gitignore` bỏ qua `*.xcodeproj`.
- `ContentView.swift` đổi `NavigationView` → `NavigationStack` (iOS 17). Chưa build.
- Mã nguồn: `DodayApp.swift` + `ContentView.swift` hiển thị "Xin chào, Doday". Chưa có camera, map, vị trí, backend, extension, dependency Google.
- Kiểm thử: 1 unit test dựng `ContentView`; **chưa chạy** trong G1.
- Công cụ: có `.swiftlint.yml`, `.swiftformat`. Không chạy Xcode/build/lint/test trong lượt tiếp tục; phiên bản Xcode 27.1 là ghi nhận lịch sử, không xác minh lại ở lượt này.
- Trong cấu hình và cây source đã khảo sát chưa thấy dependency Google/backend. Không đọc file bí mật, không tìm/chép API key hoặc dữ liệu cá nhân thật.
- Git đầu lượt cập nhật ngân sách/ảnh đã có thay đổi `ContentView.swift`, `project.yml`, `product-spec.md`, `backlog.md` và 6 file G1 chưa track. Giữ nguyên thay đổi ngoài `docs/g1/`; kiểm hash trước/sau của source, test, cấu hình, project Xcode và roadmap. Không build, test app, mở simulator, khởi động dịch vụ, gọi API tính phí, tạo tài khoản, dùng subagent, commit hoặc push.

Kết luận: chưa có hạng mục MVP nào được hiện thực hóa trong mã. Mọi hạng mục ở backlog đều "chưa bắt đầu / chưa kiểm thử".

## 5. Checklist nghiệm thu G1 (đối chiếu ROADMAP G1)

| Điều kiện G1 trong roadmap | Tài liệu đáp ứng | Tài liệu xong | Đã duyệt |
| --- | --- | --- | --- |
| 30 MVP, Share Extension và an toàn phát hành có mã yêu cầu, ưu tiên, ca nghiệm thu, người phụ trách | backlog.md §2–8 | Có, 69 yêu cầu; chủ dự án kiêm mọi vai trò | APPROVED đặc tả/backlog qua G1-SIGNOFF ngày 31/10/2026; ca chưa chạy, tham số cần đo theo cổng B |
| Nháp có thể chưa có địa điểm; roadmap cũ yêu cầu public có Place + lựa chọn rõ; GPS ≠ public/Visited | BR-M3/M4/M5, BR-L5/8/9, BR-S3; DEC-25/32 | Có, giữ dấu vết nguồn và phần thay thế | **OVERRIDE đã thay điều kiện Place + public từng lần**: ảnh không nơi hợp lệ, quyền cấu hình độc lập; 1.0 vẫn private-only. Không ghi điều kiện roadmap cũ là đã đáp ứng nguyên văn |
| Mặc định riêng tư là đề xuất cần duyệt | DEC-11/26/32, BR-M0/M5 | Có | 1.0 luôn riêng tư, tái xác nhận 31/10; bản chia sẻ sau dùng mặc định hai trục an toàn, không tự mở PUB |
| Ảnh chưa đăng nhập, đăng xuất/đổi tài khoản, xóa tài khoản, thời hạn lưu; không chuyển nháp A → B | BR-A1…A8, privacy-and-data.md §5, §7, DEC-12, DEC-16, DEC-17 | Có | APPROVED chính sách/bảng ca qua G1-SIGNOFF ngày 31/10/2026; chưa kiểm thử |
| Duyệt ngưỡng mục 4 và cách đo; không đổi ngưỡng sau thử | quality-and-acceptance.md §2, DEC-20/27 | Có | Ngưỡng đã duyệt, Q-06 tạm chốt/Q-15 chỉ PUB; B1/B2 duyệt kế hoạch/mẫu số/ngưỡng thử, hiệu chỉnh/chốt trước đo G2; chưa đo |
| Có người hỗ trợ/kiểm duyệt; nếu không thì chưa mở công khai | DEC-15/23, BR-C3, R-02/28 | Có | Chủ dự án hỗ trợ, chưa dự phòng/kênh thật; A14/B8 duyệt SLA và kênh/phương án vắng mặt trước beta ngoài, Support URL trước G12A. Không cộng đồng 1.0 |
| Chốt thị trường, nhóm tuổi, iPhone/iPad, iOS tối thiểu, đăng nhập, backend, ngân sách Google/ảnh, tải, người vận hành | DEC-01…10/15/23/25…32 | Có | Chính sách/tham số A đã duyệt; B chốt provider/codec/pháp lý/quota theo bằng chứng đúng cổng. MAU/hệ số vẫn giả định, không tải đã đạt |
| Bằng chứng: đặc tả 1.0, backlog truy vết, danh sách quyết định, sổ rủi ro, kế hoạch kiểm thử | Các tài liệu trong §2 | Có | APPROVED toàn bộ G1 qua G1-SIGNOFF ngày 31/10/2026, biên bản §8; không phải bằng chứng G2–G12 |

## 6. Tự rà soát

- **Kết quả kiểm tra tài liệu ngày 31/10/2026:** 10 tài liệu; 30/30 ID MVP đúng thứ tự nguồn; **69 yêu cầu, 69 khối và 277 ca Given/When/Then** (gồm PUB/ca chờ chốt tham số); 18 dòng chỉ số gốc (Q-01…17 + Q-08b), 2 chỉ số QP-01/02; 32 quyết định, 32 rủi ro; **11 liên kết file nội bộ hợp lệ**. Không thay số tiền/forecast tham chiếu; không coi đây là ca đã chạy hoặc bằng chứng tiết kiệm API.
- **Giới hạn thay đổi:** 11 file Git theo dõi/liệt kê ngoài `docs/g1/` có hash SHA-256 trước/sau khớp, gồm source, test, `project.yml`, project Xcode và roadmap; giữ nguyên thay đổi có trước. `git diff --check` không báo lỗi; kiểm whitespace cho cả file G1 chưa track không phát hiện lỗi. Không có build/test ứng dụng trong lượt này.
- **30 ID MVP:** đếm trong backlog.md, mỗi ID `DODAY-MVP-01…30` xuất hiện đúng 1 dòng trong ma trận và 1 khối ca nghiệm thu; thứ tự và tên khớp SRC §15. Không trùng, không thiếu.
- **Yêu cầu bổ sung:** EXT/DATA/SAFE/GGL dùng nhóm ID riêng, không thay thế hay đánh số lại MVP.
- **Mỗi yêu cầu** có nguồn, ưu tiên, phụ thuộc, vai trò, ≥1 ca thành công và ≥1 ca lỗi/biên; kiểm cấu trúc và đối chiếu nội dung lại 31/10. Đếm ca không thay thế chạy ca.
- **Phạm vi:** giữ 8 yêu cầu ADD trước, thêm GGL-10 ảnh Google và DATA-07 nhật ký cá nhân theo OVERRIDE; GGL-04 review chuyển thành bắt buộc 1.0. Không friends/public/tracking hành trình, chat, follower, thanh toán, AI tìm kiếm, chỉ đường nội bộ hoặc Feed. Bộ sưu tập và Want to visit/Visited giữ nguyên.
- **Thay đổi phạm vi đã duyệt (DEC-15 C):** phần công khai của MVP-03/09/10/11/13/15/25/26/27 và SAFE-03/04/05/06, phần kiểm duyệt SAFE-07 là `PUB`. MVP-26 không được tuyên bố đã giao chức năng xem cộng đồng chỉ vì có ca kiểm tra không hiện cộng đồng. Không xóa/đánh số lại ID; mọi ca PUB không áp dụng ở 1.0, không tính là đạt.
- **Share Extension** (DEC-13) và **review Google từng bài** (DEC-14/28) tách riêng, hiện cùng thuộc 1.0; rating + tổng lượt (MVP-22) vẫn độc lập, không tự tải review khi xem rating.
- **Nhất quán:** mặc định riêng tư, đăng nhập trước chụp, quy tắc xung đột và thời hạn xóa giống nhau giữa product-spec, privacy-and-data, decisions.
- **Không tuyên bố đạt ngưỡng:** mọi chỉ số áp dụng ở 1.0 đều "chưa đo"; Q-15 không áp dụng ở 1.0; mọi ca "chưa kiểm thử".
- **Dự toán:** công thức theo bậc giá, 3 tổng Google, dung lượng theo tháng, chi phí backup và tải đỉnh đã tính lại bằng phép tính chỉ đọc. Đây không phải kết quả đo billing, hiệu năng hay thử tải.
- **Bổ sung ADD/CROP/OVERRIDE:** 2048/400 px/cắt giữa không preview/gốc tại máy giữ nguyên; OVERRIDE thêm 18 ca so với bản 251, thay các ca xung đột, không hạ ngưỡng hoặc trần tiền. Dự toán cũ chỉ tham chiếu; ví dụ chi phí ảnh/review bổ sung không là forecast tối ưu.
- **Bổ sung ZONE:** duyệt đúng 4 điểm DEC-31, thêm 3 ca cho mặc định Hide/radius/lưu local và cụ thể hóa mốc TTL 59/60/61 s trong ca hiện có. Đánh số lại E3/E4 của PRIV-03 để hết trùng nhãn E2; không xóa ca hoặc đổi phạm vi đã duyệt.
- **Bổ sung COST:** ghi duyệt proxy/reservation nguyên tử/fail-closed, giữ nguyên 69 yêu cầu và 272 ca; ca GGL-01 E2/E3 và GGL-09 E3 đã bao phủ nguyên tắc này nhưng chưa chạy. Không đổi trần/forecast, không duyệt thêm phân bổ SKU/quota/retry, SAFE-12 hoặc privacy; chỉ cập nhật 7 file trong `docs/g1/`.
- **Bổ sung BATCH-AB:** A1–A14 và kế hoạch B1–B9 đã duyệt, thay trạng thái tương ứng sau ZONE/COST; thêm 4 ca PRIV-02 cho công tắc mặc định/tắt/bật/revision/đổi tài khoản. Tắt zone không tắt Hide/cấp consent/public/hiện ảnh cũ. Không đổi 69 ID, ngưỡng roadmap, trần hoặc forecast.
- **G1-SIGNOFF:** cập nhật trạng thái/phê duyệt trong 10 tài liệu, thêm biên bản mục C và nhật ký xác nhận ngày 31/10/2026; không đổi nội dung yêu cầu, ca nghiệm thu, ngưỡng, trần hoặc các lựa chọn/bằng chứng còn thiếu theo cổng B.
- **Sửa sau review 31/10/2026:** SAFE-01 S2 lấy mốc B nhận xác nhận xóa/thu hồi do xóa từ backend; thêm E3 cho offline → online, không phát lại hàng đợi cũ hoặc coi 401 là xác nhận xóa. Đồng bộ `privacy-and-data.md` §5 và MVP-01 E1. Giữ BR-P8 cho purge/fallback, đổi attribution thành BR-P9 và liên kết GGL-02; mã quy tắc không còn trùng. Tổng ca tăng 276 → 277, không đổi 69 yêu cầu, trạng thái APPROVED, ngưỡng, ngân sách hoặc cổng B; chưa kiểm thử ứng dụng.
- **Xung đột đã xử lý:** deployment target iOS 15 không tương thích Google Maps/Places SDK (tối thiểu iOS 16). Chủ dự án đã chốt iOS 17.0 (DEC-04); `project.yml` đã được cập nhật theo chỉ đạo; chưa build để kiểm chứng (R-13).

## 7. Quyết định còn mở (theo mức chặn)

**Đã chốt:** các quyết định 30–31/10/2026 ở decisions §3, gồm thị trường/13+/iOS17/kiêm nhiệm, kiến trúc, Share Extension, private-only, trần Google tối đa 6.000 USD/tháng và ảnh 50 USD/tháng năm đầu, crop giữa 1:1/2048/400 không preview, OVERRIDE/ZONE/COST. Tổng Google cũ 4.930,10 USD đã trừ miễn phí/SKU, không trừ lại và không phải forecast tối ưu sau ADD.

**Đợt mới BATCH-AB:** A1–A14 **đã APPROVED**, không còn chờ duyệt BR-M11/quota-admission ảnh, heuristic/consent/revision/strip-all, OTP/URL/log/support, reservation/reset/alerts/retry/breaker. B1–B9 **đã duyệt kế hoạch và các cổng chốt theo bằng chứng**, không suy thành các lựa chọn/kết quả chưa có. Bảng đầy đủ ở `approval-batch.md`.

**Mặc định vùng riêng tư:** quản lý nhiều vùng trong Cài đặt; công tắc Ẩn trong vùng riêng tư mặc định bật, có thể tắt. Local-only theo tài khoản, tắt giữ danh sách vùng. Hide Location độc lập vẫn mặc định bật. Tắt zone không cấp consent/public hoặc hiện Place/replay job ảnh cũ; các gate khác vẫn áp dụng.

**Mục C đã xác nhận (G1-SIGNOFF, 31/10/2026):** Chủ dự án trả lời “Duyệt” cho câu hỏi duyệt toàn bộ đặc tả G1 với tư cách PO/TL để chuyển APPROVED. Không còn chờ ký G1 hoặc duyệt lại A/B. Các lựa chọn/bằng chứng còn mở dưới đây giữ đúng cổng, không được coi là đã chọn/đã đo nhờ chữ ký G1; lượt này không thực hiện G2.

**Công việc còn lại theo kế hoạch B đã duyệt:**

| Cổng | Lựa chọn / bằng chứng còn thiếu | Phụ trách |
| --- | --- | --- |
| Trước đo/kết thúc G2 | Thiết bị/mạng/bộ mẫu thực, T_auto/T_confirm/TTL ngữ cảnh/Q-06; UI chi tiết, cảnh báo thư viện và movedPlace tùy chọn; quyền nguồn/TTL/attribution/lọc business status | TL/QA/DES/LEGAL/PO |
| Trước G3 | Provider/storage/email/region/telemetry/backup, pháp nhân/chủ account và ngân sách backend còn thiếu; luật/cơ chế người đại diện/trường tuổi/bằng chứng-retention/bản pháp lý gốc | PO/TL/LEGAL |
| Trước G4/G6 | Codec/chất lượng/giới hạn byte theo đo G4; forecast tối ưu và quota/rate/media thực trước G6, không tăng trần | TL/iOS/BE/QA/PO |
| G10/G11/G12A | Bằng chứng quyền/chi phí/restore/hiệu năng; kênh hỗ trợ thật và phương án vắng mặt trước beta ngoài; rà soát độc lập hoặc ngoại lệ có ghi nhận, không miễn luật/lỗi nghiêm trọng | QA/SEC/OPS/LEGAL/PO/TL |
| B-PUB | Bản phát hành riêng, ACL/profile/nơi thủ công, kiểm duyệt/lọc/người vận hành; hướng recent/quota/log B9 không mở friends/public ở 1.0 | PO/SEC/LEGAL/OPS |

Chủ dự án kiêm các vai trò trên; chưa có người dự phòng hoặc chuyên gia độc lập. **Duyệt kế hoạch không phải đã làm việc đó**. G1 đã APPROVED không chứng minh app/G2–G12 đạt chất lượng.

## 8. Biên bản duyệt

| Vai trò | Tên | Quyết định | Ngày | Ghi chú |
| --- | --- | --- | --- | --- |
| Chủ sản phẩm | Chủ dự án (kiêm nhiệm) | APPROVED toàn bộ đặc tả G1, backlog, quyết định, mô hình dữ liệu/quyền riêng tư, ngân sách, rủi ro và kế hoạch/ngưỡng nghiệm thu; giữ lựa chọn/bằng chứng B theo cổng | 31/10/2026 | Xác nhận điện tử “Duyệt” trực tiếp cho câu hỏi PO/TL; G1-SIGNOFF ở approval-batch §6 và decisions §3 |
| Trưởng kỹ thuật | Chủ dự án (kiêm nhiệm) | APPROVED cùng phạm vi; không xác nhận ứng dụng đã đạt ngưỡng hoặc cho phép bỏ qua điều kiện cổng sau | 31/10/2026 | Cùng người xác nhận hai vai trò, không kiểm tra chéo độc lập (R-22); không tạo tên/chữ ký thay người duyệt |
