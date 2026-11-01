# Doday G2 – Bằng chứng

Trạng thái: **APPROVED** (cùng G2, 01/11/2026) · Cập nhật 01/11/2026, Asia/Ho_Chi_Minh

**Build cho mọi ca dưới đây:** commit `404183b` (main) **+ thay đổi chưa commit** (dirty): `.gitignore`; `Sources/Doday/ContentView.swift` và `project.yml` là thay đổi có sẵn từ trước G2, giữ nguyên; toàn bộ file G2 chưa track (`Config/`, `Sources/G2Core|DodayG2|DodayG2ShareExtension`, `Tests/G2CoreTests|DodayG2UITests`, `spikes/`, `docs/g2/`, `project-g2.yml`). Chưa commit theo phạm vi duyệt lúc chạy. Ngày 01/11/2026, sau khi G2 được duyệt, mã của lượt §1.3c được commit nguyên trạng, chia theo phần (xem `git log`).

**Môi trường Mac:** macOS 27.0 (26A428), Xcode 27.1 (27A9275), XcodeGen 2.46.0, Node v26.4.0. **Simulator:** iPhone 17, iOS 27.0. Không thiết bị thật nào được kết nối (`xcrun xctrace list devices` chỉ có Mac + simulator).

Ký hiệu: `PASSED` · `FAILED` · `NOT_RUN` (chưa làm, có thể làm khi có điều kiện) · `BLOCKED` (thiếu điều kiện/thẩm quyền). **Simulator/unit/fixture không phải bằng chứng thực địa**; các ca đó chỉ chứng minh logic và luồng UI.

Bằng chứng đã làm sạch: không có tọa độ thật, ID thiết bị, URL nguồn thật hay bí mật. Log thô xcodebuild nằm ngoài repo (`/tmp/doday-g2-*.log`, `/tmp/doday-g2-ui.xcresult`), không phải bằng chứng lưu trữ.

## 1. Kiểm thử tự động

### 1.1 G2Core unit (simulator iPhone 17 / iOS 27.0, fixture)

Lệnh: `xcodebuild -project Doday.xcodeproj -scheme G2CoreTests -destination 'platform=iOS Simulator,name=iPhone 17' -derivedDataPath /tmp/doday-g2 CODE_SIGNING_ALLOWED=NO -collect-test-diagnostics never test` · Chạy 31/10/2026 16:26, 16:55 và **17:05 (mã cuối của G2Core, sau swiftformat)** · **26/26 PASSED** (exit 0) cả ba lần.

