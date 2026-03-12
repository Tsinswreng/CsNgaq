		```cs
using Tsinswreng.CsSql;
using IStr_Obj = IDictionary<str, obj?>;
public class DaoWord{
	public async Task<IAsyncEnumerable<IdWord?>> BatSlctIdByOwnerHead(//同構批量函數名稱必須以Bat開頭
		IDbFnCtx Ctx, //涉及同構批量的函數 第一個參數必須爲IDbFnCtx Ctx
		IdUser Owner, IEnumerable<str> Heads
		,CT Ct // 異步函數必須以CT Ct參數結尾、函數名不另加Async後綴
	){
		//此處使用了 SqlSplicer 工具、文檔見 CsDeclOut/Tsinswreng.CsSql/ISqlSplicer.cs
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
