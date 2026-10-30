# Doday 1.0 – Đặc tả sản phẩm (G1)

Trạng thái: READY_FOR_REVIEW · Ngày lập: 30/10/2026 · Người duyệt: Chủ sản phẩm + Trưởng kỹ thuật (chờ chỉ định, chưa duyệt)

## 0. Quy ước nhãn

| Nhãn | Ý nghĩa |
| --- | --- |
| [SRC §x] | Có trong tài liệu định hướng gốc, mục x |
| [ROADMAP Gx] | Đề xuất trong DODAY_IOS_ROADMAP.md; **chưa** phải quyết định đã duyệt |
| [PROPOSED] | Đề xuất của bộ G1, cần chủ sản phẩm/trưởng kỹ thuật duyệt |
| [ASSUMPTION] | Giả định làm việc, chưa kiểm chứng |
| [NEEDS_CONFIRMATION] | Bắt buộc phải có câu trả lời trước khi G1 APPROVED |
| [APPROVED dd/mm/yyyy – vai trò] | Quyết định đã duyệt. Hiện **chưa có mục nào** mang nhãn này |

Mã quyết định (DEC-xx) xem `decisions.md`; mã yêu cầu (DODAY-…) xem `backlog.md`; chỉ số (Q-xx) xem `quality-and-acceptance.md`; rủi ro (R-xx) xem `risks.md`.

## 1. Mục tiêu phiên bản 1.0

Doday 1.0 hoàn chỉnh vòng giá trị **camera → khoảnh khắc → địa điểm → bản đồ** [SRC §1, §20; ROADMAP §1]:

1. Người dùng mở app vào camera, chụp hoặc chọn ảnh và lưu khoảnh khắc mà không mất ảnh vì mạng, GPS hay Google chưa sẵn sàng.
2. Khoảnh khắc được gắn địa điểm tự động khi đủ tin cậy, có đường xác nhận/sửa/bổ sung sau.
3. Người dùng có bản đồ cá nhân: nơi đã lưu, đã ghé, bộ sưu tập, Want to visit/Visited.
4. Người dùng lưu địa điểm từ TikTok/Instagram qua Share Sheet, kể cả khi chưa xác định được địa điểm.
5. Người dùng khám phá trải nghiệm công khai của cộng đồng tại địa điểm, kiểm tra thông tin Google cập nhật và mở Google Maps để chỉ đường.
6. Có an toàn phát hành: xóa tài khoản, phân quyền ảnh, báo cáo/chặn, kiểm duyệt, hỗ trợ, chính sách công khai.

Tiêu chí thành công phát hành được định nghĩa bằng chỉ số Q-01…Q-15 (ngưỡng đề xuất, chưa đo). Chỉ số hành vi ở SRC §18 dùng để ra quyết định sản phẩm, không phải điều kiện phát hành.

## 2. Định hướng không thay đổi

- **Camera-first** [SRC §2, §4.1]: màn hình mặc định là camera, không có Home/Feed trung gian.
- **Automatic-first** [SRC §2]: tự động khi đáng tin cậy; không tự động khi không đủ tin cậy [SRC §17.1].
- **Location-centric** [SRC §2]: nội dung công khai luôn gắn một địa điểm.
- **Cấu trúc** [SRC §3]: hai khu vực chính Camera và Map; Profile là khu vực phụ (qua ảnh đại diện/menu). Map **không** được thay bằng Feed [SRC §12].
- **Phân biệt nguồn dữ liệu** [SRC §2, §6.9]: dữ liệu Google Maps và nội dung Doday luôn tách bạch về giao diện và lưu trữ.

## 3. Người dùng mục tiêu (giả thuyết)

Chưa có nghiên cứu người dùng. Toàn bộ persona dưới đây là **[ASSUMPTION]**, suy ra từ ví dụ trong nguồn (Đà Lạt, Hà Nội, quán cà phê, TikTok). Kiểm chứng ở G2 (≥5 người thử prototype) [ROADMAP G2]. Thị trường và nhóm tuổi: DEC-01, DEC-02.

