//
//  TriggerableActionTests.swift
//  triggerable-action
//
//  Created by 黄磊 on 2025/11/8.
//

import Testing
@testable import TriggerableAction

@MainActor
@Suite("可触发事件测试")
struct TriggerableActionTests {
    @Test("触发字符串事件测试")
    func testTriggerIntAction() throws {
        let triggerAction = TriggerIntAction()
        let triggerInt = 1
        
        TriggerIntAction.callInt = 0
        
        try triggerAction.trigger(with: triggerInt)
        
        #expect(TriggerIntAction.callInt == triggerInt)
    }
    
    @Test("触发字符串事件测试")
    func testTriggerStringAction() throws {
        let triggerAction = TriggerStringAction()
        let triggerString = "test"
        
        TriggerStringAction.callString = ""
        
        try triggerAction.trigger(with: triggerString)
        
        #expect(TriggerStringAction.callString == triggerString)
    }
    
    @Test("触发异步字符串事件测试")
    func testTriggerAsyncStringAction() async throws {
        let triggerAction = TriggerAsyncStringAction()
        let triggerString = "test"
        
        TriggerAsyncStringAction.callString = ""
        
        try await triggerAction.trigger(with: triggerString)
        
        #expect(TriggerAsyncStringAction.callString == triggerString)
    }
    
