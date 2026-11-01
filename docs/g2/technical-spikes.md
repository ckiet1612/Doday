# Doday G2 – Báo cáo thử kỹ thuật (spike)

Trạng thái: **APPROVED** (cùng G2, 01/11/2026) · Cập nhật 01/11/2026 · Môi trường đã chạy: Mac (macOS 27.0, Xcode 27.1 build 27A9275, XcodeGen 2.46.0, Node 26.4.0), simulator iPhone 17 / iOS 27.0. **Chưa chạy trên iPhone thật** vì máy không thấy thiết bị (`xcrun xctrace list devices` chỉ có Mac và simulator) và chưa có signing team.

Simulator, unit test, fixture và proxy lab **không** phải bằng chứng thực địa. Mọi ca cần máy thật ghi `BLOCKED`/`NOT_RUN` ở [evidence.md](evidence.md).

## 1. Tóm tắt

| Spike | Mã | Simulator / unit | iPhone thật | Trạng thái spike |
| --- | --- | --- | --- | --- |
| S1 Camera, PhotosUI, metadata, chuẩn hóa ảnh | `AppleAdapters.swift`, `G2Core/ImagePipeline.swift` | Unit đủ 8 hướng EXIF, crop giữa, ≤2048/≤400, không phóng lớn, bỏ GPS; camera simulator = “không có camera” | DEV-01/02/03 NOT_RUN | Simulator xong; máy thật miễn cho G2, chuyển G4 (G2-DEC-14) |
| S2 Lưu cục bộ | `G2Core/LocalStorage.swift`, `Lifecycle.swift` | Unit: nguồn trước, phục hồi sau mở lại, phân vùng tài khoản; UI: nháp còn sau khi tiến trình bị kết thúc | DEV-04 NOT_RUN | G2-DEC-02 APPROVED; DEV-04 chuyển G4 |
| S3 Vị trí / privacy gate / canary | `G2Core/Privacy.swift`, `Lifecycle.swift`, `AppModel.swift` | 192 tổ hợp canary + biên/sai số/tuổi/revision/kết quả muộn; mẫu canary trong Lab | DEV-05/06 NOT_RUN | Simulator xong; máy thật miễn cho G2, chuyển G4 (G2-DEC-14) |
| S4 Google Maps SDK, Details, Search, mở Google Maps | `PlacesAdapters.swift`, `G2Core/Triggers.swift` | Fixture có nhãn; Field Mask tối thiểu; Photos/review chỉ khi bấm | DEV-07/08 **BLOCKED** (live khóa, chưa có khóa/trần); DEV-09 Maps URL NOT_RUN | Live hoãn sang đầu G5 (G2-DEC-15); DEV-09 chuyển G6 |
| S5 Proxy Places Web Service | `spikes/g2/places-proxy/` | 5/5 test Node: deny-live, mask, reservation, retry, breaker | – | Fixture PASS; live hoãn sang đầu G5 (G2-DEC-15) |
| S6 Share Extension | `DodayG2ShareExtension/`, `G2Core/ShareInbox.swift` | Unit với `NSItemProvider` thật trong tiến trình test (NSURL, NSString, Data thô); inbox có chủ/epoch, chống trùng | DEV-10…13 BLOCKED (signing/App Group) | Simulator xong; máy thật miễn cho G2, chuyển G8 (G2-DEC-14) |
| S7 Trace thụ động (QP-02) | `Triggers.swift`, `PlacesLab` | 100 chuỗi × 7 sự kiện thụ động → 0 request; bộ đếm thụ động trong Lab | DEV-14 NOT_RUN | Unit xong; trace mạng thật chuyển G4 (G2-DEC-14) |

## 2. Cấu trúc và cách chạy

| Target (project-g2.yml) | Loại | Ghi chú |
| --- | --- | --- |
| `G2Core` | framework | Logic thuần, `APPLICATION_EXTENSION_API_ONLY`. Dùng chung cho app và extension |
| `DodayG2` | app `com.ckiet1612.doday.g2` | Prototype + Lab. iPhone family `1`. Tên hiển thị “Doday G2” |
| `DodayG2ShareExtension` | share extension | Chỉ ghi inbox có chủ |
| `G2CoreTests`, `DodayG2UITests` | test | Scheme `G2CoreTests`, `DodayG2` |

Target `Doday`, `project.yml` và hai thay đổi chưa commit có sẵn (`ContentView.swift`, `project.yml` iOS 17) **không bị sửa**. `project-g2.yml` dùng `include: project.yml`, nên `xcodegen generate --spec project-g2.yml` sinh một `Doday.xcodeproj` (đã nằm trong `.gitignore`) chứa cả hai bộ target.

```sh
xcodegen generate --spec project-g2.yml
xcodebuild -project Doday.xcodeproj -scheme G2CoreTests -destination 'platform=iOS Simulator,name=iPhone 17' \
  -derivedDataPath /tmp/doday-g2 CODE_SIGNING_ALLOWED=NO -collect-test-diagnostics never test
xcodebuild -project Doday.xcodeproj -scheme DodayG2 -destination 'platform=iOS Simulator,name=iPhone 17' \
  -derivedDataPath /tmp/doday-g2 CODE_SIGNING_ALLOWED=NO -only-testing:DodayG2UITests -collect-test-diagnostics never test
node --test spikes/g2/places-proxy/*.test.mjs
```

