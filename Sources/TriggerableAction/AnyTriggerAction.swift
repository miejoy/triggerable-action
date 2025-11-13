//
//  AnyTriggerAction.swift
//  triggerable-action
//
//  Created by 黄磊 on 2025/11/12.
//


// MARK: - AnyTriggerAction

/// 任意可触发事件
public struct AnyTriggerAction<TriggerData>: TriggerableAction {
    public typealias TriggerData = TriggerData
    
    var innerTrigger : @Sendable (TriggerData) throws -> Void
    
    init(innerTrigger: @Sendable @escaping (TriggerData) throws -> Void) {
        self.innerTrigger = innerTrigger
    }
    
    public func trigger(with data: TriggerData) throws {
        try innerTrigger(data)
    }
}

extension TriggerableAction {
    /// 抹除协议类型，生成可缓存包装实例
    public func eraseToAny() -> AnyTriggerAction<TriggerData> {
        .init(innerTrigger: trigger)
    }
    
    /// 前置一个数据转化器
    public func prepend<Converter: DataConverter>(converter: Converter) -> AnyTriggerAction<Converter.Input> where Converter.Output == TriggerData {
        .init { input throws in
            let output = try converter.process(data: input)
            try trigger(with: output)
        }
    }
}

// MARK: - AnyAsyncTriggerAction

/// 任意可异步触发事件
public struct AnyAsyncTriggerAction<TriggerData>: TriggerableAsyncAction {
    public typealias TriggerData = TriggerData
    
    var innerTrigger : @Sendable (TriggerData) async throws -> Void
    
    public init(innerTrigger: @Sendable @escaping (TriggerData) async throws -> Void) {
        self.innerTrigger = innerTrigger
    }
    
    public func trigger(with data: TriggerData) async throws {
        try await innerTrigger(data)
    }
}

extension TriggerableAsyncAction {
    /// 抹除协议类型，生成可缓存包装实例
    public func eraseToAny() -> AnyAsyncTriggerAction<TriggerData> {
        .init(innerTrigger: trigger)
    }
    
    /// 前置一个数据转化器
    public func prepend<Converter: AsyncDataConverter>(converter: Converter) -> AnyAsyncTriggerAction<Converter.Input> where Converter.Output == TriggerData {
        .init { input async throws in
            let output = try await converter.process(data: input)
            try await trigger(with: output)
        }
    }
}
