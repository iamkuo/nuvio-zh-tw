# Add Traditional Chinese (Taiwan) localization

## Summary

Adds a `values-zh-rTW` resource set and registers it in `AppLanguage`, so the app can be
switched to Traditional Chinese from **Settings → Appearance → App Language**.

The app currently ships only `values-zh` (Simplified). On a device set to Traditional
Chinese, Compose resource resolution falls back to `values-zh`, so the whole UI renders in
Simplified. The default `values/strings.xml` already defines `lang_chinese_simplified` and
`lang_chinese_traditional`, but `AppLanguage` only exposes a single `CHINESE("zh", …)` entry,
so there is no way to reach a Traditional variant.

## Changes

1. **New:** `composeApp/src/commonMain/composeResources/values-zh-rTW/` — 7 files, 2,697 strings
   - `strings.xml` (2,488 strings + 4 plurals)
   - `strings_servers.xml` (60), `strings_party.xml` (84), `strings_mdblist.xml` (52),
     `autosync_strings.xml` (10), `autosync_toast_strings.xml` (2), `strings_pip.xml` (1)
2. **Modified:** `AppLanguage.kt` — two lines

```diff
 import nuvio.composeapp.generated.resources.lang_chinese
+import nuvio.composeapp.generated.resources.lang_chinese_traditional
 import nuvio.composeapp.generated.resources.settings_appearance_app_language_device
@@
     CHINESE("zh", Res.string.lang_chinese),
+    CHINESE_TRADITIONAL("zh-TW", Res.string.lang_chinese_traditional),
     ;
```

No other code changes are required: `AppearanceLanguageBottomSheet` renders
`AppLanguage.entries`, and `ThemeSettingsStorage.applySelectedAppLanguage()` already forwards
the code to `AppCompatDelegate.setApplicationLocales(LocaleListCompat.forLanguageTags(code))`,
where `zh-TW` resolves to `Locale("zh", "TW")` and matches `values-zh-rTW`.

## Translation method

Base conversion via OpenCC `s2twp` (character forms + Taiwan phrase conversion), followed by a
curated glossary for Taiwan software terminology:

| Simplified | Taiwan |
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

Only the text content of `<string>` / `<item>` elements was transformed; tags, attributes,
`translatable` flags and XML escapes are byte-identical to `values-zh`.

## Verification

- All 7 files parse as well-formed XML.
- **Key parity with `values-zh` is exact**: same string names, same order, same counts,
  same 4 plurals — verified programmatically per file.
- **0 format-specifier problems**: every `%1$s`, `%d`, `%1$d`… sequence survives conversion
  (guards against `MissingFormatArgumentException` at runtime).
- No Simplified-only vocabulary remains (scanned for 视频/设置/默认/网络/信息/缓存/用户/文件/支持/
  搜索/添加/登录/质量/屏幕/加载/保存/服务器/软件/程序/链接/点击/自定义 …).
- A few characters intentionally keep the common Taiwan form (群/峰) rather than OpenCC's
  variant form (羣/峯).

## Notes

- Service names (Trakt, MDBList, Simkl, IMDb, IntroDB …) are left untranslated.
- `lang_chinese` in `values-zh-rTW` reads `中文`; `lang_chinese_traditional` reads `繁體中文（台灣）`
  so the two Chinese entries are distinguishable in the picker.
- When new strings are added to `values-zh`, `values-zh-rTW` will fall back to `values`
  (English) for the missing keys rather than crashing; keeping it in sync is a follow-up task.