**Apple ID miễn phí (Personal Team), xác nhận 31/10/2026:** bảng *Supported capabilities (iOS)* của Apple ghi App Groups có cho cột “Apple Developer” (miễn phí). Prototype vì vậy giữ App Group mặc định. Nếu Xcode vẫn báo team không hỗ trợ App Groups, đặt `G2_APP_ENTITLEMENTS =` và `G2_SHARE_ENTITLEMENTS =` (trống) trong `Config/G2.private.xcconfig`. App vẫn chạy đủ; Share Extension khi đó chỉ hiện kiểu dữ liệu nhận được, không lưu link, và DEV-10…13 phần lưu PENDING vẫn BLOCKED. Bundle ID đổi được bằng `G2_BUNDLE_ID`. Giới hạn của tài khoản miễn phí: bản cài hết hạn sau 7 ngày (cài lại từ Xcode), cần bật Developer Mode, không có TestFlight. Vì vậy Q-17 phải chạy trên iPhone cắm vào Mac này. Đã kiểm: build `generic/platform=iOS` (không ký) thành công, có `DodayG2ShareExtension.appex`.

**Chạy trên iPhone thật (cần Chủ dự án):** chép `Config/G2.private.xcconfig.example` thành `Config/G2.private.xcconfig` (git-ignored), điền `DEVELOPMENT_TEAM`. Đăng ký App Group `group.com.ckiet1612.doday.g2` cho app và extension. Mở `Doday.xcodeproj` → scheme `DodayG2` → chọn iPhone → Run, hoặc dùng `xcodebuild … -destination 'platform=iOS,name=<tên máy>' -allowProvisioningUpdates`. Không điền khóa Google: **đặt khóa không mở live**, vì `PlacesLab.liveAuthorized` là hằng `false` trong mã.

Lab mở từ Profile → “Thử kỹ thuật”. Ở đó có chọn tình huống fixture, vùng/mẫu canary, ảnh thư viện mẫu B3, trace và số đo sơ bộ.

## S1. Camera, PhotosUI và ảnh

**Đã làm.** `CameraEngine` dùng `AVCaptureSession` preset photo, `AVCapturePhotoOutput` JPEG, có đổi camera trước/sau. Session tự chạy khi đã có quyền, dừng khi rời Camera hoặc app vào nền, khôi phục khi quay lại (để chuẩn bị đo Q-02). Quyền `notDetermined` chỉ hỏi khi người dùng chạm “Bật camera”. Quyền bị từ chối/hạn chế có màn giải thích; vẫn chọn ảnh thư viện và mở Map được. `PhotosPicker(matching: .images, preferredItemEncoding: .current)` + `Transferable` dùng `FileRepresentation` để lấy **byte file gốc**, không dùng `UIImage` (UIImage làm mất metadata). Không có API `PHPhotoLibrary`, không xin quyền thư viện.

**Pipeline (`ImagePipeline.process`).** Kiểm ≤20 MB, ≤100 MP → `CGImageSourceCreateThumbnailAtIndex` với `…WithTransform` (chuẩn hóa EXIF orientation) → cắt giữa vuông → bản chính `min(cạnh, 2048)`, thumbnail `min(cạnh, 400)`, không phóng lớn → mã hóa mới JPEG 0,85, `Orientation = 1`, **không chép metadata nguồn** nên GPS/EXIF bị bỏ. JPEG 0,85 chỉ là đầu dò, **codec/byte cuối thuộc G4 (B3)**.

**Bằng chứng unit (simulator):** 8 hướng EXIF × 2 đầu ra đều vuông và trong giới hạn, không còn `{GPS}`. Ảnh 80×60 ra 60×60 (không phóng lớn). Byte hỏng thì báo lỗi. So pixel bốn góc với tham chiếu UIKit độc lập đúng cho cả 8 hướng. `inspect` đọc được có/không GPS, `HPositioningError`, `DateTimeOriginal`, và đầu ra không còn ngày chụp.

**Nguồn metadata picker (đối chiếu 31/10/2026):** WWDC23 “Embed the Photos Picker in your app”: picker mặc định gồm toàn bộ metadata, nhưng từ iOS 17 người dùng có thể bỏ vị trí trong menu Options; không cần quyền thư viện. WWDC20 10652: picker chạy ngoài tiến trình. Nghĩa là **ảnh có thể đến mà không có GPS dù gốc có**. Prototype xử lý như “Ảnh không có GPS đọc được” và không thay bằng GPS hiện tại.

**Còn thiếu trên máy thật:** DEV-01 chụp thật trước/sau + đổi camera. DEV-02 chọn ảnh HEIC/JPEG có/không GPS, ghi `hasGPS` cho từng trường hợp “Options → Location” bật/tắt, **không ghi tọa độ**. DEV-03 ảnh lớn/xoay, kiểm file giải mã. Camera trên simulator báo “Không có camera khả dụng”; nút “Chụp ảnh mẫu” chỉ hiện khi không có camera.