| Mã | Giả thuyết persona | Nhu cầu chính | Hành trình |
| --- | --- | --- | --- |
| P1 | Người hay đi cà phê/ăn uống, du lịch ngắn ngày, dùng iPhone, thường xuyên chụp ảnh tại địa điểm | Lưu khoảnh khắc nhanh, không phải viết bài; nhìn lại nơi đã đến trên bản đồ | J1, J4 |
| P2 | Người lướt TikTok/Instagram, hay "lưu để đi sau" nhưng thất lạc link | Lưu nơi thấy trên mạng xã hội bằng một thao tác chia sẻ; không mất link | J2, J4 |
| P3 | Người đang tìm nơi mới để đi | Xem ảnh thực tế (không quảng cáo), biết nơi còn mở không, giờ mở cửa, rating tổng quan | J3, J4 |

Điều cần kiểm chứng: (a) người dùng có chấp nhận đăng nhập trước khi chụp lần đầu (DEC-17); (b) tỷ lệ link TikTok/Instagram thực sự xác định được địa điểm; (c) mức sẵn lòng công khai ảnh tại địa điểm.

## 4. Phạm vi 1.0

### 4.1 Trong phạm vi

- 30 hạng mục MVP [SRC §15], ánh xạ một-một DODAY-MVP-01…30 trong `backlog.md`, gồm bộ sưu tập (MVP-29) và Want to visit/Visited (MVP-30).
- Share Extension và dán liên kết (DODAY-EXT-*): **[ROADMAP §1] đề xuất đưa vào 1.0**, quyết định DEC-13 chưa duyệt. Nguồn mô tả luồng ở SRC §5.3, §7, §11 TH2 nhưng không đánh số trong 30 hạng mục.
- Dữ liệu bền vững và đồng bộ (DODAY-DATA-*), an toàn phát hành (DODAY-SAFE-*), tuân thủ Google (DODAY-GGL-*): yêu cầu bổ sung suy ra từ SRC §6.8, §13.6, §17 và ROADMAP §1.
- Rating trung bình và **tổng lượt đánh giá** Google (MVP-22) thuộc 1.0 [SRC §15].

### 4.2 Tùy chọn 1.0 / có thể hoãn 1.1

- **Nội dung từng bài review Google** (văn bản, tác giả, thời gian, liên kết gốc) – DODAY-GGL-04. Nguồn cho phép ưu tiên sau [SRC §15, đoạn cuối]. Khuyến nghị [PROPOSED] hoãn sang 1.1 (DEC-14). Rating/tổng lượt **không** bị hoãn theo quyết định này.
- Thông báo "địa điểm đã di chuyển" dùng movedPlace/movedPlaceId [SRC §6.4: "có thể"] – DODAY-GGL-05, [PROPOSED] làm trong 1.0 nếu chi phí thấp vì trường thuộc SKU Essentials IDs Only (xem `privacy-and-data.md` §6).
- Bộ lọc "địa điểm vừa được cộng đồng chia sẻ" như marker riêng [SRC §5.2] – gói trong MVP-13, định nghĩa "vừa" là [PROPOSED] 7 ngày.

### 4.3 Ngoài phạm vi 1.0

Theo SRC §16 và ROADMAP §1: nhắn tin/chat, Stories, livestream, chỉnh sửa video, bộ lọc ảnh chuyên sâu, follower/following, bảng xếp hạng, gamification, thuật toán đề xuất nâng cao, chỉ đường/dẫn đường trong Doday, đặt bàn/đặt phòng/thanh toán, hệ thống đánh giá riêng phức tạp, đặt lịch ghé thăm, lịch sử hành trình tự động, chia sẻ với bạn bè [SRC §4.5], tab Home/Feed, tìm kiếm bằng AI/ngôn ngữ tự nhiên (ví dụ câu tìm kiếm ở SRC §5.5 được đáp ứng bằng tìm theo tên/khu vực/loại và bộ lọc) [ROADMAP §1], theo dõi vị trí nền.

