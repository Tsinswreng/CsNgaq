
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