## S2. Lưu cục bộ

| Phương án | Ưu điểm | Nhược điểm | Kết luận |
| --- | --- | --- | --- |
| SwiftData (iOS 17) + file ảnh | Có sẵn, khớp DEC-04, schema Swift, `ModelConfiguration(url:)` tách store theo tài khoản, lưu tường minh | Migration và đồng thời đa tiến trình cần thận trọng; không chứa blob ảnh | **Đề xuất** cho bản ghi nháp |
| Core Data + file | Trưởng thành, migration rõ | Nhiều boilerplate; SwiftData đã chạy trên Core Data | Dự phòng nếu SwiftData lỗi ở G4 |
| SQLite trực tiếp / thư viện ngoài | Kiểm soát tối đa | Thêm dependency, không cần ở G2 | Không chọn |
| Chỉ JSON nguyên tử | Đơn giản, dễ đọc chéo tiến trình | Không truy vấn/sắp xếp tốt khi nhiều Moment | Dùng cho policy, SavedIntent và inbox (nhỏ) |

**Bố cục (`Application Support/G2-Lab/<SHA-256(accountID)>/`):** `<id>.source` (ảnh gốc, chỉ tại máy), `drafts.store` (SwiftData), `<id>.main.jpg`/`<id>.thumb.jpg`, `privacy.json` (Hide mặc định, công tắc zone, danh sách zone, consent, revision), `saved-intents.json`. Inbox Share ở App Group: `share-inbox/inbox.json`, dùng `NSFileCoordinator` để kiểm chủ/chống trùng/ghi trong một giao dịch. Mọi file ghi `.atomic` + `completeFileProtectionUnlessOpen`, đặt `isExcludedFromBackup` để zone/ảnh gốc không vào iCloud backup (DEC-31).

**Thứ tự bền vững (BR-M11/A5):** ghi file nguồn → insert + `save()` bản ghi `sourceSaved` → **sau đó** xử lý phái sinh trên tác vụ nền → `localReady` hoặc `processingFailed`. Lỗi xử lý không xóa nguồn, giữ cùng ID để thử lại. Khi mở store, file `.source` chưa có bản ghi được nhận lại thành nháp `recovered`, không tạo trùng. GPS không được ghi vào bản ghi; chỉ có trong file gốc tại máy, như G1 cho phép.

**“Đã lưu trên máy” ≠ “Đã đồng bộ”.** G2 không có backend, nên UI luôn ghi “Đã lưu trên máy · chưa đồng bộ”. Không có trạng thái “Đã đồng bộ”.

**Bằng chứng:** unit `testSourceAndDraftRecoverAfterReopeningAndAreAccountPartitioned`, `testProcessingFailureKeepsOriginalAndSameDraftIDForRetry`, `testCurrentHideDoesNotReopenAnOldPlace…`; UI `testDraftSurvivesTerminatedProcess` (simulator, terminate + launch lại với `--g2-keep-data`). Chưa đo Q-03/Q-04 và chưa thử kill khi đang ghi trên máy thật (DEV-04).

## S3. Vị trí, privacy gate và canary

**Core Location.** `LocationEngine` xin `WhenInUse` theo lệnh người dùng, mỗi lần chỉ `requestLocation()` một mẫu, không theo dõi nền. Mẫu ghi `accuracy`, `ageAtReceipt`, `receivedAtUptime`, `precise` (`accuracyAuthorization`), `accountID`. `RecognitionVault` giữ mẫu tối đa 60 giây theo đồng hồ uptime. App gọi `discard()` ngay sau khi đánh giá, khi đổi revision, khi vào nền và khi đổi tài khoản. Mẫu không ghi xuống đĩa/log; trace Lab chỉ ghi tên sự kiện và số trường.

**PrivacyGate.evaluate (fail-closed, theo thứ tự):** Hide → consent nhận diện → có mẫu → đúng tài khoản → tuổi trong RAM <60 s → chính xác, 0…50 m, `ageAtReceipt + elapsed ≤ 60 s` → nếu bảo vệ zone bật: danh sách đã xác nhận, radius 100–1.000 m, `d ≤ r` → INSIDE, `d − accuracy ≤ r` → UNCERTAIN → mới `allowed`. `RecognitionTicket` buộc kết quả đến muộn phải cùng tài khoản/revision và gate vẫn cho phép **tại thời điểm nhận** (A4). Retry không reset hạn 60 s.

**Ba nhánh gắn nơi.** `AssignmentPolicy.decide` trả `unassigned` nếu không có `Calibration` đã khóa. App **không truyền calibration thật**, nên mọi mẫu thật chỉ dừng ở “Đủ điều kiện, nhưng chưa có ngưỡng đã hiệu chỉnh”. Nhánh tự gắn/xác nhận/không ngữ cảnh chỉ minh họa trong “Nhận diện mẫu”, và chỉ chạy sau khi gate cho phép.