Bất kỳ yêu cầu nào thêm vào ngoài danh sách này phải qua sổ quyết định, không được thêm âm thầm vào backlog.

## 5. Cấu trúc điều hướng

- Mở app (đã đăng nhập, đã qua quyền lần đầu) → **Camera**. Từ Camera có lối vào Map bằng một chạm [SRC §4.1].
- **Map**: bản đồ + thanh tìm kiếm + bộ lọc + bottom sheet thẻ địa điểm + nút mở danh sách đã lưu/bộ sưu tập (bảng phụ, không phải tab) [SRC §5, §9.1].
- **Trang chi tiết địa điểm**: 5 phần theo SRC §8.1; khối Google và khối Doday Experiences tách riêng có nhãn nguồn.
- **Mục chờ xử lý** (Share Sheet chưa xác định địa điểm, nháp chưa có địa điểm): truy cập từ Map/danh sách đã lưu, có badge số lượng [PROPOSED].
- **Profile**: qua ảnh đại diện; chứa hồ sơ, khoảnh khắc đã chia sẻ, quyền riêng tư, quản lý nội dung, người bị chặn, hỗ trợ, đăng xuất, xóa tài khoản [SRC §10].

## 6. Hành trình cốt lõi

Ký hiệu: **ĐV** đầu vào · **B** bước · **KQ** kết quả · **L** nhánh lỗi · **DP** dự phòng.

### J1 – Chụp tại địa điểm [SRC §4.2, §11 TH1]

- **ĐV:** người dùng đã đăng nhập; quyền camera (có/không); quyền vị trí (chính xác/gần đúng/từ chối); mạng (có/không).
- **B1** Mở app → camera preview sẵn sàng, nút chụp hoạt động (Q-01). Không chờ Map, đồng bộ hay backend [SRC §17.4].
- **B2** Chụp (hoặc chọn ảnh thư viện → J1b). Ngay khi bấm chụp, ứng dụng ghi **vị trí lúc chụp** (tọa độ, độ chính xác, thời điểm lấy mẫu) nếu có quyền.
- **B3** Ảnh được ghi thành **nháp bền vững** trên máy (Q-03) trước mọi tác vụ mạng. Nhận diện địa điểm chạy song song, không chặn.
- **B4** Màn xem lại: ô tiêu đề tùy chọn (placeholder, không bắt buộc), chip địa điểm (đang tìm / đã gắn / cần xác nhận / chưa có), lựa chọn hiển thị (mặc định theo DEC-11), nút Xong.
- **B5** Xong → khoảnh khắc lưu, trạng thái đồng bộ hiển thị riêng (đã lưu trên máy / đang tải lên / đã đồng bộ / lỗi cần thử lại). Trở về camera.
- **KQ:** khoảnh khắc riêng tư (hoặc công khai nếu đủ điều kiện §7.1) gắn địa điểm; xuất hiện trên Map cá nhân tại địa điểm đó; nếu chưa có địa điểm thì nằm trong Mục chờ xử lý.
- **L/DP:**
  - Từ chối camera → màn giải thích + nút mở Cài đặt; vẫn có nút chọn ảnh thư viện và nút vào Map.
  - Từ chối vị trí / vị trí gần đúng / GPS cũ hơn ngưỡng → không tự gắn; lưu nháp chưa có địa điểm hoặc hiện danh sách xác nhận (nếu gần đúng vẫn cho đề xuất); người dùng chọn thủ công sau.
  - Offline → lưu cục bộ, hàng đợi upload; nhận diện Places chạy lại khi có mạng (dùng vị trí lúc chụp, không dùng vị trí hiện tại).
  - Places lỗi/quá hạn mức/timeout → chip "Chưa xác định địa điểm", không chặn Xong.
  - Hết dung lượng máy → báo lỗi rõ, **không** báo đã lưu.
  - App bị đóng giữa chừng → nháp đã ghi vẫn còn khi mở lại; không tạo bản trùng.
  - Bị gián đoạn camera (cuộc gọi, đa nhiệm) → phiên camera khôi phục khi quay lại (Q-02).

