# Doday G2 – Thiết kế trải nghiệm và chứng minh rủi ro kỹ thuật

**Trạng thái G2: APPROVED** (01/11/2026, G2-SIGNOFF trong decisions.md) · Cập nhật 01/11/2026, Asia/Ho_Chi_Minh · Baseline: G1 APPROVED 31/10/2026 (`../g1/`), commit `404183b` + thay đổi chưa commit

Phương án triển khai G2 đã được Chủ dự án duyệt (G2-DEC-01). Prototype và các spike đã chạy được trên simulator. Ngày 01/11/2026 Chủ dự án miễn iPhone thật và Q-17 khỏi điều kiện duyệt G2 (G2-DEC-14), hoãn Google live, Q-05/06 sơ bộ và B1/B2 sang đầu G5 (G2-DEC-15), và duyệt G2-DEC-02…07, 13. Các ca máy thật và Q-17 vẫn chưa chạy, không được tính là đạt. B6 được Chủ dự án (kiêm LEGAL) xác nhận L-1…L-9 (G2-DEC-11). Mọi điều kiện ở §4 đã đạt, được miễn hoặc được hoãn có duyệt. Chủ dự án duyệt G2 ngày 01/11/2026 và chấp nhận cổng nhận lại các ca đã miễn (G2-DEC-14).

## 1. Tài liệu

| Tài liệu | Nội dung | Trạng thái |
| --- | --- | --- |
| [ux-spec.md](ux-spec.md) | Màn hình, J1–J4 thành kịch bản, ma trận trạng thái, quy tắc riêng tư trong UI, B3/movedPlace, ngôn ngữ/accessibility Quyết định UX G2-DEC-04…07, 13 APPROVED 01/11/2026; Q-17 chưa chạy (miễn, G2-DEC-14) |
| [technical-spikes.md](technical-spikes.md) | S1–S7, so sánh lưu cục bộ, Field Mask/SKU, proxy, Share Extension, B6, nguồn chính thức | APPROVED cùng G2 |
| [measurement-plan.md](measurement-plan.md) | B1/B2, Q-05/06 với D_all/D_input/D_allowed, QP-01/02, rủi ro khả thi Q-06 Hoãn khóa sang đầu G5 (G2-DEC-15) |
| [usability-report.md](usability-report.md) | Giao thức Q-17, nhiệm vụ, bảng kết quả | NOT_RUN · miễn cho việc duyệt G2 (G2-DEC-14) |
| [evidence.md](evidence.md) | Từng ca: ngày, build, thiết bị, môi trường, live/fixture, kết quả | Simulator/unit có; máy thật chưa |
| [decisions.md](decisions.md) | Đối chiếu roadmap↔G1, G2-DEC-01…15, câu hỏi mở | 01–07, 13–15 APPROVED; 08/09 hoãn G5; 10 NOT APPROVED (live hoãn G5); 11 APPROVED (LEGAL) |
| [implementation-plan.md](implementation-plan.md) | Kế hoạch triển khai đã duyệt | Cập nhật tiến độ |

## 2. Mã và cách chạy

| Đường dẫn | Vai trò |
| --- | --- |
| `project-g2.yml` | Overlay XcodeGen (`include: project.yml`): thêm target G2, không sửa target `Doday` |
| `Sources/G2Core/` | Privacy gate, trigger/Field Mask, pipeline ảnh, kho nháp/policy/saved, Share inbox |
| `Sources/DodayG2/` | App prototype + Lab (Camera, Map, chi tiết, Saved, Pending, Profile, Cài đặt) |
| `Sources/DodayG2ShareExtension/` | Share Extension ghi PENDING cho tài khoản đang đăng nhập |
| `Tests/G2CoreTests/`, `Tests/DodayG2Tests/`, `Tests/DodayG2UITests/` | Unit test lõi, unit test chạy trong app cho `AppModel`, UI smoke J1–J4 |
| `spikes/g2/places-proxy/` | Proxy lab Node: chỉ fixture, `/live` luôn khóa |
| `Config/` | xcconfig G2, entitlements App Group, Info.plist extension, `G2.private.xcconfig.example` |

