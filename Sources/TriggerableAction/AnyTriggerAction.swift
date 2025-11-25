//
//  AnyTriggerAction.swift
//  triggerable-action
//
//  Created by 黄磊 on 2025/11/12.
//


// MARK: - AnyTriggerAction

/// 任意可触发事件
public struct AnyTriggerAction<TriggerData>: TriggerableAction {
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
    
    /// 前置一个触发器
    public func prepend<T: TriggerableResultAction>(_ trigger: T) -> AnyTriggerAction<T.TriggerData> where T.ResultData == TriggerData {
        .init { input throws in
            let output = try trigger.trigger(with: input)
            try self.trigger(with: output)
        }
    }
}

// MARK: - AnyAsyncTriggerAction

/// 任意可异步触发事件
public struct AnyAsyncTriggerAction<TriggerData>: TriggerableAsyncAction {
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
    
    /// 前置一个触发器
    public func prepend<T: TriggerableAsyncResultAction>(_ trigger: T) -> AnyAsyncTriggerAction<T.TriggerData> where T.ResultData == TriggerData {
        .init { input throws in
            let output = try await trigger.trigger(with: input)
            try await self.trigger(with: output)
        }
    }
}


// MARK: - AnyTriggerResultAction

/// 任意可触发带结果事件
public struct AnyTriggerResultAction<TriggerData, ResultData>: TriggerableResultAction {
    var innerTrigger : @Sendable (TriggerData) throws -> ResultData
    
    init(innerTrigger: @Sendable @escaping (TriggerData) throws -> ResultData) {
        self.innerTrigger = innerTrigger
    }
    
    public func trigger(with data: TriggerData) throws -> ResultData {
        try innerTrigger(data)
    }
}

extension AnyTriggerResultAction where ResultData == Void {
    /// 抹除结果
    public func eraseResult() -> AnyTriggerAction<TriggerData> {
        .init(innerTrigger: trigger)
    }
}

extension TriggerableResultAction {
    /// 抹除协议类型，生成可缓存包装实例
    public func eraseToAny() -> AnyTriggerResultAction<TriggerData, ResultData> {
        .init(innerTrigger: trigger)
    }
    
    /// 前置一个数据转化器
    public func prepend<Converter: DataConverter>(converter: Converter) -> AnyTriggerResultAction<Converter.Input, ResultData> where Converter.Output == TriggerData {
        .init { input throws in
            let output = try converter.process(data: input)
            return try trigger(with: output)
        }
    }
    
    /// 前置一个触发器
    public func prepend<T: TriggerableResultAction>(_ trigger: T) -> AnyTriggerResultAction<T.TriggerData, ResultData> where T.ResultData == TriggerData {
        .init { input throws in
            let output = try trigger.trigger(with: input)
            return try self.trigger(with: output)
        }
    }
    
    /// 后置一个触发器
    public func append<T: TriggerableResultAction>(_ trigger: T) -> AnyTriggerResultAction<TriggerData, T.ResultData> where T.TriggerData == ResultData {
        .init { input throws in
            let output = try self.trigger(with: input)
            return try trigger.trigger(with: output)
        }
    }
}


// MARK: - AnyAsyncTriggerResultAction

/// 任意可异步触发事件
public struct AnyAsyncTriggerResultAction<TriggerData, ResultData>: TriggerableAsyncResultAction {
    var innerTrigger : @Sendable (TriggerData) async throws -> ResultData
    
    public init(innerTrigger: @Sendable @escaping (TriggerData) async throws -> ResultData) {
        self.innerTrigger = innerTrigger
    }
    
    public func trigger(with data: TriggerData) async throws -> ResultData {
        try await innerTrigger(data)
    }
}

extension AnyAsyncTriggerResultAction where ResultData == Void {
    /// 抹除结果
    public func eraseResult() -> AnyAsyncTriggerAction<TriggerData> {
        .init(innerTrigger: trigger)
    }
}

extension TriggerableAsyncResultAction {
    /// 抹除协议类型，生成可缓存包装实例
    public func eraseToAny() -> AnyAsyncTriggerResultAction<TriggerData, ResultData> {
        .init(innerTrigger: trigger)
    }
    
    /// 前置一个数据转化器
    public func prepend<Converter: AsyncDataConverter>(converter: Converter) -> AnyAsyncTriggerResultAction<Converter.Input, ResultData> where Converter.Output == TriggerData {
        .init { input async throws in
            let output = try await converter.process(data: input)
            return try await trigger(with: output)
        }
    }
    
    /// 前置一个触发器
    public func prepend<T: TriggerableAsyncResultAction>(_ trigger: T) -> AnyAsyncTriggerResultAction<T.TriggerData, ResultData> where T.ResultData == TriggerData {
        .init { input throws in
            let output = try await trigger.trigger(with: input)
            return try await self.trigger(with: output)
        }
    }
    
    /// 后置一个触发器
    public func append<T: TriggerableAsyncResultAction>(_ trigger: T) -> AnyAsyncTriggerResultAction<TriggerData, T.ResultData> where T.TriggerData == ResultData {
        .init { input throws in
            let output = try await self.trigger(with: input)
            return try await trigger.trigger(with: output)
        }
    }
}
