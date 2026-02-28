#import "@preview/tsinswreng-auto-heading:0.1.0": auto-heading
#let H = auto-heading;

實體規範

#H[基實體][
見
- `Ngaq.Core\Shared\Base\Models\Po\IPoBase.cs`
- `E:\_code\CsNgaq\Ngaq.Core\Shared\Base\Models\Po\PoBase.cs`

]

文件結構:

`<MyDomain>/Models/Po/<MyEntity>/`

在此文件夾下建立兩個文件
- `PoMyEntity.cs`
- `IdMyEntity.cs`

#H[IdMyEntity][
```cs
namespace Ngaq.Core.Shared.MyDomain.Models.Po.MyEntity;

using Ngaq.Core.Model.Consts;
using StronglyTypedIds;

[StronglyTypedId(ConstStrongTypeIdTemplate.UInt128)]//ulid 48位unix毫秒時間戳+80位隨機數
public partial struct IdMyEntity {

}

```
]

#H[PoMyEntity][
```cs
public partial class PoMyEntity
	:PoBaseBizTime // 若不需要 業務上的時間屬性, 則只繼承 PoBase即可
	,I_Id<IdMyEntity>
{
	public IdMyEntity Id { get; set; } = new(); //必須顯式寫`=new()`來初始化! 否則會變0值
	//...其他成員
}
```
]

