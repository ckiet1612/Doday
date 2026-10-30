# Doday: Lộ trình phát triển iOS đến phát hành chính thức

Ngày lập: 30/10/2026.

Căn cứ: tài liệu định hướng Doday đính kèm và các tài liệu chính thức Apple/Google ở cuối bản lộ trình.

Đây là kế hoạch đề xuất, không phải báo cáo nghiệm thu mã nguồn hiện có. Các ngưỡng chất lượng bên dưới là tiêu chuẩn nội bộ đề xuất, chưa phải kết quả đo trên Doday và không phải mức Apple bắt buộc. Chủ sản phẩm cần duyệt các quyết định còn mở ở G1 trước khi triển khai.

## 1. Đích phát hành và phạm vi

**Đích 1.0:** người dùng mở camera, chụp hoặc chọn ảnh, lưu khoảnh khắc an toàn, gắn địa điểm đáng tin cậy, quản lý bản đồ cá nhân, khám phá trải nghiệm công khai và lưu địa điểm từ Share Sheet.

Giữ nguyên định hướng Camera + Map; Profile truy cập phụ. Không thêm Home/Feed, follower, chat, livestream, đặt chỗ, thanh toán hoặc chỉ đường nội bộ.

Phạm vi bắt buộc:

- Đủ 30 hạng mục MVP trong mục 15 của tài liệu, gồm bộ sưu tập và Want to visit/Visited.
- Share Extension và dán liên kết, dù Share Extension chưa được đánh số trong danh sách 30 hạng mục. Đây là quyết định phạm vi 1.0 đề xuất vì tài liệu xác định luồng này quan trọng.
- An toàn phát hành: xóa tài khoản, phân quyền ảnh, báo cáo/chặn, kiểm duyệt, hỗ trợ, chính sách, giám sát, sao lưu/khôi phục.
- Điểm Google và tổng lượt đánh giá thuộc 1.0. Nội dung từng bài review Google có thể sang 1.1 theo chính tài liệu; nếu đưa vào 1.0 thì phải kiểm tra ghi nguồn và điều kiện sử dụng.

Không biến ví dụ tìm kiếm ngôn ngữ tự nhiên thành yêu cầu phải có AI. Tìm theo tên, khu vực và loại địa điểm là đủ cho 1.0 nếu đáp ứng đúng nhu cầu.

## 2. Cách vận hành các cổng nghiệm thu

Mỗi giai đoạn có một cổng G1-G12. Có thể nghiên cứu giai đoạn sau, nhưng không tuyên bố đạt mốc phụ thuộc nếu cổng trước chưa đạt. Quyền riêng tư và kiểm duyệt phải có trước khi người thử nghiệm được dùng nội dung công khai.

Một giai đoạn chỉ đạt khi có đủ:

1. Chức năng được tích hợp trong bản build xác định, không chỉ có giao diện hay mock.
2. Ca kiểm thử đạt, kèm môi trường, thiết bị, bộ dữ liệu, phiên bản và kết quả thực tế.
3. Không còn lỗi nghiêm trọng thuộc phạm vi; lỗi còn lại được ghi rõ người chịu trách nhiệm và quyết định xử lý.
4. Bằng chứng và người duyệt được lưu. Backend, iOS và QA phải cùng xác nhận khi thay đổi liên quan nhiều thành phần.

Phân loại lỗi dùng trong toàn dự án:

- **P0:** lộ dữ liệu riêng tư, chiếm tài khoản, mất dữ liệu không thể phục hồi hoặc sự cố diện rộng.
- **P1:** hỏng luồng cốt lõi, thường xuyên crash, sai phân quyền, không thể xóa dữ liệu hoặc không có đường xử lý thay thế.
- **P2:** ảnh hưởng có cách xử lý thay thế; chỉ được chấp nhận nếu có đánh giá tác động và kế hoạch xử lý.

Mỗi biên bản cổng cần ghi: mã build/commit; phiên bản backend và schema; thiết bị/iOS; ca kiểm thử; kết quả; lỗi mở; người duyệt; ngày duyệt. Không lưu bí mật hoặc dữ liệu cá nhân thật không cần thiết trong bằng chứng.

## 3. Các giai đoạn

### G1. Chốt đặc tả phát hành và các quyết định sản phẩm

**Mục tiêu:** chuyển tài liệu định hướng thành phạm vi có thể kiểm thử.

**Công việc:** lập backlog, hành trình người dùng, rủi ro, mô hình quyền riêng tư và định nghĩa chỉ số. Chốt thị trường, nhóm tuổi, iPhone/iPad, iOS tối thiểu, đăng nhập, backend, ngân sách Google/ảnh, quy mô tải dự kiến và người vận hành.

**Điều kiện đạt:**

- 30 hạng mục MVP, Share Extension và an toàn phát hành đều có mã yêu cầu, độ ưu tiên, ca nghiệm thu, người phụ trách.
- Chốt quy tắc: nháp có thể chưa có địa điểm; muốn công khai phải có địa điểm và lựa chọn chia sẻ rõ ràng; GPS không đồng nghĩa với công khai hoặc tự đánh dấu Visited.
- Đề xuất mặc định khoảnh khắc mới là riêng tư; người dùng chủ động chọn công khai. Đây là lựa chọn cần duyệt, không phải tài liệu đã quyết định sẵn.
- Chốt cách xử lý ảnh chưa đăng nhập, đăng xuất/đổi tài khoản, xóa tài khoản và thời hạn lưu dữ liệu. Không để nháp của tài khoản A tự đồng bộ sang B.
- Duyệt các ngưỡng ở mục 4 và cách đo; không đổi ngưỡng sau thử nghiệm chỉ để hợp thức hóa kết quả.
- Có người chịu trách nhiệm hỗ trợ và kiểm duyệt. Nếu chưa bố trí được, chưa mở cộng đồng công khai.

