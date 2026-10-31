# G1 – Bổ sung quyền riêng tư vị trí và sử dụng API

Ngày: **31/10/2026**, Asia/Ho_Chi_Minh. Trạng thái: **APPROVED trong bộ đặc tả G1** qua G1-SIGNOFF của Chủ dự án kiêm PO/TL; biên bản approval-batch §6. Không phải bản triển khai hoặc bằng chứng kiểm thử.

Nguồn **ADD §1…9**: yêu cầu bổ sung của chủ dự án trong phiên G1 ngày 31/10/2026, tiêu đề “TỐI ƯU API VÀ BẢO VỆ QUYỀN RIÊNG TƯ”. **CROP**: cùng tin xác nhận “Duyệt, nhưng không cần xem trước chỉ cần cắt giữa”. Không phải nội dung có sẵn trong SRC hoặc roadmap; không sửa hai nguồn đó.

**OVERRIDE (31/10/2026):** “Xác nhận vẫn riêng tư. Cho phép ghi đè các điểm đó trừ điểm đầu tiên”. Giữ private-only; cho phép thay bốn nhóm xung đột còn lại đã trình, không duyệt mọi thông số kỹ thuật hoặc toàn G1. Nhật ký tại decisions §3 ghi quy tắc cũ và phần bị thay thế.

**ZONE (31/10/2026):** chủ dự án trả lời “Duyệt” cho bốn điểm: zone chỉ tại máy; Hide bật mặc định; bán kính 200 m, chỉnh 100–1.000 m; mẫu GPS đầu vào chỉ trong RAM tối đa 60 s. Đây là APPROVED một phần DEC-31, không duyệt heuristic/consent/revision/strip-all, các tham số khác hoặc toàn G1.

**COST (31/10/2026):** chủ dự án trả lời “Duyệt” cho proxy backend, giữ chỗ ngân sách nguyên tử và ngừng gọi Google trả phí khi hết trần hoặc bộ đếm lỗi. APPROVED đúng ba nguyên tắc DEC-09, không duyệt phân bổ SKU/quota/tham số retry hoặc toàn G1; chưa triển khai/kiểm thử.

**BATCH-AB (31/10/2026):** A1–A14 và kế hoạch B1–B9 đã duyệt, truy vết ở `approval-batch.md`; chốt heuristic/consent/revision/strip-all/tham số A, không chọn thay provider/codec hoặc xác minh pháp lý. **G1-SIGNOFF** sau đó đã duyệt toàn bộ G1 (§6 biên bản). Giữ công tắc **Ẩn trong vùng riêng tư** mặc định bật, cấu hình/tắt trong Cài đặt; Hide Location độc lập mặc định bật. Không thay quyền dữ liệu bên thứ ba hoặc bằng chứng các cổng sau.

Trong bộ G1, “zone chặn/zone-blocked” là kết quả **khi công tắc bảo vệ bật**; tắt chủ động bỏ gate zone cho tác vụ mới, không bỏ Hide/consent/độ tin cậy/trigger. Các đoạn ZONE/COST ở trên là phạm vi các tin duyệt trước BATCH-AB, không phải yêu cầu duyệt lại.

## 1. Phạm vi và các quy tắc thay thế đã xác nhận

- **APPROVED (CROP / DEC-07):** đầu ra vuông, cắt giữa tự động sau chuẩn hóa hướng, không bước xem trước/xác nhận vùng cắt; bản chính tối đa 2048 × 2048 px, thumbnail tối đa 400 × 400 px, không phóng lớn ảnh nhỏ; gốc chỉ ở máy. Màn xem lại để nhập tiêu đề/Hide Location không đồng nghĩa phải có một bước duyệt crop. Không bổ sung công cụ chỉnh crop hoặc đệm viền.
- **Yêu cầu mới từ chủ dự án:** Hide Location, Home Privacy Zone, tách dữ liệu GPS/nhận diện/hiển thị, không nhận diện bằng tọa độ riêng tư, không gọi Places chỉ vì mở app/camera/di chuyển Map; quota, retry hữu hạn và circuit breaker. Thông số A đã duyệt qua BATCH-AB; lựa chọn/bằng chứng còn thiếu theo cổng B, không mặc nhiên đã triển khai.
- **APPROVED (OVERRIDE):** DEC-15/18/26 và SAFE-10 giữ binary/API 1.0 chỉ riêng tư; không friends/community. Photos/từng review theo nhu cầu xem và nhật ký cá nhân từ Moment đã lưu vào 1.0 (DEC-28/30), không suy thành tracking, mạng xã hội, widget, chat hoặc danh bạ.

