#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;

#H[Dao][
	數據訪問層
	
	- 命名規範: DaoXxx
	- 可以在此層寫 Sql 與調用 IRepo
]

#H[Svc][
	`Service`之簡稱
	
	- 命名規範: SvcXxx
	- 可在此層調用 Dao 與 IRepo
	- 不應在此層直接寫Sql
	
	- 前端不應直接依賴SvcXxx
	- 規範做法: 做一個 `ISvcXxx` 接口、前端通過接口來訪問。
	#H[事務相關][
一般的涉及操作數據庫的函數、第一次參數通常定義爲 `IDbFnCtx Ctx`、用上下文來儲存數據庫連接與事務
```cs
public interface ISvcKv{
	// ISvc接口中定義的API 涉及修改數據庫的 一定要在事務中執行  且函數第一個參數不需要`IDbFnCtx Ctx`
	// 這樣前端通過接口調用API時就有事務了。
	// 優先定義批量API
	public Task<nil> BatSet(IAsyncEnumerable<PoKv> Kvs, CT Ct);
}

public class SvcKv:ISvcKv{
	//此函數是一般的操作數據庫的函數、需要把第一個參數定義爲 `IDbFnCtx Ctx`、便于組合函數時傳播事務
	public async Task<nil> BatSet(
		IDbFnCtx Ctx
		,IAsyncEnumerable<PoKv> Kvs, CT Ct
	){
		await RepoKv.BatUpdById(Ctx, Kvs, Ct);
		return NIL;
	}
	
	//此函數是 ISvcKv 的方法實現、需要顯式開啓事務
	[Impl]
	public async Task<nil> BatSet(IAsyncEnumerable<PoKv> Kvs, CT Ct) {
		//使用 SqlCmdMkr.RunInTxn 開啓事務並轉發參數
		return SqlCmdMkr.RunInTxn(Ct, (Ctx)=>{
			return BatSet(Ctx, Kvs, Ct);
		});
	}
}

```
	]
]