**Bằng chứng:** đặc tả 1.0, backlog có truy vết, danh sách quyết định, sổ rủi ro và kế hoạch kiểm thử. **Người duyệt:** chủ sản phẩm + trưởng kỹ thuật.

### G2. Thiết kế trải nghiệm và chứng minh các rủi ro kỹ thuật

**Mục tiêu:** xác nhận luồng phù hợp và công nghệ khả thi trước khi xây đầy đủ.

**Công việc:** prototype Camera, Map, bottom sheet, chi tiết địa điểm, Share Extension và Profile; thử AVFoundation, PhotosUI, Core Location, Google Maps/Places và dữ liệu chia sẻ từ ứng dụng thật.

**Điều kiện đạt:**

- Ít nhất 5 người thuộc nhóm mục tiêu thử prototype; tối thiểu 4/5 hoàn thành từng luồng chính không cần hướng dẫn. Đây chỉ là kiểm tra sử dụng ban đầu, không chứng minh thị trường.
- Luồng camera không buộc nhập tiêu đề, tạo bộ sưu tập hay chờ nhận diện; Map có thể mở ngay cả khi không chụp ảnh.
- Thiết kế đủ trạng thái: lần đầu, từ chối quyền, vị trí gần đúng, offline, dữ liệu trống, địa điểm đóng cửa, API lỗi và upload lỗi.
- Bản thử kỹ thuật chạy trên iPhone thật: chụp ảnh, chọn ảnh, lấy vị trí, hiển thị Google Map, lấy Place Details và nhận URL qua Share Sheet. Không coi simulator là bằng chứng camera/extension thực tế.
- Ghi lại kiểu dữ liệu TikTok/Instagram thật trả về; không hứa trích xuất được mọi liên kết và không dựa vào scraping trái điều kiện dịch vụ.
- Đã chọn kiến trúc lưu cục bộ và đường xử lý khi thiếu quyền; quyết định có cần truy cập metadata ảnh, không xin quyền rộng chỉ để lấy GPS.

**Bằng chứng:** prototype đã duyệt, biên bản thử sử dụng và báo cáo thử kỹ thuật. **Người duyệt:** sản phẩm + thiết kế + kỹ thuật.

### G3. Nền tảng iOS, backend, tài khoản và an toàn dữ liệu

**Mục tiêu:** có nền móng thật để các tính năng không phải viết lại khi tích hợp.

**Công việc:** tổ chức SwiftUI/async-await, CI, cấu hình môi trường, lưu cục bộ, API, object storage, tài khoản, Profile cơ bản và kiểm soát truy cập. Không mặc định dùng một nhà cung cấp backend trước quyết định G1.

**Điều kiện đạt:**

- Build từ checkout sạch bằng cấu hình có tài liệu; CI chạy build, lint và kiểm thử; tách development/staging/production và cấu hình ký ứng dụng/extension.
- Đăng ký/đăng nhập/khôi phục hoặc tái xác thực phù hợp với phương thức đã chọn; hết phiên, đăng xuất và thu hồi phiên hoạt động. Có đường xóa tài khoản trong app nếu app hỗ trợ tạo tài khoản. [A2]
- Có schema User, Place, Moment, SavedPlace, Collection, ExternalSource; bổ sung Draft, Report, Block và nhật ký xử lý khi cần. Quan hệ nhiều-nhiều của bộ sưu tập được mô hình hóa rõ.
- Place có ID nội bộ; Google Place ID là tham chiếu duy nhất khi có. Có chống trùng SavedPlace và idempotency cho tạo/upload/retry.
- Kiểm thử ít nhất hai tài khoản chứng minh API và ảnh riêng tư không thể bị đọc/sửa bằng cách đổi ID hoặc lấy URL trực tiếp. Token lưu trong Keychain; log không chứa token, GPS thô hay ảnh riêng tư.
- Quy trình xóa dữ liệu bao trùm database, ảnh/thumbnail, phiên, bộ nhớ đệm do Doday quản lý và lịch giữ backup; quy tắc giữ lại bắt buộc nếu có phải công khai.
- Khóa SDK iOS được giới hạn phù hợp; khóa backend không nhúng vào app. Có inventory dữ liệu/SDK và threat model ban đầu, đặc biệt cho ảnh, vị trí, URL ngoài và extension.

**Bằng chứng:** build staging, hợp đồng API/schema, kết quả kiểm thử xác thực/phân quyền/xóa dữ liệu. **Người duyệt:** kỹ thuật iOS + backend + QA/an toàn.

### G4. Camera-first và khoảnh khắc riêng tư, có khả năng phục hồi

**Mục tiêu:** người dùng không mất ảnh chỉ vì Google, mạng hoặc backend chưa sẵn sàng.

**Công việc:** camera trước/sau, flash khi phần cứng hỗ trợ, PhotosUI, xem lại, tiêu đề tùy chọn, nháp bền vững, hàng đợi upload và vòng đời ứng dụng.