**Canary harness.** Unit: 2 tài khoản × Hide × consent × zone × 3 vị trí (tâm/mép vòng sai số/ngoài) × 2 sai số × precise/gần đúng = **192 tổ hợp**. Riêng: biên 59/60/61 s, NaN/âm/>50 m, sai tài khoản, zone chưa xác nhận, radius 99 m, revision/Hide/đổi tài khoản làm vé muộn mất hiệu lực, B3 bị chặn bởi Hide/zone. Lab: vùng canary 0,0 + 5 mẫu giả (ngoài/tâm/mép/gần đúng/cũ) đi qua đúng đường `received()` của app. Tọa độ canary quanh 0,0 (vịnh Guinea), không phải vị trí của ai.

**Còn thiếu:** DEV-05 quyền chính xác/gần đúng/từ chối/hạn chế trên máy thật. DEV-06 hai máy/hai tài khoản theo S-PRIVLOC. Mọi thiết lập này **không** chứng minh vị trí thật ở ngoài vùng; heuristic là bảo thủ.

## S4. Google Maps SDK, Places Details/Search và Maps URL

**Phụ thuộc:** `GoogleMaps` 11.2.0 qua SPM (`exactVersion`), chỉ liên kết vào `DodayG2`. Không thêm Places SDK for iOS để tránh đường gọi Places bỏ qua proxy (COST). `LiveGoogleMapProbe` chỉ gọi `GMSServices.provideAPIKey` khi `PlacesLab.liveAuthorized == true`. Hằng này đang là `false`, nên SDK **không khởi tạo** và không có traffic SDK.

**Adapter.** `PlacesLab.search/nearby/record` là fixture có nhãn “Doday · synthetic”, debounce 400 ms, ≥2 ký tự, hủy tác vụ cũ. `lockedProxyRequest` là đường live duy nhất: HTTPS tới proxy, token riêng, không có khóa Web Service trong app, và bị chặn trước bởi `liveAuthorized`. **Đường live chưa được tích hợp:** chưa luồng Search/Details/Photos/Reviews nào gọi `lockedProxyRequest`; tất cả chỉ chạy fixture. Dù có khóa và trần chi, app vẫn chưa gọi được Google.

**Field Mask tối thiểu (`TriggerPolicy`) và SKU theo docs Place Details (New), cập nhật 30/10/2026:**

| Lệnh người dùng | Field mask | SKU cao nhất |
| --- | --- | --- |
| Tìm (Text Search) | `places.id, places.displayName, places.location, places.businessStatus, places.attributions` | Pro (displayName/businessStatus). Chưa tối ưu Essentials, TL chốt ở G6 |
| Gần tôi (Nearby) | như trên, chỉ sau gate | Pro |
| Xem chi tiết | `id, displayName, formattedAddress, location, businessStatus, attributions, movedPlace, movedPlaceId` | Pro |
| Xem ảnh | `id, photos, attributions` rồi media theo ảnh | Essentials IDs Only + Photo media |
| Xem từng đánh giá | `id, reviews, attributions` | Enterprise + Atmosphere |
| Mở app/camera/chụp/lưu/mở Map/pan/zoom | **không có request** | – |

Giờ mở cửa và rating (`regularOpeningHours`, `rating`, `userRatingCount`) là Enterprise. Prototype hiện giá trị fixture trong khối chi tiết để thử UX J4. Nếu UX được duyệt, mask khối chi tiết phải thêm đúng các trường này, và ngân sách/forecast B7 phải tính lại. **Chưa thêm vào mã** để không mở rộng chi phí khi chưa duyệt.

**Fallback (DEC-29).** Tình huống “Hết quyền dùng trường”: không marker, không tên Google, chỉ hiện nhãn của người dùng hoặc “Địa điểm đã lưu” cùng Place ID. Không tự gọi Places khi mở Map. Offline/lỗi/quota: “Không cập nhật được thông tin lúc này”, **không hiện trạng thái cũ như hiện tại**, chỉ đường vẫn dùng được. Đóng cửa vĩnh viễn: cảnh báo đỏ, giữ bản lưu.

**Maps URL.** `MapLinks.directions` tạo `https://www.google.com/maps/dir/?api=1&destination=…&destination_place_id=…`, **không có `origin`**. Docs Maps URLs (30/10/2026): không cần khóa API; thiếu origin thì Google tự chọn điểm xuất phát (vị trí thiết bị nếu có quyền của chính Google Maps). Với Place ID fixture, app không mở để tránh chỉ đường sai. Lab cho nhập Place ID thật để thử DEV-09.

## S5. Proxy Places Web Service (lab)

`spikes/g2/places-proxy/proxy.mjs`, chỉ dùng thư viện có sẵn của Node, nghe `127.0.0.1`:

- `/live/*` luôn trả **423 LIVE_LOCKED**, mọi cờ/khóa client gửi lên đều bị bỏ qua.
- `/fixture/<event>` chỉ nhận `search|details|photos|reviews` với mask cố định; sự kiện thụ động trả 400; body >4 KB trả 413; body có `latitude/longitude/location/locationBias/coordinates` trả 400 `NO_COORDINATES`.
- `reserve()` giữ chỗ nguyên tử bằng lock file + ghi tạm + `rename`, không hoàn trả, tranh chấp thì từ chối. `retry` tối đa 2 lần (400/800 ms), không retry lỗi vĩnh viễn/hủy. `Breaker`: 5 lỗi/60 s → mở 60 s → 1 probe.
- Test: 5/5 PASS (evidence P-01…05).
- **Mới là khối dựng sẵn, chưa phải đường gọi:** server lab chưa dùng `reserve`, `retry` hay `Breaker` trong handler nào. Đường `/live/*` chỉ trả 423, chưa có mã gọi Places API (New). Test P-03…05 kiểm từng hàm riêng lẻ, không kiểm một lần gọi thật.