**J1b – Chọn ảnh từ thư viện** [SRC §4.4, §8.3]: dùng metadata vị trí trong ảnh nếu có và quyền cho phép; nếu không có, chuyển sang chọn địa điểm thủ công. **Tuyệt đối không** dùng GPS hiện tại của thiết bị cho ảnh thư viện [ROADMAP G5]. Thời điểm của khoảnh khắc = thời điểm chụp trong metadata nếu có, ngược lại = thời điểm chọn và ghi rõ là "thời điểm thêm".

### J2 – Lưu từ TikTok/Instagram [SRC §7, §11 TH2]

- **ĐV:** URL và/hoặc văn bản do ứng dụng nguồn đưa vào Share Sheet (kiểu dữ liệu thực tế ghi nhận ở G2); trạng thái đăng nhập của app chính; mạng.
- **B1** Người dùng chọn Chia sẻ → Doday. Extension nhận URL/text qua NSItemProvider.
- **B2** Extension ghi ngay một **ExternalSource ở trạng thái PENDING** (§7.5) vào kho dùng chung với app (App Group) gắn với tài khoản đang đăng nhập, rồi hiển thị "Đã lưu vào Doday".
- **B3** Nếu có mạng và đủ thời gian, thử xác định địa điểm từ dữ liệu được phép (§7.5). Có ứng viên → hiển thị để xác nhận một chạm. Không có → giữ PENDING, thông báo "Đã giữ liên kết, chọn địa điểm sau".
- **B4** Xác nhận → Place (tạo mới hoặc dùng bản ghi có sẵn theo Google Place ID) + SavedPlace (Want to visit) → địa điểm xuất hiện trên Map. Người dùng quay lại TikTok/Instagram.
- **KQ:** hoặc một SavedPlace liên kết URL nguồn, hoặc một mục PENDING giữ URL gốc trong Mục chờ xử lý.
- **L/DP:**
  - Chưa đăng nhập ở app chính → extension báo "Mở Doday để đăng nhập", không lưu vào tài khoản nào [PROPOSED]; không ép mở app chính bằng mẹo [ROADMAP G8].
  - Offline / timeout → lưu PENDING cục bộ, xử lý khi app chính chạy.
  - Link rút gọn, hết hạn, riêng tư, bị chặn, không có dữ liệu địa điểm → PENDING kèm lý do; người dùng tìm kiếm, chọn trên bản đồ hoặc thêm thủ công.
  - Gửi lại cùng URL → không tạo SavedPlace/ExternalSource trùng; báo "Đã có trong Doday".
  - Extension bị hệ điều hành đóng giữa chừng → mục đã ghi vẫn còn; mục chưa ghi thì không báo đã lưu.
- **Dán liên kết trong app** [SRC §5.3]: cùng quy trình từ B2, khởi phát từ Map.

### J3 – Khám phá rồi lưu [SRC §5.3, §11 TH3]

- **ĐV:** Map mở; có/không có địa điểm công khai trong vùng nhìn; quyền vị trí (để "gần tôi").
- **B1** Từ Camera chạm Map. Map hiển thị marker theo viewport, gom nhóm khi dày (MVP-16), phân biệt: đã lưu / đã ghé / cộng đồng chưa lưu / cộng đồng mới chia sẻ (MVP-13).
- **B2** Tìm theo tên/khu vực/loại hoặc lọc (MVP-14, MVP-15).
- **B3** Chạm marker → bottom sheet: ảnh đại diện, tên, khu vực, business status, rating Google nếu có, vài ảnh Doday nổi bật, số khoảnh khắc công khai, trạng thái lưu, nút xem chi tiết [SRC §5.4].
- **B4** Mở chi tiết → khối Google (truy xuất mới, §7.3) và khối Doday Experiences tách riêng.
- **B5** Chạm Lưu → SavedPlace (Want to visit), marker đổi kiểu ngay.
- **KQ:** địa điểm có trong bản đồ cá nhân; không cần chọn bộ sưu tập [SRC §5.3].
- **L/DP:** không có nội dung cộng đồng → trạng thái trống thân thiện, mời chia sẻ đầu tiên [SRC §8.3]; Places lỗi → vẫn xem được nội dung Doday và nút mở Google Maps; offline → hiện dữ liệu Doday đã đồng bộ, khối Google "Không tải được, thử lại"; từ chối vị trí → "gần tôi" bị tắt có giải thích, tìm theo khu vực vẫn dùng được.