**Điều kiện đạt:**

- Sau bước xác thực/quyền ban đầu, mở app vào camera; không tải Map hay đợi đồng bộ trước khi cho chụp.
- Chụp/chọn ảnh và lưu riêng tư được khi offline, không có GPS hoặc từ chối vị trí. Từ chối camera vẫn có đường vào Map/chọn ảnh nếu phù hợp.
- Phân biệt rõ: đã lưu trên máy, đang tải lên, đã đồng bộ, lỗi cần thử lại. Không hiển thị thành công đồng bộ khi mới lưu cục bộ.
- Qua kiểm thử app bị hệ điều hành đóng, mở lại, mất mạng, timeout và retry: không mất nháp đã xác nhận lưu, không sinh khoảnh khắc trùng. Lỗi hết dung lượng phải báo rõ, không xác nhận lưu giả.
- Chuyển app nền/trước, đổi camera, cuộc gọi/ngắt phiên camera và ảnh xoay/HEIC/ảnh lớn không gây hỏng luồng.
- Đạt các ngưỡng tốc độ camera/lưu cục bộ tại mục 4; nháp chưa có địa điểm có thể bổ sung sau.

**Bằng chứng:** bản alpha cá nhân, video kiểm thử trên máy thật và báo cáo phục hồi/hiệu năng. **Người duyệt:** iOS + QA.

### G5. Danh mục và nhận diện địa điểm đáng tin cậy

**Mục tiêu:** tự động khi đủ chắc chắn, luôn có đường sửa hoặc lưu trước.

**Công việc:** đánh giá GPS và thời điểm lấy vị trí, tìm ứng viên Places, xếp hạng, ngưỡng tin cậy, xác nhận ngắn và sửa thủ công. Phân biệt vị trí lúc chụp với vị trí hiện tại khi upload.

**Điều kiện đạt:**

- Đủ ba nhánh: tự gắn khi tin cậy cao; đề nghị xác nhận khi mơ hồ; lưu nháp chưa gắn khi không biết. Không đơn giản luôn chọn địa điểm gần nhất.
- Từ chối vị trí, GPS cũ, gần đúng, trong nhà, cửa hàng sát nhau, nhiều tầng và ảnh thư viện không GPS đều có kết quả xử lý rõ ràng.
- Ảnh thư viện không bị tự gắn theo GPS hiện tại. Metadata được sử dụng chỉ trong phạm vi quyền và khả năng truy cập thực tế.
- Đạt ngưỡng precision và coverage đã duyệt ở mục 4 trên dữ liệu thực địa có nhãn, có báo cáo theo nhóm điều kiện. Kết quả chỉ chứng minh trên tập đã đo.
- Nhiều tài khoản cùng lưu một Google Place ID không tạo Place trùng, kể cả gửi đồng thời. Địa điểm thủ công không có Google ID vẫn dùng được và không giả dữ liệu Google.
- Có quy tắc đối soát khi ID không còn hợp lệ, địa điểm chuyển nơi hoặc bản ghi thủ công được liên kết sau; không làm mất khoảnh khắc cũ hay tự gộp sai hai nơi.

**Bằng chứng:** bộ mẫu có nguồn/đồng ý phù hợp, nhãn đối chiếu, báo cáo precision/coverage và kiểm thử chống trùng. **Người duyệt:** kỹ thuật + QA + sản phẩm.

### G6. Map và thông tin địa điểm có nguồn rõ ràng

**Mục tiêu:** hoàn thành không gian Map và trang chi tiết dùng dữ liệu thật.

**Công việc:** marker, clustering, tải theo viewport, tìm kiếm, bộ lọc, bottom sheet, Place Details, giờ mở cửa, điểm Google và mở Google Maps.

**Điều kiện đạt:**

- Map hiển thị nguồn cá nhân/cộng đồng, trạng thái lưu/đã đến rõ ràng; phần cộng đồng chưa mở thật thì dùng dữ liệu thử gắn nhãn và chỉ nghiệm thu tích hợp ở G9.
- Tìm theo tên, khu vực, loại địa điểm; lọc theo đã lưu/đã đến/cộng đồng/trạng thái phù hợp. Không phát sinh gọi Places cho toàn bộ bản đồ trong mỗi thao tác kéo.
- Test dữ liệu chứng minh phân biệt trạng thái kinh doanh với đang mở/đóng theo giờ; xử lý đóng tạm, đóng vĩnh viễn, sắp mở khi API có, thiếu dữ liệu, chuyển nơi và lỗi cập nhật.
- Địa điểm đóng cửa vẫn ở bản đồ cá nhân. Nếu không cập nhật được, thể hiện không xác minh được; không biến dữ liệu cũ thành khẳng định trạng thái hiện tại.
- Hiển thị tên/địa chỉ, business status, giờ mở cửa, rating và số lượt đánh giá khi nguồn có. Thiếu dữ liệu không bị diễn giải thành 0 sao hoặc đang đóng cửa.
- Tách nội dung Google và Doday; đáp ứng ghi nguồn/logo/attribution. Có chính sách lưu dữ liệu theo từng trường; không sao chép toàn bộ Places thành danh mục lưu vĩnh viễn. [GG1]
- Nút xem/chỉ đường trỏ đúng địa điểm, có fallback web khi không có Google Maps; xử lý từ chối mở liên kết ngoài. [GG2]
- Field Mask, quota, rate limit và theo dõi chi phí được kiểm thử; đạt tải bản đồ ở mục 4. Tác vụ Map không làm camera chậm đi.

