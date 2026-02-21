#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;

#H[文檔記錄][
	在代碼中記錄文檔旹*不*使用C\#的xml文檔註釋格式、在本項目中我們使用以下格式:

舉例:
```cs
[Doc($@"
#Sum[合併兩字典]
#Params([字典A],[字典B])
#TParams([鍵],[值])
#Rtn[合併後的字典]
#See([{nameof(IDictionary)}],[...])
#Throw[{nameof(Exception1)}][原因1]
#Throw[{nameof(Exception2)}][原因2]
#Examples([示例1],[示例2])
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
- `#Sum[]`標籤可以省略不寫
- `#Examples`支持多個示例、與`#Params`語法類似、小括號內接多組中括號。


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

當子類繼承父類或實現接口時、若無特殊情況、Doc應標在父類/接口上而不是子類上

`#Child[{nameof(ChildClass)}][Descr]`

]

在Doc內的字符串中引用其他符號時 能用`nameof`的就用`nameof`、禁止硬編碼

其他符號 包括 類型, 成員, 方法, 形參 等等。

錯誤示例
```cs
[Doc(@$"this is for MyClass ......")]
```

正確示例
```
[Doc(@$"this is for {nameof(MyClass)} ......")]
```