| ID | Ca (XCTest) | Chứng minh | Kết quả |
| --- | --- | --- | --- |
| C-01 | PrivacyTests.testDefaultConfigurationCannotSendCoordinates | Mặc định (Hide bật, zone bật chưa xác nhận, chưa consent) không gửi tọa độ | PASSED |
| C-02 | testErrorCircleTouchingZoneIsBlocked; testUnverifiedZonesAndInvalidRadiusFailClosed | Vòng sai số chạm vùng → UNCERTAIN; vùng chưa xác nhận/radius 99 m → chặn | PASSED |
| C-03 | testOutsideWithIndependentConsentAndHideOffCanSend; testZoneOffDoesNotOverrideHideOrConsent | Chỉ cho phép khi Hide tắt + consent + ngoài vùng; tắt zone không bỏ Hide/consent | PASSED |
| C-04 | StorageAndImageTests.testSourceAndDraftRecoverAfterReopeningAndAreAccountPartitioned | Nguồn ghi đúng byte; nháp còn sau khi đóng/mở store; tài khoản B không thấy/không xử lý nháp của A | PASSED |
| C-05 | testProcessingFailureKeepsOriginalAndSameDraftIDForRetry | Lỗi xử lý giữ nguồn, cùng ID, trạng thái `processingFailed` | PASSED |
| C-06 | testCurrentHideDoesNotReopenAnOldPlaceAndSourceSurvivesStateChange | Tiêu đề cắt 120; liên kết Place lưu riêng; nguồn còn sau đổi trạng thái | PASSED |
| C-07 | testRetentionExpiresAtSixtyAndDoesNotResetOnRetry; LifecycleTests.testRecognitionVaultPurgesOnExpiryPolicyChangeAndBackground | Mốc 59/60/61 s; retry không reset hạn; vault xóa khi hết hạn/discard | PASSED |
| C-08 | testMissingStaleApproximateInvalidAndCrossAccountSamplesFailClosed | Thiếu/cũ 61 s/âm/>50 m/NaN/gần đúng/khác tài khoản → chặn | PASSED |
| C-09 | testRevisionToggleAndAccountChangeInvalidateLateResult | Kết quả đến muộn bị bỏ khi revision/Hide/tài khoản đổi | PASSED |
| C-10 | LifecycleTests.testCanaryMatrixContainsAtLeast100PrivacyCasesAndPassiveSequences | 192 tổ hợp canary đúng kỳ vọng; 100 chuỗi × 7 sự kiện thụ động → 0 request | PASSED |
| C-11 | testNoAutoAssignmentWithoutFrozenCalibration | Không có calibration → không tự gắn; nhánh tự gắn/xác nhận chỉ với ngưỡng fixture | PASSED |
| C-12 | testPassiveEventsNeverHavePlacesRequest; testPhotosAndReviewsNeedDistinctExplicitTriggers | Field mask tối thiểu; Details không chứa photos/reviews; mỗi khối một lệnh | PASSED |
| C-13 | LifecycleTests.testRealNSItemProviderURLAndTextPaths | `NSItemProvider` thật trong tiến trình: NSURL (plist trên iOS), NSString, Data thô `public.url`; text không có link bị từ chối; ghi `registeredTypes` | PASSED |
| C-14 | testInboxRequiresOwnerDeduplicatesAndRejectsStaleEpoch; testShareParserRejectsUnsupportedSchemesAndKeepsPendingIntent | Không chủ → không ghi; trùng URL (bỏ utm) báo `duplicate`; epoch cũ bị từ chối; chặn javascript:/http:/user:pass | PASSED |
| C-15 | PrivacyTests.testLibraryMismatchUsesPhotoGPSAgainstAttachedPlaceOnlyWhenNotBlocked | B3: GPS ảnh vs Place; >1 km → mismatch; Hide/zone chưa xác nhận/ảnh gần vùng → blocked | PASSED |
| C-16 | testDecodedOutputsAreSquareBoundedAndStripGPSForEveryOrientation; testCenterCropMatchesIndependentUIKitOrientationReference | 8 hướng EXIF: vuông, ≤2048/≤400, không còn GPS; pixel khớp tham chiếu UIKit | PASSED |
| C-17 | testSmallImageIsNotUpscaledAndCorruptInputFails; testMetadataDetectsSourceGPSWithoutLoggingOrCopyingToOutput | 80×60 → 60×60; byte hỏng lỗi; đọc GPS/sai số/ngày chụp, đầu ra không còn | PASSED |
| C-18 | testMapsURLHasDestinationIDAndNeverOrigin; LifecycleTests.testSavedIntentStoresOnlyIDsUserLabelsAndUserStatusPerAccount | Maps URL có `destination_place_id`, không `origin`; SavedIntent chỉ ID/nhãn/trạng thái, theo tài khoản | PASSED |
| C-19 | PrivacyTests.testZoneStatusClassifiesAPhotoAndFailsClosed | `ZoneStatus`: trong vùng → inside; vòng sai số chạm vùng → uncertain; thiếu tọa độ, sai số không hợp lệ hoặc vùng chưa xác nhận → uncertain; bảo vệ tắt → off | PASSED (01/11) |
| C-20 | PrivacyTests.testChoosingAPlaceNeverBypassesHideOrAnActiveZone | Chỉ `off`/`outside` khi Hide tắt mới được gắn Place; Hide bật thì luôn chặn | PASSED (01/11) |
| C-21 | PrivacyTests.testCameraPhotoZoneNeedsAReliableSampleWithinSixtySecondsOfCapture | Ảnh chụp: chỉ mẫu tin cậy, cùng tài khoản, nhận trong 60 s sau khi chụp; 61 s, mẫu cũ hoặc kém chính xác → uncertain | PASSED (01/11) |