    @Test("异步触发同步字符串事件测试")
    func testAsyncTriggerSyncStringAction() async throws {
        struct TriggerIntAction: TriggerableAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) throws {
                Self.callInt = data
            }
        }
        
        struct AsyncStringToIntConverter: AsyncDataConverter {
            nonisolated(unsafe)
            static var callString: String = ""
            func process(data: String) async throws -> Int {
                Self.callString = data
                return Int(data)!
            }
        }
        
        let triggerAction = TriggerIntAction().prepend(converter: AsyncStringToIntConverter())
        let triggerString = "1"
        let triggerInt = 1
        
        
        try await triggerAction.trigger(with: triggerString)
        
        #expect(TriggerIntAction.callInt == triggerInt)
    }
    
    @Test("触发字符串转数字事件测试")
    func testTriggerStringToIntAction() throws {
        struct TriggerStringToIntAction: TriggerableResultAction {
            func trigger(with data: String) throws -> Int {
                return Int(data)!
            }
        }
        
        let triggerAction = TriggerStringToIntAction()
        let triggerString = "1"
        let triggerInt = 1
        
        let result = try triggerAction.trigger(with: triggerString)
        
        #expect(result == triggerInt)
    }
    
    @Test("触发异步字符串转数字事件测试")
    func testTriggerAsyncStringToIntAction() async throws {
        struct TriggerAsyncStringToIntIntAction: TriggerableAsyncResultAction {
            func trigger(with data: String) async throws -> Int {
                return Int(data)!
            }
        }
        
        let triggerAction = TriggerAsyncStringToIntIntAction()
        let triggerString = "1"
        let triggerInt = 1
        
        let result = try await triggerAction.trigger(with: triggerString)
        
        #expect(result == triggerInt)
    }
    
    @Test("异步触发同步字符串转数字事件测试")
    func testAsyncTriggerSyncStringToIntAction() async throws {
        struct TriggerStringToIntAction: TriggerableResultAction {
            func trigger(with data: String) throws -> Int {
                return Int(data)!
            }
        }
        
        struct AsyncStringToStringConverter: AsyncDataConverter {
            nonisolated(unsafe)
            static var callString: String = ""
            func process(data: String) async throws -> String {
                Self.callString = data
                return data
            }
        }
        
        let triggerAction = TriggerStringToIntAction().prepend(converter: AsyncStringToStringConverter())
        let triggerString = "1"
        let triggerInt = 1
        
        let result = try await triggerAction.trigger(with: triggerString)
        
        #expect(AsyncStringToStringConverter.callString == triggerString)
        #expect(result == triggerInt)
    }
    
    @Test("任意可触发事件测试")
    func testAnyTriggerAction() throws {
        let triggerAction = TriggerStringAction().eraseToAny()
        let triggerString = "test"
        
        TriggerStringAction.callString = ""
        
        try triggerAction.trigger(with: triggerString)
        
        #expect(TriggerStringAction.callString == triggerString)
    }
    
    @Test("任意可异步触发事件测试")
    func testAnyAsyncTriggerAction() async throws {
        let triggerAction = TriggerAsyncStringAction().eraseToAny()
        let triggerString = "test"
        
        TriggerAsyncStringAction.callString = ""
        
        try await triggerAction.trigger(with: triggerString)
        
        #expect(TriggerAsyncStringAction.callString == triggerString)
    }
    
    @Test("任意可异步触发同步事件测试")
    func testAsyncAnyTriggerAction() async throws {
        struct TriggerIntAction: TriggerableAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) throws {
                Self.callInt = data
            }
        }
        
        struct AsyncStringToIntConverter: AsyncDataConverter {
            nonisolated(unsafe)
            static var callString: String = ""
            func process(data: String) async throws -> Int {
                Self.callString = data
                return Int(data)!
            }
        }
        
        let triggerAction = TriggerIntAction().eraseToAny().prepend(converter: AsyncStringToIntConverter())
        let triggerString = "1"
        let triggerInt = 1
                
        try await triggerAction.trigger(with: triggerString)
        
        #expect(TriggerIntAction.callInt == triggerInt)
    }
    
    @Test("任意可触发带结果事件测试")
    func testAnyTriggerResultAction() throws {
        struct TriggerStringToIntAction: TriggerableResultAction {
            func trigger(with data: String) throws -> Int {
                return Int(data)!
            }
        }
        let triggerAction = TriggerStringToIntAction().eraseToAny()
        let triggerString = "1"
        let triggerInt = 1
                
        let result = try triggerAction.trigger(with: triggerString)
        
        #expect(result == triggerInt)
    }
    
    @Test("任意可异步触发带结果事件测试")
    func testAnyAsyncTriggerResultAction() async throws {
        struct TriggerAsyncStringToIntIntAction: TriggerableAsyncResultAction {
            func trigger(with data: String) async throws -> Int {
                return Int(data)!
            }
        }
        let triggerAction = TriggerAsyncStringToIntIntAction().eraseToAny()
        let triggerString = "1"
        let triggerInt = 1
                
        let result = try await triggerAction.trigger(with: triggerString)
        
        #expect(result == triggerInt)
    }
    
    @Test("任意可异步触发同步带结果事件测试")
    func testAsyncAnyTriggerResultAction() async throws {
        struct TriggerStringToIntAction: TriggerableResultAction {
            func trigger(with data: String) throws -> Int {
                return Int(data)!
            }
        }
        
        struct AsyncStringToStringConverter: AsyncDataConverter {
            nonisolated(unsafe)
            static var callString: String = ""
            func process(data: String) async throws -> String {
                Self.callString = data
                return data
            }
        }
        
        let triggerAction = TriggerStringToIntAction().eraseToAny().prepend(converter: AsyncStringToStringConverter())
        let triggerString = "1"
        let triggerInt = 1
                
        let result = try await triggerAction.trigger(with: triggerString)
        
        #expect(AsyncStringToStringConverter.callString == triggerString)
        #expect(result == triggerInt)
    }
    
    @Test("触发器数据转化测试")
    func testDataConverter() throws {
        let triggerAction = TriggerIntAction().eraseToAny()
        let triggerString = "1"
        let resultInt = 1
        
        let converterAction = triggerAction.prepend(converter: StringToIntConverter())
        StringToIntConverter.callString = ""
        TriggerIntAction.callInt = 0
        
        try converterAction.trigger(with: triggerString)
        
        #expect(StringToIntConverter.callString == triggerString)
        #expect(TriggerIntAction.callInt == resultInt)
    }
    
    @Test("触发器异步数据转化测试")
    func testAsyncDataConverter() async throws {
        struct TriggerAsyncIntAction: TriggerableAsyncAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) async throws {
                Self.callInt = data
            }
        }
        
        struct AsyncStringToIntConverter: AsyncDataConverter {
            nonisolated(unsafe)
            static var callString: String = ""
            func process(data: String) async throws -> Int {
                Self.callString = data
                return Int(data)!
            }
        }
        
        let triggerAction = TriggerAsyncIntAction().eraseToAny()
        let triggerString = "1"
        let resultInt = 1
        
        let converterAction = triggerAction.prepend(converter: AsyncStringToIntConverter())
        AsyncStringToIntConverter.callString = ""
        TriggerAsyncIntAction.callInt = 0
        
        try await converterAction.trigger(with: triggerString)
        
        #expect(AsyncStringToIntConverter.callString == triggerString)
        #expect(TriggerAsyncIntAction.callInt == resultInt)
    }
    
    @Test("异步触发器同步数据转化测试")
    func testAsyncTriggerSyncDataConverter() async throws {
        struct StringToIntConverter: DataConverter {
            nonisolated(unsafe)
            static var callString: String = ""
            func process(data: String) throws -> Int {
                Self.callString = data
                return Int(data)!
            }
        }
        
        struct TriggerAsyncIntAction: TriggerableAsyncAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) async throws {
                Self.callInt = data
            }
        }
        
        let triggerAction = TriggerAsyncIntAction().eraseToAny()
        let triggerString = "1"
        let resultInt = 1
        
        let converterAction = triggerAction.prepend(converter: StringToIntConverter())
        StringToIntConverter.callString = ""
        TriggerAsyncIntAction.callInt = 0
        
        try await converterAction.trigger(with: triggerString)
        
        #expect(StringToIntConverter.callString == triggerString)
        #expect(TriggerAsyncIntAction.callInt == resultInt)
    }
    
    @Test("带结果触发器数据转化测试")
    func testDataConverterWithResultAction() throws {
        struct TriggerStringToIntAction: TriggerableResultAction {
            func trigger(with data: String) throws -> Int {
                return Int(data)!
            }
        }
        
        struct StringToStringConverter: DataConverter {
            nonisolated(unsafe)
            static var callString: String = ""
            func process(data: String) throws -> String {
                Self.callString = data
                return data
            }
        }
        
        let triggerAction = TriggerStringToIntAction().eraseToAny()
        let triggerString = "1"
        let resultInt = 1
        
        let converterAction = triggerAction.prepend(converter: StringToStringConverter())
        StringToStringConverter.callString = ""
        
        let result = try converterAction.trigger(with: triggerString)
        
        #expect(StringToStringConverter.callString == triggerString)
        #expect(result == resultInt)
    }
    
    @Test("带结果异步触发器数据转化测试")
    func testAsyncDataConverterWithResultAction() async throws {
        struct TriggerAsyncStringToIntAction: TriggerableAsyncResultAction {
            func trigger(with data: String) async throws -> Int {
                return Int(data)!
            }
        }
        
        struct StringToStringConverter: DataConverter {
            nonisolated(unsafe)
            static var callString: String = ""
            func process(data: String) throws -> String {
                Self.callString = data
                return data
            }
        }
        
        let triggerAction = TriggerAsyncStringToIntAction().eraseToAny()
        let triggerString = "1"
        let resultInt = 1
        
        let converterAction = triggerAction.prepend(converter: StringToStringConverter())
        StringToStringConverter.callString = ""
        
        let result = try await converterAction.trigger(with: triggerString)
        
        #expect(StringToStringConverter.callString == triggerString)
        #expect(result == resultInt)
    }
    
    @Test("空触发器数据转化测试")
    func testDataToVoidConverter() throws {
        struct TriggerVoidAction: TriggerableAction {
            nonisolated(unsafe)
            static var call: Bool = false
            func trigger(with data: Void) throws {
                Self.call = true
            }
        }
        
        struct IntToVoidConverter: DataToVoidConverter {
            typealias Input = Int
        }
        
        let triggerAction = TriggerVoidAction().eraseToAny()
        let triggerInt = 1
        
        let converterAction = triggerAction.prepend(converter: IntToVoidConverter())
        
        TriggerVoidAction.call = false
        
        try converterAction.trigger(with: triggerInt)
        
        #expect(TriggerVoidAction.call)
    }
    
    @Test("异步空触发器数据转化测试")
    func testAsyncDataToVoidConverter() async throws {
        struct AsyncTriggerVoidAction: TriggerableAsyncAction {
            nonisolated(unsafe)
            static var call: Bool = false
            func trigger(with data: Void) async throws {
                Self.call = true
            }
        }
        
        struct AsyncStringToVoidConverter: AsyncDataToVoidConverter {
            typealias Input = String
        }
        
        let triggerAction = AsyncTriggerVoidAction().eraseToAny()
        let triggerString = "1"
        
        let converterAction = triggerAction.prepend(converter: AsyncStringToVoidConverter())
        AsyncTriggerVoidAction.call = false
        
        try await converterAction.trigger(with: triggerString)
        
        #expect(AsyncTriggerVoidAction.call)
    }
    
    @Test("异步触发器前置同步转化器测试")
    func testAsyncTriggerWithSyncDataConverter() async throws {
        struct StringToIntConverter: DataConverter {
            nonisolated(unsafe)
            static var callString: String = ""
            func process(data: String) throws -> Int {
                Self.callString = data
                return Int(data)!
            }
        }
        
        struct TriggerAsyncIntAction: TriggerableAsyncAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) async throws {
                Self.callInt = data
            }
        }
        
        let triggerAction = TriggerAsyncIntAction().eraseToAny()
        let triggerString = "1"
        let resultInt = 1
        
        let converterAction = triggerAction.prepend(converter: StringToIntConverter())
        StringToIntConverter.callString = ""
        TriggerAsyncIntAction.callInt = 0
        
        try await converterAction.trigger(with: triggerString)
        
        #expect(StringToIntConverter.callString == triggerString)
        #expect(TriggerAsyncIntAction.callInt == resultInt)
    }
    
    nonisolated(unsafe)
    static var triggerBlockActionCall = 0
    @Test("触发可触发闭包事件测试")
    func testTriggerBlockAction() throws {
        let triggerAction = TriggerBlockAction { (data: Int) in
            Self.triggerBlockActionCall = data
        }
        
        let triggerInt = 1
        
        Self.triggerBlockActionCall = 0
        try triggerAction.trigger(with: triggerInt)
        
        #expect(Self.triggerBlockActionCall == triggerInt)
    }
    
    nonisolated(unsafe)
    static var triggerAsyncBlockActionCall = 0
    @Test("触发可异步触发闭包事件测试")
    func testTriggerAsyncBlockAction() async throws {
        let triggerAction = TriggerAsyncBlockAction { (data: Int) async in
            Self.triggerAsyncBlockActionCall = data
        }
        
        let triggerInt = 1
        
        Self.triggerAsyncBlockActionCall = 0
        try await triggerAction.trigger(with: triggerInt)
        
        #expect(Self.triggerAsyncBlockActionCall == triggerInt)
    }
    
    @Test("触发可触发闭包带结果事件测试")
    func testTriggerBlockResultAction() throws {
        let triggerAction = TriggerBlockResultAction { (data: Int) -> String in
            "\(data)"
        }
        
        let triggerInt = 1
        let triggerString = "1"
        
        let result = try triggerAction.trigger(with: triggerInt)
        
        #expect(result == triggerString)
    }
    
    @Test("触发可异步触发闭包带结果事件测试")
    func testTriggerAsyncBlockResultAction() async throws {
        let triggerAction = TriggerAsyncBlockResultAction { (data: Int) async -> String in
            "\(data)"
        }
        
        let triggerInt = 1
        let triggerString = "1"
        
        let result = try await triggerAction.trigger(with: triggerInt)
        
        #expect(result == triggerString)
    }
    
    nonisolated(unsafe)
    static var triggerGroupActionCall1 = 0
    nonisolated(unsafe)
    static var triggerGroupActionCall2 = 0
    @Test("触发可触发事件组测试")
    func testTriggerGroupAction() throws {
        let triggerAction1 = TriggerBlockAction { data in
            Self.triggerGroupActionCall1 = data
        }
        let triggerAction2 = TriggerBlockAction { data in
            Self.triggerGroupActionCall2 = data
        }
        
        var group = triggerAction1.group()
        group.add(triggerAction2)
        
        let triggerInt = 1
        
        Self.triggerGroupActionCall1 = 0
        Self.triggerGroupActionCall2 = 0
        
        try group.trigger(with: triggerInt)
        
        #expect(Self.triggerGroupActionCall1 == triggerInt)
        #expect(Self.triggerGroupActionCall2 == triggerInt)
    }
    
    nonisolated(unsafe)
    static var triggerAsyncGroupActionCall1 = 0
    nonisolated(unsafe)
    static var triggerAsyncGroupActionCall2 = 0
    @Test("触发可触发异步事件组测试")
    func testTriggerAsyncGroupAction() async throws {
        let triggerAction1 = TriggerAsyncBlockAction { data in
            Self.triggerAsyncGroupActionCall1 = data
        }
        let triggerAction2 = TriggerAsyncBlockAction { data in
            Self.triggerAsyncGroupActionCall2 = data
        }
        
        var group = triggerAction1.group()
        group = .init()
        group.add(triggerAction1)
        group.add(triggerAction2)
        
        let triggerInt = 1
        
        Self.triggerGroupActionCall1 = 0
        Self.triggerGroupActionCall2 = 0
        
        try await group.trigger(with: triggerInt)
        
        #expect(Self.triggerAsyncGroupActionCall1 == triggerInt)
        #expect(Self.triggerAsyncGroupActionCall2 == triggerInt)
    }
    
    nonisolated(unsafe)
    static var asyncTriggerSyncGroupActionCall1 = 0
    nonisolated(unsafe)
    static var asyncTriggerSyncGroupActionCall2 = 0
    @Test("异步触发可触发同步事件组测试")
    func testAsyncTriggerSyncGroupAction() async throws {
        struct AsyncStringToIntConverter: AsyncDataConverter {
            nonisolated(unsafe)
            static var callString: String = ""
            func process(data: String) async throws -> Int {
                Self.callString = data
                return Int(data)!
            }
        }
        
        let triggerAction1 = TriggerBlockAction { data in
            Self.asyncTriggerSyncGroupActionCall1 = data
        }
        let triggerAction2 = TriggerBlockAction { data in
            Self.asyncTriggerSyncGroupActionCall2 = data
        }
        
        var group = TriggerGroupAction<Int>()
        group.add(triggerAction1)
        group.add(triggerAction2)
        
        let triggerAction = group.prepend(converter: AsyncStringToIntConverter())
        
        let triggerString = "1"
        let triggerInt = 1
        
        Self.asyncTriggerSyncGroupActionCall1 = 0
        Self.asyncTriggerSyncGroupActionCall2 = 0
        
        try await triggerAction.trigger(with: triggerString)
        
        #expect(Self.asyncTriggerSyncGroupActionCall1 == triggerInt)
        #expect(Self.asyncTriggerSyncGroupActionCall2 == triggerInt)
    }
    
    @Test("触发可触发带结果事件组测试")
    func testTriggerGroupResultAction() throws {
        let triggerAction1 = TriggerBlockResultAction { (data: Int) -> String in
            "\(data)"
        }
        let triggerAction2 = TriggerBlockResultAction { (data: Int) -> String in
            "\(data + 1)"
        }
        
        var group = triggerAction1.group()
        #expect(group.triggers.count == 1)
        group = .init()
        group.add(triggerAction1)
        group.add(triggerAction2)
        
        let triggerInt = 1
        let triggerResult1 = "1"
        let triggerResult2 = "2"
        
        let result = try group.trigger(with: triggerInt)
        
        #expect(result.count == 2)
        if result.count == 2 {
            #expect(result[0] == triggerResult1)
            #expect(result[1] == triggerResult2)
        }
    }
    
    @Test("触发异步可触发带结果事件组测试")
    func testTriggerAsyncGroupResultAction() async throws {
        let triggerAction1 = TriggerAsyncBlockResultAction { (data: Int) -> String in
            "\(data)"
        }
        let triggerAction2 = TriggerAsyncBlockResultAction { (data: Int) -> String in
            "\(data + 1)"
        }
                
        var group = triggerAction1.group()
        #expect(group.triggers.count == 1)
        group = .init()
        group.add(triggerAction1)
        group.add(triggerAction2)
        
        let triggerInt = 1
        let triggerResult1 = "1"
        let triggerResult2 = "2"
        
        let result = try await group.trigger(with: triggerInt)
        
        #expect(result.count == 2)
        if result.count == 2 {
            #expect(result[0] == triggerResult1)
            #expect(result[1] == triggerResult2)
        }
    }
    
    @Test("异步触发同步可触发带结果事件组测试")
    func testAsyncTriggerSyncGroupResultAction() async throws {
        let triggerAction1 = TriggerBlockResultAction { (data: Int) -> String in
            "\(data)"
        }
        let triggerAction2 = TriggerBlockResultAction { (data: Int) -> String in
            "\(data + 1)"
        }
        
        struct AsyncIntToIntConverter: AsyncDataConverter {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func process(data: Int) async throws -> Int {
                Self.callInt = data
                return data
            }
        }
        
        var group = triggerAction1.group()
        #expect(group.triggers.count == 1)
        group = .init()
        group.add(triggerAction1)
        group.add(triggerAction2)
        
        let triggerInt = 1
        let triggerResult1 = "1"
        let triggerResult2 = "2"
        
        let result = try await group.prepend(converter: AsyncIntToIntConverter()).trigger(with: triggerInt)
        
        #expect(result.count == 2)
        if result.count == 2 {
            #expect(result[0] == triggerResult1)
            #expect(result[1] == triggerResult2)
        }
    }
    
    @Test("触发器前置带结果触发器测试")
    func testTriggerActionPrependResultTrigger() throws {
        struct TriggerIntAction: TriggerableAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) throws {
                Self.callInt = data
            }
        }
        
        struct TriggerIntToIntAction: TriggerableResultAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) throws -> Int {
                Self.callInt += data
                return data
            }
        }
        
        let triggerInt = 1
        
        let trigger = TriggerIntAction().prepend(TriggerIntToIntAction()).prepend(TriggerIntToIntAction()).eraseResult()
        
        try trigger.trigger(with: triggerInt)
        
        #expect(TriggerIntAction.callInt == triggerInt)
        #expect(TriggerIntToIntAction.callInt == (triggerInt + triggerInt))
    }
    
    @Test("异步触发器前置异步带结果触发器测试")
    func testTriggerAsyncActionPrependAsyncResultTrigger() async throws {
        struct TriggerAsyncIntAction: TriggerableAsyncAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) async throws {
                Self.callInt = data
            }
        }
        
        struct TriggerAsyncIntToIntAction: TriggerableAsyncResultAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) async throws -> Int {
                Self.callInt = data
                return data
            }
        }
        
        let triggerInt = 1
        
        let trigger = TriggerAsyncIntAction().prepend(TriggerAsyncIntToIntAction()).prepend(TriggerAsyncIntToIntAction()).eraseResult()
        
        try await trigger.trigger(with: triggerInt)
        
        #expect(TriggerAsyncIntAction.callInt == triggerInt)
        #expect(TriggerAsyncIntToIntAction.callInt == triggerInt)
    }
    
    @Test("带结果触发器后置触发器测试")
    func testTriggerResultActionAppendTrigger() throws {
        struct TriggerIntAction: TriggerableAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) throws {
                Self.callInt = data
            }
        }
        
        struct TriggerIntToIntAction: TriggerableResultAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) throws -> Int {
                Self.callInt = data
                return data
            }
        }
        
        let triggerInt = 1
        
        let trigger = TriggerIntToIntAction().append(TriggerIntAction()).eraseResult()
        
        try trigger.trigger(with: triggerInt)
        
        #expect(TriggerIntAction.callInt == triggerInt)
        #expect(TriggerIntToIntAction.callInt == triggerInt)
    }
    
    @Test("异步带结果触发器后置异步触发器测试")
    func testTriggerAsyncResultActionAppendAsyncTrigger() async throws {
        struct TriggerAsyncIntAction: TriggerableAsyncAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) async throws {
                Self.callInt = data
            }
        }
        
        struct TriggerAsyncIntToIntAction: TriggerableAsyncResultAction {
            nonisolated(unsafe)
            static var callInt: Int = 0
            func trigger(with data: Int) async throws -> Int {
                Self.callInt = data
                return data
            }
        }
        
        let triggerInt = 1
        
        let trigger = TriggerAsyncIntToIntAction().append(TriggerAsyncIntAction()).eraseResult()
        
        try await trigger.trigger(with: triggerInt)
        
        #expect(TriggerAsyncIntAction.callInt == triggerInt)
        #expect(TriggerAsyncIntToIntAction.callInt == triggerInt)
    }
}

struct TriggerIntAction: TriggerableAction {
    nonisolated(unsafe)
    static var callInt: Int = 0
    func trigger(with data: Int) throws {
        Self.callInt = data
    }
}

struct TriggerStringAction: TriggerableAction {
    nonisolated(unsafe)
    static var callString: String = ""
    func trigger(with data: String) throws {
        Self.callString = data
    }
}

struct TriggerAsyncStringAction: TriggerableAsyncAction {
    nonisolated(unsafe)
    static var callString: String = ""
    func trigger(with data: String) async throws {
        Self.callString = data
    }
}

struct StringToIntConverter: DataConverter {
    nonisolated(unsafe)
    static var callString: String = ""
    func process(data: String) throws -> Int {
        Self.callString = data
        return Int(data)!
    }
}
