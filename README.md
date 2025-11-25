# TriggerableAction

TriggerableAction 是一个轻量级的可触发事件模块，为 Swift 提供灵活的事件触发和数据转换功能。

[![Swift](https://github.com/miejoy/triggerable-action/actions/workflows/test.yml/badge.svg)](https://github.com/miejoy/triggerable-action/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/miejoy/triggerable-action/branch/main/graph/badge.svg)](https://codecov.io/gh/miejoy/triggerable-action)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![Swift](https://img.shields.io/badge/swift-6.2-brightgreen.svg)](https://swift.org)

## 依赖

- iOS 15.0+ / macOS 12+ / tvOS 15+ / watchOS 8+
- Xcode 14.0+
- Swift 6.2+

## 简介

### 该模块包含如下内容:

- **TriggerableAction**: 可触发事件协议，定义了同步事件触发的基本接口
- **TriggerableAsyncAction**: 可触发异步事件协议，继承自 TriggerableAction，支持异步事件触发
- **TriggerableResultAction**: 可触发带结果事件协议，定义了返回结果的同步触发接口
- **TriggerableAsyncResultAction**: 可触发异步带结果事件协议，定义了返回结果的异步触发接口
- **AnyTriggerAction**: 任意可触发事件的类型擦除包装器，用于统一不同类型的触发器
- **AnyAsyncTriggerAction**: 任意可异步触发事件的类型擦除包装器
- **AnyTriggerResultAction**: 任意可触发带结果事件的类型擦除包装器
- **AnyAsyncTriggerResultAction**: 任意可异步触发带结果事件的类型擦除包装器
- **TriggerBlockAction**: 基于闭包的可触发事件实现
- **TriggerAsyncBlockAction**: 基于异步闭包的可触发事件实现
- **TriggerBlockResultAction**: 基于闭包的可触发带结果事件实现
- **TriggerAsyncBlockResultAction**: 基于异步闭包的可触发带结果事件实现
- **TriggerGroupAction**: 可触发事件组，支持将多个触发器组合在一起
- **TriggerAsyncGroupAction**: 可触发异步事件组
- **TriggerGroupResultAction**: 可触发带结果事件组
- **TriggerAsyncGroupResultAction**: 可触发异步带结果事件组
- **DataConverter**: 数据转换器协议，用于在触发事件前进行数据预处理
- **AsyncDataConverter**: 异步数据转换器协议

### 核心特性:

- **类型安全**: 通过泛型确保触发数据类型的一致性
- **异步支持**: 同时支持同步和异步事件触发
- **结果返回**: 支持触发器返回处理结果，扩展了事件触发的使用场景
- **类型擦除**: 提供各种类型擦除包装器用于统一存储不同类型的触发器
- **数据转换**: 支持在触发前进行数据转换，实现数据预处理
- **事件组合**: 支持将多个触发器组合成事件组，实现批量触发
- **闭包支持**: 提供基于闭包的快速触发器实现

## 安装

### [Swift Package Manager](https://github.com/apple/swift-package-manager)

在项目中的 Package.swift 文件添加如下依赖:

```swift
dependencies: [
    .package(url: "https://github.com/miejoy/triggerable-action.git", from: "1.0.0"),
]
```

## 使用

### 基础使用

#### 创建带结果的自定义触发器

```swift
import TriggerableAction

struct StringToIntAction: TriggerableResultAction {
    func trigger(with data: String) throws -> Int {
        guard let intValue = Int(data) else {
            throw ConversionError.invalidFormat
        }
        return intValue
    }
}

enum ConversionError: Error {
    case invalidFormat
}

let resultAction = StringToIntAction()
let result = try resultAction.trigger(with: "123") // result = 123
```

#### 创建异步带结果的触发器

```swift
import TriggerableAction

struct AsyncStringToIntAction: TriggerableAsyncResultAction {
    func trigger(with data: String) async throws -> Int {
        // 模拟异步操作
        try await Task.sleep(nanoseconds: 1_000_000_000)
        guard let intValue = Int(data) else {
            throw ConversionError.invalidFormat
        }
        return intValue
    }
}

let asyncResultAction = AsyncStringToIntAction()
let asyncResult = try await asyncResultAction.trigger(with: "456") // asyncResult = 456
```

#### 创建自定义触发器

```swift
import TriggerableAction

struct PrintAction: TriggerableAction {
    typealias TriggerData = String
    
    func trigger(with data: String) throws {
        print("触发数据: \(data)")
    }
}

let action = PrintAction()
try action.trigger(with: "Hello, World!")
```

#### 创建异步触发器

```swift
import TriggerableAction

struct AsyncPrintAction: TriggerableAsyncAction {
    typealias TriggerData = String
    
    func trigger(with data: String) async throws {
        // 模拟异步操作
        try await Task.sleep(nanoseconds: 1_000_000_000)
        print("异步触发数据: \(data)")
    }
}

let asyncAction = AsyncPrintAction()
try await asyncAction.trigger(with: "Hello, Async World!")
```

### 使用闭包触发器

#### 带结果的同步闭包触发器

```swift
import TriggerableAction

let blockResultAction = TriggerBlockResultAction<String, Int> { data in
    guard let intValue = Int(data) else {
        throw ConversionError.invalidFormat
    }
    return intValue
}

let result = try blockResultAction.trigger(with: "789") // result = 789
```

#### 带结果的异步闭包触发器

```swift
import TriggerableAction

let asyncBlockResultAction = TriggerAsyncBlockResultAction<String, Int> { data async in
    try await Task.sleep(nanoseconds: 1_000_000_000)
    guard let intValue = Int(data) else {
        throw ConversionError.invalidFormat
    }
    return intValue
}

let asyncResult = try await asyncBlockResultAction.trigger(with: "101") // asyncResult = 101
```

#### 同步闭包触发器

```swift
import TriggerableAction

let blockAction = TriggerBlockAction<String> { data in
    print("闭包触发: \(data)")
}

try blockAction.trigger(with: "闭包测试")
```

#### 异步闭包触发器

```swift
import TriggerableAction

let asyncBlockAction = TriggerAsyncBlockAction<String> { data async in
    try await Task.sleep(nanoseconds: 1_000_000_000)
    print("异步闭包触发: \(data)")
}

try await asyncBlockAction.trigger(with: "异步闭包测试")
```

### 使用类型擦除

#### 带结果的类型擦除触发器

```swift
import TriggerableAction

struct DoubleToStringAction: TriggerableResultAction {
    func trigger(with data: Double) throws -> String {
        return String(format: "%.2f", data)
    }
}

let doubleAction = DoubleToStringAction()
let anyResultAction = doubleAction.eraseToAny() // 类型擦除为 AnyTriggerResultAction<Double, String>

let stringResult = try anyResultAction.trigger(with: 3.14159) // stringResult = "3.14"
```

#### 异步带结果的类型擦除触发器

```swift
import TriggerableAction

struct AsyncDoubleToStringAction: TriggerableAsyncResultAction {
    func trigger(with data: Double) async throws -> String {
        try await Task.sleep(nanoseconds: 100_000_000)
        return String(format: "%.2f", data)
    }
}

let asyncDoubleAction = AsyncDoubleToStringAction()
let anyAsyncResultAction = asyncDoubleAction.eraseToAny() // 类型擦除为 AnyAsyncTriggerResultAction<Double, String>

let asyncStringResult = try await anyAsyncResultAction.trigger(with: 2.71828) // asyncStringResult = "2.72"
```

#### 类型擦除触发器

```swift
import TriggerableAction

struct IntAction: TriggerableAction {
    typealias TriggerData = Int
    
    func trigger(with data: Int) throws {
        print("整数触发: \(data)")
    }
}

let intAction = IntAction()
let anyAction = intAction.eraseToAny() // 类型擦除

// 可以存储不同类型的触发器
var actions: [AnyTriggerAction<Any>] = []
// 注意：需要确保类型兼容性
```

### 使用数据转换器

#### 创建数据转换器

```swift
import TriggerableAction

struct StringToIntConverter: DataConverter {
    typealias Input = String
    typealias Output = Int
    
    func process(data: String) throws -> Int {
        guard let intValue = Int(data) else {
            throw ConversionError.invalidFormat
        }
        return intValue
    }
}

enum ConversionError: Error {
    case invalidFormat
}

struct IntAction: TriggerableAction {
    typealias TriggerData = Int
    
    func trigger(with data: Int) throws {
        print("处理整数: \(data)")
    }
}

let intAction = IntAction()
let convertedAction = intAction.prepend(converter: StringToIntConverter())

try convertedAction.trigger(with: "123") // 字符串会被转换为整数
```

#### 异步数据转换器

```swift
import TriggerableAction

struct AsyncStringToIntConverter: AsyncDataConverter {
    typealias Input = String
    typealias Output = Int
    
    func process(data: String) async throws -> Int {
        // 模拟异步转换过程
        try await Task.sleep(nanoseconds: 100_000_000)
        guard let intValue = Int(data) else {
            throw ConversionError.invalidFormat
        }
        return intValue
    }
}

let asyncIntAction = AsyncPrintAction()
let asyncConvertedAction = asyncIntAction.prepend(converter: AsyncStringToIntConverter())

try await asyncConvertedAction.trigger(with: "456")
```

### 使用事件组

#### 带结果的同步事件组

```swift
import TriggerableAction

let resultAction1 = TriggerBlockResultAction<Int, String> { data in
    return "结果1: \(data)"
}

let resultAction2 = TriggerBlockResultAction<Int, String> { data in
    return "结果2: \(data * 2)"
}

var resultGroup = resultAction1.group()
resultGroup.add(resultAction2)

let results = try resultGroup.trigger(with: 10)
// results = ["结果1: 10", "结果2: 20"]
```

#### 带结果的异步事件组

```swift
import TriggerableAction

let asyncResultAction1 = TriggerAsyncBlockResultAction<Int, String> { data async in
    try await Task.sleep(nanoseconds: 100_000_000)
    return "异步结果1: \(data)"
}

let asyncResultAction2 = TriggerAsyncBlockResultAction<Int, String> { data async in
    try await Task.sleep(nanoseconds: 100_000_000)
    return "异步结果2: \(data * 3)"
}

var asyncResultGroup = asyncResultAction1.group()
asyncResultGroup.add(asyncResultAction2)

let asyncResults = try await asyncResultGroup.trigger(with: 20)
// asyncResults = ["异步结果1: 20", "异步结果2: 60"]
```

#### 同步事件组

```swift
import TriggerableAction

let action1 = TriggerBlockAction<String> { data in
    print("动作1: \(data)")
}

let action2 = TriggerBlockAction<String> { data in
    print("动作2: \(data)")
}

var group = action1.group()
group.append(action2)

try group.trigger(with: "组触发测试")
// 输出:
// 动作1: 组触发测试
// 动作2: 组触发测试
```

#### 异步事件组

```swift
import TriggerableAction

let asyncAction1 = TriggerAsyncBlockAction<String> { data async in
    try await Task.sleep(nanoseconds: 100_000_000)
    print("异步动作1: \(data)")
}

let asyncAction2 = TriggerAsyncBlockAction<String> { data async in
    try await Task.sleep(nanoseconds: 100_000_000)
    print("异步动作2: \(data)")
}

var asyncGroup = asyncAction1.group()
asyncGroup.append(asyncAction2)

try await asyncGroup.trigger(with: "异步组触发测试")
```

### 高级用法

#### 带结果触发器的链式组合

```swift
import TriggerableAction

// 前置带结果触发器
let stringToIntAction = TriggerBlockResultAction<String, Int> { Int($0)! }
let intToStringAction = TriggerBlockResultAction<Int, String> { "处理后: \($0)" }

// 链式组合：String -> Int -> String
let chainedAction = intToStringAction.prepend(stringToIntAction)
let chainedResult = try chainedAction.trigger(with: "123") // chainedResult = "处理后: 123"

// 后置带结果触发器
let doubleAction = TriggerBlockResultAction<Int, Double> { Double($0) * 1.5 }
let chainedResult2 = stringToIntAction.append(doubleAction).trigger(with: "100") // chainedResult2 = 150.0
```

#### 带结果触发器与普通触发器的组合

```swift
import TriggerableAction

// 带结果触发器
let resultAction = TriggerBlockResultAction<String, Int> { Int($0)! }

// 普通触发器
let normalAction = TriggerBlockAction<Int> { print("收到整数: \($0)") }

// 组合：先获取结果，再执行普通触发器
let combinedAction = resultAction.append(normalAction).eraseResult()
try combinedAction.trigger(with: "42") // 输出: "收到整数: 42"
```

#### 链式数据转换

```swift
import TriggerableAction

struct StringToDoubleConverter: DataConverter {
    typealias Input = String
    typealias Output = Double
    
    func process(data: String) throws -> Double {
        guard let doubleValue = Double(data) else {
            throw ConversionError.invalidFormat
        }
        return doubleValue
    }
}

struct DoubleToIntConverter: DataConverter {
    typealias Input = Double
    typealias Output = Int
    
    func process(data: Double) throws -> Int {
        return Int(data)
    }
}

let intAction = IntAction()
let chainedAction = intAction
    .prepend(converter: DoubleToIntConverter())
    .prepend(converter: StringToDoubleConverter())

try chainedAction.trigger(with: "123.45") // String -> Double -> Int
```

#### 混合同步异步操作

```swift
import TriggerableAction

// 同步触发器配合异步转换器
let syncAction = IntAction()
let asyncConvertedAction = syncAction.prepend(converter: AsyncStringToIntConverter())

try await asyncConvertedAction.trigger(with: "789")
```

## 最佳实践

1. **类型设计**: 为触发器选择合适的触发数据类型，避免过度泛化
2. **错误处理**: 在触发器和转换器中实现适当的错误处理机制
3. **异步操作**: 对于耗时操作，优先使用异步触发器避免阻塞主线程
4. **事件组合**: 使用事件组来组织相关的触发器，提高代码的可维护性
5. **数据转换**: 利用数据转换器实现数据预处理，保持触发器的简洁性

## 作者

Raymond.huang: raymond0huang@gmail.com

## License

TriggerableAction is available under the MIT license. See the LICENSE file for more info.