**Lịch sử đỏ→xanh trong G2:** C-13 từng FAILED (31/10 15:44 và 16:11) do `public.url` của NSURL trên iOS là binary plist. Đã sửa reader, xác nhận bằng probe `simctl spawn` (4/4 đúng) rồi chạy lại 26/26. C-15 từng FAILED do dữ liệu test nằm đúng biên 200,15 m; dời tâm vùng, logic không đổi.

### 1.1b App model hosted trong app (`DodayG2Tests`, simulator iPhone 18 Pro / iOS 27.0, fixture), 01/11/2026

Target test mới chạy trong app, gọi trực tiếp `AppModel`, dùng để chống tái phát hai lỗi P1 phát hiện khi review.

| ID | Test | Kiểm điều gì | Kết quả |
| --- | --- | --- | --- |
| A-01 | testManualPlaceIsBlockedUntilTheCameraPhotoIsShownOutside | Mặc định (vùng chưa xác nhận), chưa kiểm vị trí, mẫu inside/edge/approximate/stale: `attach()` đều từ chối. Chỉ mẫu outside trong 60 s mới gắn được | PASSED |
| A-02 | testZoneVerdictDoesNotSurviveAPolicyChange | Đổi revision policy thì verdict ngoài vùng mất hiệu lực | PASSED |
| A-03 | testZoneOffLeavesHideAsTheOnlyGate | Tắt bảo vệ vùng: Hide mặc định vẫn chặn; tắt Hide của ảnh thì gắn được | PASSED |
| A-04 | testLibraryPhotoIsJudgedByItsOwnGPSNotTheCurrentLocation | Ảnh thư viện có GPS trong vùng: bị chặn dù điện thoại đang ở ngoài. Không có GPS: bị chặn. GPS cách 3,3 km: gắn được | PASSED |
| A-05 | testImportStartedByOneAccountIsDroppedAfterSwitching | Nhập ảnh dưới A, đổi sang B trước khi tải xong (trình tải cố ý bỏ qua hủy): B và A đều không nhận ảnh | PASSED |
| A-06 | testImportIsDroppedAfterSignOut | Đăng xuất trong lúc nhập: kết quả bị bỏ | PASSED |
| A-07 | testImportCompletesWithinTheSameSession | Cùng phiên: ảnh được lưu với origin `library` | PASSED |

Chạy 13:38–13:42 (7/7, có log CoreData I/O do các test xóa kho dùng chung khi xử lý ảnh của test trước còn chạy), rồi khoảng 13:43–13:46 sau khi thêm bước chờ xử lý ở `tearDown` (7/7, không còn log lỗi). Lượt đầy đủ 13:46 cũng 7/7. G2Core cùng lượt: 29/29.

### 1.2 Proxy lab (Node, fixture)

Lệnh: `node --test spikes/g2/places-proxy/*.test.mjs` · 31/10/2026 ~16:05 và chạy lại 19:21 trên mã cuối · **5/5 PASSED** cả hai lần.

| ID | Ca | Kết quả |
| --- | --- | --- |
| P-01 | Sự kiện thụ động và search <2 ký tự không có mask; photos/reviews mask riêng; details không có photos | PASSED |
| P-02 | `/live/*` trả 423 dù client gửi `approved: true` + khóa giả; fixture có nhãn `mode: fixture`; `/fixture/pan` 400 | PASSED |
| P-03 | Retry tối đa 2 lần (3 attempt); lỗi vĩnh viễn không retry | PASSED |
| P-04 | Breaker mở sau 5 lỗi/60 s, đóng tới 60 s, một probe, success đóng lại | PASSED |
| P-05 | 10 reservation đồng thời với trần 2 → đúng 2 thành công, lần sau bị từ chối | PASSED |

### 1.3 UI smoke (simulator iPhone 17 / iOS 27.0, fixture)

Lệnh: `xcodebuild -project Doday.xcodeproj -scheme DodayG2 -destination 'platform=iOS Simulator,name=iPhone 17' -derivedDataPath /tmp/doday-g2 CODE_SIGNING_ALLOWED=NO -only-testing:DodayG2UITests -collect-test-diagnostics never test`.

**Lượt hợp lệ gần nhất: 31/10/2026 17:06–17:26**, sau `swiftformat`/sửa lint, máy bình thường. Kết quả **8/9 PASSED, 1 FAILED, 1 skipped** (ScreenshotTour chỉ chạy khi yêu cầu).

