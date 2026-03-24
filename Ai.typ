`E:/_code/CsNgaq/Doc/Spec/`
這個目錄下有項目說明和代碼規範。

```
Common.typ	-- 通用
DocSpec.typ -- 在代碼加註釋文檔的規範 (大多數情況你不需要讀此文件 除非明確要求)
CodeDoc.typ -- 在C#代碼中撰寫目錄文檔的規範 (大多數情況你不需要讀此文件 除非明確要求)
Db.typ -- 數據庫相關
Entity.typ -- 實體類相關
Frontend.typ -- 前端相關
MapEtSerialization.typ -- 對象映射與序列化
Cfg.typ -- 配置文件用法
Proj.typ -- 項目結構介紹 (按需閱讀、如果你要做的任務只是一個小功能就可以先不看整個項目結構的介紹)
Err.typ -- 異常處理
Dto.typ -- 數據庫傳輸對象規範
SvcDao.typ -- Serivce 和 Dao 規範
Typst.typ -- typst文檔(.typ) 撰寫規範 (大多數情況你不需要讀此文件)
```

Common.typ是必看項。

其次、根據你這次要做的任務、在上述文件中挑選你所需的來看。
比如我現在要你做前端的任務、你就得看Frontend.typ文件、別的就先不看。


*遇到任何不確定的地方一定要先問我。建議多問 不要帶着疑問幹活*

再次強調兩點:
- 所有代碼必須兼容AOT
- 可迭代集合應當保持流式、禁止用ToList()全部加載到內存裏