### J4 – Mở lại nơi đã lưu, kiểm tra và chỉ đường [SRC §6.1, §6.7, §11 TH4]

- **ĐV:** SavedPlace có Google Place ID hoặc là nơi thủ công; mạng.
- **B1** Mở từ Map hoặc danh sách đã lưu (MVP-28).
- **B2** Ứng dụng truy xuất Place Details mới với field mask tối thiểu cho màn chi tiết (DODAY-GGL-01). Không dùng dữ liệu cũ từ lần lưu đầu như trạng thái hiện tại [SRC §9.1].
- **B3** Hiển thị business status, giờ mở cửa thường lệ và đang mở/đóng, rating + tổng lượt; cảnh báo nổi bật khi tạm đóng/đóng vĩnh viễn; thông báo "đã di chuyển" nếu có movedPlace.
- **B4** "Chỉ đường" / "Xem trên Google Maps" → Google Maps URL có destination_place_id / query_place_id (MVP-23, MVP-24).
- **KQ:** người dùng quyết định đi hay không dựa trên dữ liệu Google mới nhất tại thời điểm truy vấn, có nhãn nguồn.
- **L/DP:** Places lỗi/offline → "Không cập nhật được thông tin lúc này", **không** hiển thị trạng thái cũ như khẳng định hiện tại; nút chỉ đường vẫn hoạt động. Không có Google Maps app → mở URL trên trình duyệt. Nơi thủ công không có Google ID → không có khối Google; chỉ đường dùng tọa độ/tên người dùng nhập, ghi rõ "Địa điểm do bạn thêm". Place ID không còn hợp lệ → đánh dấu cần đối soát (DODAY-GGL-06), giữ khoảnh khắc và SavedPlace.

## 7. Quy tắc nghiệp vụ

### 7.1 Ảnh và khoảnh khắc

- BR-M1 Tiêu đề tùy chọn, tối đa [PROPOSED] 120 ký tự, không hashtag/danh mục/mô tả bắt buộc [SRC §4.3]. Bỏ trống vẫn hoàn tất được.
- BR-M2 Nhận diện địa điểm không bao giờ chặn chụp, xem lại hay lưu [SRC §4.2].
- BR-M3 **Nháp** (riêng tư) được phép chưa có địa điểm và bổ sung sau [ROADMAP G1].
- BR-M4 **Công khai** chỉ khi: (a) đã đăng nhập, (b) có địa điểm (Place đã xác nhận hoặc tự gắn), (c) người dùng chủ động chọn "Công khai" ở lần đăng đó, (d) tài khoản không bị khóa. Nếu thiếu (b), lựa chọn Công khai bị vô hiệu kèm lý do [ROADMAP G1].
- BR-M5 Mặc định cho khoảnh khắc mới: [PROPOSED] **Riêng tư**. Đây là đề xuất của roadmap, **chưa duyệt** (DEC-11). Ứng dụng không tự chuyển sang công khai từ bất kỳ tín hiệu nào.
- BR-M6 Đổi Công khai → Riêng tư hoặc xóa có hiệu lực ở API, tìm kiếm, số đếm, ảnh bìa, thumbnail và URL ảnh Doday phân phối (`privacy-and-data.md` §4).
- BR-M7 Sửa địa điểm của khoảnh khắc công khai → khoảnh khắc chuyển sang địa điểm mới; không để lại bản ở địa điểm cũ.
- BR-M8 Ảnh công khai được loại metadata vị trí chính xác trước khi phân phối; địa điểm công khai không đồng nghĩa công khai tọa độ chụp thô [ROADMAP G9].
- BR-M9 1.0 chỉ hỗ trợ ảnh tĩnh, một ảnh/khoảnh khắc [ASSUMPTION – nguồn chỉ nói "ảnh"; video ngoài phạm vi theo SRC §16].

