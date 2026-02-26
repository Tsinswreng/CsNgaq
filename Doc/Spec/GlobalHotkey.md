# 全局快捷键系统 (Global Hotkey Listener)

## 概述

这是一个跨平台的全局快捷键监听系统，允许应用在后台（即使窗口不活跃）监听和响应全局快捷键事件。

## 架构

采用接口 + 各自实现的模式，确保跨平台兼容性：

### 核心接口 (Ngaq.Core)

- **IHotkeyListener** - 快捷键监听器接口（平台无关）
- **IHotkeyMgr** - 快捷键管理器接口（用于生命周期管理）
- **EHotkeyModifiers** - 快捷键修饰符枚举（Ctrl, Shift, Alt, Win）
- **EHotkeyKey** - 快捷键枚举（A-Z, 0-9, F1-F12, 特殊键等）

### 平台实现

#### Windows (Ngaq.Windows)
- **WinHotkeyListener** - 使用 Win32 API `RegisterHotKey` 实现
- 文件：`e:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Windows\Domains\Hotkey\WinHotkeyListener.cs`

#### Android (Ngaq.Android)
- **AndroidHotkeyListener** - Android 平台实现（框架预留）
- 文件：`e:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Android\Domains\Hotkey\AndroidHotkeyListener.cs`

### 服务实现 (Ngaq.Ui)

- **SvcHotkeyMgr** - 快捷键管理服务
- 文件：`e:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Infra\Hotkey\SvcHotkeyMgr.cs`

## 使用方法

### 1. 基本使用

在 `App.cs` 或其他地方注册快捷键：

```csharp
using Ngaq.Core.Frontend.Hotkey;

// 获取快捷键监听器
var HotkeyListener = App.GetSvc<IHotkeyListener>();

// 注册快捷键: Ctrl+Shift+T
await HotkeyListener.Register(
    HotkeyId: "my_hotkey",
    Modifiers: EHotkeyModifiers.Ctrl | EHotkeyModifiers.Shift,
    Key: EHotkeyKey.T,
    OnHotkey: async (Ct) => {
        System.Console.WriteLine("快捷键被触发了!");
        // 执行你的逻辑
        await Task.CompletedTask;
    },
    Ct: default
);
```

### 2. 测试快捷键

当前已在 `App.OnFrameworkInitializationCompleted()` 中注册了测试快捷键：

- **快捷键组合**：Ctrl+Shift+T
- **快捷键 ID**：`test_hotkey_1`
- **执行效果**：在控制台输出 "🎉 [Global Hotkey] Ctrl+Shift+T triggered! 全局快捷键被触发了!"

运行 Windows 版本的应用后，按下 Ctrl+Shift+T 即可看到效果。

### 3. 注销快捷键

```csharp
await HotkeyListener.Unregister("my_hotkey", default);
```

### 4. 清理所有快捷键

```csharp
await HotkeyListener.Cleanup(default);
```

## 支持的快捷键

### 字母键
A-Z (26个)

### 数字键
D0-D9 (0-9)

### 功能键
F1-F12

### 特殊键
- Enter, Escape, Backspace, Tab, Space, Delete
- Home, End, PageUp, PageDown
- Up, Down, Left, Right
- Print, Pause, Insert, NumLock, CapsLock, ScrollLock

## 支持的修饰符

- `Ctrl` - Ctrl 键
- `Shift` - Shift 键
- `Alt` - Alt 键
- `Win` - Windows 键
- 可组合使用：`Ctrl | Shift | Alt`

## 依赖注入配置

### Windows 平台 (DiWindows.cs)

```csharp
z.AddSingleton<IHotkeyListener, WinHotkeyListener>();
```

### Android 平台 (DiAndroid.cs)

```csharp
z.AddSingleton<IHotkeyListener, AndroidHotkeyListener>();
```

## 技术细节

### Windows 实现

- 使用 Win32 API `RegisterHotKey` 和 `UnregisterHotKey`
- 需要有效的窗口句柄
- 在当前应用进程中全局生效
- 支持字母键、数字键、功能键和特殊键

### 虚拟键码映射

Windows 虚拟键码映射示例：
- A-Z: 0x41-0x5A
- 0-9: 0x30-0x39
- F1-F12: 0x70-0x7B
- Enter: 0x0D
- Escape: 0x1B
- 等等...

### 修饰符码映射

- Ctrl: 0x2
- Shift: 0x4
- Alt: 0x1
- Win: 0x8

## 文件清单

创建的文件：

1. **e:\_code\CsNgaq\Ngaq.Core\Frontend\Hotkey\IHotkeyListener.cs** - 快捷键监听器接口
2. **e:\_code\CsNgaq\Ngaq.Core\Frontend\Hotkey\IHotkeyMgr.cs** - 快捷键管理器接口
3. **e:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Windows\Domains\Hotkey\WinHotkeyListener.cs** - Windows 实现
4. **e:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Android\Domains\Hotkey\AndroidHotkeyListener.cs** - Android 实现
5. **e:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\Infra\Hotkey\SvcHotkeyMgr.cs** - 服务管理器实现

修改的文件：

1. **e:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Windows\DiWindows.cs** - 添加 DI 配置
2. **e:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Android\DiAndroid.cs** - 添加 DI 配置
3. **e:\_code\CsNgaq\Ngaq.Frontend\proj\Ngaq.Ui\App.cs** - 添加快捷键初始化和测试代码
4. **e:\_code\CsNgaq\Ngaq.Core\Frontend\ImgBg\ISvcImg.cs** - 修复语法错误

## 注意事项

1. **只在 Windows 平台初始化**：快捷键注册仅在 Windows 平台执行，通过 `RuntimeInformation.IsOSPlatform(OSPlatform.Windows)` 判断
2. **线程安全**：当前实现使用字典存储注册的快捷键，在多线程环境下需要谨慎
3. **应用关闭**：应该在应用关闭前调用 `Cleanup()` 清理所有快捷键
4. **AWait 语法**：注册和注销操作都是异步的，使用 `await` 或 `ConfigureAwait(false)`

## 扩展

### 添加新的快捷键

1. 在 `EHotkeyKey` 枚举中添加新的键
2. 在 `ConvertKey()` 方法中添加对应的虚拟键码映射
3. 注册快捷键时使用新键

### 支持其他平台

1. 在相应的平台目录下创建新的监听器实现
2. 实现 `IHotkeyListener` 接口
3. 在对应的 DI 模块中注册

### 增强事件系统

当前实现支持注册回调函数。如果需要事件驱动，可以：

1. 创建自定义事件类
2. 在快捷键触发时发送事件
3. 订阅者可以订阅事件处理

## 测试

运行 Windows 版应用，按下 Ctrl+Shift+T，应该看到控制台输出测试消息。
