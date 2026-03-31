#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;
\-\-\-

name: add-comment

description: 生成帶註釋的 C\# 代碼。當編寫新的 C\# 代碼時使用。

\-\-\-

#H[C\# 代碼註釋規範][
	#H[添加註釋的位置][
		- 文件頭
		- 類型(class/interface/struct/enum等)
		- 方法(不管是不是public)
		- 類型的成員(包括字段和訪問器 事件等等、不管是不是public)
		- 函數內部實現
	]
	#H[目標][
		- 讓讀者快速理解「意圖、約束、邊界條件」，而不是重複代碼表面含義。
	]

	#H[適用場景][
		- AI新寫代碼的時候即默認需要詳盡地添加註釋
		- 用戶明確要求“加註釋/補註釋/完善註釋”。
		- 複雜分支、狀態轉換、併發控制、緩存策略、異常恢復等難以一眼看懂的邏輯。
	]

	#H[禁止事項][
		- 不爲顯而易見的代碼添加機械式註釋。
	]

	#H[示例][
```cs
/// Build index for all test nodes in the subtree.
/// Guarantees that each key maps to a de-duplicated node list.
/// <param name="root">Root node to traverse.</param>
/// <exception cref="ArgumentNullException">
/// Thrown when <paramref name="root"/> is null.
/// </exception>
private static void IndexTesteeForSubtree(ITestNode root) {
	// DFS traversal keeps memory stable for deep trees.
	var stack = new Stack<ITestNode>();
	stack.Push(root);
	...
}
```

	]
]