### 7.2 Vị trí và nhận diện địa điểm

- BR-L1 Ba nhánh [SRC §4.2, ROADMAP G5]: **Tự gắn** khi điểm tin cậy ≥ ngưỡng T_auto; **Xác nhận** (tối đa [PROPOSED] 5 ứng viên, một chạm) khi T_confirm ≤ điểm < T_auto hoặc có ≥2 ứng viên sát điểm; **Chưa gắn** khi dưới T_confirm hoặc không có vị trí. T_auto/T_confirm được hiệu chỉnh ở G2/G5 để đạt Q-05 (precision) trước, rồi mới tối ưu Q-06 (coverage).
- BR-L2 Không bao giờ quy tắc "chọn nơi gần nhất" [SRC §4.4]. Điểm tin cậy kết hợp khoảng cách so với bán kính độ chính xác, mật độ ứng viên, loại địa điểm, độ mới của mẫu vị trí.
- BR-L3 Không tự gắn khi: quyền vị trí gần đúng (reduced accuracy), độ chính xác ngang kém hơn [PROPOSED] 50 m, mẫu vị trí cũ hơn [PROPOSED] 60 giây so với lúc chụp, hoặc có ≥2 ứng viên trong bán kính độ chính xác. Các ngưỡng này là giả thuyết, kiểm chứng ở G2.
- BR-L4 Ảnh thư viện: chỉ dùng tọa độ trong metadata ảnh khi có và được phép; không dùng GPS hiện tại; không xin quyền thư viện toàn phần chỉ để đọc GPS [ROADMAP G2].
- BR-L5 GPS/nhận diện **không** làm nội dung thành công khai và **không** đặt Visited (BR-S3).
- BR-L6 Vị trí dùng là vị trí **lúc chụp**, không phải vị trí lúc upload hoặc lúc có mạng lại.
- BR-L7 Người dùng luôn sửa được địa điểm sau khi lưu (MVP-07).

### 7.3 Danh mục địa điểm và dữ liệu Google

- BR-P1 Mỗi Place có **Doday Place ID** nội bộ; **Google Place ID** là thuộc tính duy nhất (unique) khi có [SRC §6.2]. Ảnh, khoảnh khắc, SavedPlace, bộ sưu tập liên kết bằng Doday Place ID.
- BR-P2 Chống trùng: tạo Place theo Google Place ID là upsert idempotent; nhiều người dùng lưu cùng nơi, kể cả đồng thời, chỉ có một Place [SRC §6.2, §7.3].
- BR-P3 **Nơi thủ công**: Place không có Google Place ID, có tên + tọa độ do người dùng nhập, chỉ hiển thị cho người tạo; không được hiển thị như dữ liệu Google; không thể nhận khoảnh khắc công khai cho đến khi được liên kết với Google Place ID [PROPOSED – tránh tạo địa điểm công khai giả]. Liên kết sau: người dùng chọn Google Place tương ứng → chuyển SavedPlace/khoảnh khắc sang Place đó, không gộp tự động.
- BR-P4 Địa điểm đóng cửa tạm/vĩnh viễn **vẫn được giữ** trong bản đồ cá nhân, có cảnh báo rõ [SRC §6.4].
- BR-P5 Ba trường độc lập, không suy ra lẫn nhau [SRC §6.4, §6.5, §9.3]:
  - **Business status** (Google): OPERATIONAL / CLOSED_TEMPORARILY / CLOSED_PERMANENTLY / FUTURE_OPENING / không xác định.
  - **Đang mở/đóng lúc xem** (Google, từ currentOpeningHours): mở / đóng / không có dữ liệu.
  - **Trạng thái cá nhân** (Doday): Want to visit / Visited.