**Điều kiện trước khi được bật live (chưa đủ):** (1) Chủ dự án duyệt trần thử bằng văn bản, ví dụ ≤5 USD/đợt (G2-DEC-10). (2) Google Cloud project thử riêng: chỉ bật Places API (New) + Maps SDK for iOS, quota/ngày đặt sát trần, budget alert. (3) Khóa server chỉ ở máy chạy proxy, nhập qua cơ chế bí mật riêng, không qua chat/Git. Khóa iOS giới hạn bundle ID. (4) Proxy live thêm: allowlist mask như trên, reservation trước **mỗi** attempt kể cả retry, tôn trọng `Retry-After`, log không body/tọa độ. (5) Kịch bản thử ≤50 tác vụ đếm trước. (6) **Viết đường live**, phải được duyệt riêng:
- Nối adapter của app tới proxy cho Search, Details, Photos và Reviews.
- Thêm handler live trong proxy gọi Places API (New) với mask đã allowlist.
- Đặt reservation, retry và breaker trên chính đường gọi đó.
- Có test tích hợp với một Google giả lập trước khi bật.

Chỉ cấp khóa và duyệt trần chi **chưa đủ** để chạy DEV-07/08. Thiếu điều kiện nào thì giữ live **BLOCKED**.

## S6. Share Extension

`Config/G2Share-Info.plist`: `com.apple.share-services`, `NSExtensionActivationSupportsWebURLWithMaxCount = 1`, `NSExtensionActivationSupportsText = YES`. Extension và app dùng App Group `group.com.ckiet1612.doday.g2`.

**Luồng.** Mở inbox → không có chủ thì báo “Chưa có tài khoản… chưa lưu liên kết” và **không ghi gì**. Có chủ thì đọc provider → hiện **chỉ các kiểu dữ liệu** nhận được → người dùng chạm “Lưu liên kết · PENDING” → giao dịch kiểm chủ + epoch, chuẩn hóa HTTPS (bỏ `utm_*`, fragment, chặn user/password/port/localhost/.local) và chống trùng theo tài khoản → “Đã lưu trên máy · PENDING” hoặc “Đã có trong Doday” → đóng sau 0,9 s (bản ghi đã bền vững trước đó). Không fetch trang, không đọc metadata TikTok/Instagram, không mở app chính bằng mẹo. App chính hiện link ở “Chờ xử lý” (Map/Saved có badge). Người dùng chọn địa điểm thì tạo SavedIntent “Muốn ghé” và gỡ PENDING.

**Phát hiện kỹ thuật (31/10/2026, simulator iOS 27.0 và macOS 27.0):** cùng `NSItemProvider(object: NSURL)`, iOS trả `public.url` dưới dạng **binary plist**, còn macOS trả chuỗi UTF‑8. `NSString` đăng ký `public.utf8-plain-text`. Provider tự đăng ký `public.url` có thể trả byte UTF‑8 thô. `ItemProviderReader` vì vậy thử `loadObject(URL)` trước, rồi `loadItem` cho URL/văn bản, với `Data` thì giải plist → UTF‑8 → `URL(dataRepresentation:)`. Thứ tự UTF‑8 trước là bắt buộc, vì `URL(dataRepresentation:)` sẽ escape văn bản kèm link và làm mất link. Đây là dữ liệu tự tạo, **chưa phải** kiểu dữ liệu thật từ TikTok/Instagram.

**Ma trận phải ghi trên máy thật (DEV-10…13):** nguồn (TikTok, Instagram, Safari) × phiên bản app nguồn × `registeredTypeIdentifiers` × kiểu đã nhận × kết quả (PENDING/trùng/từ chối). Thêm các ca: chưa đăng nhập, app chính chưa chạy, extension bị đóng giữa chừng, chế độ máy bay. Không ghi URL thật vào evidence; chỉ ghi host và kiểu.

## S7. Trace thụ động (QP-02)

`TriggerPolicy.request(for:)` trả `nil` cho `appOpen, cameraOpen, capture, save, mapOpen, pan, zoom`. `PlacesLab.passive()` có `precondition` để không sự kiện thụ động nào có descriptor. Lab hiện số sự kiện thụ động và luôn 0 request từ chúng, tách riêng “Maps SDK: chưa khởi tạo”. Unit 100 chuỗi × 7 sự kiện → 0 request. Proxy từ chối `/fixture/pan`. Còn thiếu trace mạng thật trên máy (DEV-14, ví dụ qua Instruments Network/Charles), cần làm khi live được duyệt, để tách traffic SDK khỏi Places.

## B6. Nguồn – trường – quyền – TTL – attribution – fallback