| ID | Ca | Chứng minh (simulator, fixture) | 17:06–17:26 |
| --- | --- | --- | --- |
| U-01 | testFirstRunThenSignedOutCannotCaptureButMapOpens | Onboarding; chưa đăng nhập không chụp được; Map vẫn mở | PASSED |
| U-02 | testJ1CaptureSavesWithoutTitleOrPlaceAndStaysLocal | J1: lưu không cần tiêu đề/nơi; nhật ký hiện “Đã lưu trên máy” | PASSED |
| U-03 | testDraftSurvivesTerminatedProcess | Nháp còn sau khi tiến trình app bị kết thúc và mở lại | PASSED |
| U-04 | testCameraChipHidesNextPhotoOnlyAndKeepsDefault | Chip Camera chỉ đổi ảnh sắp chụp; mặc định Cài đặt giữ “ẩn” | PASSED |
| U-05 | testJ3MapWithoutCaptureSearchAndSave | J3: Map khi chưa chụp → tìm → Lưu | PASSED |
| U-06 | testJ4SavedPlaceLoadsDetailsOnDemandAndOffersDirections | J4: Saved → chi tiết theo yêu cầu → Chỉ đường | PASSED |
| U-07 | testJ2PastedLinkStaysPendingAndIsNotDuplicated | J2 dự phòng: dán link → PENDING, dán lại → “Đã có trong Doday”, chọn nơi → hết PENDING | PASSED |
| U-08 | testEnglishInterface | Giao diện tiếng Anh | PASSED |
| U-09 | testPrivacyDefaultsAndZoneOffNeedsConfirmation | Mặc định Hide=bật, zone=bật, consent=tắt **đúng**; bước xác nhận tắt zone **FAILED** | FAILED → xem dưới |

**Diễn biến U-07/U-09 (không che lỗi):** U-07 FAILED ở 16:2x, vì alert thông báo ở màn gốc làm **đóng sheet Chờ xử lý**. Đây là lỗi UX thật, đã sửa bằng banner trong sheet, rồi PASSED ở lượt 17:06–17:26. U-09: phần mặc định luôn đúng. Bước xác nhận tắt zone lỗi vì iOS mới biến `confirmationDialog` thành popover không có nút Hủy. Đã đổi sang `alert` có Hủy (cũng là sửa UX) và sửa nút “Giữ bản lưu hiện tại” của movedPlace. Ca sau sửa: xem §1.3b.

**Lượt 18:40–19:20 trên mã cuối: KHÔNG HỢP LỆ (môi trường).** 6/9 ca lỗi ngay ở `app.launch()` (“does not have a process ID”, “Failed to get background assertion”). Lúc đó load average của máy là 111–362, ổ dữ liệu đầy 95% (còn 22 GB), `spindump` chạy. J3/J4 vẫn PASSED. Không tính lượt này là FAILED của sản phẩm, cũng không tính là PASSED. Thay đổi từ lượt hợp lệ tới mã cuối chỉ gồm: alert tắt zone, role nút movedPlace, nhãn thanh trên “G2”, và helper trong test.

### 1.3b Mã cuối, chạy lại khi máy đã hạ tải (load 1 phút <15)

Mã app cuối gồm cả: alert tắt zone, nút movedPlace luôn hiện, nhãn “G2”, bỏ focus bàn phím khi tìm, giới hạn cỡ chữ chip camera. Kết quả: **9/9 PASSED**.

| Nhóm | Thời gian (31/10/2026) | Ca | Kết quả |
| --- | --- | --- | --- |
| 1 | 19:55–20:04 | U-05 J3; U-09 privacy (Hủy giữ zone bật; xác nhận tắt zone thì Hide vẫn bật, consent vẫn tắt) | PASSED, PASSED |
| 2 | 20:13–20:27 | U-07 J2; U-06 J4 (sau khi helper gõ phím chờ focus thật) | PASSED, PASSED |
| 3 | 20:28–20:37 | U-01, U-02, U-03, U-04, U-08 | 5/5 PASSED |

