//
//  TriggerableAction.swift
//
//
//  Created by 黄磊 on 2020-04-16.
//

/// 可触发异步事件
public protocol TriggerableAsyncAction: Sendable {
    associatedtype TriggerData
    func trigger(with data: TriggerData) async throws
}

/// 可触发事件
public protocol TriggerableAction : TriggerableAsyncAction {
    func trigger(with data: TriggerData) throws
}