**Bằng chứng:** bộ ca trạng thái địa điểm, kiểm thử deep link, kiểm tra nguồn/cache và profile hiệu năng. **Người duyệt:** iOS + backend + QA.

### G7. Bản đồ cá nhân, danh sách đã lưu và bộ sưu tập

**Mục tiêu:** hoàn chỉnh giá trị sử dụng cá nhân, không cần phụ thuộc cộng đồng đông.

**Công việc:** lưu/bỏ lưu, danh sách, tìm/sắp xếp theo thời gian, bộ sưu tập nhiều-nhiều, Want to visit/Visited, đồng bộ và thao tác offline phù hợp.

**Điều kiện đạt:**

- Lưu địa điểm thông thường không bắt nhập ghi chú hoặc chọn bộ sưu tập; bỏ lưu không xóa Place chung hay khoảnh khắc của người dùng khác.
- Tạo/đổi tên/xóa bộ sưu tập; một địa điểm thuộc nhiều bộ; xóa bộ không xóa địa điểm hay ảnh ngoài ý định.
- Want to visit/Visited tách khỏi business status; không tự đánh dấu đã ghé chỉ vì GPS đi ngang hoặc ứng dụng nhận diện ứng viên.
- Tìm/sắp xếp danh sách, mở lại chi tiết và cập nhật thông tin có hoạt động thật; đồng bộ nhiều thiết bị không mất hoặc nhân đôi quan hệ.
- Kiểm thử retry, đồng thời thêm/bỏ, xóa ở thiết bị A và thao tác offline ở B theo quy tắc xung đột đã công bố trong đặc tả.
- Mỗi tài khoản chỉ truy cập bộ sưu tập/danh sách riêng theo quyền đã chốt; đổi tài khoản không lộ dữ liệu cũ.

**Bằng chứng:** kiểm thử tích hợp trên ít nhất hai thiết bị/phiên và báo cáo xung đột đồng bộ. **Người duyệt:** iOS + backend + QA.

### G8. Lưu từ TikTok/Instagram qua Share Extension

**Mục tiêu:** giữ được ý định lưu ngay cả khi không trích xuất được địa điểm.

**Công việc:** nhận NSItemProvider, App Group/hàng đợi phù hợp, lưu URL nguồn, thử nhận diện từ dữ liệu được phép, xác nhận hoặc tìm thủ công; nhận URL dán trong app.

**Điều kiện đạt:**

- Nhận được các kiểu URL/text thực tế từ TikTok, Instagram và Safari theo khả năng Share Sheet của từng nguồn; thử trên máy thật với phiên bản ứng dụng nguồn được ghi lại.
- Luồng thành công: nhận liên kết, xác nhận địa điểm, lưu và xuất hiện trên Map; gửi lại cùng dữ liệu không tạo Place/SavedPlace trùng.
- Luồng thất bại trích xuất: vẫn lưu URL gốc vào mục chờ xác định, tìm/chọn địa điểm sau. Không đặt tiêu chí phải tự đoán được mọi URL.
- Link riêng tư, hết hạn, rút gọn, bị chặn, thiếu nội dung và offline đều không làm extension treo hoặc mất dữ liệu đã xác nhận lưu.
- Extension bị đóng hoặc app chưa chạy vẫn phục hồi được; phiên hết hạn/đổi tài khoản không gắn nhầm chủ sở hữu. Không phụ thuộc mẹo ép mở app chính từ extension.
- Nếu backend đọc URL ngoài: giới hạn giao thức/redirect, timeout, dung lượng và chặn truy cập mạng nội bộ; không tải nội dung riêng tư hoặc vượt cơ chế bảo vệ của nguồn.

**Bằng chứng:** ma trận URL và ứng dụng nguồn, kiểm thử vòng đời extension, video luồng thành công/dự phòng. **Người duyệt:** iOS + backend + QA/an toàn.

### G9. Cộng đồng, quyền công khai và công cụ an toàn

**Mục tiêu:** hoàn tất trải nghiệm social theo địa điểm mà không lộ dữ liệu cá nhân.

**Công việc:** đăng công khai, trải nghiệm tại địa điểm, Profile/nội dung đã chia sẻ, sửa/xóa/đổi quyền, báo cáo, chặn, giới hạn spam và công cụ kiểm duyệt.

**Điều kiện đạt:**

- Luồng chụp -> xác nhận địa điểm khi cần -> chọn công khai -> xem tại đúng địa điểm hoạt động end-to-end giữa các tài khoản. Nội dung riêng tư không xuất hiện trong Map cộng đồng, kết quả tìm kiếm, số đếm, ảnh bìa hoặc API công khai.
- Công khai -> riêng tư/xóa được áp dụng ở API và các bản ảnh Doday phân phối, không chỉ ẩn giao diện. Kiểm thử URL cũ, thumbnail và bộ nhớ đệm; thông báo rõ không thể thu hồi bản người khác đã tải trước đó.
- Ảnh công khai được xử lý loại metadata vị trí chính xác không cần thiết; không phát hành lịch sử GPS hay theo dõi nền. Địa điểm công khai không đồng nghĩa công khai tọa độ chụp thô.
- Có cơ chế lọc nội dung không phù hợp, báo cáo, chặn người dùng, thông tin liên hệ và quy trình xử lý. [A1, mục 1.2]
- Moderator thật thử nhận báo cáo, xem xét, ẩn/gỡ nội dung, khóa người dùng, lưu vết quyết định và xử lý yêu cầu hỗ trợ. Không chỉ có nút báo cáo nhưng không ai nhận.
- Quy tắc chặn bao phủ API và mọi bề mặt hiển thị được xác định; hạn mức upload/đăng và chống spam được kiểm thử.
- Phạm vi ra mắt có nội dung mẫu thật được cho phép sử dụng, có nguồn và tài khoản rõ ràng; không giả trải nghiệm cộng đồng bằng nội dung sao chép.