Lượt 19:32: U-09 riêng lẻ PASSED (sau khi đổi sang alert). Cùng lượt, J4 FAILED vì harness gõ khi ô chưa có focus; đã sửa helper, PASSED ở nhóm 2. Simulator chậm (mỗi ca 30–400 s) do máy tải cao/ổ đầy, không phải số đo hiệu năng app.

**Lượt bổ sung 01/11/2026**, chạy trên iPhone 18 Pro / iOS 27.0 simulator, load 1 phút 35–85. Lượt này chạy sau hai thay đổi: chế độ test xóa cả `test-inbox` (technical-spikes, “Lỗi phát hiện và đã sửa”), và `AppModel(arguments:)` cho Xcode Preview.
- 12:51–13:02: U-02 J1 và U-03 PASSED. U-07 J2 FAILED: liên kết thứ nhất đã lưu, nhưng lần bấm Lưu thứ hai bị trượt trong lúc hàng Lưu dịch lên vì banner cũ biến mất.
- Đã sửa test J2: chờ banner cũ mất rồi mới bấm; nếu bấm trượt thì bấm lại. Bấm lại không thể lưu trùng vì nút Lưu bị khóa khi ô đã trống.
- 13:04–13:10: U-07 J2 và U-05 J3 PASSED.
- Các ca U-01, U-04, U-06, U-08, U-09 chưa chạy lại sau hai thay đổi này. Cả hai thay đổi không đụng tới luồng của các ca đó.

**Sau khi sửa hai lỗi P1 (01/11/2026)**, iPhone 18 Pro / iOS 27.0 simulator:
- Lượt đầy đủ 13:46–13:59, load 1 phút 22–68: 8/10 PASSED (U-01, U-02, U-03, U-05, U-06, U-07, U-08, U-09); ScreenshotTour bỏ qua theo thiết kế.
  - U-04 FAILED vì app không khởi động: “does not have a process ID”, lúc load khoảng 62. Chạy lại 14:00–14:05 thì PASSED.
  - U-10 FAILED: dòng lý do nằm ở chân danh sách, khuất dưới mép màn chọn đang ở nửa màn hình. **Đây cũng là lỗi UX**, vì người dùng không thấy lý do.
- Đã đưa lý do lên đầu màn chọn, và cho test vuốt danh sách tới các dòng thủ công. 14:06–14:10: U-10 PASSED.
- Mã cuối: 10/10 ca đều đã PASSED ít nhất một lần, nhưng **không trong cùng một lượt**. 8 ca của lượt đầy đủ chạy trước khi dời dòng lý do; thay đổi đó chỉ chạm màn chọn địa điểm, nơi chỉ U-10 mở tới.

| ID | Test | Kiểm điều gì | Kết quả |
| --- | --- | --- | --- |
| U-10 | testManualPlaceStaysBlockedWhileZoneIsUncertain | Tắt Hide của ảnh khi vùng chưa xác nhận: màn xem lại có lý do; màn chọn có lý do ở đầu; dòng thủ công bị khóa; bấm vào không gắn nơi | PASSED (14:10) |

### 1.3c Một lượt đủ ba target, mã cuối (01/11/2026)

Lệnh: `xcodebuild -project Doday.xcodeproj -scheme DodayG2 -destination 'id=<iPhone 18 Pro simulator>' -derivedDataPath /tmp/doday-g2 CODE_SIGNING_ALLOWED=NO -collect-test-diagnostics never test` · iPhone 18 Pro / iOS 27.0 simulator, fixture · 14:26:52–14:38:09, load 1 phút 4–87 · exit 0, `** TEST SUCCEEDED **`. Mã giống lượt ở §1.1b và §1.3b sau khi sửa P1; lượt này không đổi mã, chỉ đổi tài liệu.

| Target | Kết quả |
| --- | --- |
| G2CoreTests | 29/29 PASSED |
| DodayG2Tests (AppModel) | 7/7 PASSED |
| DodayG2UITests | **10/10 PASSED trong cùng một lượt** (U-01…U-10); ScreenshotTour bỏ qua theo thiết kế |
| Proxy lab (`node --test spikes/g2/places-proxy/proxy.test.mjs`, Node 26.4.0, 14:38) | 5/5 PASSED |