| Xung đột / khoảng trống | Quy tắc trước OVERRIDE | Yêu cầu mới | Trạng thái hiện hành |
| --- | --- | --- | --- |
| Công khai không cần địa điểm | BR-M4, MVP-10 PUB buộc có Place | ADD §2/3: đăng/chia sẻ khi không có hoặc ẩn địa điểm | DEC-25 APPROVED: Place không bắt buộc; quy tắc PUB cập nhật, không bật public 1.0 |
| Bạn bè / cộng đồng ở 1.0 | DEC-15/18: không có cộng đồng; chưa có mô hình bạn bè | ADD §3/7 có nhóm bạn bè, ảnh công khai, cộng đồng | DEC-26 APPROVED: xác nhận vẫn private-only, phần này không ghi đè |
| Trigger nhận diện | J1/BR-L1 và MVP-06 có thể được hiểu là lookup sau mỗi ảnh | ADD §1: không Nearby mỗi ảnh hoặc theo GPS liên tục | DEC-27 APPROVED nguyên tắc: lookup theo nhu cầu hợp lệ; phương pháp Q-06/thông số chốt trước đo G2 |
| Photos / Reviews | Chưa đưa ảnh Google Places vào 1.0; DEC-14 hoãn từng review tới 1.1 | ADD §1: chỉ tải khi cần xem | DEC-28 APPROVED phạm vi 1.0 on-demand; thay DEC-14, chung trần tiền, có backlog riêng |
| Saved Map khi Google lỗi | MVP-12/19 cần marker/tên; không được lưu Google tùy ý | ADD §1/7: không Places khi mở Map, vẫn xem nơi đã lưu | DEC-29 APPROVED fallback ID/dữ liệu Doday/danh sách; không hứa marker thiếu tọa độ |
| Nhật ký hành trình | Khoảnh khắc cá nhân có sẵn; lịch sử hành trình tự động ngoài SRC §16 | ADD §7/8 gọi tên nhật ký | DEC-30 APPROVED nhật ký đọc Moment/thời điểm đã lưu trong 1.0; không tuyến đường/tracking nền |
| Chính sách vùng riêng tư | Chưa có radius, lưu/sync và xử lý GPS mơ hồ | ADD §3/4 và bổ sung công tắc tại Cài đặt | ZONE + BATCH-AB/DEC-31 APPROVED: local-only, mặc định bật/có thể tắt chủ động, heuristic/consent/revision/strip-all; chưa kiểm thử |
| Mặc định quyền và độc lập audience | BR-M4/DEC-11: public chủ động từng lần; 1.0 chỉ owner | ADD §3/4: mặc định do người dùng đặt; ảnh bạn bè nhưng địa điểm công khai | DEC-32 APPROVED nguyên tắc: hai trục cấu hình, không chọn lại mỗi ảnh; friends/public chỉ bản chia sẻ sau |

## 2. Ba lớp vị trí và quyền độc lập

**Nguyên tắc APPROVED (DEC-25/26/32); schema cụ thể [PROPOSED – TL/SEC, G3]**:

| Khái niệm | Dữ liệu | Quyền / vòng đời |
| --- | --- | --- |
| Vị trí thiết bị / EXIF nguồn | Tọa độ, độ chính xác, thời điểm chụp, nguồn camera hoặc thư viện | Đầu vào nhạy cảm chỉ để đánh giá trên máy; không là vị trí bài đăng; không ghi thô vào Moment/Place chung |
| Kết quả nhận diện | Place ứng viên, nguồn Google/Doday, độ tin cậy, thời điểm | Không tự thành nơi hiển thị; không tạo Visited; Places payload theo chính sách P1/P2 ở §7 |
| Địa điểm người dùng cho phép hiển thị | `display_place_id` có thể null, `location_visibility`, phiên bản chính sách | Độc lập với `photo_visibility`; 1.0 chỉ cho owner/hidden; friends/public cần bản chia sẻ mới được duyệt riêng |
| Cấu hình bảo vệ | Hide hiện tại, Hide cho ảnh mới, các zone, phiên bản cấu hình | Gắn tài khoản; không suy từ quyền iOS ra đồng ý gửi Google hoặc chia sẻ địa điểm |