```sh
xcodegen generate --spec project-g2.yml
xcodebuild -project Doday.xcodeproj -scheme G2CoreTests -destination 'platform=iOS Simulator,name=iPhone 17' \
  -derivedDataPath /tmp/doday-g2 CODE_SIGNING_ALLOWED=NO -collect-test-diagnostics never test
# Cả ba target (G2CoreTests, DodayG2Tests, DodayG2UITests) trong một lượt:
xcodebuild -project Doday.xcodeproj -scheme DodayG2 -destination 'platform=iOS Simulator,name=iPhone 17' \
  -derivedDataPath /tmp/doday-g2 CODE_SIGNING_ALLOWED=NO -collect-test-diagnostics never test
node --test spikes/g2/places-proxy/*.test.mjs
```

Cách chạy trên iPhone thật: technical-spikes §2. Mở Lab: Profile → “Thử kỹ thuật”.

## 3. Đối chiếu yêu cầu G2

| Yêu cầu (roadmap G2 / G1) | Đáp ứng trong G2 | Bằng chứng | Trạng thái |
| --- | --- | --- | --- |
| Prototype Camera, xem lại/tiêu đề/Hide, Map, tìm kiếm, bottom sheet, chi tiết, Saved, bộ sưu tập, Muốn ghé/Đã ghé, Share/PENDING, Profile/nhật ký, Cài đặt zone/consent | Có, target `DodayG2` | ux-spec §2; UI U-01…U-09 | Simulator PASS · máy thật NOT_RUN |
| Camera không buộc tiêu đề/bộ sưu tập/chờ nhận diện; Map mở khi chưa chụp | Có | U-02, U-05 | Simulator PASS |
| Đủ trạng thái (lần đầu, quyền, GPS, offline, lỗi, trống, đóng cửa, lỗi xử lý, hàng chờ…) | Ma trận ux-spec §4, tái hiện qua Lab | Ảnh simulator evidence §4 | Simulator; máy thật NOT_RUN |
| Q-17 ≥5 người, J1–J4 ≥4/5 | Giao thức sẵn | usability-report | **NOT_RUN** · miễn cho G2 (G2-DEC-14) |
| AVFoundation, PhotosUI, metadata trên iPhone thật | Mã có; unit pipeline | DEV-01…03 | **NOT_RUN** · miễn cho G2, chuyển G4 (G2-DEC-14) |
| Lưu cục bộ, nháp sau mở lại, phân vùng tài khoản | SwiftData + file (G2-DEC-02) | C-04…06, U-03 | Simulator PASS · G2-DEC-02 APPROVED · DEV-04 NOT_RUN, chuyển G4 |
| Core Location, gate, canary, revision, kết quả muộn, RAM ≤60 s | Có | C-01…03, C-07…12 | Unit PASS · DEV-05/06 NOT_RUN |
| Google Maps SDK, Details, Search, mở Google Maps trên máy thật | Fixture; SDK pin, live khóa. **Đường live chưa tích hợp**: adapter chưa nối proxy | DEV-07…09 | **BLOCKED** · hoãn sang đầu G5 (G2-DEC-15): chưa có trần thử/khóa và còn thiếu mã live (technical-spikes §S5 điều kiện 6) |
| Places chỉ qua proxy, chặn chi tiêu | Proxy lab fail-closed. Reservation, retry và breaker mới được test riêng, chưa nằm trên đường gọi nào | P-01…05 | Fixture PASS · live BLOCKED (chưa có handler live) |
| Share Extension nhận NSItemProvider thật từ TikTok/Instagram/Safari | Mã extension + reader đã thử với NSItemProvider tự tạo | C-13; DEV-10…13 | **BLOCKED** (signing/App Group) · miễn cho G2, chuyển G8 (G2-DEC-14) |
| Trace 0 Places/media/review thụ động; tách Maps SDK | Có | C-14, P-01 | Unit PASS · DEV-14 NOT_RUN |
| B1/B2 chốt trước đo | measurement-plan | – | Hoãn sang đầu G5 (G2-DEC-15) |
| Q-05/06 sơ bộ | Đã có phương pháp và đã nêu rủi ro khả thi Q-06. **Chưa có số liệu nào** | – | **BLOCKED** · hoãn sang đầu G5 (G2-DEC-15): cần đường live (§S5 điều kiện 6, G2-DEC-10), iPhone thật và hiệu chỉnh B1 (G2-DEC-08) |
| B3 (UI thư viện >1 km, movedPlace) | G2-DEC-04/05, đã có trong prototype | C-15; U (Lab) | APPROVED 01/11/2026 |
| B6 (nguồn–trường–quyền–TTL, TikTok/Instagram, business status) | Bảng điều kiện | technical-spikes §B6 | APPROVED (LEGAL) L-1…L-9, 01/11/2026 (G2-DEC-11) |