**Trạng thái: APPROVED (LEGAL) cho L-1…L-9** — Chủ dự án (kiêm LEGAL), thread G2, 01/11/2026: “Xác nhận B6: L-1 -> L-9” (G2-DEC-11). Phạm vi chỉ gồm chín mục bên dưới; không mở Google live và không cho đọc metadata. Bảng là điều kiện kỹ thuật, không phải ý kiến pháp lý. Nguồn: Places API Policies (cập nhật 30/10/2026), docs Place Details (30/10/2026), Service Specific Terms bản “Last modified 28/10/2026”, tải lại đầy đủ ngày 01/11/2026.

| Nguồn / trường | Dùng ở | Được lưu? (điều kiện) | TTL đề xuất | Attribution | Fallback khi hết quyền/lỗi |
| --- | --- | --- | --- | --- | --- |
| Google Place ID | SavedIntent, Moment | Có, lâu dài (ngoại lệ trong Policies) | Không hạn; đối soát GGL-06 khi không còn hợp lệ | – | Giữ bản lưu, đánh dấu cần đối soát |
| Google `location` | Marker | Ngoại lệ tạm ≤30 ngày liên tiếp rồi xóa (G1 §14.3) | ≤30 ngày, purge (L-2) | Logo/“Google Maps” khi không có bản đồ Google | Không marker; danh sách + Place ID |
| `displayName`, `formattedAddress`, `businessStatus` | Sheet/chi tiết | **Không** (chỉ trong RAM khi đang xem) | Phiên xem | Có | Nhãn người dùng/“Địa điểm đã lưu”; status “chưa xác định” |
| Giờ, rating, số lượt | Chi tiết | Không | Phiên xem | Có | “Không cập nhật được thông tin lúc này” |
| `photos` (name) + media | Khối ảnh khi bấm | Không cache photo name/media | Không | Tác giả + liên kết nguồn bắt buộc | Khối ảnh báo lỗi, phần khác vẫn dùng |
| `reviews` | Khối review khi bấm | Không | Không | Tác giả (avatar/tên/liên kết), ghi cách sắp xếp; FR cần tháng/năm | Khối review báo lỗi |
| `movedPlaceId` | Banner đã chuyển | Chỉ lưu Place ID mới khi người dùng chọn lưu | – | – | Chỉ báo đóng cửa nếu thiếu |
| URL TikTok/Instagram/Safari | Inbox PENDING | Có, của chủ tài khoản, URL chuẩn hóa | Không tự hết hạn (A12) | – | Giữ PENDING, chọn nơi thủ công |
| Metadata trang TikTok/Instagram (tiêu đề, ảnh, vị trí) | – | **Không lấy** | – | – | – |

**Danh sách LEGAL xác nhận (L-1…L-9).** Trích dẫn tóm lược từ nguồn chính thức tải ngày 01/11/2026; người xác nhận đọc bản gốc:

| Mục | Doday 1.0 làm gì | Căn cứ cần đối chiếu |
| --- | --- | --- |
| L-1 | Lưu Google Place ID lâu dài trong SavedIntent/Moment | SST §3 “Google ID Caching” (cho cache `place_id` từ Places API); Policies: place ID “exempt from the caching restrictions” |
| L-2 | Tọa độ `location` của Place chỉ lưu tạm ≤30 ngày liên tiếp rồi xóa tự động | SST §14.3 |
| L-3 | Tên, địa chỉ, `businessStatus`, giờ, rating chỉ giữ trong RAM khi đang xem, không lưu | Policies: không pre-fetch/cache/store nội dung ngoài ngoại lệ |
| L-4 | Ảnh và review Google tải khi bấm, không cache; luôn hiện tác giả (avatar, tên, liên kết) | Policies, mục “Photos and reviews” |
| L-5 | Hiện logo Google Maps (chật thì chữ “Google Maps”) khi nội dung Places không nằm trên bản đồ Google. Marker Places chỉ vẽ trên bản đồ Google; bản đồ vẽ tay trong prototype chỉ dùng cho fixture | Policies (logo/attribution); SST §14.1/14.2 (cấm dùng với bản đồ không phải Google) |
| L-6 | Share Sheet chỉ lưu URL/văn bản người dùng chia sẻ; 1.0 không fetch trang, không đọc metadata TikTok/Instagram. Muốn đọc metadata sau này phải xác minh điều khoản từng nguồn trước | DEC-21/A13 |
| L-7 | Loại hợp đồng/billing Google Maps Platform áp dụng (bản thường hay bản EEA tùy địa chỉ thanh toán), gắn với pháp nhân DEC-19 | Google Maps Platform Terms; Policies, mục EEA |
| L-8 | Trước phát hành (không phải G2): app có Terms of Use và Privacy Policy công khai, dẫn Google Terms of Service và Google Privacy Policy | Policies (yêu cầu chung) |
| L-9 | Quy tắc lọc business status dưới đây (vai trò TL, không phải LEGAL) | – |

Trả lời mẫu: “Xác nhận B6: L-1…L-9” hoặc ghi mục nào không đồng ý. Mục không được xác nhận thì giữ khóa phần tương ứng.

