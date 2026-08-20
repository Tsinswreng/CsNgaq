-Sesn[
	-T[2026_0818_231456][
		看skill和記憶。
		然後看CsSh這個項目。
		現在我想發到nuget。
		想一套發佈/更新的流程。
	][
````md
已檢視記憶與 `Tsinswreng.CsSh`。

現況：

- `CsSh` 是獨立 GitHub 倉庫：`https://github.com/Tsinswreng/CsSh`
- 主庫是 `net10.0`、AOT 相容的類別庫，已有完整測試與 README。
- 尚無 NuGet 套件中繼資料、LICENSE、發佈腳本或 GitHub Actions。
- 依賴 `Tsinswreng.CsCore 0.0.1-alpha`；必須先確認此依賴已可由 nuget.org 還原，否則使用者安裝 CsSh 會失敗。
- 工作樹有未提交修改，不應直接作為正式發版來源。
- README 為 `README.typ`，NuGet Gallery 不適合直接顯示；建議新增面向套件頁面的 `README.md`。

我建議採用「Git tag 驅動、CI 驗證後自動上傳」的流程：

| 階段 | 觸發 | 結果 |
|---|---|---|
| 日常開發 | PR／推送 `master` | 還原、建置、執行測試、打包驗證；不發布 |
| 預發版 | 建立 tag，如 `v0.1.0-alpha.1` | CI 打出同版本 `.nupkg`／`.snupkg`，推送 NuGet；僅預發版使用者取得 |
| 正式版 | 建立 tag，如 `v0.1.0` | 同一 CI 流程，推送正式版、建立 GitHub Release |
| 更新 | 依 SemVer 決定下一個 tag | `patch` 修 bug、`minor` 加相容 API、`major` 有破壞性變更 |

每次發布的 CI 固定執行：

1. 只接受乾淨、已推送的 tag commit。
2. `dotnet restore`、Release build、執行現有測試。
3. `dotnet pack` 產生套件與符號套件。
4. 檢查套件內容和 metadata。
5. 以 NuGet secret 或 nuget.org 的 trusted publishing 身分驗證推送。
6. 發布成功後建立 GitHub Release，附變更摘要與套件版本。

首發前需新增：

- 套件 metadata：`PackageId`、版本、作者、描述、tags、repository、專案 URL、README、license、symbols。
- `README.md`（保留現有 `README.typ` 作專案文件）。
- LICENSE。
- GitHub Actions：驗證工作流 + 發版工作流。
- `CHANGELOG.md` 或 GitHub Release notes 規範。
- NuGet API key／可信發佈設定（僅存 GitHub Secrets，絕不寫入倉庫）。

需要你確認兩件會改變方案的事項：

1. 首個公開版本要先發 `0.1.0-alpha.1`，還是直接 `0.1.0`？我建議先 `0.1.0-alpha.1`，因為 API 最近仍在調整且依賴本身是 alpha。
2. 採用哪種授權？我建議 MIT；沒有 LICENSE 的套件不宜公開發佈。

你確認後，我再把流程落為具體檔案、版本規則和可直接執行的發版指令。
````
	]
	
	-T[2026_0818_233529][
		版本號用0.1.0-alpha。
		那就用MIT吧。
		readme.md 我自己編譯, 你先不管。
		你把設施給我弄好。
	][
		
	]
]
