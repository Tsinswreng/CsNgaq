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
	// ISvc接口中定義的API 涉及修改數據庫的 一定要在事務中執行
	// 函數第一個參數定義成`IDbFnCtx? Ctx`
	// 若傳入的Ctx不爲null則使用傳入的上下文 若爲空則自己開一個帶事務的上下文
	// 這樣前端通過接口調用API時就有事務了。
	// 優先定義批量API
	public Task<nil> BatSet(
		IDbFnCtx? Ctx
		,IAsyncEnumerable<PoKv> Kvs, CT Ct
	);
}

public class SvcKv:ISvcKv{
	//此函數是 ISvcKv 的方法實現
	[Impl]
	public async Task<nil> BatSet(
		IDbFnCtx? Ctx,
		IAsyncEnumerable<PoKv> Kvs, CT Ct
	) {
		//如果操作涉及修改數據庫即需用RunInTxnIfNoCtx
		//如果是純讀 則用 Ctx??=new DbFnCtx();
		return await SqlCmdMkr.RunInTxnIfNoCtx(Ctx, Ct, async(Ctx)=>{
			return await BatSet(Ctx, Kvs, Ct);
		});
	}
}

```
		#H[UserCtx][
			`/Ngaq.Core/Shared/User/UserCtx/IUserCtx.cs`
			常用API:
			- `UserCtx.UserId`
			
			Svc層中、若函數的前兩個參數爲`IDbFnCtx? Ctx, IUserCtx User`、
			則應改定義成 `IDbUserCtx`
			`/Ngaq.Core/Infra/DbUserCtx.cs`
			以減少重複參數數量
		]
	]
]

#H[調用其他批量函數的規範][
	- 善用 BatchCollector
	- 調用支持批量操作的函數的時候 避免在for循序中多次調用且每次調用時只傳一個參數
		- 接收批量參數的函數 你就得批量地傳 不能把原本成批量的數據拆成一個 逐個傳
]
