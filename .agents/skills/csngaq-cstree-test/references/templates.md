# Templates

## Minimal Tester Skeleton

```cs
using Tsinswreng.CsTreeTest;

namespace Your.Namespace;

public partial class TestXxx : ITester {
	public ITestNode RegisterTestsInto(ITestNode? node) {
		node ??= new TestNode();
		RegisterMethodA(node);
		return node;
	}
}
```

## Method Registration Skeleton

```cs
public partial class TestXxx {
	public void RegisterMethodA(ITestNode node) {
		var register = node.MkTestFnRegister(
			typeof(TestXxx),
			[typeof(IXxx)],
			[nameof(IXxx.MethodA)],
			"MethodA"
		);
		var R = register.Register;
		R("normal case", async _ => {
			return null;
		});
	}
}
```

## TestMgr Registration Skeleton

```cs
public class LocalTestMgr : DiEtTestMgr {
	public static LocalTestMgr Inst = new();
	public override ITestNode RegisterTestsInto(ITestNode? test) {
		test = this.TestNode;
		this.RegisterTester<TestXxx>();
		return test;
	}
}
```

## Parent Manager Collecting Child Manager

```cs
public class WindowsTestMgr : DiEtTestMgr {
	public static WindowsTestMgr Inst = new();
	public override ITestNode RegisterTestsInto(ITestNode? test) {
		test = this.TestNode;
		this.RegisterSubMgr(LocalTestMgr.Inst);
		return test;
	}
}
```

## DB Test Cleanup Pattern

Use setup + cleanup guards so inserted data is always removed:

```cs
var insertedIds = new List<long>();
try {
	// insert fixtures and collect ids
	// run assertions
}
finally {
	// hard-delete by insertedIds
}
```