**Bằng chứng:** bộ kiểm thử quyền riêng tư đa tài khoản, ảnh/URL thử, diễn tập kiểm duyệt và nhật ký xử lý mẫu. **Người duyệt:** QA/an toàn + vận hành + sản phẩm.

### G10. Hoàn thiện chất lượng, bảo mật và vận hành production

**Mục tiêu:** biến bản đủ chức năng thành bản có thể vận hành và phục hồi.

**Công việc:** regression, hiệu năng, memory/thermal, accessibility, xử lý lỗi, kiểm thử tải, backup/restore, dashboard, cảnh báo và diễn tập sự cố.

**Điều kiện đạt:**

- 100% ca cốt lõi/rủi ro cao đạt; không còn P0/P1. P2 chỉ được giữ khi có đánh giá tác động, người duyệt và hạn xử lý.
- Ma trận gồm iPhone thật cấu hình thấp nhất đã chọn, máy phổ biến, iOS thấp nhất và iOS mới nhất hỗ trợ; màn nhỏ/lớn, quyền thay đổi, nền/trước, mạng chậm/offline và bộ nhớ thấp. Có Dynamic Type, VoiceOver, tương phản và chữ tiếng Việt đầy đủ.
- Đạt mục 4; thử tải backend ít nhất 2 lần tải đỉnh dự kiến tại G1 trong 30 phút, không vi phạm mục tiêu lỗi/độ trễ và không vượt trần ngân sách đã duyệt. Không gọi đây là bằng chứng quy mô chưa thử.
- Không còn phát hiện Critical/High chưa xử lý đối với xác thực, ảnh, vị trí, upload, truy cập đối tượng, URL ngoài và extension. Kiểm tra lỗi quyền bằng API trực tiếp, không chỉ UI.
- Production tách staging; giới hạn quyền quản trị; backup có người sở hữu và một lần khôi phục thật đạt RPO/RTO ở mục 4.
- Có cảnh báo crash, lỗi upload, auth, Places/quota, storage và chi phí. Không coi cảnh báo ngân sách là cơ chế tự chặn chi phí; có quota/rate limit và công tắc giảm tải đã thử.
- Có rollback backend tương thích app cũ, migration an toàn và khả năng tắt tính năng rủi ro phía server. Không giả định có thể thu hồi ngay binary iOS đã cài.

**Bằng chứng:** báo cáo regression/tải/an toàn, phục hồi backup và runbook sự cố. **Người duyệt:** kỹ thuật + QA/an toàn + vận hành.

### G11. TestFlight với người dùng thật và Release Candidate

**Mục tiêu:** xác nhận ứng dụng hoạt động ngoài môi trường phát triển.

**Công việc:** TestFlight nội bộ trước, sau đó beta bên ngoài theo quy trình Apple; theo dõi build cụ thể, phản hồi và chỉ số. Beta bên ngoài có thể cần TestFlight App Review, không đồng nghĩa được duyệt App Store. [A5]

**Điều kiện đạt:**

- Đề xuất ít nhất 30 người thuộc nhóm mục tiêu, 14 ngày, 1.000 phiên trên nhánh 1.0; báo cáo riêng cho build ứng viên, không gộp số đẹp từ build cũ.
- Release Candidate có ít nhất 7 ngày, 500 phiên và 20 người dùng thật; nếu chưa đủ mẫu thì kéo dài thử, không coi thiếu dữ liệu là đạt. Đây là ngưỡng nội bộ, không phải điều kiện Apple.
- Crash-free sessions >= 99,5% trên mẫu của Release Candidate, đồng thời không có crash tái hiện được trong luồng cốt lõi; báo cả số phiên, số crash và phạm vi thiết bị.
- Các luồng chụp/lưu, sửa địa điểm, Share Sheet, Map/Discover và kiểm tra nơi đã lưu đều được thử thực địa; mỗi luồng có ít nhất 20 lần thử hợp lệ, gồm cả nhánh dự phòng.
- Không mất ảnh đã xác nhận lưu, không lộ riêng tư, không có P0/P1 chưa giải quyết. Duy trì các ngưỡng kỹ thuật; thay đổi đáng kể cần kiểm thử lại và thu đủ mẫu liên quan.
- Theo dõi retention, tỷ lệ sửa địa điểm và xem -> lưu để ra quyết định sản phẩm; không dùng một tỷ lệ retention chưa có baseline làm bằng chứng App Store sẵn sàng.
- Sản phẩm, kỹ thuật, QA và vận hành duyệt Release Candidate cùng checklist G12A.

**Bằng chứng:** báo cáo beta có mẫu số, phản hồi, lỗi, biện pháp xử lý và build được ký duyệt. **Người duyệt:** sản phẩm + kỹ thuật + QA + vận hành.

