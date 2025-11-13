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
    
    public typealias TriggerData = TriggerData
    
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
    public mutating func append<T: TriggerableAction>(_ trigger: T) where T.TriggerData == TriggerData {
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
public struct TriggerAsyncGroupAction<Data>: TriggerableAsyncAction {
    var triggers: [AnyAsyncTriggerAction<TriggerData>] = []
    
    public typealias TriggerData = Data
    
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
    public mutating func append<T: TriggerableAsyncAction>(_ trigger: T) where T.TriggerData == TriggerData {
        triggers.append(trigger.eraseToAny())
    }
}

extension TriggerableAsyncAction {
    /// 生成异步事件组
    public func group() -> TriggerAsyncGroupAction<TriggerData> {
        .init(self)
    }
}