**Nguyên tắc đã được yêu cầu:** ảnh được phép lưu riêng tư không có Place; Hide không cản lưu ảnh. Khi bản chia sẻ được duyệt, quyền xem ảnh không tự cấp quyền xem GPS/Place. Bật hiển thị địa điểm phải là lựa chọn rõ, không suy từ GPS đã cấp hoặc hệ thống tìm được nơi.

Với ảnh “bạn bè” nhưng địa điểm “công khai” ở bản chia sẻ sau, **DEC-32 APPROVED nguyên tắc** chỉ công khai tài nguyên địa điểm độc lập, không trả ID/ảnh/tiêu đề/thời gian/số đếm của khoảnh khắc hạn chế. Không công khai raw GPS thiết bị. Cho phép suy ra bài đăng qua reverse lookup không được coi là quyền độc lập an toàn. Chưa có quan hệ bạn bè hoặc tài nguyên public trong 1.0; schema/API PUB cần SEC nghiệm thu trước mở.

## 3. Hide Location và Home Privacy Zone

### 3.1 Hide Location

- Nút/toggle một thao tác trên camera và màn xem lại có sẵn; không thêm màn xác nhận sau mỗi ảnh. Có phạm vi rõ “ảnh hiện tại” và thiết lập “ảnh mới”; không dùng lần tắt cho ảnh hiện tại để âm thầm đổi thiết lập tương lai.
- Bật Hide: không gửi tọa độ ảnh đến Google hoặc nhà cung cấp nhận diện khác; không gửi GPS làm bias Autocomplete/Text Search, URL, query string, analytics hoặc attachment. Ảnh/thumbnail vẫn lưu hoặc upload tới Doday theo quyền ảnh đã được duyệt, sau loại metadata vị trí.
- **[APPROVED 31/10/2026, ZONE/DEC-31]:** Hide mặc định bật trên thiết bị/cấu hình mới; chỉ tắt khi người dùng chủ động. Tắt Hide không tự cấp audience công khai và không làm ảnh cũ hiện vị trí. Người dùng vẫn có thể tìm bằng tên/khu vực do họ nhập, không dùng tọa độ ảnh ẩn làm bias.
- **[APPROVED BATCH-AB A3, DEC-31]:** đồng ý nhận diện bên ngoài thiết lập riêng một lần trong cài đặt/onboarding, có thể rút lại; không coi Core Location, Hide-off hoặc tắt bảo vệ zone là đồng ý gửi Google. Không hỏi lại sau từng ảnh; chưa đồng ý thì bỏ lookup, vẫn chụp/lưu.
- Bật Hide khi đã có Place: bỏ liên kết hiển thị của khoảnh khắc, marker/nhóm ảnh/số đếm phát sinh từ nó; **không** xóa SavedPlace độc lập hoặc ảnh của người khác. Không chỉ ẩn nhãn mà vẫn trả `place_id`, địa chỉ, tọa độ, geohash hoặc quan hệ qua API.
- Yêu cầu đã gửi trước khi bật Hide không thể “thu hồi” khỏi bên nhận. Hủy tác vụ còn hủy được, bỏ kết quả đến muộn, chặn mọi lần gửi/retry tiếp theo; không hứa xóa ký ức bên thứ ba hoặc xóa ảnh người khác đã lưu.

### 3.2 Home Privacy Zone

**Yêu cầu từ ADD §3:** tạo nhiều vùng (không chỉ nhà), tự ẩn khi ở trong vùng; không gửi tọa độ vùng bảo vệ đi nhận diện. Không tạo marker/địa chỉ/vùng suy ra công khai.

**[APPROVED 31/10/2026, ZONE/DEC-31]:** zone chỉ tại máy, bán kính mặc định 200 m, điều chỉnh 100–1.000 m. Tâm/radius ở kho cục bộ theo tài khoản, không sync/backup cloud hoặc logs/analytics; mất máy có thể mất cấu hình. Không dùng reverse geocoding để đoán nhà hoặc geofencing nền. Nhà cung cấp bản đồ có thể nhận viewport khi người dùng chủ động xem bản đồ; không hứa hoàn toàn offline/không có bên thứ ba. Cài zone không cần gửi tọa độ cho Places để nhận diện.

