# Nuvio 繁體中文（台灣）介面翻譯 / Traditional Chinese (Taiwan) UI for Nuvio

把 [Nuvio](https://github.com/NuvioMedia/NuvioMobile) 的整個介面變成繁體中文（台灣用語）。

倉庫內容物：一份 `values-zh-rTW` 資源集（**2,697 條字串**）＋ **兩行程式碼**的補丁。
不動資料層、不動邏輯，只補上 Nuvio 目前缺的繁體中文語系。

## 現成 APK（最快看到成果）

**[下載 APK（175 MB）](https://files.manuscdn.com/user_upload_by_module/session_file/310519663958334677/eEVtsoifObXIQRAH.apk)**

以 `cmp-rewrite` 最新原始碼 + 本倉庫補丁編譯，版本 `1.1.0-beta.2`（versionCode 159），
`full` distribution、debug 簽章。

- 套件 id 是 `com.nuviodebug.com`、名稱「Nuvio Debug」，**會與你現有的 Nuvio 並存**，
  不會覆蓋官方版，也不會動到官方版的資料。
- 代價是它算另一個 app：外掛、Trakt 登入、播放進度設定都要重設一次。
- 安裝後到 **設定 → 外觀 → 應用程式語言**，選「繁體中文（台灣）」。
- 這是驗證用的 debug 建置（未經 R8 最佳化，體積較大、啟動稍慢）。確認介面無誤後，
  建議走下面的「方法 B」讓上游合併，之後就能用官方 APK。

實測驗證：`aapt2 dump resources` 在 APK 內看到 `(zh-rTW)` 資源（例如 `快轉 %d 秒`），
`classes5.dex` 內含 `CHINESE_TRADITIONAL` 與 `zh-TW` 字面值。

---

## 為什麼需要這個

Nuvio 是 Kotlin Multiplatform + Compose Multiplatform。字串放在
`composeApp/src/commonMain/composeResources/values-<locale>/`，語系資料夾沿用 Android 的
qualifier 規則（`values-zh`、`values-pt-rBR`）。

目前只有 `values-zh`（簡體中文），**沒有** `values-zh-rTW`。所以手機設成繁體中文時，
Compose 的資源解析會退回 `values-zh`，整個介面顯示簡體。

更關鍵的是 `AppLanguage` 是一個寫死的 enum：

```kotlin
CHINESE("zh", Res.string.lang_chinese),
```

它只提供一個中文選項，`fromCode()` 只做字串完全比對，所以就算你把 `values-zh-rTW`
資料夾丟進去，選單裡也點不到它。這就是為什麼只翻譯字串不夠，必須同時改 enum。

好消息是維護者早就把標籤字串準備好了 —— `values/strings.xml` 裡已經有
`lang_chinese_simplified` 與 `lang_chinese_traditional`，只是 enum 沒有引用。
所以補丁只需要兩行。

---

## 補丁內容

`patches/0001-add-traditional-chinese-language.patch`

```diff
 import nuvio.composeapp.generated.resources.lang_chinese
+import nuvio.composeapp.generated.resources.lang_chinese_traditional
 import nuvio.composeapp.generated.resources.settings_appearance_app_language_device
@@
     CHINESE("zh", Res.string.lang_chinese),
+    CHINESE_TRADITIONAL("zh-TW", Res.string.lang_chinese_traditional),
     ;
```

選單本身是 `AppLanguage.entries.map { ... }`，所以新增 enum 條目就會自動出現在
**設定 → 外觀 → 應用程式語言**，位置緊接在「中文」之後。

語言切換走的是 `AppCompatDelegate.setApplicationLocales(LocaleListCompat.forLanguageTags(code))`，
`zh-TW` 會解析成 `Locale("zh", "TW")`，正好對上 `values-zh-rTW`，不需要改任何其他程式碼。

---

## 字串清單

| 檔案 | 字串數 |
|---|---|
| `strings.xml` | 2,488（+4 plurals） |
| `strings_servers.xml` | 60 |
| `strings_party.xml` | 84 |
| `strings_mdblist.xml` | 52 |
| `autosync_strings.xml` | 10 |
| `autosync_toast_strings.xml` | 2 |
| `strings_pip.xml` | 1 |
| **合計** | **2,697** |

---

## 翻譯方式與品質檢查

以 OpenCC `s2twp`（字形轉換 + 台灣詞彙）為基底，再套一層台灣用語對照表，
只轉換 `<string>` / `<item>` 元素內的文字，標籤、屬性與格式符號原封不動。

主要用語對照（節錄）：

| 簡體原文 | 台灣用語 |
|---|---|
| 播放列表 | 播放清單 |
| 緩存 | 快取 |
| 清晰度 | 畫質 |
| 用戶 | 使用者 |
| 文件 | 檔案 |
| 屏幕 | 螢幕 |
| 加載 | 載入 |
| 保存 | 儲存 |
| 支持 | 支援 |
| 搜索 | 搜尋 |
| 添加 | 新增 |
| 登錄 | 登入 |
| 賬號 | 帳號 |
| 默認 | 預設 |
| 設置 | 設定 |
| 網絡 | 網路 |
| 信息 | 資訊 |
| 服務器 | 伺服器 |
| 自定義 | 自訂 |
| 點擊 | 點選 |
| 視頻 | 影片 |

驗證結果：

- 7 個檔案全部為合法 XML
- 字串 key 與 `values-zh` **100% 對齊**（名稱、順序、數量、plurals 皆相同）
- 格式符號（`%1$s`、`%d` 等）**0 個問題** —— 不會出現 `MissingFormatArgumentException` 崩潰
- 簡體專有用語掃描（视频／设置／默认／网络／信息／缓存／用户／文件／支持／搜索／添加／登录／质量／屏幕／加载／保存／服务器／软件／程序／链接／点击／自定义 等）**全部為 0**
- 少數字詞保留台灣慣用的「群／峰」寫法（OpenCC 會轉成異體「羣／峯」，此處刻意保留常見字形）

---

## 如何套用

### 方法 A：自己編譯 APK

```bash
git clone --depth 1 -b cmp-rewrite https://github.com/NuvioMedia/NuvioMobile.git
cd NuvioMobile

# 1) 放入繁體中文資源
cp -r /path/to/nuvio-zh-tw/composeApp/src/commonMain/composeResources/values-zh-rTW \
      composeApp/src/commonMain/composeResources/

# 2) 套用補丁
patch -p1 < /path/to/nuvio-zh-tw/patches/0001-add-traditional-chinese-language.patch

# 3) 編譯
echo "sdk.dir=$ANDROID_HOME" > local.properties
./gradlew :composeApp:assembleDebug
# 產物：composeApp/build/outputs/apk/debug/composeApp-debug.apk
```

需要 JDK 21、Android SDK Platform 37.1、Build-Tools 37.0.0。
（`compileSdk` 是 `37` + `minorApiLevel 1`，所以 platform 套件名稱是 `platforms;android-37.1`。）

安裝後到 **設定 → 外觀 → 應用程式語言** 選「Chinese (Traditional)」，整個介面就會切成繁體中文。

### 方法 B：請上游合併（推薦）

把這個倉庫的內容做成 PR 送給 [NuvioMedia/NuvioMobile](https://github.com/NuvioMedia/NuvioMobile)，
之後每個人都能在官方 APK 裡直接選繁體中文。PR 說明文字見 [`PR.md`](PR.md)。

### 方法 C：`apply.sh`

```bash
./apply.sh /path/to/NuvioMobile
```

---

## 注意事項

- 這是**社群翻譯**，不是官方版本。專有名詞（Trakt、MDBList、Simkl 等服務名稱）保持原文。
- 之後 Nuvio 若新增字串，`values-zh-rTW` 會缺少對應 key，Compose 會自動退回 `values`（英文）顯示，
  不會崩潰，但會看到英文。要維持完整覆蓋率就得跟著 `values-zh` 同步更新。
- 補丁只影響介面文字，不影響你原本的中繼資料外掛、Trakt 同步或播放進度設定。