Lượt này thay cho ghi chú “10/10 cộng dồn, không trong cùng một lượt” ở §1.3b. Vẫn là Simulator và fixture: **không** phải bằng chứng iPhone thật, Google live hay Q-17 (G2-DEC-14/15). Lint không chạy lại vì mã không đổi kể từ lần 0 lỗi trước đó.

### 1.4 Baseline target phát hành

| ID | Ca | Kết quả |
| --- | --- | --- |
| B-01 | `Doday` scheme `DodayTests` (1 test, dựng `ContentView`) trên simulator iPhone 17, 31/10/2026 ~17:04, sau sửa lint | **PASSED** (1/1, `TEST SUCCEEDED`). SwiftLint của target: 0 lỗi, 56 cảnh báo (đều trong mã G2) |
| B-01a | Cùng ca, lượt 16:4x trước sửa lint | **FAILED – build**: SwiftLint báo 25 lỗi trong mã G2 → G2 đã làm hỏng build target phát hành; đã sửa, xem B-01 |

## 2. Ca trên iPhone thật

Mọi ca dưới đây **chưa chạy**: không có iPhone kết nối và chưa có signing team/App Group. Mỗi ca khi chạy phải ghi: ngày, build/commit + dirty, model/iOS, mạng, live/fixture, bước, kết quả thực tế, trạng thái, file bằng chứng (đã làm sạch).

| ID | Ca | Bước tóm tắt | Trạng thái | Cần người dùng |
| --- | --- | --- | --- | --- |
| DEV-01 | AVFoundation chụp thật, đổi camera trước/sau, quyền từ chối/hạn chế, trở lại từ nền | Camera → cấp quyền → chụp sau/trước → nền/foreground → từ chối trong Cài đặt | NOT_RUN | iPhone + signing |
| DEV-02 | PhotosPicker: HEIC/JPEG có/không GPS, Options Location bật/tắt; ghi `hasGPS`/ngày chụp, **không ghi tọa độ** | Chọn 10 ảnh đã chuẩn bị → ghi bảng | NOT_RUN | iPhone + bộ ảnh thử |
| DEV-03 | Ảnh lớn/xoay qua pipeline: file giải mã vuông, giới hạn, không GPS | Chụp dọc/ngang → xuất file từ container → ImageIO | NOT_RUN | iPhone |
| DEV-04 | Kill app ngay sau chụp, mở lại; chế độ máy bay; 2 tài khoản mẫu | 20 chu kỳ chụp→kill→mở | NOT_RUN | iPhone |
| DEV-05 | Core Location: chính xác/gần đúng/từ chối/hạn chế; mẫu bị bỏ sau đánh giá | Review → Kiểm tra vị trí; Cài đặt iOS | NOT_RUN | iPhone |
| DEV-06 | S-PRIVLOC trên 2 máy/2 tài khoản: vùng thật do người thử đặt, inside/edge/outside; console/log không chứa tọa độ | ≥100 tình huống | NOT_RUN | 2 iPhone |
| DEV-07 | Google Maps SDK hiển thị bản đồ; traffic SDK tách riêng | Lab → Maps SDK | **BLOCKED** | Trần thử + khóa iOS (G2-DEC-10) |
| DEV-08 | Places Details + Search qua proxy live, Field Mask tối thiểu, photos/reviews theo lệnh | ≤50 tác vụ đếm trước | **BLOCKED** | Trần thử, Cloud project thử, khóa server, LEGAL |
| DEV-09 | Mở Google Maps bằng Maps URL với Place ID thật (không cần khóa) | Lab → nhập Place ID → Mở | NOT_RUN | iPhone |
| DEV-10 | Share từ TikTok: phiên bản app, `registeredTypeIdentifiers`, kiểu nhận, PENDING | ≥10 link công khai | **BLOCKED** | Signing + App Group |
| DEV-11 | Share từ Instagram (như DEV-10) | ≥10 link | **BLOCKED** | như trên |
| DEV-12 | Share từ Safari (như DEV-10) | ≥10 link | **BLOCKED** | như trên |
| DEV-13 | Extension: chưa đăng nhập, app chính chưa chạy, extension bị đóng giữa chừng, offline, link trùng | Ma trận 5 ca | **BLOCKED** | như trên |
| DEV-14 | Trace mạng thật: 0 Places/media/review do thao tác thụ động | ≥100 chuỗi; Instruments Network | NOT_RUN (cần live để có ý nghĩa với SDK) | iPhone |
| Q17 | Thử sử dụng ≥5 người | usability-report | NOT_RUN | Người thử + iPhone |