**[APPROVED BATCH-AB/DEC-31]:** Cài đặt có danh sách vùng để thêm/sửa/xóa và công tắc **Ẩn trong vùng riêng tư**, mặc định **bật**, người dùng có thể chủ động tắt. Trạng thái bật/tắt lưu local theo tài khoản, không cloud backup/sync; tắt không xóa danh sách vùng. Máy mới/cấu hình chưa xác minh không kế thừa trạng thái tắt của máy/tài khoản khác. Không tự đoán nhà, không thêm bước sau mỗi ảnh.

- **APPROVED A2:** khi bảo vệ bật, phân loại cục bộ `INSIDE`, `OUTSIDE`, `UNCERTAIN`; nếu `d ≤ radius + horizontalAccuracy` thì ẩn vì có thể giao vùng, chỉ ngoài khi toàn vùng bất định không giao zone. Heuristic bảo thủ, không bảo đảm GPS chính xác tuyệt đối.
- Khi bảo vệ bật, GPS thiếu/cũ/gần đúng, độ chính xác không hợp lệ hoặc cấu hình chưa xác minh: `UNCERTAIN` → ẩn, không nhận diện ngoài máy. B1 duyệt thử tuổi mẫu ≤60 s, ngang ≤50 m; đây không chứng minh ở ngoài nhà. Khi bảo vệ đã tắt chủ động, GPS không đáng tin vẫn không đủ điều kiện tự gắn theo BR-L3.
- Ảnh thư viện dùng EXIF hợp lệ của chính ảnh. Không có EXIF → không thay bằng GPS hiện tại. Không trì hoãn gửi tọa độ riêng tư sang ngày khác chỉ vì lúc đó thiết bị ở ngoài zone.
- Hide và **zone đang bật** có tính phủ định ưu tiên: zone/không chắc chắn thắng thao tác tự gắn/chọn Place; chọn thủ công không tự tắt bảo vệ. Tắt zone chủ động trong Cài đặt chỉ bỏ gate zone cho tác vụ mới, **không** tắt Hide hiện tại/ảnh mới (vẫn mặc định bật), cấp consent nhận diện, công khai, khôi phục Place ảnh cũ hoặc phát lại job. Mọi gate Hide/consent/độ tin cậy/trigger còn áp dụng.
- Mất máy/đổi máy với zone chỉ cục bộ có thể mất cấu hình. Thiết bị mới giữ Hide an toàn cho đến khi cấu hình được người dùng xác nhận; không âm thầm coi danh sách chưa có là “không có vùng bảo vệ”. Xóa tài khoản/xóa dữ liệu máy xóa zone và hàng đợi tương ứng.

### 3.3 Hàng đợi và backend