## 4. Điều kiện để chuyển READY_FOR_REVIEW

1. Chủ dự án duyệt UX (ux-spec, G2-DEC-04/05/06/07) **sau** Q-17.
2. Q-17 có biên bản thật: ≥5 người, mỗi luồng ≥4/5.
3. iPhone thật: DEV-01…06 và DEV-09…14 PASS. DEV-07/08 (Google live) PASS, **hoặc** Chủ dự án ghi chấp nhận rõ việc hoãn kèm tác động/cổng tiếp theo.
4. Chốt lưu cục bộ (G2-DEC-02) và metadata (G2-DEC-03).
5. B1/B2 khóa phương pháp và thiết bị (G2-DEC-08/09).
   - **Q-06 phải có kết quả khả thi sơ bộ từ thực địa**, vì G1 yêu cầu “xác nhận khả thi G2”. Tối thiểu cần tỷ lệ ảnh có ngữ cảnh hợp lệ và coverage trên D_allowed của một đợt nhỏ. Kế hoạch đo không thay được kết quả này.
   - Q-05 đủ mẫu (≥200 lần tự gắn) thuộc G5. G2 chỉ ghi số sơ bộ hoặc “không đủ mẫu”, không ghi đạt.
   - Nếu Chủ dự án đổi thiết kế trigger vì Q-06, phải ghi quyết định **trước** G5 và không hạ ngưỡng.
6. B6 có xác nhận LEGAL, hoặc điều kiện chặn được ghi và Chủ dự án chấp nhận cho cổng sau.
7. Không còn lỗi nghiêm trọng đã biết thuộc G2.

**Tình trạng ngày 01/11/2026:**

| Điều kiện | Tình trạng |
| --- | --- |
| 1. Duyệt UX | G2-DEC-04…07 APPROVED. Bước “sau Q-17” được miễn (G2-DEC-14) |
| 2. Q-17 | Miễn cho G2 (G2-DEC-14); kết quả vẫn NOT_RUN |
| 3. iPhone thật | Miễn cho G2 (G2-DEC-14). DEV-07/08 hoãn sang đầu G5, kèm tác động và cổng (G2-DEC-15) |
| 4. G2-DEC-02/03 | APPROVED |
| 5. B1/B2, Q-06 sơ bộ | Hoãn sang đầu G5 (G2-DEC-15) |
| 6. B6 | Đạt: Chủ dự án (kiêm LEGAL) xác nhận L-1…L-9 (G2-DEC-11) |
| 7. Không còn lỗi nghiêm trọng đã biết | Không còn lỗi nghiêm trọng mở trong phạm vi đã kiểm; lượt chạy đủ ba target ngày 01/11 ở evidence §1.3c: 29/29 + 7/7 + UI 10/10 + proxy 5/5 |

Chủ dự án đã chuyển G2 sang APPROVED ngày 01/11/2026 (“Chấp nhận cổng đề xuất. Duyệt G2.”). **Chưa bắt đầu G3**: cần yêu cầu riêng và các điều kiện ở §5.

## 5. Điều kiện chuyển G3 (tóm tắt)

G2 APPROVED; quyết định G2-DEC-02/03 chốt; B4 (backend/region/telemetry) và B5 (LEGAL người đại diện) đã có lịch xử lý trước G3; DEC-19 (pháp nhân/tài khoản) được chọn; target phát hành chuyển family `1` (DEC-03) ở G3.
