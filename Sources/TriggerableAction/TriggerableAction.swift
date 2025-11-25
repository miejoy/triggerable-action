//
//  TriggerableAction.swift
//
//
//  Created by 黄磊 on 2020-04-16.
//

/// 可触发异步带结果事件
public protocol TriggerableAsyncResultAction: Sendable {
    associatedtype TriggerData
    associatedtype ResultData
    func trigger(with data: TriggerData) async throws -> ResultData
}

/// 可触发带结果事件
public protocol TriggerableResultAction: TriggerableAsyncResultAction {
    func trigger(with data: TriggerData) throws -> ResultData
}

/// 可触发异步事件
public protocol TriggerableAsyncAction: TriggerableAsyncResultAction where ResultData == Void {}

/// 可触发事件
public protocol TriggerableAction : TriggerableAsyncAction, TriggerableResultAction {}
