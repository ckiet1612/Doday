# Doday G2 – Biên bản thử sử dụng prototype (Q-17)

Trạng thái: **NOT_RUN** · Chưa có người thử. Ngày 01/11/2026 Chủ dự án miễn Q-17 khỏi điều kiện duyệt G2 (G2-DEC-14); việc miễn **không** biến kết quả thành đạt. Bảng kết quả để trống có chủ đích; người lập **không** tự đóng vai người dùng hay điền kết quả giả.

Ngưỡng (G1, DEC-20): ≥5 người thuộc nhóm mục tiêu; **từng luồng J1–J4 có ≥4/5 người hoàn thành không cần hướng dẫn**. Đây chỉ là kiểm tra sử dụng ban đầu, không chứng minh thị trường (ROADMAP G2).

## 1. Người tham gia

| Tiêu chí | Yêu cầu |
| --- | --- |
| Nhóm | Ít nhất 1 người mỗi persona P1 (hay chụp tại quán/du lịch), P2 (lưu link TikTok/Instagram), P3 (tìm nơi mới); dùng iPhone hằng ngày |
| Độ tuổi | ≥18 cho đợt G2 (tránh quy trình người đại diện DEC-24 khi chưa xác minh); 13–15 chỉ thử sau khi LEGAL chốt |
| Loại trừ | Người đã xem/thiết kế prototype; người trong dự án |
| Đồng ý | Phiếu đồng ý ngắn: không ghi âm/quay mặt; chỉ ghi thao tác và lời nói đã ẩn danh; dữ liệu mẫu, không cần tài khoản thật; có thể dừng bất kỳ lúc nào |
| Mã hóa | P01…P05 (ẩn danh); không lưu tên/số điện thoại trong repo |

## 2. Thiết lập

- iPhone thật cài build `DodayG2` (ghi commit/dirty). Tiếng Việt, trừ khi người thử chọn tiếng Anh. Đăng nhập “Tài khoản mẫu A”. Lab: tình huống “Bình thường”. Chưa có nơi đã lưu, chưa có Moment (J4 dùng nơi do chính người thử lưu ở J3).
- Đã cài TikTok/Instagram (nếu Share Extension ký được). Nếu không, J2 dùng đường dự phòng “Dán link” và ghi rõ là dự phòng.
- Người điều phối chỉ đọc nhiệm vụ, không chỉ chỗ bấm. Hỗ trợ thì luồng tính **không hoàn thành không hướng dẫn**.
- Thời gian tối đa mỗi luồng: 3 phút.

## 3. Nhiệm vụ (đọc nguyên văn)

| Luồng | Lời nhắc cho người thử | Hoàn thành khi | Quan sát thêm |
| --- | --- | --- | --- |
| J1 | “Bạn đang ở một quán cà phê. Hãy lưu lại khoảnh khắc này bằng Doday, chỉ cho riêng bạn.” | Moment xuất hiện trong “Khoảnh khắc của tôi” (người thử tự tìm thấy, hoặc điều phối kiểm sau) | Có cố nhập tiêu đề/chọn nơi không; có hiểu “Ảnh sắp chụp: ẩn vị trí” không |
| J2 | “Bạn vừa thấy một quán trên TikTok/Instagram. Hãy lưu nó vào Doday để đi sau.” (đưa link mẫu nếu dùng dự phòng) | Link nằm trong “Chờ xử lý” với PENDING (hoặc người thử chọn nơi → Muốn ghé) | Có hiểu PENDING = chưa xác định nơi không |
| J3 | “Bạn muốn tìm ‘Doday Test Garden’ và lưu lại để ghé sau.” | Nơi ở trạng thái “Đã lưu/Muốn ghé” | Có tìm được Map khi chưa chụp không; có nhầm marker không |
| J4 | “Mở lại nơi bạn vừa lưu, kiểm tra nó còn mở cửa không, rồi chỉ đường tới đó.” | Người thử nói được trạng thái và chạm “Chỉ đường” tới bước chuyển Google Maps | Có hiểu “dữ liệu mẫu” và thông báo Place ID mẫu không |

Câu hỏi sau phiên (thang 1–5): dễ lưu khoảnh khắc; hiểu ai xem được ảnh; hiểu ẩn vị trí ảnh này và ảnh mới; tin “Đã lưu trên máy” nghĩa là chưa đồng bộ.

## 4. Kết quả (chưa có)

| Người | Persona | J1 | J2 | J3 | J4 | Thời gian (J1/J2/J3/J4) | Lỗi quan sát | Ghi chú |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| P01 | – | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | – | – | – |
| P02 | – | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | – | – | – |
| P03 | – | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | – | – | – |
| P04 | – | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | – | – | – |
| P05 | – | NOT_RUN | NOT_RUN | NOT_RUN | NOT_RUN | – | – | – |
| **Tổng** | | –/5 | –/5 | –/5 | –/5 | | | Ngưỡng ≥4/5 mỗi luồng |

Ký hiệu: `C` hoàn thành không hướng dẫn · `H` hoàn thành sau hướng dẫn · `F` không hoàn thành.

## 5. Lỗi, thay đổi và lần thử lại

| ID | Luồng | Mô tả (đã ẩn danh) | Mức (P0/P1/P2) | Thay đổi prototype | Build sau sửa | Thử lại với ai | Kết quả |
| --- | --- | --- | --- | --- | --- | --- | --- |
| – | – | Chưa có | – | – | – | – | – |

Quy tắc: luồng không đạt ≥4/5 thì sửa prototype, ghi thay đổi, rồi thử lại với **người mới** (≥5 cho luồng đó). Không xóa kết quả lần đầu.

## 6. Cần Chủ dự án

1. Tuyển 5 người theo §1 (hoặc chỉ định người tuyển).
2. Cung cấp iPhone thật và signing để cài build (xem technical-spikes §2).
3. Ngày/giờ thử; người điều phối (không phải người thiết kế, nếu có thể).