**Điều kiện mở khóa:** đã được xác nhận qua L-1…L-9 ngày 01/11/2026. Cơ chế purge (DEC-29), attribution và Terms/Privacy công khai vẫn phải được làm và kiểm ở cổng sau. Điều khoản TikTok/Instagram về đọc metadata công khai phải được xác minh theo từng nguồn (DEC-21/A13). Không suy một ngoại lệ (Place ID, tọa độ) sang trường khác.

**Lọc business status hợp lệ (L-9):** chỉ dùng `businessStatus` từ response **trong phiên xem**. `OPERATIONAL` không gắn nhãn. `CLOSED_TEMPORARILY` → cảnh báo vàng. `CLOSED_PERMANENTLY` → cảnh báo đỏ, giữ bản lưu, có `movedPlaceId` thì banner chuyển. Thiếu/không nhận diện được → “chưa xác định”, không suy là mở. Kết quả tìm kiếm/Nearby không loại nơi đóng cửa khỏi bản lưu đã có; ẩn nơi `CLOSED_PERMANENTLY` khỏi danh sách ứng viên **nhận diện** tự động (APPROVED qua L-9, 01/11/2026).

## Nguồn chính thức đã đối chiếu (31/10/2026)

| Nguồn | Phiên bản / ngày trên trang | Điểm dùng |
| --- | --- | --- |
| Maps SDK for iOS release notes – developers.google.com/maps/documentation/ios-sdk/release-notes | 11.2.0, phát hành 24/09/2026; tối thiểu iOS 16 từ 10.0.0; SPM được khuyến nghị, CocoaPods ngừng từ 11.0.0 | Pin `exactVersion: 11.2.0` |
| Place Details (New) – …/places/web-service/place-details | Cập nhật 30/10/2026 | Field mask bắt buộc, không khuyến khích `*`; SKU theo trường |
| Places API Policies – …/places/web-service/policies | Cập nhật 30/10/2026 | Place ID lưu được; nội dung khác không pre-fetch/cache; logo Google khi không có bản đồ Google; attribution tác giả ảnh/review |
| Maps URLs – …/maps/documentation/urls/get-started | Cập nhật 30/10/2026 | Không cần khóa; `destination_place_id`; origin tùy chọn |
| GMP Service Specific Terms – cloud.google.com/maps-platform/terms/maps-service-terms | “Last modified 28/10/2026”. Lần tải 31/10 bị cắt; tải lại đầy đủ 01/11/2026 | §3 cache Google ID; §14.1–14.3 Places: dùng không cần bản đồ, cấm bản đồ không phải Google, tọa độ ≤30 ngày |
| WWDC23 10107 “Embed the Photos Picker in your app”; WWDC20 10652 “Meet the new Photos picker” | Phiên WWDC | Picker không cần quyền thư viện, chạy ngoài tiến trình; người dùng có thể bỏ vị trí (iOS 17+) |
| Apple NSExtensionActivationRule | Trang JS, không đọc được nội dung | Khóa `…SupportsWebURLWithMaxCount`, `…SupportsText` dùng theo tài liệu chuẩn; kiểm trên máy thật |

## Lỗi phát hiện và đã sửa trong G2