### G12. Hồ sơ App Store, xét duyệt và phát hành có kiểm soát

**Mục tiêu:** tách rõ đủ điều kiện gửi xét duyệt, Apple chấp thuận và bản thực sự có thể tải.

**G12A - Đủ tiêu chuẩn nội bộ để gửi:**

- G1-G11 đạt; đúng Release Candidate được ký, đánh phiên bản và kiểm tra archive/distribution, cả app lẫn extension.
- Tài khoản Apple Developer, quyền truy cập App Store Connect, App ID/Bundle ID và cấu hình ký/phân phối hợp lệ; các thỏa thuận bắt buộc trong tài khoản đã được xử lý. Chuẩn bị đăng ký/xác minh từ G1, không đợi đến ngày nộp.
- Dùng SDK/toolchain đang được Apple chấp nhận tại ngày nộp. Tại lần đối chiếu 30/10/2026, yêu cầu upload là Xcode 26 trở lên với iOS 26 SDK trở lên, áp dụng từ 28/04/2026. Từ 09/09/2026, deployment target iOS/iPadOS phải từ 13 trở lên; Doday có thể chọn mức cao hơn theo nhu cầu và SDK phụ thuộc. Apple đã thông báo từ tháng 04/2027 cần iOS 27 SDK trở lên. SDK build không phải deployment target. Đối chiếu lại tại ngày nộp. [A6]
- Hoàn thành App Privacy đúng app và SDK thật; privacy manifest/required-reason API/SDK signature khi thuộc diện áp dụng; khai báo quyền và purpose string chính xác. ATT chỉ đặt ra nếu có tracking thuộc định nghĩa Apple, không mặc định dùng để xin camera/GPS. [A3, A4, A7]
- Privacy Policy, Terms, Support và đầu mối kiểm duyệt công khai, truy cập được. Hồ sơ App Store có metadata, ảnh chụp từ bản thật, age rating, khai báo nội dung và xuất khẩu mã hóa phù hợp.
- Cung cấp tài khoản/quy trình review hợp lệ, backend hoạt động, hướng dẫn các nhánh vị trí/mẫu nội dung để người review không bị chặn vì không đứng tại địa điểm thử. Không giấu tính năng chỉ bật sau review.
- Đối chiếu điều kiện dịch vụ đăng nhập nếu có dùng social login; lựa chọn đăng nhập phải đáp ứng mục 4.8 nếu thuộc diện áp dụng. [A1]
- Hoàn tất kiểm tra Google Maps/Places: bản đồ đúng nguồn, attribution, quyền dùng ảnh/review, lưu trữ đúng chính sách, key/quota và ngân sách production. [GG1, GG3]
- Có lịch phát hành, người trực, phương án giảm tải/tắt tính năng và kịch bản xử lý sự cố; không còn blocker pháp lý/chính sách đã biết trong thị trường mục tiêu.

**G12B - Được phép phát hành và đã lên store:**

- Apple App Review chấp thuận đúng phiên bản; mọi yêu cầu bổ sung/rejection đã được xử lý. Không thể bảo đảm trước kết quả xét duyệt.
- Phát hành theo thị trường/nhóm người dùng đã chọn; xác minh trang App Store và cài mới được bản thật trên iPhone.
- Smoke test sau phát hành: đăng nhập, chụp/lưu, đồng bộ, Map/Places, Share Sheet, quyền riêng tư và báo cáo hoạt động với production.
- Có người trực và kiểm tra 24-72 giờ đầu; khi có P0, dừng mở rộng, hạn chế tính năng liên quan và xử lý sự cố. Theo dõi giai đoạn này là vận hành sau phát hành, không phải yêu cầu Apple xét duyệt.

Lưu ý: chức năng phased release bảy ngày của App Store Connect được tài liệu hóa cho bản cập nhật; không mặc định có rollout phần trăm tương tự cho lần ra mắt 1.0. Lần đầu có thể kiểm soát bằng phạm vi thị trường và cơ chế cấp quyền truy cập phù hợp với hồ sơ review đã công khai. [A8]

**Bằng chứng:** checklist ký duyệt, build/phê duyệt App Store, bản cài store và kết quả smoke test production. **Người duyệt:** chủ sản phẩm + release owner + vận hành.

## 4. Ngưỡng chất lượng đề xuất

Các ngưỡng phải được duyệt ở G1 và đo bằng công cụ phù hợp. P95 là thời gian mà 95% phép đo không vượt quá. Không gộp thời gian lưu cục bộ với upload mạng.

