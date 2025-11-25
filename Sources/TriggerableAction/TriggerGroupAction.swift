//
//  TriggerGroupAction.swift
//
//
//  Created by 黄磊 on 2020-04-18.
//

import Foundation


// MARK: - TriggerGroupAction

/// 可触发事件组
public struct TriggerGroupAction<TriggerData>: TriggerableAction {
    var triggers: [AnyTriggerAction<TriggerData>] = []
        
    public init() {}
    
    init<T: TriggerableAction>(_ trigger: T) where T.TriggerData == TriggerData {
        triggers.append(trigger.eraseToAny())
    }
    
    public func trigger(with data: TriggerData) throws {
        try triggers.forEach { (aTrigger) in
            try aTrigger.trigger(with: data)
        }
    }
    
    /// 添加可触发事件
    public mutating func add<T: TriggerableAction>(_ trigger: T) where T.TriggerData == TriggerData {
        triggers.append(trigger.eraseToAny())
    }
}

extension TriggerableAction {
    /// 生成事件组
    public func group() -> TriggerGroupAction<TriggerData> {
        .init(self)
    }
}

// MARK: - TriggerAsyncGroupAction

/// 可触发异步事件组
public struct TriggerAsyncGroupAction<TriggerData>: TriggerableAsyncAction {
    var triggers: [AnyAsyncTriggerAction<TriggerData>] = []
        
    public init() {}
    
    init<T: TriggerableAsyncAction>(_ trigger: T) where T.TriggerData == TriggerData {
        triggers.append(trigger.eraseToAny())
    }
    
    public func trigger(with data: TriggerData) async throws {
        for aTrigger in triggers {
            try await aTrigger.trigger(with: data)
        }
    }
    
    /// 添加可异步触发事件
    public mutating func add<T: TriggerableAsyncAction>(_ trigger: T) where T.TriggerData == TriggerData {
        triggers.append(trigger.eraseToAny())
    }
}

extension TriggerableAsyncAction {
    /// 生成异步事件组
    public func group() -> TriggerAsyncGroupAction<TriggerData> {
        .init(self)
    }
}


// MARK: - TriggerGroupResultAction

/// 可触发带结果事件组
public struct TriggerGroupResultAction<TriggerData, ResultData>: TriggerableResultAction {
    var triggers: [AnyTriggerResultAction<TriggerData, ResultData>] = []
        
    public init() {}
    
    init<T: TriggerableResultAction>(_ trigger: T) where T.TriggerData == TriggerData, T.ResultData == ResultData {
        triggers.append(trigger.eraseToAny())
    }
    
    public func trigger(with data: TriggerData) throws -> [ResultData] {
        try triggers.map { (aTrigger) in
            try aTrigger.trigger(with: data)
        }
    }
    
    /// 添加可触发带结果事件
    public mutating func add<T: TriggerableResultAction>(_ trigger: T) where T.TriggerData == TriggerData, T.ResultData == ResultData {
        triggers.append(trigger.eraseToAny())
    }
}

extension TriggerableResultAction {
    /// 生成带结果事件组
    public func group() -> TriggerGroupResultAction<TriggerData, ResultData> {
        .init(self)
    }
}

// MARK: - TriggerAsyncGroupResultAction

/// 可触发异步带结果事件组
public struct TriggerAsyncGroupResultAction<TriggerData, ResultData>: TriggerableAsyncResultAction {
    var triggers: [AnyAsyncTriggerResultAction<TriggerData, ResultData>] = []
    
    public init() {}
    
    init<T: TriggerableAsyncResultAction>(_ trigger: T) where T.TriggerData == TriggerData, T.ResultData == ResultData {
        triggers.append(trigger.eraseToAny())
    }
    
    public func trigger(with data: TriggerData) async throws -> [ResultData] {
        var result: [ResultData] = []
        for aTrigger in triggers {
            try await result.append(aTrigger.trigger(with: data))
        }
        return result
    }
    
    /// 添加可异步触发带结果事件
    public mutating func add<T: TriggerableAsyncResultAction>(_ trigger: T) where T.TriggerData == TriggerData, T.ResultData == ResultData {
        triggers.append(trigger.eraseToAny())
    }
}

extension TriggerableAsyncResultAction {
    /// 生成异步带结果事件组
    public func group() -> TriggerAsyncGroupResultAction<TriggerData, ResultData> {
        .init(self)
    }
}