| Lỗi | Phát hiện bởi | Sửa |
| --- | --- | --- |
| `public.url` của NSURL trên iOS là binary plist, reader cũ báo `invalidURL` | Unit C-13 + probe X-02 | `loadObject(URL)` trước; giải plist/UTF‑8 trước `URL(dataRepresentation:)` |
| Cảnh báo B3 cũ so GPS ảnh với **vị trí hiện tại** | Rà soát với backlog MVP-06 E1 | So với tọa độ Place được gắn; logic vào `G2Core.LibraryPlaceCheck` + unit C-15 |
| Alert thông báo ở màn gốc làm đóng sheet “Chờ xử lý” | UI test J2 | Banner trong sheet; alert lỗi chỉ ở lớp trên cùng (`g2ErrorAlert`) |
| Kết quả gate `allowed` tồn tại quá 60 s sau khi mẫu bị hủy | Rà soát A4 | `liveGate` hết hiệu lực sau 60 s |
| Nút kết quả Map mất định danh accessibility (`.combine` trong label của Button) | UI test J3 | Bỏ `.combine`, ẩn chevron khỏi VoiceOver |
| Chưa có Hide một chạm trên Camera (addendum §3.1) | Rà soát addendum | Chip “Ảnh sắp chụp” (G2-DEC-06) |
| Mô tả quyền vị trí thiếu mục đích “Gần tôi”/gợi ý địa điểm | Rà soát | Sửa `InfoPlist.strings` vi/en và `project-g2.yml` |
| Trên iOS mới, `confirmationDialog` thành popover và ẩn nút role `.cancel`: tắt zone không có Hủy; “Giữ bản lưu hiện tại” (movedPlace) bị ẩn | UI test privacy | Tắt zone dùng `alert` có Hủy; movedPlace bỏ role cancel |
| Sau khi tìm trên Map, bàn phím vẫn mở và che danh sách kết quả | Soát ảnh simulator 06 | `FocusState`: bỏ focus khi tìm |
| Dynamic Type AX: chip “Ảnh sắp chụp” dãn 3 dòng, đè lên nội dung giữa khung camera | Soát ảnh AX 02/03 | Giới hạn cỡ chữ lớp phủ camera ở `xxLarge`; phần còn lại vẫn theo Dynamic Type |
| Nhãn thanh trên “G2 · FIXTURE” bị cắt trong nút tròn kiểu iOS mới | Soát ảnh | Rút gọn “G2”, accessibility label vẫn đủ |
| **Target phát hành `Doday` không build được**: script SwiftLint của target này quét toàn bộ `Sources`/`Tests` theo `.swiftlint.yml`, gặp 25 lỗi trong mã G2 (dòng >200, tên biến 1 ký tự, force cast) | Chạy baseline B-01 | `swiftformat` theo `.swiftformat` có sẵn + sửa tay; lint còn **0 lỗi**. Không sửa `.swiftlint.yml` hay target `Doday` |
| Chế độ test chỉ xóa thư mục riêng của app, không xóa hộp liên kết mẫu `test-inbox`. Khi có App Group (bản đã ký, Xcode Preview), hộp này nằm trong App Group nên liên kết của lần chạy trước còn sót lại. Trên iPhone thật, UI test J2 vì thế có thể lúc đạt lúc không | Soát ảnh Xcode Preview ngày 01/11/2026: preview Hồ sơ hiện “Liên kết đang chờ (1)” sau preview Chờ xử lý | Khi reset dữ liệu test thì xóa luôn `test-inbox`. Hộp thật `share-inbox` không bị đụng tới |
| **[P1] Chọn Place thủ công vượt được bảo vệ vùng.** `attach()` chỉ kiểm Hide. Ảnh đã tắt Hide nhưng ở trong vùng, hoặc chưa chắc ở ngoài vùng, vẫn gắn được nơi. Màn xem lại còn ghi “Bạn vẫn có thể tự chọn nơi”, trái addendum §3.2 / DEC-31 | Review tĩnh, 01/11/2026 | `G2Core.ZoneStatus` là phép phân loại dùng chung cho gate, B3 và việc gắn Place. `attach()` là điểm chặn duy nhất: Hide hoặc vùng `inside`/`uncertain` thắng mọi lựa chọn. Ảnh thư viện xét theo GPS của chính ảnh. Ảnh chụp chỉ xét theo mẫu vị trí trong 60 giây sau khi chụp, và verdict mất khi policy đổi revision. Màn chọn khóa các dòng thủ công và nêu lý do. Test: unit `ZoneStatus`, `AppModelTests` (4 ca), UI `testManualPlaceStaysBlockedWhileZoneIsUncertain` |
| **[P1] Ảnh đang nhập có thể lưu nhầm tài khoản.** Tác vụ PhotosPicker gọi `capture()` sau `await`, lúc đó đã dùng kho của tài khoản mới | Review tĩnh, 01/11/2026 | `AppModel.importPhoto` gắn mỗi lần nhập với phiên (chủ + epoch) và token. Đổi tài khoản hoặc đăng xuất thì hủy; kết quả về muộn bị bỏ, kể cả khi trình tải không dừng khi bị hủy. Test: `AppModelTests` (đổi tài khoản, đăng xuất, cùng phiên) |

## Giới hạn đã biết

| Giới hạn | Tác động | Người xử lý | Cổng |
| --- | --- | --- | --- |
| Chưa có iPhone/signing/App Group | Mọi spike S1/S3/S6 chưa có bằng chứng thực địa | Chủ dự án cấp máy + team | Trước trình G2 |
| Live Google khóa **và chưa tích hợp** (adapter chưa nối proxy; proxy chưa có handler live) | Không chứng minh được Maps SDK, Details, Search thật. Có khóa và ngân sách vẫn phải làm thêm điều kiện (6) ở §S5 | Chủ dự án (trần thử), TL | Trước trình G2 |
| `isExcludedFromBackup` cho ảnh gốc | Mất máy/khôi phục máy mới thì mất ảnh chưa đồng bộ (đã chấp nhận ở DEC-07) | PO xác nhận lại ở G4 | G4 |
| Inbox JSON một file | Đủ cho G2; nhiều mục sẽ chậm | TL | G8 |
| 61 cảnh báo SwiftLint kiểu dáng trong mã prototype (đếm lúc 20:40) (dòng >120, ngoặc sau wrap, file >400 dòng) | Log build target phát hành có cảnh báo, không lỗi | iOS | Dọn khi chuyển mã sang production G3/G4 |
| Thông báo dùng `t(vi, en)` trong mã, chưa String Catalog | Chưa kiểm được khóa thiếu bản dịch tự động | iOS | G3 (L10N-01) |
| Lỗi phát sinh trong sheet Map (Saved/chi tiết) vẫn dùng alert ở màn gốc | Lỗi ghi đĩa hiếm khi xảy ra; nếu xảy ra có thể đóng sheet | iOS | G4/G7 |
| Cảnh báo concurrency AVFoundation (Swift 5) | Không lỗi chạy; cần dọn khi lên Swift 6 | iOS | G3/G4 |
| Bản đồ là sơ đồ fixture, không phải Google Map | Q-17 thử luồng, không thử cảm nhận bản đồ thật | DES/TL | Sau khi live được duyệt |