| Chỉ số | Mức đề xuất | Điều kiện đo/bằng chứng |
| --- | --- | --- |
| Camera sẵn sàng khi mở mới | P95 <= 2 giây | iPhone thật thấp nhất hỗ trợ; từ mở app đến preview và nút chụp hoạt động; loại luồng đăng nhập/xin quyền lần đầu; >= 100 lần |
| Camera trở lại từ nền | P95 <= 1 giây | >= 100 lần; phân biệt trường hợp phiên bị hệ điều hành hủy |
| Chụp đến nháp lưu bền vững | P95 <= 1 giây | >= 100 ảnh với định dạng/kích thước hỗ trợ; không chờ GPS/Google/upload |
| Ảnh đã xác nhận lưu | 0 mất, 0 trùng trong bộ thử phục hồi | >= 100 chu kỳ kết hợp đóng app, timeout, retry, offline và đổi mạng; không bao gồm người dùng xóa app hoặc mất thiết bị trước đồng bộ |
| Độ đúng tự gắn địa điểm | Precision >= 95% | Địa điểm gắn đúng / mọi lần tự gắn; >= 200 lần tự gắn thực địa, >= 30 địa điểm đa dạng; có nhãn và báo cáo từng nhóm |
| Mức sử dụng tự gắn | Đề xuất coverage >= 30% trong điều kiện đủ đầu vào | Số tự gắn / toàn bộ ca đủ điều kiện đã định nghĩa trước; không loại ca sai khỏi mẫu số; báo cả trường hợp không đủ đầu vào. Mức này cần xác nhận khả thi ở G2 |
| Truy vấn bản đồ cá nhân | P95 <= 2 giây đến nội dung dùng được | Bộ 1.000 địa điểm do Doday sở hữu/quyền dùng hợp lệ; viewport/clustering; mạng thử có ghi băng thông/độ trễ |
| Lưu qua Share Sheet | >= 98% không mất yêu cầu lưu hợp lệ | >= 100 ca đủ định dạng; thành công là lưu được địa điểm hoặc URL chờ xác định; tỷ lệ tự trích xuất báo riêng, không nhập làm một |
| Upload ảnh | >= 99% hoàn tất trong cửa sổ thử có mạng ổn định | >= 200 yêu cầu; sau retry có giới hạn; ghi kích thước ảnh, mạng và thời hạn quan sát; không tính offline thành lỗi backend |
| API do Doday quản lý | >= 99,5% yêu cầu hợp lệ thành công trong beta; P95 <= 800 ms | Không gồm upload file và thời gian nhà cung cấp ngoài; báo riêng lỗi/độ trễ Google và độ trễ end-to-end |
| Crash-free sessions của RC | >= 99,5% | >= 500 phiên, >= 20 người, >= 7 ngày; kèm số crash và không có crash cốt lõi tái hiện được |
| Khôi phục dữ liệu server | Đề xuất RPO <= 24 giờ, RTO <= 4 giờ | Một lần khôi phục thật ở môi trường cách ly; bao gồm quan hệ DB/ảnh, không chỉ kiểm tra file backup tồn tại |
| Quyền riêng tư | 0 truy cập trái phép trong bộ thử quyền | API, storage, thumbnail, tìm kiếm, số đếm, URL cũ, chuyển công khai -> riêng tư, đổi tài khoản và xóa tài khoản |
| Kiểm duyệt | Ca khẩn cấp được tiếp nhận <= 4 giờ; thông thường <= 24 giờ | SLA nội bộ đề xuất; có người trực, diễn tập và nhật ký. Phải thu hẹp beta nếu không có khả năng đáp ứng |

Không một ngưỡng hay mẫu thử hữu hạn nào chứng minh không bao giờ có lỗi. Sự cố dữ liệu/quyền riêng tư và lỗi cốt lõi đã biết vẫn chặn phát hành dù trung bình thống kê đạt.

## 5. Đối chiếu toàn bộ phạm vi MVP

| Phạm vi trong tài liệu | Giai đoạn chịu trách nhiệm | Nghiệm thu cuối |
| --- | --- | --- |
| 1-3: tài khoản, hồ sơ, thiết lập riêng tư | G3, G9 | G10-G11 |
| 4-5: camera-first, chụp/chọn ảnh | G4 | G10-G11 |
| 6-7: vị trí, nhận diện, xác nhận/sửa | G5 | G10-G11 thực địa |
| 8-10: tiêu đề tùy chọn, lưu/chia sẻ, public/private | G4, G9 | G10-G11 |
| 11-16: Map, marker, cá nhân/cộng đồng, tìm/lọc/clustering | G6, G9 | G10-G11 |
| 17: lưu vào bản đồ cá nhân | G7 | G10-G11 |
| 18: tham chiếu Google Place ID | G3, G5 | G10 |
| 19-24: thông tin, trạng thái, giờ, rating, xem/chỉ đường | G6 | G10-G11 |
| 25-27: chi tiết, trải nghiệm công khai, chia sẻ tại nơi | G6, G9 | G10-G11 |
| 28-30: danh sách, bộ sưu tập, Want to visit/Visited | G7 | G10-G11 |
| Mục 7: Share Sheet và URL nguồn TikTok/Instagram | G2, G8 | G10-G11 trên máy thật |
| Mục 17: bảo mật, dữ liệu Google, chi phí, quyền riêng tư, UGC | G3, G6, G8-G10 | G11-G12A |
| Nội dung từng review Google | Tùy chọn 1.0; có thể sang 1.1 | Nếu có: G6, G10 và kiểm tra ghi nguồn |

## 6. Các mốc để quyết định có được mở rộng hay không

| Mốc | Điều kiện | Chưa được tuyên bố |
| --- | --- | --- |
| Thiết kế và nền tảng đã chốt | G1-G3 đạt | Chưa chứng minh camera/Map ngoài thực địa |
| Alpha cá nhân dùng được | G4-G7 đạt | Chưa sẵn sàng cộng đồng công khai |
| Đủ chức năng 1.0 | G8-G9 đạt cùng các cổng trước | Chưa sẵn sàng App Store nếu chưa qua G10-G11 |
| Release Candidate | G10-G11 đạt | TestFlight không phải App Store approval |
| Đủ tiêu chuẩn gửi App Store | G12A đạt | Không bảo đảm Apple sẽ duyệt |
| Đã phát hành chính thức | G12B đạt | Không đồng nghĩa đã chứng minh tải lớn hoặc phù hợp thị trường |

