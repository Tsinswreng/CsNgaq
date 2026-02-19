#let H(t,d)={}

數據庫操作規範

#H[ORM][
	- 自研的`Tsinswreng.CsSqlHelper`
	- 常用API: `E:\_code\CsNgaq\Tsinswreng.CsSqlHelper\proj\Tsinswreng.CsSqlHelper\ExtnITable.cs`
	- 需要獲取成員名旹、若有[能用表達式樹拿到成員名]的API 就不要用nameof、
		- 例: 有`T.Fld(x=>x.Id)`就勿用`T.Fld(nameof(MyEntity.Id))`
		- 實在沒有纔考慮nameof。但是*絕對禁止硬編碼字段與表名*!
]

#H[文件命名][
	- `IAppRepo<TEntity>`: 通用倉儲類、封裝了常用且通用的Crud方法。接口見`E:\_code\CsNgaq\Tsinswreng.CsSqlHelper\proj\Tsinswreng.CsSqlHelper\IRepo.cs`
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
	]
	#H[分頁][
		在`<項目根目錄>/CsDeclOut/Tsinswreng.CsSqlHelper/CsPage/`下:

	]

]

#H[數據庫ˇ操作ʹ函數ˇʹ組合複用 與 事務傳播][
涉及數據庫查詢的方法定義示例:
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
