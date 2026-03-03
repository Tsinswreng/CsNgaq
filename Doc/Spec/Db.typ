#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;

數據庫操作規範

*所有操作都要兼容AOT!!!*

#H[使用的庫][
	#H[ORM][
		- 自研的`Tsinswreng.CsSqlHelper`
		- 常用API: `<項目根目錄>\CsDeclOut\Tsinswreng.CsSqlHelper\ExtnITable.cs`
		- 需要獲取成員名旹、若有[能用表達式樹拿到成員名]的API 就不要用nameof、
			- 例: 有`T.Fld(x=>x.Id)`就勿用`T.Fld(nameof(MyEntity.Id))`
			- 實在沒有纔考慮nameof。但是*絕對禁止硬編碼字段與表名*!
	]
	#H[強類型Id][
		命名: Id+實體名 如`IdUser`
		
		內部封裝了 UInt128、生成的羅輯是ULID (前48位是unix毫秒時間戳、後80位是隨機數)
		
		在數據庫存儲時被映射到`byte[]`類型
	]

]

#H[批量操作][
	
	此處的批量操作 包括讀與寫的批量 不只是寫入的批量。
	
	*!!設計 讀寫數據庫相關的函數, API時 優先提供批量版本!!*
	
	實現量操作旹, 一般有兩種思路
	
	一種是使用專爲批量設計的sql語法 如 `IN`子句 但是這種做法適配性有限、與非批量寫法差異較大
	
	所以一般只有在 只操作單個字段的時候、我們纔考慮用`IN`子句的批量實現
	
	其他大多數時候都是用 基于拼接同結構sql語句的批量操作
	
	#H[基于拼接同結構sql語句的批量操作][

		原理: 把多個同結構的Sql語句拼進同一個sqlCmd.CommandText中, 一次執行多條sql語句。
		以下簡體「同構批量」
		

		同構批量函數命名必須以 `Bat`開頭
		
		代碼示例
		
		```cs
using Tsinswreng.CsSqlHelper;
using IStr_Obj = IDictionary<str, obj?>;
public class DaoWord{
	public async Task<IAsyncEnumerable<IdWord?>> BatSlctIdByOwnerHead(//同構批量函數名稱必須以Bat開頭
		IDbFnCtx Ctx, //涉及同構批量的函數 第一個參數必須爲IDbFnCtx Ctx
		IdUser Owner, IEnumerable<str> Heads
		,CT Ct // 異步函數必須以CT Ct參數結尾、函數名不另加Async後綴
	){
		//此處使用了 SqlSplicer 工具、文檔見 CsDeclOut/Tsinswreng.CsSqlHelper/ISqlSplicer.cs
		// T是Dao的成員變量 代表ITable<PoWord>
		// 此處的Sql的類型是 I_DuplicateSql 、 不是str
		var Sql = T.SqlSplicer().Select(x=>x.Id).From().Where1() //.From()不傳參數則默認用T的表名; Where1即 where 1=1
		.AndEq(x=>x.Owner, out var POwner) // out var POwner 即聲明了一個Sql參數、可在後文直接使用POwner
		.AndEq(x=>x.Head, out var PHead)
		;
		
		//第一個泛型參數str是待批量傳入的參數的元素類型、因爲我們稍後要傳入 IEnumerable<str> Heads、所以第一個泛型參數填str
		//第二個泛型參數即 AutoBatch內部的lambda的返回值類型
		await using var batch = SqlCmdMkr.AutoBatch<str, IAsyncEnumerable<IdWord?>>(
			Ctx, Sql,
			async(z, Heads, Ct)=>{ //第一個參數 z 即 batch 自己
				var Args = ArgDict.Mk(T)
				.AddT(POwner, Owner) // AddT即 綁定固定的參數
				.AddManyT(PHead, Head) // AddManyT即 綁定列表參數 實際傳參時該參數會被傳入列表的每一個元素
				//執行命令有四種寫法 Asy2d, Asy1d, All2d, All1d
				// Asy表示返回 IAsyncEnumerable<IStr_Obj> ; All表示返回 IList<IStr_Obj>
				// 2d表示把結果集分成2維存在不同列表、不混在一起; 1d表示把結果集在同一列表中混在一起
				var GotDicts = z.SqlCmd.Args(Args).AsyE1d(Ct).OrEmpty();
				return GotDicts.Select(x=>{
					var ans = x[T.Memb(x=>x.Id)];//x是 IStr_Obj 類型、這裏我們只取 Id 字段的值
					return (IdWord?)IdWord.FromByteArr((u8[])ans!);
				});
			}
		);
		var R = batch.AllFlat(Heads, Ct);//傳入所有Heads參數、R的類型是 IAsyncEnumerable<IdWord?>
		return R;
	}
}
		```
	]
]



#H[文件命名][
	- `IRepo<TEntity>`: 通用倉儲類、封裝了常用且通用的Crud方法。接口見`CsDeclOut\Tsinswreng.CsSqlHelper\IRepo.cs`
	- `DaoXxx`: 數據訪問層。寫Sql操作數據庫
	- `SvcXxx`: 服務層、寫業務理則。不應直接在此層寫Sql操作數據庫、可調用DaoXxx或RepoXxx
]

#H[常用API(重要)][
	#H[表][
		在`<項目根目錄>/CsDeclOut/Tsinswreng.CsSqlHelper/`下:
		- `ITable.cs`
		- `ExtnITable.cs`
		- `IRepo.cs`
	]
	#H[常用工具][
		在`<項目根目錄>/CsDeclOut/Tsinswreng.CsSqlHelper/CsTools/`下:
		- `BatchCollector.cs`
		//AutoBatch
	]
	#H[分頁][
		在`<項目根目錄>/CsDeclOut/Tsinswreng.CsSqlHelper/CsPage/`下:

	]

]

#H[數據庫ˇ操作ʹ函數ˇʹ組合複用 與 事務傳播][
涉及數據庫查詢的方法定義示例(非批量):
```cs
public async Task<Func<
	TId, TArg2,
	CT, Task<R>
>> FnQueryDb(IDbFnCtx Ctx, CT Ct){
	//在外層構建帶參數的sql
	var Sql = T.SqlSplicer().Select().From().WhereT()
	.AndEq(x=>x.Id, PId).ToSqlStr();
	;
	var Cmd = await Ctx.PrepareToDispose(SqlCmdMkr, Sql, Ct);
	var fnAnother = await FnAnother(Ctx, Ct);//如需組合其他的數據庫操作函數也應在外層構建
	return async (Id, Arg2)=>{
		//在裏層傳參並執行sql
		var Args = ArgDict.Mk(T).AddT(PId, Id)
		var GotDict = await SqlCmd.Args(Args).AsyE1d(Ct).FirstOrDefaultAsync(Ct);
		var R = DoSomeHandle(GotDict);//如在此調用fnAnother
		return R;
	}
}
```




需要封裝成帶事務的函數時:
```cs
public async Task<R> QueryDb(TId Id, TArg2 Arg2, CT Ct){
	return await TxnWraper.Wrap(FnQueryDb, Id, Arg2, Ct);
}
```
]

#H[Sql參數][
	- 見 ITable.Prm()
	不准用位置參數。若一定要則用`@_0`, `@_1`的命名參數來模擬
]

#H[其他有用的工具(你不一定會用到、按需讀取)][
	- 分頁模型: `IPageAsyE<>`
	- 攢批發送: `BatchCollector`
]