- BR-P6 Thiếu dữ liệu → hiển thị "Chưa có thông tin"; không hiển thị 0 sao, không suy "đang đóng", không phỏng đoán [SRC §6.3, §17.2].
- BR-P7 Truy xuất Google khi mở chi tiết, theo field mask của từng màn hình; không gọi khi kéo bản đồ hay mở lại thẻ không cần thiết [SRC §6.8]. Không lưu nội dung Places ngoài các ngoại lệ chính sách cho phép (`privacy-and-data.md` §6).
- BR-P8 Nội dung Google và Doday tách khối, có nhãn nguồn/attribution; rating Google không được gọi là đánh giá Doday [SRC §6.6].

### 7.4 Đã lưu, bộ sưu tập, Want to visit/Visited

- BR-S1 Lưu không bắt nhập ghi chú/chọn bộ sưu tập; mặc định Want to visit [SRC §5.3, §9.2].
- BR-S2 Một địa điểm thuộc nhiều bộ sưu tập; xóa bộ sưu tập không xóa SavedPlace, Place hay ảnh; bỏ lưu không xóa Place chung hay khoảnh khắc của người khác [ROADMAP G7].
- BR-S3 Visited chỉ do người dùng đặt. Ứng dụng [PROPOSED] chỉ được **gợi ý** "Đánh dấu đã ghé?" khi người dùng lưu một khoảnh khắc đã **xác nhận** tại địa điểm đó; không tự đổi do GPS đi ngang [SRC §9.3].
- BR-S4 Bỏ lưu một nơi đang có khoảnh khắc của chính người dùng: [PROPOSED] marker vẫn hiện ở lớp "khoảnh khắc của tôi"; khoảnh khắc không bị xóa.
- BR-S5 Bộ sưu tập là riêng tư trong 1.0 [PROPOSED; chia sẻ bộ sưu tập không có trong nguồn].

### 7.5 Share Sheet và mục chờ xử lý

- BR-X1 **Thành công lưu** = ghi được ExternalSource bền vững (URL gốc, nguồn, thời điểm, tài khoản) **hoặc** một SavedPlace. Lưu URL ≠ tự trích xuất địa điểm; hai tỷ lệ đo riêng (Q-08, Q-08b).
- BR-X2 **Mục chờ xử lý (PENDING)** = ExternalSource đã lưu nhưng chưa liên kết Place. Trạng thái: `PENDING` → `RESOLVED` (đã liên kết Place) / `DISMISSED` (người dùng bỏ). Mục PENDING không hết hạn tự động [PROPOSED]; có badge số lượng.
- BR-X3 Trích xuất chỉ dùng: dữ liệu ứng dụng nguồn đưa vào Share Sheet, metadata công khai của URL mà điều khoản nguồn cho phép đọc, hoặc API chính thức nếu có thỏa thuận. Không scraping trái điều khoản, không đăng nhập thay người dùng, không vượt cơ chế bảo vệ [ROADMAP G8]. Không cam kết trích xuất được mọi link [SRC §7.2].
- BR-X4 Nếu backend đọc URL: chỉ https, giới hạn redirect [PROPOSED 3], timeout [PROPOSED 5 s], dung lượng [PROPOSED 1 MB], chặn địa chỉ mạng nội bộ (SSRF) [ROADMAP G8].
- BR-X5 Chuẩn hóa URL (bỏ tham số theo dõi theo danh sách cho phép) làm khóa chống trùng theo tài khoản.

### 7.6 Tài khoản, nháp và đồng bộ