Các hạng mục phụ thuộc hợp đồng đã ổn định có thể được phát triển song song khi đủ nhân lực: G4 và chuẩn bị G5/G8 sau G3; chuẩn bị nội dung store và chính sách từ G1. Tuy nhiên chỉ nghiệm thu tích hợp sau khi các phụ thuộc hoạt động thật. Không bỏ qua G9 để đẩy nội dung công khai vào beta sớm.

Chưa gắn lịch tuần vì chưa biết nhân sự, thời gian làm việc và mức hoàn thiện mã nguồn. Sau G1-G2 mới ước lượng theo năng lực, lấy số liệu thử kỹ thuật và phần việc còn lại làm căn cứ, không lấy ngày mong muốn làm tiêu chuẩn hoàn thành.

## 7. Những điều kiện luôn chặn phát hành

- Ảnh/nháp đã xác nhận lưu có thể mất do lỗi ứng dụng, hoặc dữ liệu riêng tư truy cập được trái phép.
- Tự gắn sai địa điểm phổ biến nhưng không cảnh báo/không sửa được; nhận diện chặn việc lưu ảnh.
- Không phân biệt được business status, giờ mở cửa và dữ liệu chưa biết/cũ.
- Không có đường báo cáo/chặn/xử lý nội dung cộng đồng, hoặc không có người vận hành.
- Có nút xóa tài khoản nhưng dữ liệu gắn với tài khoản vẫn không được xử lý theo chính sách đã công bố.
- Nội dung Google sử dụng sai điều kiện; API không có giới hạn/không biết chi phí khi ra mắt.
- Không có backup đã thử khôi phục, hỗ trợ hoặc phương án giảm thiểu sự cố.
- Chưa đủ mẫu beta hoặc chỉ có mock/simulator nhưng lại ghi nhận như thử nghiệm thực tế.
- Hồ sơ store, quyền, dữ liệu thu thập hoặc SDK thực tế không khớp; backend review không truy cập được.

## 8. Nguồn chính thức đã đối chiếu

Đối chiếu ngày 30/10/2026; cần kiểm tra lại khi chuẩn bị nộp vì chính sách, SDK và điều kiện dịch vụ có thể thay đổi. Các nguồn này hỗ trợ phần tuân thủ; số mẫu thử và ngưỡng chất lượng của lộ trình là đề xuất riêng.

- **A1:** Apple, App Review Guidelines: 1.2 User-Generated Content; 2.1 App Completeness; 4.8 Login Services; 5.1 Privacy. Nguồn: `https://developer.apple.com/app-store/review/guidelines/`.
- **A2:** Apple Developer Support, Offering account deletion in your app. Nguồn: `https://developer.apple.com/support/offering-account-deletion-in-your-app/`.
- **A3:** Apple, App privacy details on the App Store. Nguồn: `https://developer.apple.com/app-store/app-privacy-details/`.
- **A4:** Apple Developer Support, Third-party SDK requirements và tài liệu privacy manifest/required-reason API khi áp dụng. Nguồn: `https://developer.apple.com/support/third-party-SDK-requirements/` và `https://developer.apple.com/documentation/bundleresources/adding-a-privacy-manifest-to-your-app-or-third-party-sdk`.
- **A5:** App Store Connect Help, Invite external testers; quy trình TestFlight App Review. Nguồn: `https://developer.apple.com/help/app-store-connect/test-a-beta-version/invite-external-testers`.
- **A6:** Apple Developer, Upcoming Requirements và thông báo ngày 09/09/2026. Nguồn: `https://developer.apple.com/news/upcoming-requirements/` và `https://developer.apple.com/news/?id=k1mtkt1k`.
- **A7:** Apple, User privacy and data use; phạm vi áp dụng AppTrackingTransparency. Nguồn: `https://developer.apple.com/app-store/user-privacy-and-data-use/`.
- **A8:** App Store Connect Help, Release a version update in phases. Nguồn: `https://developer.apple.com/help/app-store-connect/update-your-app/release-a-version-update-in-phases`.
- **GG1:** Google Maps Platform, Places API Policies and attributions; giới hạn caching/storage, nguồn dữ liệu và bản đồ. Nguồn: `https://developers.google.com/maps/documentation/places/web-service/policies`.
- **GG2:** Google Maps Platform, Maps URLs Get Started. Nguồn: `https://developers.google.com/maps/documentation/urls/get-started`.
- **GG3:** Google Maps Platform, API Security Best Practices; Place Details (New), Field Mask và nhóm trường dữ liệu. Nguồn: `https://developers.google.com/maps/api-security-best-practices` và `https://developers.google.com/maps/documentation/places/web-service/place-details`.

Kết luận: phát hành 1.0 không cần làm mọi tính năng tương lai, nhưng phải hoàn chỉnh vòng giá trị camera -> khoảnh khắc -> địa điểm -> bản đồ, đồng thời có bảo vệ dữ liệu và năng lực vận hành thật. G12A là điều kiện đủ nội bộ để gửi; chỉ G12B mới được gọi là đã phát hành chính thức.
