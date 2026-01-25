#let H(t,d)={}

#H[文檔記錄][
	在代碼中記錄文檔旹*不*使用C\#的xml文檔註釋格式、在本項目中我們使用以下格式:

舉例:
```cs
[Doc($@"
#Sum[合併兩字典]
#Params([字典A],[字典B])
#TParams([鍵],[值])
#Rtn[合併後的字典]
#See[{nameof(IDictionary)}]
#Throw[{nameof(Exception1)}][原因1]
#Throw[{nameof(Exception2)}][原因2]
...
")]
public IDictionary<K,V> Merge<K,V>(IDictionary<K,V> A, IDictionary<K,V> B)
	where K:notnull
{

}
```
說明:
- 像`#Sum[content]`這樣的 使用的是typst語法。中括號內的東西爲內容塊。內容塊內可以換行; 用星號包裹的內容爲加粗; 用 - 表示無序標題; 用 + 表示有序標題; 用 = 表示一級標題, 用==表示 二級標題。用三個一組的兩組反引號可以包裹代碼塊。不過這些提到的都是高級的，我們推薦你儘量簡單描述，所以大部分時候你是不應該用到很多高級語法的。
- 不是每個標籤都要寫。按需使用標籤即可。如簡單的函數 像 `int Add(int a, int b)=>a+b;`這種簡單的函數就只用寫`#Sum[兩數相加]`,`#Params([...],[...]...)`, `#Rtn[]`就夠了。
- 需要引用其他符號的時候就用`nameof`、避免硬編碼。
- `#Params([],[]...)` 這種是按參數順序填寫。如`#Params([第一個參數的解釋],[第二個參數的解釋]...)`。`#TParams`同理。 *注意是按參數順序填寫解釋、不要再把參數名稱寫上去。*



同一個符號上面可以加多個`[Doc]`特性。

當Doc只寫一個 `#Sum`標籤旹 應該簡化

正確示例:
```cs
[Doc($@"Type of the relationship")]
public ERelationType Type{get;set;}
```

不建議的示例:
```cs
[Doc($@"
#Sum[Type of the relationship]
")]
public ERelationType Type{get;set;}
```

#H[寫給AI的提示詞][
	如果你是AI、當你接收到任務、需要在源碼中補充`[Doc]`風格的文檔的時候:
	- 嚴格按照上面的說明執行
	- 如果源碼中已經有了xml風格的註釋、仍然要補充上`[Doc]`註釋
	- 大部分情況下 public的符號 都建議要加 `[Doc]`註釋。除非是代碼非常簡單且意圖顯而易見
	- 一次性多改點、不要每次就只改了一點東西就來找我確認
	- 註釋要避免正確廢話。
		錯誤示例:
		```cs
		public class Person{
			[Doc($@"Default ctor")]
			public Person(){

			}
		}
		```
		誰都能一眼看出來`public Person()`是默認構造器、這種註釋毫無意義、所以應當避免。

]

]