- BR-A1 Đăng nhập: [PROPOSED] bắt buộc một lần trước lần chụp đầu tiên (DEC-17, phương án A). Nếu chủ sản phẩm chọn cho phép chụp khi chưa đăng nhập (phương án B), áp dụng BR-A2b.
- BR-A2b Nháp khách (chỉ khi chọn phương án B): lưu trong vùng "chưa có chủ"; khi đăng nhập lần đầu hỏi rõ "Chuyển N nháp vào tài khoản X?"; không bao giờ tự chuyển; đã chuyển thì không chuyển lần nữa sang tài khoản khác.
- BR-A3 Dữ liệu cục bộ **phân vùng theo tài khoản**. Đăng xuất khi còn mục chưa đồng bộ → cảnh báo số lượng, lựa chọn "Đợi đồng bộ" / "Đăng xuất, giữ trên máy cho tài khoản này" / "Xóa khỏi máy". Mục giữ lại chỉ hiển thị và upload khi đúng tài khoản đó đăng nhập lại.
- BR-A4 Đổi tài khoản: không hiển thị, không upload, không gộp dữ liệu của tài khoản A vào B, kể cả hàng đợi upload và mục PENDING của extension [ROADMAP G1].
- BR-A5 Offline: chụp, lưu nháp, lưu/bỏ lưu, đổi Want to visit/Visited, thêm vào bộ sưu tập được xếp hàng; công khai, báo cáo, chặn, xóa tài khoản cần mạng.
- BR-A6 Xung đột nhiều thiết bị (DEC-16): thao tác set-membership (lưu, thêm vào bộ) idempotent; trường đơn trị (Want to visit/Visited, tên bộ, tiêu đề) last-writer-wins theo thời điểm server nhận; xóa thắng sửa đồng thời; **riêng tư thắng công khai** khi xung đột hiển thị; xóa bộ sưu tập thắng thao tác thêm đồng thời.
- BR-A7 Mất thiết bị: dữ liệu đã đồng bộ khôi phục khi đăng nhập máy mới; nháp chưa đồng bộ **mất** và điều này được công bố [ROADMAP §4]. Người dùng [PROPOSED] đăng xuất các phiên khác từ Profile.
- BR-A8 Xóa tài khoản trong app, có xác nhận/tái xác thực; quy trình và thời hạn ở `privacy-and-data.md` §5 [A2].

### 7.7 Cộng đồng và an toàn

- BR-C1 Báo cáo nội dung/người dùng, chặn người dùng, lọc nội dung không phù hợp, liên hệ công khai [Apple 1.2, truy cập 30/10/2026].
- BR-C2 Người bị chặn: không thấy nhau ở Map cộng đồng, chi tiết địa điểm, Profile; áp dụng ở API.
- BR-C3 Không có người hỗ trợ/kiểm duyệt được chỉ định → **không mở công khai** cho người thử nghiệm bên ngoài; app chạy chế độ chỉ riêng tư (cờ server) [ROADMAP G1].
- BR-C4 Hạn mức đăng công khai [PROPOSED 30/ngày/tài khoản] và báo cáo [PROPOSED 20/ngày] chống spam.

## 8. Trạng thái và lỗi cần xử lý

| Bề mặt | Trạng thái bắt buộc có thiết kế và ca kiểm thử |
| --- | --- |
| Camera | Lần đầu xin quyền; từ chối camera; không có camera sau/flash; bị gián đoạn; bộ nhớ đầy |
| Vị trí | Chính xác; gần đúng; từ chối; GPS cũ; trong nhà; nhiều ứng viên sát nhau; nhiều tầng |
| Nháp/đồng bộ | Đã lưu trên máy; đang tải lên; đã đồng bộ; lỗi thử lại; thất bại vĩnh viễn (ảnh hỏng) |
| Map | Lần đầu trống; offline; viewport dày đặc; không có kết quả tìm kiếm; từ chối vị trí |
| Thông tin Google | Đủ dữ liệu; thiếu từng trường; 4 business status + không xác định; đã di chuyển; lỗi/quá hạn mức; ID không hợp lệ |
| Share Sheet | Thành công có địa điểm; PENDING; chưa đăng nhập; offline; trùng; link lỗi; extension bị đóng |
| Cộng đồng | Không có khoảnh khắc; nội dung bị ẩn do báo cáo; người bị chặn; chế độ công khai bị tắt (BR-C3) |
| Tài khoản | Hết phiên; đăng xuất còn dữ liệu chưa đồng bộ; đổi tài khoản; đang xóa tài khoản; bị khóa |

Chuỗi hiển thị người dùng: tiếng Việt đầy đủ dấu; ngôn ngữ thêm theo DEC-01.