## 3. Probe kỹ thuật một lần

| ID | Ngày | Môi trường | Mục đích | Kết quả |
| --- | --- | --- | --- | --- |
| X-01 | 31/10/2026 | macOS 27.0, binary tự biên dịch | Kiểu trả về `NSItemProvider.loadItem` | NSURL `public.url` → UTF‑8; NSString → `public.utf8-plain-text` |
| X-02 | 31/10/2026 | Simulator iOS 27.0, `simctl spawn` | Như X-01 trên iOS | NSURL `public.url` → **binary plist**; `loadObject(URL)` đọc đúng |
| X-03 | 31/10/2026 | Simulator iOS 27.0, `simctl spawn`, mã `ShareInbox.swift` thật | Reader sau sửa | 4/4 đúng (NSURL, NSString, Data thô, không link → từ chối) |
| X-04 | 31/10/2026 | Mac | Quét bí mật/tọa độ trong file G2 | Không có khóa API, team ID, khóa riêng hoặc tọa độ thật |
| X-06 | 31/10/2026 21:1x | Mac, `generic/platform=iOS`, không ký | Build cho iPhone thật | Thành công, có extension; chưa ký/cài (chưa có team) |
| X-07 | 31/10/2026 21:1x | `xcodebuild -showBuildSettings` với file riêng tạm | Công tắc tài khoản miễn phí | Mặc định có App Group; khi đặt trống thì bỏ entitlement, bundle ID đổi được; file tạm đã xóa |
| X-05 | 31/10/2026 | Git | Baseline G1/target phát hành | `git diff` trên `docs/g1`, roadmap, `Sources/Doday`, `Tests/DodayTests` = chỉ 2 thay đổi có sẵn (ContentView, project.yml) |

## 4. Ảnh chụp simulator (UX, fixture)

Ảnh trong [screens/](screens/), thu nhỏ còn cạnh dài 900 px, chỉ chứa dữ liệu mẫu (không người, không vị trí thật). Tạo bằng `ScreenshotTour` (`TEST_RUNNER_G2_SCREENSHOTS=1`) trên simulator iPhone 17 / iOS 27.0. **Không phải bằng chứng máy thật hay thử sử dụng.**

| Bộ | Lượt | Ảnh | Ghi chú |
| --- | --- | --- | --- |
| Tiếng Việt, cỡ chữ mặc định | 31/10 20:06–20:08 (mã cuối) | `vi-default-01…07` | Onboarding, Camera chưa đăng nhập/đã đăng nhập, xem lại, chọn địa điểm, kết quả Map (bàn phím đã đóng), bottom sheet |
| Tiếng Việt, cỡ chữ mặc định | 31/10 19:33–19:37 | `vi-default-08…12` | Chi tiết theo yêu cầu, Nơi đã lưu, Chờ xử lý (banner), Profile, Khoảnh khắc của tôi. Mã trước hai bản sửa bàn phím/chip AX, các màn này không chịu ảnh hưởng |
| Tiếng Anh | 31/10 19:39–19:40 | `en-default-01, 03…05` | Bỏ ảnh 02 vì chụp đúng lúc chuyển cảnh |
| Tiếng Việt, Dynamic Type `accessibilityXL` | 31/10 20:10–20:12 (mã cuối) | `vi-AX-01…04` | Chip camera giới hạn ở `xxLarge`, không đè nội dung; phần còn lại theo cỡ chữ |

**Chưa có:** ảnh màn nhỏ 4,7″/iPhone 17e (lượt 17e treo khi khởi chạy runner ở 17:27 và bị dừng), Pro Max, Cài đặt/Lab, và tour đủ 14 bước ở tiếng Anh/AX. Tour dừng ở bước chờ phần tử (harness), không do app lỗi. Kiểm màn nhỏ/lớn và VoiceOver trên máy thật thuộc DEV/Q-17.