**[APPROVED BATCH-AB A4, DEC-31]:** mỗi ảnh/tác vụ giữ ID tài khoản và `privacy_revision`, không snapshot quyền “được gửi” dùng mãi. Đánh giá lại trước enqueue, mỗi lần gửi/retry và khi nhận kết quả; đổi Hide/zone/**công tắc bảo vệ hoặc consent** làm job cũ mất hiệu lực. Tắt rồi bật lại không replay job/kết quả cũ hoặc hiện vị trí ảnh cũ; muốn sửa phải có thao tác riêng qua gate hiện tại. Xung đột đa thiết bị: hidden thắng visible; config thiếu/revision cũ không tăng quyền. Zone/công tắc local không sync giữa máy; quyền Moment nhận từ server không được tự nới. Độ trễ thu hồi đa máy phải đo, không hứa tức thì ở máy offline.

Backend tách đường upload ảnh khỏi đường lookup; không nhận/persist GPS thô trong payload khoảnh khắc. Payload nhận diện chỉ được phép khi policy cho phép; nếu hidden/zone-blocked/unknown, từ chối request có tọa độ trước khi gọi provider, không log body. Backend không thể tự kiểm chứng người dùng có thật sự ở trong zone chỉ lưu trên thiết bị; cần kiểm client + contract + integration, không tuyên bố chống được client độc hại gửi tọa độ giả chỉ bằng cờ. Không đưa zone lên server chỉ để giải quyết giới hạn đó khi chưa duyệt.

## 4. Ma trận kích hoạt Google

Áp dụng yêu cầu ADD §1/2/6; bảng là **quy tắc sản phẩm**, không tuyên bố đã cấu hình. Native Maps SDK có thể cần mạng để tải nền bản đồ; **0 Places** không có nghĩa 0 network toàn SDK.

| Sự kiện | Dịch vụ được dùng | Rào bảo vệ |
| --- | --- | --- |
| Mở app, camera, chụp/lưu ảnh | Không tự gọi Places, Photos, Reviews, Geocoding, Routes | Camera/lưu chạy độc lập; chỉ xử lý tự gắn từ ngữ cảnh đã có quyền dùng, không trigger request mới |
| Mở/di chuyển/zoom Map | Maps SDK hiển thị; truy vấn dữ liệu Doday | Không Places để dựng lại marker theo viewport; không Autocomplete/Nearby/Text Search khi chỉ pan/zoom |
| Người dùng nhập/tìm địa điểm | Autocomplete hoặc Text Search theo thao tác | Không gọi khi chỉ focus ô rỗng; session token đúng; debounce/hủy tác vụ cũ; không bias bằng GPS bị ẩn |
| Người dùng chủ động yêu cầu “gần đây” / nhận diện địa điểm | Nearby Search khi cần | Kiểm Hide/zone/độ chính xác/quyền nhận diện trước; không mỗi GPS tick, mỗi ảnh hoặc retry vô hạn; không đồng nghĩa công khai |
| Mở chi tiết/chủ động làm mới thông tin Google | Place Details | Field Mask tối thiểu theo khối cần xem; không `*`, không lấy cả trường không dùng “để dành”; không làm mới chỉ vì mở Map |
| Chủ động xem ảnh Google Places / từng review | 1.0: metadata ảnh rồi Photo media theo ảnh cần xem; Details `reviews` khi mở review | Không prefetch ảnh/review khi mở Map/chi tiết; attribution đúng nguồn; không đồng nhất review với rating/tổng lượt; dùng chung quota/trần Google |
| Chạm chỉ đường / mở Google Maps | Google Maps URL | Không Routes, không gửi GPS nguồn/zone làm `origin`; Google Maps tự xử lý vị trí theo quyền riêng của nó |
| Cần tên/địa chỉ từ vị trí | Không bổ sung Geocoding nếu Core Location/Places đã đủ | Không reverse geocode ảnh bị Hide/zone; nhu cầu mới phải duyệt riêng |

**[APPROVED BATCH-AB A10, DEC-09]:** debounce 400 ms và tối thiểu 2 ký tự cho search; tối đa 2 retry cho lỗi tạm thời, exponential backoff có jitter, không retry lỗi quyền/4xx cố định; 429 tôn trọng Retry-After. Circuit breaker riêng dịch vụ/SKU: mở sau 5 lỗi liên tiếp trong 60 s, nghỉ 60 s, half-open tối đa 1 probe; hết ngân sách không probe tính phí. Tham số đã duyệt, chưa kiểm thử.

Giới hạn request theo tài khoản × dịch vụ, toàn hệ thống × dịch vụ và dự toán tiền tháng; **A11 duyệt alerts 50/80/100%**, không tự dừng tiền. Quota/rate limit cụ thể chốt theo B7 trước G6. Dùng request ID/idempotency; gom request đang bay chỉ khi cùng tài khoản, privacy revision, API, toàn bộ tham số/vị trí được phép, Field Mask, ngôn ngữ và ngữ cảnh session token. Không ghi raw GPS của khóa gom vào logs/kho bền vững; **không** coi gom request là giấy phép cache hoặc gộp qua tài khoản/truy vấn khác.

**APPROVED (COST + BATCH-AB A11/DEC-09):** Places Web Service chỉ qua proxy; reservation nguyên tử theo SKU đắt nhất có thể tính/giá bậc đầu trước cuộc gọi trả phí/retry. Ledger chung, reset kỳ billing thực, không reset sớm/đếm đúp; hết trần/bộ đếm lỗi không có cuộc gọi/probe trả phí. Không chặn camera/lưu/dữ liệu Doday theo Google. Forecast vẫn trừ free tier một lần; phân bổ/quota thực chốt B7. Xem ngân sách §2.3, kiểm GGL-01/09 ở G10 trước khi tuyên bố hoạt động.

**Nhận diện sau OVERRIDE/B1:** giữ ba nhánh tự gắn/xác nhận/thủ công. Không cần Google mới nếu có ngữ cảnh Doday/kết quả hợp lệ còn quyền dùng, đúng vị trí/thời điểm và gate hiện tại; không dùng lại Place cũ khi đã di chuyển. Lookup Google chỉ từ lệnh gần đây/nhận diện chủ động; ngưỡng tin cậy/TTL ngữ cảnh còn cần TL/QA chốt trước sử dụng ở G2. Không ngữ cảnh thì lưu không nơi; không bắt chọn sau từng ảnh. Không hạ precision/coverage hoặc chỉ đo trên người đã tìm.

## 5. Tối thiểu dữ liệu và khả năng hoạt động

- Doday quản lý tài khoản, Moment, ảnh, SavedPlace, Collection, Want to visit/Visited, zone và nhật ký cá nhân 1.0 từ Moment/thời điểm đã lưu. Nhật ký không thu thập thêm đường đi/GPS nền; ảnh Hide vẫn xem được nhưng không suy ra nơi, giữ phân vùng tài khoản và quy tắc xóa/đồng bộ. Place nội bộ tồn tại độc lập với Google ID, kể cả nơi thủ công và nơi đóng cửa. Nguồn từng trường phải truy được; không đổi nhãn dữ liệu Google thành Doday để lưu vô hạn.
- **[APPROVED 31/10/2026, ZONE/DEC-31]:** mẫu GPS đầu vào được tách ra cho đánh giá/nhận diện chỉ trong RAM tối đa 60 s từ lúc nhận mẫu; không DB/queue/backup/logs/analytics/crash reports, không làm tròn hoặc retry để kéo dài thời hạn. Hết tác vụ/bị chặn thì bỏ sớm; hết thời hạn không dùng lại hoặc “bù” bằng vị trí lúc upload. Thời hạn này không phải tuổi mẫu Q-06, TTL tâm zone hoặc cache tọa độ Place Google. Zone giữ cục bộ tới khi người dùng xóa; EXIF trong ảnh gốc cục bộ theo chính sách ảnh, không phải kho mẫu GPS nhận diện.
- **APPROVED A1/DEC-31:** loại EXIF GPS khỏi **mọi ảnh/thumbnail upload Doday**, kể cả riêng tư/Hide-off/zone-off. Đánh giá đầu vào/gắn Place riêng trước khi xuất bản xử lý, không cần giữ GPS trong file upload để tự gắn. Gốc cục bộ có thể chứa GPS, phân vùng tài khoản; crop/nén không chứng minh đã loại metadata. Chặn raw GPS/tọa độ zone trong telemetry client/backend/proxy/analytics/crash; chỉ đo mã kết quả/nhóm lỗi không định vị.
- Khi **chỉ Google lỗi/hết quota** nhưng Doday và mạng còn hoạt động: camera, lưu nháp, upload/lưu riêng tư Doday, dữ liệu SavedPlace/bộ sưu tập và khoảnh khắc cá nhân vẫn dùng; khối Google mới báo unavailable riêng. Chia sẻ/cộng đồng chỉ áp dụng khi bản đó đã được duyệt, không thêm vào 1.0 qua fallback.
- Khi **thiết bị offline hoặc Doday backend lỗi**: chỉ chức năng/dữ liệu đã có cục bộ và hàng đợi được bảo đảm; không hứa upload/xem dữ liệu chưa tải hoặc chia sẻ qua mạng vẫn thành công. Marker Google hết TTL không được dùng quá hạn; vẫn giữ bản ghi SavedPlace/Place ID và nhãn do người dùng tự nhập, có thể thiếu vị trí để vẽ.
- Không promise bản đồ nền offline nếu SDK không cung cấp trong điều kiện thử. Nút mở Google Maps URL còn dùng được nhưng app Google/website cần mạng riêng; không coi Google outage đã được giải quyết vì nút vẫn hiện.

## 6. Ưu tiên và kiểm thử

P0/P1/P2 dưới đây là **ưu tiên sản phẩm theo ADD §9**, khác độ nghiêm trọng lỗi P0/P1/P2 của roadmap. Không tự hạ mức lỗi rò dữ liệu vì mục vận hành là P2.

| Ưu tiên | Backlog truy vết | Điều kiện |
| --- | --- | --- |
| P0 quyền riêng tư | PRIV-01…04, DATA-06 | Không gửi tọa độ được bảo vệ; quyền backend; ảnh không nơi; thu hồi/hàng đợi; 1.0 vẫn private-only, hai trục PUB theo DEC-25/26/32 |
| P1 trải nghiệm | MVP-04/05/09, DATA-01/05 | Không bước crop preview, không Google trên đường chụp/lưu; Q-01…04 không đổi |
| P2 vận hành | GGL-01/03/08/09, DATA-05 | Rate limit, quota, chi phí, dedup, circuit breaker, cache hợp lệ; không tuyên bố tiết kiệm đã đo |

Ca Given/When/Then đặt ở `backlog.md`, mẫu và QP-01/02 ở `quality-and-acceptance.md`. **Chưa kiểm thử/chưa đo**. Kiểm luồng app, extension, upload retry, hai tài khoản/hai thiết bị, payload API, storage và telemetry; không chỉ screenshot UI. Không gửi tọa độ thật trong G1.

## 7. Nguồn chính thức đã kiểm

Truy cập **31/10/2026**; không dùng ngày cập nhật trang thay ngày truy cập. Kiểm lại khi chọn hợp đồng/billing và trước phát hành. Điều khoản áp dụng phụ thuộc billing account/hợp đồng thực tế; LEGAL xác nhận ở G2/G3.

| Mã | Nguồn và nội dung dùng | URL |
| --- | --- | --- |
| P1 | Places API policies: hạn chế lưu/cache, ngoại lệ Place ID, attribution | `https://developers.google.com/maps/documentation/places/web-service/policies` |
| P2 | Service Specific Terms §14.2/14.3: dữ liệu Places không dùng với bản đồ khác Google; tọa độ Places chỉ cache tạm tối đa 30 ngày liên tiếp rồi xóa | `https://cloud.google.com/maps-platform/terms/maps-service-terms` |
| P3 | Place Details (New): Field Mask và SKU; nguồn B3 trong dự toán | `https://developers.google.com/maps/documentation/places/web-service/place-details` |
| P4 | Maps URLs: mở Maps/chỉ đường, `api=1`, không cần API key cho URL | `https://developers.google.com/maps/documentation/urls/get-started` |
| P5 | Place Photos (New): photo resource name có thể hết hạn, không cache name; attribution tác giả khi có | `https://developers.google.com/maps/documentation/places/web-service/place-photos` |

P5/P3 và bảng giá B1 được tải lại read-only ngày 31/10, HTTP 200; không gọi endpoint API tính phí. P2 nay đọc được, thay trạng thái “chưa đọc được” của lần 30/10; không suy ngoại lệ tọa độ 30 ngày thành quyền cache tên, địa chỉ, business status, reviews hoặc ảnh 30 ngày. Không auto-refresh cache bằng gọi Places lúc mở Map; DEC-29 đã chốt fallback ID/nhãn Doday/danh sách, TTL theo trường vẫn cần LEGAL.

## 8. Đối chiếu yêu cầu bổ sung

| Nguồn ADD | Nội dung đặc tả | Backlog / quyết định |
| --- | --- | --- |
| §1 API khi cần | §4; dự toán theo trigger, media/review hợp lệ | GGL-04/08/09/10, DEC-27/28/29 |
| §2 chụp độc lập, ảnh không nơi | §1/5; J1; BR-M2/3 | MVP-04/06/09, DATA-05, DEC-25/26/27 |
| §3 GPS/Place/hiển thị, zone, Hide, audience | §2/3 | PRIV-01/02/03, DATA-06, DEC-31/32 |
| §4 UX một thao tác/mặc định | §3.1, không preview crop theo CROP | PRIV-01, DEC-07/32 |
| §5 tối thiểu dữ liệu | §5; privacy inventory/retention | PRIV-04, SAFE-02/06 |
| §6 rate/quota/cache/retry/breaker | §4/7 | GGL-01/03/09, DEC-09 |
| §7 Google unavailable | §5; nhật ký riêng tư vẫn dùng, chia sẻ/community không vào 1.0 | DATA-05/07, DEC-26/29/30 |
| §8 quyền quản lý dữ liệu/Place ID | §2/5/7 | MVP-18, DATA-05, GGL-03 |
| §9 P0/P1/P2 | §6 | Ma trận backlog; giữ nguyên 30 ID MVP |
