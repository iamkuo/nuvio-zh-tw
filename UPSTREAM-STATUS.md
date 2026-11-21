# Nuvio 繁體中文：上游什麼時候會上？倉庫證據分析

調查對象：[NuvioMedia/NuvioMobile](https://github.com/NuvioMedia/NuvioMobile)（預設分支 `cmp-rewrite`，4,711 stars，663 open issues）
調查時間：2026-11-21

---

## 一句話結論

**沒有任何排程。** 這個專案沒有里程碑、沒有 roadmap、沒有發版日曆，發版是維護者手動按的。
但發版頻率極高、翻譯 PR 的合併速度也極快（多數 0–3 天）。
所以「什麼時候會有繁體中文」完全取決於**有沒有一個 CI 綠、能合併的 PR**——而現在有一個，
已經躺了 65 天沒人理。

---

## 1. 沒有排程的證據

| 檢查項目 | 結果 |
|---|---|
| Milestones | **0 個**（`/milestones` 回傳空陣列） |
| Issue due date / 專案看板 | 無 |
| 分支 | 只有 `cmp-rewrite`、`main` |
| 發版方式 | `.github/workflows/android-release.yml` 只綁 `workflow_dispatch` → **手動觸發** |
| 翻譯流程 | 沒有 Crowdin/Weblate；社群建議集中化的 #2117 仍 open |

issue #2301「Chinese language」(2026-10-17) 與 #1550「Simplified Chinese」(2026-07-15) 都還開著、
**零維護者回覆**——即使簡體中文早就上線了。這說明這個專案不看 feature request，只看 PR。

---

## 2. 但發版其實非常快

實際 tag 節奏（`/releases`）：

| 日期 | 版本 |
|---|---|
| 2026-10-27 | 0.6.5-beta |
| 2026-10-31 | 0.6.6-beta |
| 2026-11-04 | 0.6.7-beta |
| 2026-11-05 | 0.6.8-beta |
| 2026-11-06 | 0.6.9-beta |
| 2026-11-08 | 0.6.10-beta |
| 2026-11-10 | 0.6.11-beta |
| 2026-11-12 | 0.6.12-beta |
| 2026-11-15 | 0.6.13-beta → **1.0.0** |
| 2026-11-16 | 1.1.0-beta.1 |
| 2026-11-18 | 1.1.0-beta.2 |

**22 天內 10 個版本，平均每 2 天一次。** 今天是 11/21，距離 beta.2 已 3 天，
下一個版本隨時會出。也就是說：**合併之後 0–2 天使用者就吃得到。**

---

## 3. 翻譯 PR 的合併速度：多數當天或隔天

抓最近 20 個已合併的 i18n / localization PR，計算「開啟 → 合併」：

| 耗時 | 件數 |
|---|---|
| 0 天（當天） | 10 |
| 1 天 | 5 |
| 2 天 | 2 |
| 3 天 | 2 |
| 12 天 | 1 |

就在 **2026-11-21 00:13–00:17 UTC 這四分鐘內，維護者連併了 6 個翻譯 PR**：
#2696（Title Case）、#2706（土耳其）、#2720（希伯來 `values-iw`）、#2689（匈牙利）、
#2687（法文）、#2707（斯洛伐克）。

其中 #2720 是為了解決 11/19、11/21 才開的 bug #2718 / #2719「希伯來文完全不顯示」——
**bug 開 → 修好 → 併入，兩天。**

---

## 4. 簡體中文是怎麼進去的（最好的參考案例）

| 事件 | 日期 |
|---|---|
| 社群 JadeDouble 送 PR #2499「Add Simplified Chinese (zh) localization」（2,768 行、10 檔） | 2026-11-03 |
| CI 首次建置失敗（bot 留言） | 2026-11-03 |
| **合併** | 2026-11-16（13 天） |
| 1.1.0-beta.1 發版 → 使用者看到簡體中文 | 2026-11-16（同一天） |

補丁內容跟我們做的一模一樣：`values-zh/` 七個檔案 + `AppLanguage` 註冊
`CHINESE("zh", Res.string.lang_chinese)`。

---

## 5. 繁體中文的現況：已經有人送，但卡住了

**PR #1973「i18n(zh): Add chinese translation」** — 作者 `raymondlo88`，**2026-09-17 開啟，至今 65 天未合併**。

它要加的東西跟我們那份幾乎相同，而且更完整：

| 檔案 | 內容 |
|---|---|
| `values-b+zh+Hant/strings.xml` 等 8 檔 | 2,887 行繁體字串 |
| `AppLanguage.kt` | `CHINESE_TRADITIONAL("zh-Hant", Res.string.lang_chinese_traditional)` |
| `androidMain/res/xml/locale_config.xml` | `<locale android:name="zh-Hant"/>` |
| `iosApp/iosApp/Info.plist` | `CFBundleLocalizations` 加 `zh-Hant` |

**卡在哪：**

- `mergeable = MERGEABLE`（沒有衝突）、`mergeStateStatus = UNSTABLE`（CI 沒綠）、`reviewDecision` 空白
- 兩個 workflow（`PR Full Debug Build`、`PR Template Check`）狀態都是 **`action_required`**
  —— fork 來的外部 PR 需要維護者手動按「Approve and run」才會跑
- 最近一次觸發 2026-11-17 03:55，仍掛在 `action_required`；10/28 那次是真的建置失敗
- 作者 2026-11-19 留言「Please check and approve workflow. Thank you.」→ **沒有回應**

**更早的一次嘗試：** PR #1941（同作者，2026-09-14，6,870 行，同時加 `values-zh`、
`values-zh-rCN`、`values-zh-rTW`）維護者 `tapframe` 有實際 review：

> "run resource generation and locale tests before marking ready. there are some issues"
> "resource generation passes now, but `zh-Hans` and `zh-Hans-SG` still fall back to traditional chinese."

3 天後被 #1973 取代並關閉。**這段對話證明維護者在意的是「locale 解析是否正確」，不是「要不要繁體」。**

---

## 6. 所以時間表長怎樣

| 情境 | 預期時間 |
|---|---|
| 維持現狀，沒人推動 | **永遠不會**。沒有排程會自動撿起 #1973 |
| 推 #1973 一把（請維護者批准 workflow + review） | 批准後 CI 約 15–30 分鐘；若綠，依往例 **1–3 天內合併**，再 0–2 天進 beta → **約一週內** |
| 送一個全新的乾淨 PR（BCP-47 命名 + 三處註冊） | 參照 #2720 那種小 PR：**當天～3 天合併**，下一版就出貨 |
| 以 bug 形式開 issue（「zh-TW 裝置顯示簡體」） | 希伯來文那兩個 bug 兩天內修好；bug 標籤比 enhancement 有效得多 |

---

## 7. 如果要送 PR，必須補的東西

我們目前那份補丁只有「資源 + AppLanguage」兩處，**還缺兩個註冊點**，缺了在 review 階段會被退回：

1. `composeApp/src/androidMain/res/xml/locale_config.xml`
   ```xml
   <locale android:name="zh-Hant"/>
   ```
   （目前清單只有 `zh`。這個檔決定 Android 13 系統「應用程式語言」裡看不看得到。）
2. `iosApp/iosApp/Info.plist` → `CFBundleLocalizations` 加 `<string>zh-Hant</string>`

**命名要一致**：上游既有 PR 與 Compose Multiplatform 官方建議的 script 變體寫法是
`values-b+zh+Hant` + 代碼 `zh-Hant`；我們原本用的 `values-zh-rTW` + `zh-TW` 雖然也能跑
（APK 實測有效），但兩者並存會衝突。要送 PR 應該改成 BCP-47 寫法。

---

## 附：資料來源

- `GET /repos/NuvioMedia/NuvioMobile/releases`、`/milestones`、`/branches`
- `GET /repos/NuvioMedia/NuvioMobile/commits?path=…values-zh/strings.xml` → 11-03 `JadeDouble`、11-16 `tapframe`
- `GET /repos/NuvioMedia/NuvioMobile/pulls/1973`、`/1941`、`/2499` 及其 comments / files
- `GET /repos/NuvioMedia/NuvioMobile/actions/runs?head_sha=e0f49bb…` → 兩筆 `action_required`
- `gh search prs --repo NuvioMedia/NuvioMobile "localization" --merged`（20 筆耗時統計）
- `.github/workflows/android-release.yml` → `workflow_dispatch` only
